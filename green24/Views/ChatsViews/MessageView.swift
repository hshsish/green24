
import SwiftUI

struct MessageView: View {
    
    @State var goToUserView : Bool = false
    var body: some View {
        VStack{
            ZStack{
                Text("Chats")
                    .bold()
                    .font(.body)
                HStack(alignment: .center){
                    NavigationLink(destination: MainView(),
                                   isActive: $goToUserView) {
                        EmptyView()
                    }.navigationBarHidden(true)
                    Button(action: {
                        goToUserView = true
                        
                    }, label: {
                        Image("userPhoto")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .padding(.leading, 10)
                    })
                                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "square.and.pencil")
                            .padding(.trailing, 10)
                    }
                }
            }
            
            Divider()
            ScrollView{
                ChatRow()
//                ChatRow()
            }
            Spacer()
        }
        .font(.title2)
        .navigationBarHidden(true)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
