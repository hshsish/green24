
import AVKit
import UIKit
import SwiftUI

public struct RecordingPreview: View {
    
    let url: URL?
    
    public var body: some View {
        
        ZStack {
            if url != nil {
                if checkURL() == "video" {
                    let player = AVPlayer(url: url!)
                    AVPlayerControllerRepresented(player: player)
                        .onAppear {
                            player.play()
                        }.onDisappear {
                            player.pause()
                        }
                } else {
                    Image(uiImage: UIImage(contentsOfFile: url!.path)!)
                        .ignoresSafeArea()
                }
            }
        }.background(Color.black)
    }
    
    func checkURL() -> String {
        if url!.absoluteString.hasSuffix(".mov") {
            return "video"
        }
        return "photo"
    }
}

struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    
    var player : AVPlayer
  
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player

        controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = false
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                    object: player.currentItem,
                                                    queue: nil) { [weak player] _ in
                 player?.seek(to: CMTime.zero)
                 player?.play()
             }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
