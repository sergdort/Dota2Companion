import Combine
import SwiftUI

public struct PlayerContainerView: View {
  @ObservedObject
  var model = PlayerViewModel()
  @Environment(\.imageFetcher)
  var imageFetcher

  public var body: some View {
    PlayerView(
      image: (
        model.player.map {
          imageFetcher.image(for: $0.profile.avatarmedium)
        } ?? Empty().eraseToAnyPublisher(),
        nil
      ),
      rankIcon: model.rankIcon,
      name: model.player?.profile.personaname ?? "Placeholder",
      wins: 1527,
      loses: 1764
    )
    .redacted(reason: model.player == nil ? .placeholder : [])
    .onAppear(perform: model.fetch)
  }
}

public final class PlayerViewModel: ObservableObject {
  @Published
  var player: Player? = nil
  private var cancel: Cancellable?
  private var repository = PlayerRepository()

  var rankIcon: RankIcon? {
    return player.flatMap(repository.rankImage)
  }

  func fetch() {
    cancel = repository.getPlayer()
      .receive(on: DispatchQueue.main).sink(
        receiveCompletion: { completion in
          print("Player", completion)
        },
        receiveValue: { [weak self] in
          self?.player = $0
        }
      )
  }
}
