
import SwiftUI
import Firebase

struct HomeView: View {
    
    @EnvironmentObject var authModel : AuthViewModel
    @State var goToSearchView: Bool = false
    @State var go2StoryView: Bool = false
    @State var openCameraView : Bool = false
    @State var showGallery : Bool = false
    @State var selectedImage: UIImage?
    @State var createPost: Bool = false
    @State var posts = [Post]()
    @State var image: UIImage? = nil
    var acco : AccountSettingsView
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("system")
                        .padding(.leading)
                        .bold()
                    
                    Image(systemName: "globe")
                        .bold()
                        .padding(.trailing)
                        .font(.body)
                        .foregroundStyle(.blue)
                    
                    Spacer()
                    
                    NavigationLink(destination: SearchView(),
                                   isActive: $goToSearchView) {
                        EmptyView()
                    }
                    Button(action: {
                        goToSearchView = true
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    NavigationLink(destination: CreatePostView(),
                                   isActive: $createPost) {
                        EmptyView()
                    }
                    
                    Menu {
                        
                        Button(action: {
                            openCameraView = true
                        }) {
                            Label("Story", systemImage: "camera")
                        }
                        
                        Button(action: {
                            createPost = true
                        }){
                            Label("Post", systemImage: "square.and.pencil")
                        }
                    } label: {
                        Image(systemName: "plus")
                            .padding(.trailing, 15)
                        
                    }
                    //                    .sheet(isPresented: $showGallery) {
                    //                        ImagePickerView(selectedImage: self.$selectedImage)
                    //                    }
                    .fullScreenCover(isPresented: $openCameraView) {
                        CameraView()
                    }
                }
                .padding(.top, 40)
                .font(.title3)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        VStack{
                            NavigationLink(destination: StoryView(),
                                           isActive: $go2StoryView) {
                                EmptyView()
                            }
                            Button(action: {
                                go2StoryView = true
                            }, label: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 80, height: 80)
                                
                                
                            })
                            Text(authModel.name)
                        }.padding(.leading)
                    }.frame(height: 100)
                }
            }
            
            Divider()
            
            ScrollView(showsIndicators: false) {
                //                List(PostManager.post) { post in
                //                    VStack{
                //                        Text("lll")
                //                        Text(post.postText)
                //                    }
                //                }.onAppear() {
                //                    self.PostManager.fetchPosts()
                //                }
                //                PostView()
                
                Spacer()
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(acco: AccountSettingsView())
    }
}
