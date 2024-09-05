import UIKit
import AVFoundation
import AVKit

@objc(VideoPlayerView) // Make the class accessible to Objective-C
class VideoPlayerView: UIView {

    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?

    // Property to accept the video URL from React Native
    @objc var videoURL: NSString = "" {
        didSet {
            guard let url = URL(string: videoURL as String) else {
                print("Invalid video URL")
                return
            }
            setupPlayer(with: url)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setupPlayerViewController()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Set up AVPlayerViewController to show the player with native controls
    private func setupPlayerViewController() {
        playerViewController = AVPlayerViewController()
        playerViewController?.showsPlaybackControls = true
        
        if let playerVC = playerViewController {
            playerVC.view.frame = self.bounds
            playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(playerVC.view)
        }
    }

    // Set up the player with a given URL
    private func setupPlayer(with url: URL) {
        player = AVPlayer(url: url)
        playerViewController?.player = player
        player?.play() // Auto-play when video URL is set
    }

    // Expose play functionality to React Native
    @objc func play() {
        player?.play()
    }

    // Expose pause functionality to React Native
    @objc func pause() {
        player?.pause()
    }

    // Expose stop functionality to React Native
    @objc func stop() {
        player?.pause()
        player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
    }

    // Make sure player resizes properly
    override func layoutSubviews() {
        super.layoutSubviews()
        playerViewController?.view.frame = self.bounds
    }
}
