import Testing

@testable import EnvironmentLogger

@Suite("Logging tests", .serialized)
struct LoggingTests {
  func log(mode: String) {
    #if os(anyAppleOS)
      print(
        """
        Running on an Apple operating system. Log messages will be routed to the unified logging \
        system instead of stderr.
        """
      )
    #endif
    let logger = EnvironmentLogger(
      environment: [
        "LOG_LEVEL": "trace",
        "LOG_MODE": mode,
      ],
      subsystem: "EnvironmentLogger",
      category: "Tests"
    )
    logger.trace("Cryptic trace message.")
    logger.debug("Confusing debug message.")
    logger.info("Boring info message.")
    logger.warning("Ignorable warning message.")
    logger.error("Annoying error message.")
  }

  @Test("Test logging in pretty mode")
  func testLoggingPrettyMode() throws {
    log(mode: "pretty")
  }

  @Test("Test logging in timed mode")
  func testLoggingTimedMode() throws {
    log(mode: "timed")
  }

  @Test("Test logging in full mode")
  func testLoggingFullMode() throws {
    log(mode: "full")
  }
}
