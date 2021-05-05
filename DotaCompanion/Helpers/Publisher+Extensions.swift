import Combine

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
