import SwiftUI
import DotaDomain

struct AbilityDetailsView: View {
  @Environment(\.imageFetcher)
  private var imageFetcher: ImageFetcher

  let ability: Ability

  private var formattedDescription: String {
    return ability.specialValues
      .filter { value in
        ability.descLOC.contains("%\(value.name)%")
      }
      .reduce(ability.descLOC) { partialResult, value in
        partialResult
          .replacingOccurrences(
            of: "%\(value.name)%",
            with: value.formattedValues
          )
      }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      VStack(alignment: .leading) {
        Text(ability.nameLOC.uppercased())
          .font(.title)
          .foregroundColor(Colors.textMain.color)
        Text(formattedDescription)
          .font(.callout)
          .foregroundColor(Colors.textMain.color)
      }
      VStack(alignment: .leading) {
        ForEach(
          ability.specialValues.filter { $0.headingLOC.isEmpty == false
          },
          id: \.name
        ) { value in
          AbilityValuesView(value: value)
        }
      }
    }
  }
}

struct AbilityValuesView: View {
  let value: SpecialValue

  var body: some View {
    HStack {
      Text(value.headingLOC)
        .foregroundColor(Colors.textSecondary.color)
      if value.valuesInt.isNotEmpty {
        Text(
          value.valuesInt.map {
            "\($0)" + (value.isPercentage ? "% " : " ")
          }.joined(separator: "/ ")
        )
        .font(.body)
        .foregroundColor(Colors.textMain.color)
      }
      if value.valuesFloat.isNotEmpty {
        Text(
          value.valuesFloat.map {
            "\($0) " + (value.isPercentage ? "% " : " ")
          }.joined(separator: "/ ")
        )
        .font(.body)
        .foregroundColor(Colors.textMain.color)
      }
    }
  }
}

extension SpecialValue {
  var formattedValues: String {
    if valuesInt.isNotEmpty {
      return valuesInt.map {
        "\($0)" + (isPercentage ? "% " : " ")
      }.joined(separator: "/ ")
    }
    if valuesFloat.isNotEmpty {
      return valuesFloat.map {
        "\($0)" + (isPercentage ? "% " : " ")
      }.joined(separator: "/ ")
    }
    return ""
  }
}

#if DEBUG
import SwiftUI

struct AbilityDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      AbilityDetailsView(ability: .fixture())
        .background(Colors.backgroundFront.color)
      Spacer()
    }
  }
}

#endif
