import DotaDomain
import SwiftUI

struct MatchRow: View {
  @Environment(\.imageFetcher)
  private var imageFetcher

  var match: RecentMatch
  var hero: Hero

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(match.isWin ? "WON MATCH" : "LOST MATCH")
          .font(.headline)
          .foregroundColor(
            match.isWin ? Colors.win.color : Colors.lose.color
          )
        Spacer()
      }
//      HStack {
//        AsyncImage(source: hero.imagePublisher(imageFetcher: imageFetcher), placeholder: nil)
//          .frame(width: 100, height: 50)
//        Text(hero.localizedName)
//        Spacer()
//        Rectangle()
//          .fill(match.isWin ? Colors.win.color : Colors.lose.color)
//          .frame(width: 10, height: 50)
//      }
//      VStack(alignment: .leading) {
//        HStack {
//          Text("Last Hits")
//          Text("\(match.lastHits)")
//          Spacer()
//        }
//        HStack {
//          Text("Denies")
//          Text("\(match.de)")
//          Spacer()
//        }
//        HStack {
//          Text("Gold")
//          Text("\(match.totalGold)")
//          Spacer()
//        }
//      }
    }
    .padding()
  }
}

#if DEBUG

struct MatchRow_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      MatchRow(
        match: .fixture(),
        hero: .fixture()
      )
      Spacer()
    }
  }
}

#endif
