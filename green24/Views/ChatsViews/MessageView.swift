
import SwiftUI

struct MessageView: View {
    
    @State var goToUserView : Bool = false
    @EnvironmentObject private var authModel: AuthViewModel
    
    var body: some View {
        VStack{
            ZStack{
                Text("Chats")
                    .bold()
                    .font(.body)
                HStack(alignment: .center){
                    NavigationLink(destination: MainView(selectedTab: "user"),
                                   isActive: $goToUserView) {
                        EmptyView()
                    }.navigationBarHidden(true)
                    Button(action: {
                        goToUserView = true
                        
                    }, label: {
                        Image(uiImage: authModel.loadProfileImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .padding(.leading, 15)
                    })
                                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding(15)
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "square.and.pencil")
                            .padding(.trailing, 15)
                    }
                }
            }
            
            Divider()
            ScrollView{
                ChatRow()
            }
            Spacer()
        }
        .font(.title2)
        .navigationBarHidden(true)
    }
}
