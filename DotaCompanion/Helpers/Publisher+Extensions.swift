import Combine
import Foundation

public extension Publisher {
  func ignoreError() -> AnyPublisher<Output, Never> {
    return `catch` { _ in
      Empty()
    }
    .eraseToAnyPublisher()
  }

  func replaceError(
    replace: @escaping (Failure) -> Self.Output
  ) -> AnyPublisher<Self.Output, Never> {
    return `catch` { error in
      Result.Publisher(replace(error))
    }.eraseToAnyPublisher()
  }
}

extension Publisher where Output == Data {
  func prependAndStore(from cache: FileCache, path: String) -> AnyPublisher<Output, Failure> {
    return Deferred { () -> AnyPublisher<Output, Failure> in
      let storedSource = self.handleEvents(receiveOutput: { data in
        try? cache.persist(data: data, path: path)
      })
      if let cachedData = try? cache.loadFile(path: path) {
        return storedSource.prepend(cachedData).eraseToAnyPublisher()
      }
      return storedSource.eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }
}
