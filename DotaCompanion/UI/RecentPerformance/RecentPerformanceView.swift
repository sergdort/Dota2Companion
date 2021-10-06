import SwiftUI
import Combine
import UIKit
import DotaDomain

public struct RecentPerformanceView: View {
  var winRate: Double
  var kills: RecentPerformance.Value
  var deaths: RecentPerformance.Value
  var assists: RecentPerformance.Value

  @Environment(\.imageFetcher)
  var imageFetcher

  public var body: some View {
    VStack(alignment: .leading) {
      WidgetHeader(
        mainText: "Averages/Maximums",
        secondaryText: "in last 20 matches"
      )
      HStack {
        WinRateView(winRate: Int(winRate * 100))
        RecentPerformanceStatView(
          name: "KILLS",
          averageValue: kills.average.toInt,
          maxValue: kills.max,
          color: Colors.win.color,
          heroIcon: (
            kills.maxHero.iconPublisher(imageFetcher: imageFetcher),
            nil
          )
        )
        RecentPerformanceStatView(
          name: "DEATHS",
          averageValue: deaths.average.toInt,
          maxValue: deaths.max,
          color: Colors.lose.color,
          heroIcon: (
            deaths.maxHero.iconPublisher(imageFetcher: imageFetcher),
            nil
          )
        )
        RecentPerformanceStatView(
          name: "ASSISTS",
          averageValue: assists.average.toInt,
          maxValue: assists.max,
          color: Colors.gold.color,
          heroIcon: (
            assists.maxHero.iconPublisher(imageFetcher: imageFetcher),
            nil
          )
        )
        Spacer()
      }
    }
  }
}

struct WidgetHeader: View {
  var mainText: String
  var secondaryText: String

  var body: some View {
    Text(mainText)
      .font(.headline)
      .foregroundColor(Colors.textMain.color)
      + Text(" " + secondaryText)
      .font(.caption)
      .bold()
      .foregroundColor(Colors.textSecondary.color)
  }
}

struct WinRateView: View {
  var winRate: Int

  var body: some View {
    VStack {
      Text("WINRATE")
        .font(.caption)
        .foregroundColor(Colors.textSecondary.color)
      Text("\(winRate)%")
        .font(.title)
        .foregroundColor(Colors.textMain.color)
    }
  }
}

struct RecentPerformanceStatView: View {
  var name: String
  var averageValue: Int
  var maxValue: Int
  var color: Color
  var heroIcon: AsyncImageInput

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(name)
        .font(.caption)
        .foregroundColor(Colors.textSecondary.color)
      HStack {
        Text("\(averageValue)")
          .font(.title)
          .foregroundColor(color)
          +
          Text("\(maxValue)")
          .font(.body)
          .foregroundColor(Colors.textSecondary.color)
        AsyncImage(
          source: heroIcon.async,
          placeholder: heroIcon.placeholder
        )
        .frame(width: 30, height: 30)
      }
    }
  }
}

extension Double {
  var toInt: Int {
    Int(self)
  }
}

extension Optional where Wrapped == Hero {
  func iconPublisher(imageFetcher: ImageFetcher) -> AnyPublisher<UIImage, Never> {
    if let hero = self {
      let iconPath = hero.icon.hasPrefix("/") ? String(hero.icon.dropFirst()) : hero.icon
      return imageFetcher.image(
        for: ENV.prod.assetsBaseURL.appendingPathComponent(iconPath)
      )
      .catch { _ in
        imageFetcher.image(
          for: ENV.prod.heroesAssetsBaseURL
            .appendingPathComponent("\(hero.id)_icon.png")
        )
      }
      .ignoreError()
    }
    return Empty().eraseToAnyPublisher()
  }
}

#if DEBUG
import SwiftUI

struct RecentPerformanceView_Previews: PreviewProvider {
  static var previews: some View {
    RecentPerformanceView(
      winRate: 0.55,
      kills: RecentPerformance.Value(average: 10, max: 22, maxHero: .fixture()),
      deaths: RecentPerformance.Value(average: 3, max: 10, maxHero: .fixture()),
      assists: RecentPerformance.Value(average: 7, max: 17, maxHero: .fixture())
    )
    .background(Colors.backgroundFront)
  }
}

#endif
