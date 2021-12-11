# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](Https://conventionalcommits.org) for commit guidelines.

<!-- changelog -->

## [v0.7.0](https://github.com/spandex-project/spandex_ecto/compare/0.6.2...v0.7.0) (2021-12-11)

### What's Changed
* fix: remove outdated requirements by @novaugust in #23
* docs: Ecto 3 example update to better guide setups with multiple repos by @rraub in #20
* Update Telemetry matcher in Readme by @octosteve in #25
* Allow to configure EctoLogger through :telemetry.attach/4 by @kamilkowalski in #21
* Add possibility to pass the span's resource through :telemetry_options by @mruoss in #27

### New Contributors
* @novaugust made their first contribution in #23
* @rraub made their first contribution in #20
* @octosteve made their first contribution in #25
* @kamilkowalski made their first contribution in #21
* @mruoss made their first contribution in #27



## [v0.6.2](https://github.com/spandex-project/spandex_ecto/compare/0.6.1...v0.6.2) (2020-5-26)

### Bug Fixes:

* update spandex version dependency



## [v0.6.1](https://github.com/spandex-project/spandex_ecto/compare/0.6.0...v0.6.1) (2019-10-14)

### Bug Fixes:

* #9 'mongodb_ecto results in invalid spans'

## [v0.6.0](https://github.com/spandex-project/spandex_ecto/compare/v0.5.0...v0.6.0) (2019-5-24)

### Features:

* Support for Ecto 3 Telemetry (#13, #14)



## [v0.5.0](https://github.com/spandex-project/spandex_ecto/compare/0.4.0...v0.5.0) (2019-4-11)

### Features:

* change 'nanoseconds' to 'nanosecond' (#10)



## [v0.4.0](https://github.com/spandex-project/spandex_ecto/compare/0.3.0...v0.4.0) (2018-11-28)

### Features:

* add param_count as a tag (#7)



## [0.3.0](https://github.com/spandex-project/spandex_ecto/compare/0.3.0...0.3.0) (2018-11-27)

### Features:

* truncate queries, 5000 character default (#6)

### Bug Fixes:

* Use proper call to Process.info/2
