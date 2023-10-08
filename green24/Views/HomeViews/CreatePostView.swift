
import SwiftUI

struct CreatePostView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var PostManager: postManager
 
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                }.padding(.leading, 15)
                
                Spacer()
                
                Text("NewPublication")
                    .font(.title2)
                Spacer()
                
                Button(action: {

                }) {
                    Image(systemName: "")
                        .font(.title2)
                }
                .padding(.trailing, 15)
            }.padding(.top, 50)
            
            Divider()
            
            TextEditor(text: $PostManager.postText)
                .multilineTextAlignment(.leading)
                .frame(maxHeight: .infinity)
                .onTapGesture {
                           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                       }
            HStack{
                
                Button(action: {
                    
                }) {
                    Image(systemName: "plus")
                }.padding(.leading, 15)
                
                Button(action: {
                    
                }) {
                    Image(systemName: "mappin")
                }.padding()
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Image(systemName: "at.badge.plus")
                }.padding(.trailing, 15)
            }.font(.title2)

                Button(action: {
//                    PostManager.createPost(id: "", postText: PostManager.postText)
                    PostManager.postText = ""
                    if PostManager.pwc == true {
                        dismiss()
                    }
                }) {
                    Text("Share")
                        .font(.title2)
                               .foregroundColor(.white)
                               .frame(maxWidth: .infinity, maxHeight: 65)
                               .background(Color.blue)
            }
        }.ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
