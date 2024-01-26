
import SwiftUI
import Kingfisher
import Firebase
import Combine

struct TextPostView: View {
    
    var post: Post

    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject var postManager: PostManager
    @EnvironmentObject var viewModel: YourViewModel
    @State private var openComments: Bool = false
    @State private var isBookmarked: Bool = false
    @State private var isHeartFilled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 0){
                let uid = Auth.auth().currentUser?.uid
                
                if uid == post.author {
                    Image(uiImage: authModel.loadProfileImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding(10)
                    
                } else {
                    Image("userPhoto")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 2))
                        .padding(10)
                }
                
                if let uid =  authModel.user?.uid {
                    Text(authModel.name)
                        .bold()
                } else {
                    if let uid =  viewModel.userID {
                        Text(uid)
                            .bold()
                    }
                }
            }
                Text(post.postCaption ?? "")
                .padding(.leading, 10)
                
                HStack(spacing: 0){
                    Button(action: {
                        let uid = Auth.auth().currentUser?.uid
                        //                    postManager.addLikeToPost()
                    }) {
                        Image(systemName:  postManager.toggleLike ? "heart.fill" : "heart")
                            .font(.title2)
                            .padding(10)
                    }
                    
                    Button(action: {
                        openComments = true
                    }) {
                        Image(systemName: "message")
                            .font(.title2)
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "paperplane")
                            .font(.title2)
                            .padding(10)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        isBookmarked.toggle()
                        
                        if isBookmarked {
                            authModel.savePostToFirebase(userId: authModel.user!.uid, postId: post.id)
                        } else {
                            authModel.removeSavedPostFromFirebase(userId: authModel.user!.uid, postId: post.id)
                        }
                        
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .padding(10)
                    }
                }
                
                Text("\(post.likes.count) likes")
                    .padding(.leading ,10)
                    .bold()
                
    
        }
    }
}
