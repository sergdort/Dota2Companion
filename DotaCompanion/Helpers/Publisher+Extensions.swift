import Combine

public extension Publisher {
  func ignoreError() -> AnyPublisher<Output, Never> {
    return `catch` { _ in
      Empty()
    }
    .eraseToAnyPublisher()
  }
}
