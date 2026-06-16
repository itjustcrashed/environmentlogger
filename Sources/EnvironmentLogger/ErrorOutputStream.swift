import Foundation

#if !os(anyAppleOS)
  nonisolated(unsafe) var errorOutputStream = ErrorOutputStream()

  struct ErrorOutputStream: TextOutputStream {
    mutating func write(_ string: String) {
      if let data = string.data(using: .utf8) {
        try? FileHandle.standardError.write(contentsOf: data)
      }
    }
  }
#endif
