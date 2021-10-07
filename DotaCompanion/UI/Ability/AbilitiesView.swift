import SwiftUI
import DotaDomain

struct AbilitiesView: View {
  @Binding
  private var selectedAbility: Ability

  let abilities: [Ability]

  init(abilities: [Ability], selectedAbility: Binding<Ability>) {
    self.abilities = abilities
    self._selectedAbility = selectedAbility
  }

  var body: some View {
    LazyVGrid(
      columns: Array(
        repeating: GridItem(
          .adaptive(minimum: 50, maximum: 200),
          spacing: 8,
          alignment: .leading
        ),
        count: 4
      ),
      alignment: .leading,
      spacing: 8
    ) {
      ForEach(abilities, id: \.id) { ability in
        AbilityView(
          ability: ability,
          isSelected: ability == selectedAbility
        ) {
          self.selectedAbility = ability
        }
      }
    }
  }
}

struct AbilityView: View {
  @Environment(\.imageFetcher)
  private var imageFetcher: ImageFetcher

  var ability: Ability
  var isSelected: Bool
  var didSelect: () -> Void

  var body: some View {
    AsyncImage(
      source: ability.icon(imageFetcher: imageFetcher),
      placeholder: nil
    )
    .overlay(alignment: Alignment.bottomTrailing) {
      if ability.abilityIsGrantedByShard || ability.abilityHasShard {
        Image("aghs_shard", bundle: nil)
      } else if ability.abilityIsGrantedByScepter || ability.abilityHasScepter {
        Image("aghs_scepter", bundle: nil)
      }
    }
    .aspectRatio(CGSize(width: 1, height: 1), contentMode: ContentMode.fill)
    .border(Colors.gold.color, width: isSelected ? 2 : 0)
    .onTapGesture(perform: didSelect)
  }
}

struct AbilitiesView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      AbilitiesView(
        abilities: [
          .fixture(id: 0),
          .fixture(id: 1),
          .fixture(id: 2),
          .fixture(id: 3)
        ],
        selectedAbility: .constant(.fixture())
      )
      Spacer()
    }
  }
}
