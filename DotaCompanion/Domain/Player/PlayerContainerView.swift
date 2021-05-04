import Combine
import SwiftUI

public struct PlayerContainerView: View {
  @ObservedObject
  var viewModel = PlayerViewModel()
  @Environment(\.imageFetcher)
  var imageFetcher

  public var body: some View {
    Group {
      if let player = viewModel.player, let rankIcon = viewModel.rankIcon {
        PlayerView(
          image: (
            imageFetcher.image(for: player.profile.avatarmedium),
            nil
          ),
          rankIcon: rankIcon,
          name: player.profile.personaname,
          wins: 1527,
          loses: 1764
        )
      } else {
        PlayerView(
          image: (Empty().eraseToAnyPublisher(), nil),
          rankIcon: nil,
          name: "Default Behaviour",
          wins: 1527,
          loses: 1764
        )
        .padding([.leading, .trailing], 8)
      }
    }
    .redacted(reason: viewModel.player == nil ? .placeholder : [])
    .onAppear(perform: viewModel.fetch)
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
