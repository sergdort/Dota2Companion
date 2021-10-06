import Foundation
import Combine
import UIKit
import DotaCore

public final class ImageFetcher {
  private let cache = NSCache<NSURL, UIImage>()
  private let repo = FileCache(name: "ImageFetcher")

  public init() {}

  public func image(for url: URL) -> AnyPublisher<UIImage, Error> {
    return Deferred { () -> AnyPublisher<UIImage, Error> in
      if let image = self.cache.object(forKey: url as NSURL) {
        return Result.Publisher(image).eraseToAnyPublisher()
      } else if let data = try? self.repo.loadFile(path: url.path), let image = UIImage(data: data) {
        self.cache.setObject(image, forKey: url as NSURL)
        return Result.Publisher(image).eraseToAnyPublisher()
      }
      return URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .handleEvents(receiveOutput: { data in
          try? self.repo.persist(data: data, path: url.path)
        })
        .tryMap { data -> UIImage in
          if let image = UIImage(data: data) {
            return image
          }
          throw CoreError.parser("Could not create image from \(url)")
        }
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveOutput: { image in
          self.cache.setObject(image, forKey: url as NSURL)
        })
        .mapError { error in
          error as Error
        }
        .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }
}
