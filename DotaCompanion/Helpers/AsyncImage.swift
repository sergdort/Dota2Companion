import SwiftUI
import Combine

struct AsyncImage<M: View>: View {
  @State
  private var image: UIImage?
  private let source: AnyPublisher<UIImage, Never>
  var modifier: (Image) -> M
  
  init(
    source: AnyPublisher<UIImage, Never>,
    placeholder: UIImage?,
    modifier: @escaping (Image) -> M
  ) {
    self.source = source
    self._image = State(initialValue: placeholder)
    self.modifier = modifier
  }
  
  var body: some View {
    return modifier(Image(uiImage: image ?? UIImage()))
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
  
  func image(for url: URL) -> AnyPublisher<UIImage, Never> {
    return Deferred { () -> AnyPublisher<UIImage, Never> in
      if let image = self.cache.object(forKey: url as NSURL) {
        return Result.Publisher(image)
          .eraseToAnyPublisher()
      }
      
      return URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
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
