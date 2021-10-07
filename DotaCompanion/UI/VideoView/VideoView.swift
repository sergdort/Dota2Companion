import SwiftUI
import AVKit

struct VideoView: UIViewControllerRepresentable {
  let asset: AVAsset

  func makeCoordinator() -> Coordinator {
    Coordinator(asset: asset)
  }

  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let viewController = AVPlayerViewController()
    return viewController
  }

  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    context.coordinator.setAsset(asset: asset)
    uiViewController.player = context.coordinator.player
    uiViewController.showsPlaybackControls = false
    uiViewController.allowsPictureInPicturePlayback = false
    uiViewController.player?.play()
  }

  final class Coordinator {
    private(set) var player: AVQueuePlayer
    private var looper: AVPlayerLooper

    init(asset: AVAsset) {
      let item = AVPlayerItem(asset: asset)
      self.player = AVQueuePlayer(playerItem: item)
      self.looper = AVPlayerLooper(player: player, templateItem: item)
    }

    func setAsset(asset: AVAsset) {
      let item = AVPlayerItem(asset: asset)
      self.player = AVQueuePlayer(playerItem: item)
      self.looper = AVPlayerLooper(player: player, templateItem: item)
    }
  }
}
