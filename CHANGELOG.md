# Changelog

## v0.10.0-dev

- Enhancements
    - The library used for JSON encoding/decoding can be changed
      by using the `:json_encoder` and `:json_decoder` configuration

- Backwards incompatible changes
    - Support for `{ :system, "ENV_VARIABLE" }` configuration has been removed

## v0.9.0 (2018-09-30)

- Enhancements
    - Compiling a graph module without passing an `:otp_app` will now raise
    - Graphs can be declared with compile time configuration defaults
      that are later overwritten by the application environment

- Backwards incompatible changes
    - Minimum required elixir version is now "~> 1.5"
    - Public access to the internal pool child spec has been removed
    - Public access to the internal pool module name has been removed
    - Support for cayley version `0.6.1` has been dropped

- Deprecations
    - Accessing the system environment by configuring `{ :system, var }` or
      `{ :system, var, default }` will now result in a `Logger.info/1` message
      and will stop working in a future release

## v0.8.0 (2018-09-09)

- Enhancements
    - Configuration can be done on graph (re-) start by setting a
      `{ mod, fun }` tuple for the config key `:init`. This method will be
      called with the graph module name as the first (and only) parameter
      and is expected to return `:ok`
    - Queries now support the `limit` parameter
    - Support for elixir 1.5 style `child_spec` has been added

- Soft deprecations (no warnings)
    - Support for `{ :system, "ENV_VARIABLE" }` configuration has been
      removed from the documentation. It will eventually be removed completely
      after a proper deprecation phase

## v0.7.0 (2017-12-28)

- Enhancements
    - Basic support for defining a default graph query language

- Backwards incompatible changes
    - Default query endpoint has been updated to support cayley version `0.7.0`.
      To use an older version you need to add `language: :gremlin` to
      your graph configuration
    - Support for cayley version `0.6.0` has been dropped

## v0.6.0 (2017-09-17)

- Backwards incompatible changes
    - Minimum required elixir version is now "~> 1.3"

## v0.5.0 (2017-09-09)

- Enhancements
    - Configuration values can be fetched from the system environment
      using `{ :system, ENV_VAR }` or `{ :system, ENV_VAR, default }`

## v0.4.0 (2017-05-18)

- Enhancements
    - Bulk operations for write/delete are now supported

## v0.3.0 (2016-12-11)

- Backwards incompatible changes
    - Minimum required elixir version is now "~> 1.2"
    - Minimum required erlang version is now "~> 18.0"
    - Support for `:poison < 2.0` has been removed

## v0.2.0 (2015-06-13)

- Enhancements
    - Allows retrieving the shape of a query
    - Pools connections to the graph
    - Uses `:hackney` instead of `:inets`

- Backwards incompatible changes
    - Configuration is done using config files

## v0.1.0 (2015-06-04)

- Initial Release
