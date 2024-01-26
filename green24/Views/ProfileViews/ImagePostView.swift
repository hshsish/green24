
import SwiftUI
import Kingfisher
import Firebase
import Combine

struct ImagePostView: View {
    
    var post: Post
    @Environment(\.presentationMode) var presentatioMode
    @EnvironmentObject var viewModel: YourViewModel
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject var postManager: PostManager
    @State private var openComments: Bool = false
    @State private var isBookmarked: Bool = false
    @State private var isHeartFilled: Bool = false
    @State var userID: String? = nil
    var backButton: some View {
        
        Button(action: {
            self.presentatioMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
                .font(.title2)
        }).padding(.leading, 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            
            KFImage(URL(string: post.postImageURL!))
                .placeholder {
                    
                    Image("dark_plug")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: 550)
                        .overlay {
                            ProgressView()
                        }
                }
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 550)
                .overlay(
                    VStack(alignment: .leading) {
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
                            
                            VStack(spacing: 0){
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
                            Spacer()
                            
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "ellipsis")
                                    .padding([.trailing, .top], 10)
                            })
                        }
                        .frame(height: 55)
                        
                        Spacer()
                    }
                )    .overlay(
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                        .opacity(isHeartFilled ? 1.0 : 0.0)
                )
                .onTapGesture(count: 2) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isHeartFilled = true
                        postManager.toggleLike.toggle()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isHeartFilled = false
                        }
                    }
                }
            
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
            
            HStack(spacing: 3){
                
                if let uid =  authModel.user?.uid {
                    Text(authModel.name)
                        .bold()
                } else {
                    Text("username")
                }
                
                Text(post.postCaption ?? "")
            }
            .padding(.leading, 10)
            
            Button(action: {
                openComments = true
           
            }) {
                Text("Add a comment...")
                    .padding(.leading ,10)
                    .foregroundColor(.gray)
            } .sheet(isPresented: $openComments) {
                CommentView(postID: post.id).environmentObject(viewModel)
                    .presentationDetents([.medium, .large])
            }
            
            Text("\(viewModel.convertDateString(from: post.createdAt))")
                .padding(.leading ,10)
                .foregroundColor(.gray)
                .padding(.bottom, 30)
            //            } else {
            //                TextPostView(post: post).environmentObject(viewModel)
            //            }
            
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.fetchAuthorUsername(forUserID: post.author)
        }
        .navigationTitle("\(authModel.name)")
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: backButton.padding(0))
    }
}

class YourViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    @Published var userID: String? = nil
    @Published var post = Post(id: "", author: "", createdAt: Date(), likes: [], save: 0)
    let db = Firestore.firestore()
    @Published var username: String? = ""
    
    func fetchAuthorUsername(forUserID username: String) {
        getUsername(forUserID: username) { userID in
            if let userID = userID {
                self.userID = userID
            } else {
                print("Не удалось получить username для пользователя")
            }
        }
    }
    
    func convertDateString(from date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yy"
        return outputFormatter.string(from: date)
    }
    
    func fetchAutoohorUsername(forusername username: String) {
        getUsername(forUserID: username) { userID in
            if let userID = userID {
                self.userID = userID
            } else {
                print("Не удалось получить username для пользователя")
            }
        }
    }
    
    func getUsername(forUserID userID: String, completion: @escaping (String?) -> Void) {
        let usersCollection = Firestore.firestore().collection("Users")
        
        usersCollection.document(userID).getDocument { (document, error) in
            if let error = error {
                print("Ошибка при получении данных пользователя: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let document = document, document.exists, let username = document["name"] as? String {
                    completion(username)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func addLikeToPost() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Пользователь не аутентифицирован")
            return
        }
    }
}

