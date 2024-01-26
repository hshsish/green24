
import SwiftUI

struct CommentRowView: View {
    
    var comment: Comment
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject var postManager: PostManager
    @EnvironmentObject var viewModel: YourViewModel
    @State var receivedUsername: String = ""
    
    var body: some View {
        HStack(alignment: .top, spacing: 0){
            Button(action: {
            }, label: {
                Image(uiImage: authModel.loadProfileImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
            })
            
            VStack(alignment: .leading, spacing: 0){
                HStack{
                        Text(receivedUsername)
                            .font(.system(size: 15))
                            .bold()

                    Text("\(viewModel.convertDateString(from: comment.createdDate))")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
                
                HStack{
                    Text("\(comment.text)")
                    
                    Spacer()
                }
            }
            
            Button(action: {
            }, label: {
                Image(systemName: "arrowshape.turn.up.left")
                
            })
        }.frame(maxWidth: .infinity)
            .onAppear(){
                viewModel.getUsername(forUserID: comment.userID) { receivedUsername in
                    DispatchQueue.main.async {
                        viewModel.username = receivedUsername
                        self.receivedUsername = receivedUsername!
                        print("\(self.receivedUsername)")
                    }
                }
            }
    }
}
