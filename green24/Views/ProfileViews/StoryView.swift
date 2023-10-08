
import SwiftUI

struct StoryView: View {
    
    @State var goToUserView : Bool = false
    var body: some View {
        ZStack{
            Image("userPhoto")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            VStack{
                Spacer()
                HStack{
                    
                    NavigationLink(destination: MainView(selectedTab: "user"),
                               isActive: $goToUserView) {
                   EmptyView()
                }.navigationBarHidden(true)
                    
                    Button(action: {
                        goToUserView = true
                    }, label: {
                        Image("userPhoto")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .padding(5)

                    })
                    
                    Text("Username")
                        .frame(width: 200)
            
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "bolt.horizontal")
                            .padding(5)
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "heart")
                            .padding(5)
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.right")
                            .padding(.leading, 5)
                    })
                }.frame(width: .infinity, height: 40, alignment: .leading)
                .foregroundColor(.black)
                   
            }
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
