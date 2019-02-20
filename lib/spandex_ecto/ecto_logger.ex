defmodule SpandexEcto.EctoLogger do
  @moduledoc """
  A trace builder that can be given to ecto as a logger. It will try to get
  the trace_id and span_id from the caller pid in the case that the particular
  query is being run asynchronously (as in the case of parallel preloads).
  """

  defmodule Error do
    defexception [:message]
  end

  def trace(log_entry, database) do
    # Put in your own configuration here
    config = Application.get_env(:spandex_ecto, __MODULE__)
    tracer = config[:tracer] || raise "tracer is a required option for #{inspect(__MODULE__)}"
    service = config[:service] || :ecto
    truncate = config[:truncate] || 5000

    if tracer.current_trace_id() do
      now = :os.system_time(:nano_seconds)
      query =
        log_entry
        |> string_query()
        |> String.slice(0, truncate)

      num_rows = num_rows(log_entry)

      queue_time = get_time(log_entry, :queue_time)
      query_time = get_time(log_entry, :query_time)
      decoding_time = get_time(log_entry, :decode_time)

      start = now - (queue_time + query_time + decoding_time)

      tracer.start_span(
        "query",
        start: start,
        completion_time: now,
        service: service,
        resource: query,
        type: :db,
        sql_query: [
          query: query,
          rows: inspect(num_rows),
          db: database
        ],
        tags: tags(log_entry)
      )

      Logger.metadata(trace_id: tracer.current_trace_id(), span_id: tracer.current_span_id())

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

      tracer.finish_span()
    end

    log_entry
  end

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

  defp to_nanoseconds(time) when is_integer(time), do: System.convert_time_unit(time, :native, :nanosecond)
  defp to_nanoseconds(_time), do: 0

  defp tags(%{params: params}) when is_list(params) do
    param_count =
      params
      |> Enum.count()
      |> to_string()

    [
      param_count: param_count
    ]
  end
  defp tags(_), do: []
end
