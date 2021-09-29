import SwiftUI
import DotaDomain

struct HeroGridItem: View {
  @Environment(\.imageFetcher)
  private var imageFetcher

  let hero: Hero

  var body: some View {
    AsyncImage(
      source: hero.imagePublisher(imageFetcher: imageFetcher),
      placeholder: nil
    )
  }
}
