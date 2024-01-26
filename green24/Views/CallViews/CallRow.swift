
import SwiftUI

struct CallRow: View {
    var body: some View {

            HStack{
                Button(action: {
                    
                }, label: {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("+ 1 420 864 66 39")
                        .font(.body)
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
                
            } .frame(height: 45)
            .frame(maxWidth: .infinity)
    }
}

struct CallRow_Previews: PreviewProvider {
    static var previews: some View {
        CallRow()
    }
}
