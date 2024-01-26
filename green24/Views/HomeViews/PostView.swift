
import SwiftUI
import Firebase
import UIKit

struct PostView: View {
    
    @State private var posts: [Post] = []
    @ObservedObject var postManager = PostManager()
    
    var body: some View {
        VStack{
            
            Text("kks")
            
                Image("userPhoto")
                .frame(width: .infinity)
                .frame(maxHeight: .infinity)
            
        }
    }
}
