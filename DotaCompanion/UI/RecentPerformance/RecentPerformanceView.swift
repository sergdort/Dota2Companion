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
        secondaryText: "in last 20 displayed matches"
      )
      HStack {
        WinRateView(winRate: Int(winRate * 100))
        MatchStatView(
          name: "KILLS",
          averageValue: kills.average.toInt,
          maxValue: kills.max,
          color: Colors.win.color,
          heroIcon: (
            kills.maxHero.iconPublisher(imageFetcher: imageFetcher),
            nil
          )
        )
        MatchStatView(
          name: "DEATHS",
          averageValue: 3,
          maxValue: 7,
          color: Colors.lose.color,
          heroIcon: (
            deaths.maxHero.iconPublisher(imageFetcher: imageFetcher),
            nil
          )
        )
        MatchStatView(
          name: "ASSISTS",
          averageValue: 14,
          maxValue: 28,
          color: Colors.gold.color,
          heroIcon: (
            assists.maxHero.iconPublisher(imageFetcher: imageFetcher),
            nil
          )
        )
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

struct MatchStatView: View {
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

extension Hero {
  func imagePublisher(imageFetcher: ImageFetcher) -> AnyPublisher<UIImage, Never> {
    imageFetcher.image(
      for: ENV.prod.assetsBaseURL.appendingPathComponent(img)
    )
    .ignoreError()
  }
}
