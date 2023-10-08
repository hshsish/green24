
import SwiftUI

struct ChatRow: View {
    
    @State var isShowingOptions : Bool = false

    var body: some View {
        VStack{
            HStack{
                NavigationLink(destination: ChatView(),
                               isActive: $isShowingOptions) {
                   EmptyView()
                }.navigationBarBackButtonHidden(true)
                
                Button(action: {
                    isShowingOptions = true
                    
                }, label: {
                    Image("userPhoto")
                        .resizable()
                        .frame(width: 57, height: 57)
                        .clipShape(Circle())
                })
                VStack{
                    Spacer()
                    HStack{
                        Text("username")
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .font(.title3)
                            .bold()
                        
                        Image(systemName: "checkmark")
                            .font(.body)
                            .foregroundColor(.blue)
                        
                        Text("04:20")
                            .padding(.trailing)
                            .font(.body)
                            .foregroundColor(.gray)
                        
                    }.frame(height: 15)
                 
                        Text("textmessage")
                            .frame(maxWidth: .infinity,maxHeight: 20,alignment: .leading)
                            .font(.body)
                            .padding(.bottom,15)
                            .foregroundColor(.gray)
                }
                
            }
            .frame(height: 60)
            .background(Color(uiColor: .tertiarySystemFill))
            .clipShape(Capsule())
            .padding(.all, 5)
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow()
    }
}
