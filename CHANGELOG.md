# Changelog

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
