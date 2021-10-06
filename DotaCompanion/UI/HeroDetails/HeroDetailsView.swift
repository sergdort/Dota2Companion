import SwiftUI
import DotaDomain
import CombineFeedback

struct HeroDetailsView: View {
  @Environment(\.imageFetcher)
  private var imageFetcher

  let hero: Hero

  var body: some View {
    VStack(alignment: .leading) {
      AsyncUIImage(
        contentMode: .scaleAspectFit,
        source: hero.backdropImage(imageFetcher: imageFetcher)
      )
      .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fill)
      VStack(alignment: .leading) {
        Text(hero.attackType.rawValue)
          .foregroundColor(Colors.textSecondary.color)
          .font(.headline)
        Text(hero.roles.map(\.rawValue).joined(separator: ", "))
          .foregroundColor(Colors.textMain.color)
      }
    }
  }
}
