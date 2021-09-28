import DotaDomain
import SwiftUI
import Combine

struct MatchRow: View {
  @Environment(\.imageFetcher)
  private var imageFetcher

  var match: Match
  var hero: Hero
  var items: [Item]

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      Rectangle()
        .fill(match.isWin ? Colors.win.color : Colors.lose.color)
        .frame(width: 4)
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          AsyncImage(
            source: hero.imagePublisher(imageFetcher: imageFetcher),
            placeholder: nil
          )
          .frame(width: 80, height: 50)
          MatchStatView(
            value: match.kills,
            name: "KILLS",
            color: Colors.win.color
          )
          MatchStatView(
            value: match.deaths,
            name: "DEATHS",
            color: Colors.lose.color
          )
          MatchStatView(
            value: match.assists,
            name: "ASSISTS",
            color: Colors.gold.color
          )
          MatchStatView(
            value: match.assists,
            name: "ASSISTS",
            color: Colors.gold.color
          )
        }
        HStack {
          ForEach(items) { item in
            AsyncImage(
              source: item.imagePublisher(imageFetcher: imageFetcher),
              placeholder: nil
            )
            .frame(width: 40, height: 30)
            .background(.thinMaterial)
          }
        }
      }
      Spacer()
    }
  }
}

struct MatchStatView: View {
  var value: Int
  var name: String
  var color: Color

  var body: some View {
    VStack {
      Text(name)
        .font(.caption)
        .foregroundColor(Colors.textSecondary.color)
        .lineLimit(1)
      Text("\(value)")
        .font(.subheadline)
        .foregroundColor(color)
        .bold()
    }
  }
}

extension Item {
  func imagePublisher(imageFetcher: ImageFetcher) -> AnyPublisher<UIImage, Never> {
    let url = URL(string: ENV.prod.assetsBaseURL.absoluteString + img)!
    return imageFetcher.image(
      for: url
    )
    .ignoreError()
  }
}

#if DEBUG

struct MatchRow_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      LazyVStack {
        MatchRow(
          match: .fixture(),
          hero: .fixture(),
          items: []
        )
        MatchRow(
          match: .fixture(radiantWin: false),
          hero: .fixture(),
          items: Array(repeating: .fixture(), count: 6)
        )
        Spacer()
      }
    }
    .background(Colors.backgroundFront)
  }
}

#endif
