
import SwiftUI

struct CommentView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var postManager: PostManager
    @EnvironmentObject var viewModel: YourViewModel
    @State var postID: String
    
    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .center, spacing: 15, content: {
                Text("Comments")
                    .bold()
                    .padding(.top, 20)
            })
            
            ScrollView{
                ForEach(postManager.comments, id: \.self) { comment in
                    CommentRowView(comment: comment)
                        .padding(10)
                        .frame(minHeight: 70)
                        .frame(maxHeight: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.init(uiColor: .tertiarySystemBackground), lineWidth: 1)
                        )
                        .environmentObject(viewModel)
                }
            }.frame(maxHeight: .infinity)
            
            Divider()
            
            HStack{
                Button(action: {
                }, label: {
                    Image(uiImage: authModel.loadProfileImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 2)
                        )
                })
                
                TextField("Add your comment", text: $postManager.commentText)
                    .frame(height: 40)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                    )
                
                if postManager.commentText.isEmpty {
                }else{
                    ZStack{
                        Button(action: {
                            postManager.addComment(postID: postID)
                           
                        }, label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 30))
                        })
                    }
                }
            }.padding(10)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(){
             
                postManager.getAllComments(forPostID: postID) { fetchedComments, error in
                    if let fetchedComments = fetchedComments {
                        postManager.comments = fetchedComments
                    } else if let error = error {
                        print("Error fetching comments: \(error)")
                    }
                }
            }
            .refreshable {
                postManager.getAllComments(forPostID: postID) { fetchedComments, error in
                    if let fetchedComments = fetchedComments {
                        postManager.comments = fetchedComments
                        
                    } else if let error = error {
                        print("Error fetching comments: \(error)")
                    }
                }
            }.onChange(of: postManager.comments) { oldValue in
                postManager.getAllComments(forPostID: postID) { fetchedComments, error in
                    if let fetchedComments = fetchedComments {
                        postManager.comments = fetchedComments
                    } else if let error = error {
                        print("Error fetching comments: \(error)")
                    }
                }
            }
    }
}
