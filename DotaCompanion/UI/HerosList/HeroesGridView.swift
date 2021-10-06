import SwiftUI
import DotaDomain

struct HeroesGridView: View {
  let heroes: [Hero]
  let onSelect: (Hero) -> Void

  var body: some View {
    ScrollView {
      LazyVGrid(
        columns: Array(
          repeating: GridItem(
            .adaptive(minimum: 200, maximum: 400),
            spacing: 8,
            alignment: .leading
          ),
          count: 3
        ),
        alignment: .leading,
        spacing: 8
      ) {
        ForEach(heroes, id: \.id) { hero in
          Button {
            onSelect(hero)
          } label: {
            HeroGridItem(hero: hero)
          }
          .aspectRatio(CGSize(width: 256, height: 144), contentMode: .fill)
        }
      }
      .padding(.horizontal)
    }
  }
}

#if DEBUG
import SwiftUI

struct HeroesGridView_Previews: PreviewProvider {
  static var previews: some View {
    HeroesGridView(
      heroes: [
        .fixture(id: 0),
        .fixture(id: 1),
        .fixture(id: 2),
        .fixture(id: 3),
        .fixture(id: 5)
      ],
      onSelect: { _ in EmptyView() }
    )
  }
}

#endif
