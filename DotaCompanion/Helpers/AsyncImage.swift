import SwiftUI
import Combine
import DotaCore
import DotaDomain

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

struct AsyncUIImage: View {
  @State
  private var image: UIImage?
  private let source: AnyPublisher<UIImage, Never>
  private let contentMode: UIView.ContentMode

  init(
    contentMode: UIView.ContentMode = .scaleAspectFill,
    source: AnyPublisher<UIImage, Never>,
    placeholder: UIImage? = nil
  ) {
    self.contentMode = contentMode
    self.source = source
    self._image = State(initialValue: placeholder)
  }

  var body: some View {
    return ImageRepresentable(
      contentMode: contentMode,
      image: image
    )
    .bind(source, to: $image)
  }
}

struct ImageRepresentable: UIViewRepresentable {
  var contentMode: UIView.ContentMode
  var image: UIImage?

  func makeUIView(context: Context) -> View {
    View(image: image)
  }

  func updateUIView(_ uiView: View, context: Context) {
    uiView.image = image
    uiView.contentMode = contentMode
    uiView.clipsToBounds = true
  }

  final class View: UIImageView {
    public override var intrinsicContentSize: CGSize {
      return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
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

struct ImageFetcherKey: EnvironmentKey {
  static let defaultValue = ImageFetcher()
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
