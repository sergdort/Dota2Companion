import CombineFeedback
import Combine

extension Feedback {
  static func whenInitialized<Effects: Publisher>(
    source: @escaping (Dependency) -> Effects
  ) -> Feedback where Effects.Output == Event, Effects.Failure == Never {
      .custom { state, output, dependency in
        state.map(\.0).first()
          .flatMap { _ in
            source(dependency).enqueue(to: output)
          }
      }
  }

  static func whenInitialized(
    just: @escaping (Dependency) -> Event
  ) -> Feedback  {
      .custom { state, output, dependency in
        state.map(\.0).first()
          .flatMap { _ in
            Just(just(dependency)).enqueue(to: output)
          }
      }
  }

  static func whenInitialized(
    maybe: @escaping (Dependency) -> Event?
  ) -> Feedback  {
      .custom { state, output, dependency in
        state.map(\.0).first()
          .flatMap { _ in
            Just(maybe(dependency))
              .compactMap { $0 }
              .enqueue(to: output)
          }
      }
  }
}
