![GitHub Issues](https://img.shields.io/github/issues/itjustcrashed/environmentlogger)

# EnvironmentLogger

EnvironmentLogger is a cross-platform logging framework that is configured using environment variables, similar to [env_logger][env_logger].

The framework is supported on iOS, macOS, watchOS, tvOS, visionOS, GNU/Linux, musl/Linux, Android and Windows. FreeBSD support will be added once I figure out how to sanely develop on that operating system.

> [!NOTE]
> The logger is routed to stderr on non-Apple operating systems.

> [!IMPORTANT]
> The logger is routed directly to the [unified logging system][apple-log-sys] on all Apple operating systems (`anyAppleOS`).

## Why This Framework Exists

As more projects written in Swift target non-Apple operating systems, 

## Configuration

EnvironmentLogger is configured using two variables:
 * `LOG_LEVEL`: The level to print logs from. This can be `trace`, `debug`, `info`, `warning`, or `error` (default).
 * `LOG_MODE`: The mode to print logs in. This can be `pretty` (default), `timed`, or `full`.

[apple-log-sys]: https://developer.apple.com/documentation/os/logging
[env_logger]: https://crates.io/crates/env_logger
