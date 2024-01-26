
import SwiftUI
import CoreData
import Foundation
import Firebase
import Combine
import FirebaseStorage
import Kingfisher

struct UserView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject var postManager: PostManager
    @Environment(\.colorScheme) var colorScheme
    @State var go2StoryView = false
    @State private var inputImage: UIImage?
    @EnvironmentObject var viewModel: YourViewModel
    @State private var posts = [Post]()
    @State var profilePicker : picker = picker.photo
    @State private var selectedIndex: Int = 0
    let segmentTitles = ["Photos", "Posts"]
    
    @State private var nextPage : Bool = false
    
    enum picker : String {
        case photo, text
    }
    
    init() {
        let segmentedControl = UISegmentedControl.appearance()
        let screenSize = UIScreen.main.bounds.size
        
        segmentedControl.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 70)
    }
    
    var plugImage: Image {
        if colorScheme == .dark {
            return Image("dark_plug")
        } else {
            return Image("white_plug")
        }
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                VStack(spacing: 0){
                    HStack{
                        Text(authModel.name)
                            .padding(.leading, 15)
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                        }
                        
                        Button {
                            nextPage = true
                        } label: {
                            Image(systemName: "text.justify")
                                .padding(15)
                        }.sheet(isPresented: $nextPage) {
                            SettingsView(authModel: authModel, imageManager: ImageManager())
                        }
                    }.font(.title2)
                    
                    HStack{
                        
                        Button(action: {
                        }, label: {
                            
                            Image(uiImage: authModel.loadProfileImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                            
                        }) .padding([.bottom, .leading], 5)
                        HStack{
                            VStack(alignment: .center){
                                
                                Button(action: {
                                    
                                }, label: {
                                    if postManager.numberOfPosts != 0 {
                                        Text("\(postManager.numberOfPosts)")
                                            .font(.title2)
                                    }else {
                                        Text("0")
                                            .font(.title2)
                                    }
                                })
                                
                                Text("posts")
                                
                            }.padding()
                            
                            VStack{
                                
                                Button(action: {
                                    
                                }, label: {
                                    Text("0")
                                        .font(.title2)
                                })
                                
                                Text("followers")
                                
                            }.padding()
                            
                            VStack{
                                
                                Button(action: {
                                    
                                }, label: {
                                    Text("0")
                                        .font(.title2)
                                })
                                
                                Text("following")
                                    .font(.callout)
                                
                            }.padding()
                            
                        }.frame(maxWidth: .infinity)
                    }.frame(maxWidth: .infinity)
                    
                    HStack{
                        Text(authModel.userBio)
                            .padding(.leading, 10)
                            .font(.body)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal) {
                        HStack{
                            NavigationLink(destination: StoryView(),
                                           isActive: $go2StoryView) {
                                EmptyView()
                            }.navigationBarHidden(true)
                            
                            Button(action: {
                                go2StoryView = true
                            }, label: {
                                Image("profilePhoto")
                                    .resizable()
                                    .frame(width: 65, height: 65)
                                    .clipShape(Circle())
                                    .padding(5)
                            })
                            
                            Button(action: {
                                
                            }, label: {
                                Image("profilePhoto")
                                    .resizable()
                                    .frame(width: 65, height: 65)
                                    .clipShape(Circle())
                                    .padding(5)
                            })
                        }
                    }
                }
                
                Divider()
                
                CustomSegmentedControl(selectedIndex: $selectedIndex, segmentTitles: segmentTitles)
                    .padding(5)
                
                if selectedIndex == 0 {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0),
                            GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0),
                            GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0)
                        ], spacing: 0) {
                            if postManager.post.isEmpty {
                                
                                ForEach(0..<21) { _ in
                                    plugImage
                                        .resizable()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 550)
                                        .overlay {
                                            ProgressView()
                                        }
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                                        .clipped()
                                }
                            } else {
                                ForEach(postManager.post) { post in
                                    NavigationLink(destination: ImagePostView(post: post).environmentObject(authModel).environmentObject(viewModel).environmentObject(postManager)) {
                                        KFImage(URL(string: post.postImageURL!))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                                            .clipped()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    
                    TextPostView(post: Post(id: "", author: "", createdAt: Date(), likes: [], save: 0))
                    
                    Spacer()
                }
            }
            .refreshable {
                postManager.fetchUserPosts()
            }.onAppear {
                postManager.fetchUserPosts()
            }
        }
        
    }
}

struct CustomSegmentedControl: View {
    @Binding var selectedIndex: Int
    var segmentTitles: [String]
    
    var body: some View {
        HStack {
            ForEach(0..<segmentTitles.count, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                }) {
                    Text(segmentTitles[index])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(index == selectedIndex ? .white : .blue)
                        .background(index == selectedIndex ? Color.blue : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 40)
    }
}
