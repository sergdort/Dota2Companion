import SwiftUI
import Combine

struct AsyncImage: View {
  @State
  private var image: UIImage?
  private let source: AnyPublisher<UIImage, Never>

  init(
    source: AnyPublisher<UIImage, Never>,
    placeholder: UIImage?
  ) {
    self.source = source
    self._image = State(initialValue: placeholder)
  }
  
  var body: some View {
    return Image(uiImage: image ?? UIImage())
      .resizable()
      .clipped()
      .bind(source, to: $image)
  }
}

extension View {
  func bind<P: Publisher, Value>(
    _ publisher: P,
    to state: Binding<Value?>
  ) -> some View where P.Failure == Never, P.Output == Value {
    return onReceive(publisher) { value in
      state.wrappedValue = value
    }
  }
}

final class ImageFetcher {
  private let cache = NSCache<NSURL, UIImage>()
  private let repo = CacheFileRepository(directory: "com.dota2.companion.ImageFetcher")
  
  func image(for url: URL) -> AnyPublisher<UIImage, Never> {
    return Deferred { () -> AnyPublisher<UIImage, Never> in
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
        .compactMap(UIImage.init(data:))
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveOutput: { image in
          self.cache.setObject(image, forKey: url as NSURL)
        })
        .ignoreError()
    }
    .eraseToAnyPublisher()
  }
}

struct ImageFetcherKey: EnvironmentKey {
  static let defaultValue: ImageFetcher = ImageFetcher()
}

extension EnvironmentValues {
  var imageFetcher: ImageFetcher {
    get {
      return self[ImageFetcherKey.self]
    }
    set {
      self[ImageFetcherKey.self] = newValue
    }
  }
}
