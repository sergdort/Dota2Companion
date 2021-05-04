import Combine
import SwiftUI

typealias AsyncImageInput = (async: AnyPublisher<UIImage, Never>, placeholder: UIImage?)

public struct PlayerView: View {
  var image: AsyncImageInput
  var rankIcon: RankIcon?
  var rankPlaceholder: UIImage? = nil
  var starsPlaceholder: UIImage? = nil
  var name: String
  var wins: Int
  var loses: Int

  @Environment(\.redactionReasons)
  var redactionReasons

  var winRate: CGFloat {
    return CGFloat(wins) / CGFloat(wins + loses) * 100
  }

  public var body: some View {
    HStack(alignment: .top) {
      AsyncImage(
        source: image.async,
        placeholder: image.placeholder
      ) {
        $0.resizable()
      }
      .frame(width: 90, height: 90)
      .clipShape(Circle())
      HStack {
        VStack(alignment: .leading) {
          Text(name)
            .font(.title)
            .lineLimit(redactionReasons == .placeholder ? 1 : nil)
            .foregroundColor(Colors.textMain.color)
          PlayerStatsView(wins: wins, loses: loses)
        }
        PlayerRankView(
          rankIcon: rankIcon,
          rankPlaceholder: rankPlaceholder,
          starsPlaceholder: starsPlaceholder
        )
      }
    }
  }
}

struct PlayerRankView: View {
  var rankIcon: RankIcon?
  var rankPlaceholder: UIImage? = nil
  var starsPlaceholder: UIImage? = nil

  @Environment(\.imageFetcher)
  var imageFetcher

  var body: some View {
    if let rankIcon = rankIcon {
      VStack {
        AsyncImage(
          source: imageFetcher.image(for: rankIcon.medal),
          placeholder: rankPlaceholder
        ) {
          $0.resizable()
        }
      }
      .frame(width: 50, height: 50)
      .overlay {
        if let start = rankIcon.stars {
          AsyncImage(
            source: imageFetcher.image(for: start),
            placeholder: starsPlaceholder
          ) {
            $0.resizable()
          }
        }
      }
    } else {
      Color.clear.frame(width: 50, height: 50)
    }
  }
}

extension View {
  @ViewBuilder
  func overlay<V: View>(@ViewBuilder _ builder: () -> V) -> some View {
    overlay(builder())
  }
}

public struct PlayerStatsView: View {
  var wins: Int
  var loses: Int

  var winRate: CGFloat {
    return CGFloat(wins) / CGFloat(wins + loses) * 100
  }

  public var body: some View {
    HStack {
      VStack {
        Text("Wins")
          .foregroundColor(Colors.textSecondary.color)
        Text("\(wins)")
          .foregroundColor(Colors.win.color)
      }
      VStack {
        Text("Loses")
          .foregroundColor(Colors.textSecondary.color)
        Text("\(loses)")
          .foregroundColor(Colors.lose.color)
      }
      VStack {
        Text("Winrate")
          .foregroundColor(Colors.textSecondary.color)
        Text(String(format: "%0.2f", winRate) + "%")
          .foregroundColor(Colors.textMain.color)
      }
    }
  }
}

#if DEBUG
struct PlayerView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      PlayerView(
        image: (Empty().eraseToAnyPublisher(), UIImage(named: "profile_img")),
        rankIcon: nil,
        name: "Default Behaviour",
        wins: 1527,
        loses: 1764
      )
      .redacted(reason: .placeholder)
      PlayerView(
        image: (Empty().eraseToAnyPublisher(), UIImage(named: "profile_img")),
        rankIcon: RankIcon(
          stars: URL(string: "https://www.opendota.com"),
          medal: URL(string: "https://www.opendota.com")!
        ),
        rankPlaceholder: UIImage(named: "rank_guardian"),
        starsPlaceholder: UIImage(named: "rank_star_4"),
        name: "Default Behaviour",
        wins: 1527,
        loses: 1764
      )
    }
//    .previewLayout(.sizeThatFits)
  }
}
#endif
