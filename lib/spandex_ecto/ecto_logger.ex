defmodule SpandexEcto.EctoLogger do
  @moduledoc """
  A trace builder that can be given to ecto as a logger. It will try to get
  the trace_id and span_id from the caller pid in the case that the particular
  query is being run asynchronously (as in the case of parallel preloads).
  """

  alias Spandex.{
    Span,
    SpanContext,
    Trace
  }

  defmodule Error do
    defexception [:message]
  end

  def trace(log_entry, database) do
    # Put in your own configuration here
    config = Application.get_env(:spandex_ecto, __MODULE__)
    otp_app = config[:otp_app] || raise "otp_app is a required option for #{inspect(__MODULE__)}"
    tracer = config[:tracer] || raise "tracer is a required option for #{inspect(__MODULE__)}"
    service = config[:service] || :ecto

    unless Application.get_env(otp_app, tracer)[:disabled?] do
      now = :os.system_time(:nano_seconds)
      setup(log_entry, tracer)
      query = string_query(log_entry)
      num_rows = num_rows(log_entry)

      queue_time = get_time(log_entry, :queue_time)
      query_time = get_time(log_entry, :query_time)
      decoding_time = get_time(log_entry, :decode_time)

      start = now - (queue_time + query_time + decoding_time)

      tracer.update_span(
        start: start,
        completion_time: now,
        service: service,
        resource: query,
        type: :db,
        sql_query: [
          query: query,
          rows: inspect(num_rows),
          db: database
        ]
      )

      report_error(tracer, log_entry)

      if queue_time != 0 do
        tracer.start_span("queue")
        tracer.update_span(service: service, start: start, completion_time: start + queue_time)
        tracer.finish_span()
      end

      if query_time != 0 do
        tracer.start_span("run_query")

        tracer.update_span(
          service: service,
          start: start + queue_time,
          completion_time: start + queue_time + query_time
        )

        tracer.finish_span()
      end

      if decoding_time != 0 do
        tracer.start_span("decode")

        tracer.update_span(
          service: service,
          start: start + queue_time + query_time,
          completion_time: now
        )

        tracer.finish_span()
      end

      finish_ecto_trace(log_entry, tracer)
    end

    log_entry
  end

  defp finish_ecto_trace(%{caller_pid: caller_pid}, tracer) do
    if caller_pid != self() do
      tracer.finish_trace()
    else
      tracer.finish_span()
    end
  end

  defp finish_ecto_trace(_, _), do: :ok

  defp setup(%{caller_pid: caller_pid}, tracer) when is_nil(caller_pid) do
    tracer.start_span("query")
  end

  defp setup(%{caller_pid: caller_pid}, tracer) when is_pid(caller_pid) do
    if caller_pid == self() do
      tracer.start_span("query")
    else
      case Process.info(caller_pid)[:dictionary][:spandex_trace] do
        nil ->
          tracer.start_trace("query")

        %Trace{id: trace_id, stack: [%Span{id: span_id} | _]} ->
          tracer.continue_trace("query", %SpanContext{trace_id: trace_id, parent_id: span_id})

        %Trace{id: trace_id, stack: []} ->
          tracer.continue_trace("query", %SpanContext{trace_id: trace_id})
      end
    end

    Logger.metadata(trace_id: tracer.current_trace_id(), span_id: tracer.current_span_id())
  end

  defp setup(_, _), do: :ok

  defp report_error(_tracer, %{result: {:ok, _}}), do: :ok

  defp report_error(tracer, %{result: {:error, error}}) do
    tracer.span_error(%Error{message: inspect(error)}, nil)
  end

  defp string_query(%{query: query}) when is_function(query), do: Macro.unescape_string(query.() || "")
  defp string_query(%{query: query}) when is_bitstring(query), do: Macro.unescape_string(query)
  defp string_query(_), do: ""

  defp num_rows(%{result: {:ok, %{num_rows: num_rows}}}), do: num_rows
  defp num_rows(_), do: 0

  def get_time(log_entry, key) do
    log_entry
    |> Map.get(key)
    |> to_nanoseconds()
  end

  defp to_nanoseconds(time) when is_integer(time), do: System.convert_time_unit(time, :native, :nanoseconds)
  defp to_nanoseconds(_time), do: 0
end
