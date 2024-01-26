
import SwiftUI
import Firebase

struct HomeView: View {
    
    @EnvironmentObject var authModel: AuthViewModel
    @EnvironmentObject var postManager: PostManager
    @EnvironmentObject var viewModel: YourViewModel
    @State private var posts = [Post]()
    @State private var selectedImage: UIImage?
    @State private var image: UIImage? = nil
    @State private var goToSearchView: Bool = false
    @State private var go2StoryView: Bool = false
    @State private var openCameraView : Bool = false
    @State private var createPost: Bool = false
    let acco: AccountSettingsView
    
    var body: some View {
        VStack(spacing: 0){
            VStack(spacing: 0){
                HStack {
                    Text("system")
                        .bold()
                        .padding(.leading, 15)
                    
                    Image(systemName: "globe")
                        .bold()
                        .font(.body)
                        .foregroundStyle(.blue)
                    
                    Spacer()
                    
                    NavigationLink(destination: SearchView(), isActive: $goToSearchView) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        goToSearchView = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .padding(15)
                    }
                    Button(action: {
                        createPost = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .padding(.trailing ,15)
                        
                    }.fullScreenCover(isPresented: $createPost){
                        CreatePostView()
                            .environmentObject(authModel)
                    }
                    
                    
                    //                    Menu {
                    //                        Button{
                    //                            openCameraView = true
                    //                        }) {
                    //                            Label("Story", systemImage: "camera")
                    //                        }
                    //
                    //                        Button(action: {
                    //                            createPost = true
                    //                        }) {
                    //                            Label("Post", systemImage: "square.and.pencil")
                    //                        }
                    //                    } label: {
                    //                        Image(systemName: "plus")
                    //                            .font(.title2)
                    //                            .padding(15)
                    //
                    //                    }
                    //                    .fullScreenCover(isPresented: $openCameraView) {
                    //                        CameraView()
                    //                    }
                }.frame(height: 35)
            }
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        VStack {
                            NavigationLink(destination: StoryView(), isActive: $go2StoryView) {
                                EmptyView()
                            }
                            Button(action: {
                                go2StoryView = true
                            }) {
                                Image(uiImage: authModel.loadProfileImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .overlay(
                                                     Circle()
                                                         .stroke(Color.blue, lineWidth: 2)
                                                 )
                            }
                            
                            Text(authModel.name)
                                .font(.system(size: 15))
                        }.padding(.leading, 5)
                    }.frame(height: 100)
                }

            Divider()
          
                  LazyVStack(spacing: 0) {
                      ForEach(postManager.post) { post in
                          ImagePostView(post: post).environmentObject(viewModel)
                              .frame(maxWidth: .infinity)
                      }
                  }
                }.refreshable {
                    postManager.fetchUserPosts()
                }
                    .onAppear {
                        postManager.fetchUserPosts()
                    }
        }
        .frame(maxWidth: .infinity)
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(acco: AccountSettingsView())
    }
}
