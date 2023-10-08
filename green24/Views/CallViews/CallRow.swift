
import SwiftUI

struct CallRow: View {
    var body: some View {

            HStack{
                Button(action: {
                    
                }, label: {
                    
                    Image("userPhoto")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding()
                    
                    Text("+ 1 420 864 66 39")
                        .font(.body)
                        .foregroundColor(.white)
                })
                
                Spacer()
                
                Text("2 min ago")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                
                Image(systemName: "phone.arrow.up.right")
                    .font(.body)
                    .padding()
                    .foregroundColor(.blue)
                
            }  .frame(height: 50)
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(Capsule())
    }
}

struct CallRow_Previews: PreviewProvider {
    static var previews: some View {
        CallRow()
    }
}
