import Foundation

#if canImport(OSLog)
  import OSLog
#endif

/// A logging system that is configured via environment variables.
///
/// - Note: On Apple operating systems, all log messages are immediately routed to the [unified
/// logging system](https://developer.apple.com/documentation/os/logging), and thus are not printed
/// to `stderr` as they are on all other supported operating systems.
public struct EnvironmentLogger {
  #if !os(anyAppleOS)
    let level: LogLevel
    let mode: LogMode
  #endif

  let subsystem: String
  let category: String

  /// Create a new logger from the environment.
  /// - Parameter environment: The environment to read variables from.
  /// - Parameter subsystem: The subsystem that the logger operates in (e.g. `SwiftUI` or `com.apple.dt.Xcode`).
  /// - Parameter category: The category that the logger handles (e.g. `FileManager` or `ContentViewModel`).
  public init(
    environment: [String: String] = ProcessInfo.processInfo.environment,
    subsystem: String,
    category: String
  ) {
    #if !os(anyAppleOS)
      self.level = LogLevel(environment["LOG_LEVEL"])
      self.mode = LogMode(environment["LOG_MODE"])
    #endif

    self.subsystem = subsystem
    self.category = category
  }

  /// Write a log message to the console.
  /// - Parameter level: The level to log the message at.
  /// - Parameter message: The string to log.
  public func log(atLevel level: LogLevel, _ message: String) {
    #if canImport(OSLog)
      let log = OSLog(subsystem: subsystem, category: category)

      let type: OSLogType
      switch level {
      case .trace, .debug:
        type = .debug
      case .info:
        type = .info
      case .warning:
        type = .default
      case .error:
        type = .error
      }

      os_log("%{public}@", log: log, type: type, message)
    #else
      guard level.rawValue >= self.level.rawValue else {
        return
      }

      let prettyLevel: String
      let fullLevel: String
      switch level {
      case .trace:
        prettyLevel = "\u{001B}[0;1;36mtrace:\u{001B}[0m"
        fullLevel = "[\u{001B}[0;36mTRACE\u{001B}[0m]"
      case .debug:
        prettyLevel = "\u{001B}[0;1;35mdebug:\u{001B}[0m"
        fullLevel = "[\u{001B}[0;35mDEBUG\u{001B}[0m]"
      case .info:
        prettyLevel = "\u{001B}[0;1;34minfo:\u{001B}[0m"
        fullLevel = "[\u{001B}[0;34mINFO \u{001B}[0m]"
      case .warning:
        prettyLevel = "\u{001B}[0;1;33mwarning:\u{001B}[0m"
        fullLevel = "[\u{001B}[0;33mWARN \u{001B}[0m]"
      case .error:
        prettyLevel = "\u{001B}[0;1;31merror:\u{001B}[0m"
        fullLevel = "[\u{001B}[0;31mERROR\u{001B}[0m]"
      }

      var stream = errorOutputStream
      switch self.mode {
      case .pretty:
        print("\(prettyLevel) \(message)", to: &stream)
      case .timed:
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.string(from: Date())
        print("\(time) \(prettyLevel) \(message)", to: &stream)
      case .full:
        let formatter = ISO8601DateFormatter()
        let time = formatter.string(from: Date())
        print("\(time) \(fullLevel) \(message)", to: &stream)
      }
    #endif
  }

  /// Log a message on the ``EnvironmentLogger/LogLevel/trace`` level.
  @inlinable
  @inline(always)
  public func trace(_ message: String) {
    log(atLevel: .trace, message)
  }

  /// Log a message on the ``EnvironmentLogger/LogLevel/debug`` level.
  @inlinable
  @inline(always)
  public func debug(_ message: String) {
    log(atLevel: .debug, message)
  }

  /// Log a message on the ``EnvironmentLogger/LogLevel/info`` level.
  @inlinable
  @inline(always)
  public func info(_ message: String) {
    log(atLevel: .info, message)
  }

  /// Log a message on the ``EnvironmentLogger/LogLevel/warning`` level.
  @inlinable
  @inline(always)
  public func warning(_ message: String) {
    log(atLevel: .warning, message)
  }

  /// Log a message on the ``EnvironmentLogger/LogLevel/error`` level.
  @inlinable
  @inline(always)
  public func error(_ message: String) {
    log(atLevel: .error, message)
  }
}

#if !os(anyAppleOS)
  extension EnvironmentLogger {
    public enum LogLevel: UInt8 {
      /// A level that includes granular details of execution.
      ///
      /// Trace logs are extremely specific information that can help developers understand exactly
      /// what an application is doing.
      ///
      /// - Important: This level also includes logs from the ``debug``, ``info``, ``warning``, and ``error`` levels.
      case trace = 0
      /// A level that includes information that is useful while debugging an issue.
      ///
      /// Debug logs are used when actively fixing an issue in an application. They are only
      /// available in `DEBUG` configurations, which can be enabled by passing `-D DEBUG` to `swiftc`
      /// when not using the Swift Package Manager or Xcode.
      ///
      /// ```swift
      /// #if DEBUG
      ///   logger.log(.debug, "Button clicked!")
      /// #endif
      /// // ...
      /// ```
      ///
      /// - Important: This level also includes logs from the ``info``, ``warning``, and ``error`` levels.
      case debug
      /// A level that includes general state changes and important information.
      ///
      /// - Important: This level also includes logs from the ``warning`` and ``error`` levels.
      case info
      /// A level that includes potential issues that don't cause immediate issues.
      ///
      /// - SeeAlso: This level also includes logs from the ``error`` level.
      case warning
      /// A level that includes unexpected behavior that causes immediate issues.
      case error

      /// Match a log level from a raw enviroment variable.
      init(_ string: consuming String?) {
        switch string {
        case "trace":
          self = .trace
        case "debug":
          self = .debug
        case "info":
          self = .info
        case "warning":
          self = .warning
        case "error":
          self = .error
        default: self = .error
        }
      }

    }
  }

  extension EnvironmentLogger {
    public enum LogMode {
      case pretty
      case timed
      case full

      /// Match a log mode from a raw environment variable.
      init(_ string: consuming String?) {
        switch string {
        case "pretty":
          self = .pretty
        case "timed":
          self = .timed
        case "full":
          self = .full
        default: self = .pretty
        }
      }
    }
  }
#endif
