
import SwiftUI
import Firebase
import UIKit

struct PostView: View {
    
    @State private var posts: [Post] = []
    @EnvironmentObject var authModel : AuthViewModel
    @ObservedObject var PostManager = postManager()
    
    var body: some View {
   Text("kks")
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
//    .scaleEffect(zoomScale)
//    .gesture(
//        MagnificationGesture()
//            .onChanged { value in
//                let delta = value / self.lastScale
//                self.lastScale = value
//                self.zoomScale *= delta
//                let pinchZoomScale = min(max(delta * self.zoomScale, 1), 4)
//                camera.updateZoomScale(scale: pinchZoomScale)
//            }
//            .onEnded { value in
//                self.lastScale = 1.0
//            }
//    )
