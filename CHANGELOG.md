## [Unreleased]

## [1.0.0] - 2025-03-01

- Updates `protos` to `~> 1.0`

## [0.1.1] - 2025-01-26

- Bumps `protos` to `~> 0.7`
- Bumps `activerecord` and `activesupport` requirements to `~> 8.0`
- Hides authenticity token and method field when the form has a GET method
  automatically
- Fixes passing symbol values to labels
- Fixes passing wrong values to radio button components

## [0.1.0] - 2024-09-04

- Adds tests for all Rails components
- Adds `Time`, `Datetime`, `Date`, and `RadioButton` components
- Fixes a bug in `Button` component calling the wrong method on `attrs`
- Bumps supported Ruby version to 3.2
- Adds value suffix to labels allowing them to match radio button ids
- Bumps `protos` dependency to `v0.6.0`

## [0.0.2] - 2024-08-14

- Adds handling client supplied values like files and images
- Fixes overriding methods on forms when supplying a Rails model
- Adds `include_blank` option on select component to match Rails API
- Transfers ownership of repo from `nolantait` to `inhouse-work` organization to
  match other `protos-` gems

## [0.0.1] - 2023-06-23

- Initial release
