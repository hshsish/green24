
import SwiftUI

struct SavedView: View {
    
    @EnvironmentObject var authModel: AuthViewModel
    
    var body: some View {
        VStack{
            
            Text("All saved posts")
                .bold()
                .padding(15)
            
            List {
                
            }
        }.onAppear {
        }
    }
}

#Preview {
    SavedView()
}
