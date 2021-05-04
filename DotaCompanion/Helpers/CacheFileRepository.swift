import Foundation

final class CacheFileRepository {
  private let fileManager = FileManager.default
  private let directory: String

  init(directory: String) {
    self.directory = directory
  }

  func loadFile(path: String) throws -> Data {
    let fileURL = directoryURL.appendingPathComponent(path)
    return try Data(contentsOf: fileURL)
  }

  func persist(data: Data, path: String) throws {
    let path = path.hasPrefix("/") ? String(path.dropFirst()) : path
    do {
      try createDirectoryIfNeeded()
      let fileURL = directoryURL.appendingPathComponent(path)
      let fileDirectoryURL = fileURL.deletingLastPathComponent()
      try createDirectoryIfNeeded(for: fileDirectoryURL)

      if fileManager.fileExists(atPath: fileURL.path) {
        try fileManager.removeItem(at: fileURL)
      }

      try data.write(to: fileURL, options: .atomic)
    } catch {
      throw error
    }
  }

  private func createDirectoryIfNeeded() throws {
    if fileManager.fileExists(atPath: directoryURL.path) == false {
      try fileManager.createDirectory(
        at: directoryURL,
        withIntermediateDirectories: true,
        attributes: nil
      )
    }
  }

  private func createDirectoryIfNeeded(for url: URL) throws {
    if fileManager.fileExists(atPath: url.path) == false {
      try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
  }

  private var directoryURL: URL {
    cacheDirectory().appendingPathComponent(directory)
  }

  private func cacheDirectory() -> URL {
    return fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
  }
}
