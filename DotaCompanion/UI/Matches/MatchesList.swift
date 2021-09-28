import SwiftUI
import DotaDomain

struct MatchesList: View {
  var data: [MatchData]

  var body: some View {
    LazyVStack {
      ForEach(data, id: \.match.id) { data in
        MatchRow(
          match: data.match,
          hero: data.hero,
          items: data.items
        )
      }
    }
  }
}
