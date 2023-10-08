
import SwiftUI

struct NotificationRow: View {
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                }, label: {
                    Image("userPhoto")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.leading, 10)
                    
                })
                VStack(alignment: .leading){
                    Text("username liked your photo")
                        .frame(width: .infinity)
                        .padding(.trailing)
                    
                    HStack{
                        Text("2 min ago")
                        Spacer()
                    }
                    
                }
                Spacer()
                Button(action: {
                }, label: {
                    Image("profilePhoto")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 10)
                    
                })
            }
        }
    }
}

struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRow()
    }
}
