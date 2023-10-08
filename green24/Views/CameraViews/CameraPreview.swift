
import Foundation
import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        DispatchQueue.main.async {
            camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
            camera.preview.frame = view.frame
            camera.preview.videoGravity = .resizeAspectFill
            view.layer.addSublayer(camera.preview)
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            camera.session.startRunning()
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    
    }
}
