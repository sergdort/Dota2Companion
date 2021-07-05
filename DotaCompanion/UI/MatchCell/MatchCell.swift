import DotaDomain
import SwiftUI
import Combine

struct MatchRow: View {
  @Environment(\.imageFetcher)
  private var imageFetcher

  var match: Match
  var hero: Hero
  var itemsRepo: ItemsRepository

  var items: [Item] {
    return match.itemsIds.compactMap(itemsRepo.item)
  }

  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text(match.isWin ? "WON MATCH" : "LOST MATCH")
          .font(.headline)
          .foregroundColor(
            match.isWin ? Colors.win.color : Colors.lose.color
          )
        HStack {
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
          Spacer()
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
      AsyncImage(
        source: hero.imagePublisher(imageFetcher: imageFetcher),
        placeholder: nil
      )
      .frame(width: 80, height: 50)
    }
    .padding()
  }
}

struct MatchStatView: View {
  var value: Int
  var name: String
  var color: Color

  var body: some View {
    VStack(alignment: .leading) {
      Text("\(value)")
        .font(.subheadline)
        .foregroundColor(color)
        .bold()
      Text(name)
        .font(.caption)
        .foregroundColor(Colors.textSecondary.color)
    }
  }
}

extension Item {
  func imagePublisher(imageFetcher: ImageFetcher) -> AnyPublisher<UIImage, Never> {
    imageFetcher.image(
      for: ENV.prod.assetsBaseURL.appendingPathComponent(
        img.hasPrefix("/") ? String(img.dropFirst()) : img
      )
    )
    .ignoreError()
  }
}

#if DEBUG

struct MatchRow_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      MatchRow(
        match: .fixture(),
        hero: .fixture(),
        itemsRepo: ItemsRepository()
      )
      Spacer()
    }
    .background(Colors.backgroundFront)
  }
}

#endif
