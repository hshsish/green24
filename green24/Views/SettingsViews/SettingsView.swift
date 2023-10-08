
import SwiftUI

struct SettingsView: View {
    
    @State var setView = false
    @State var notView = false
    @State var backView = false
    @State var privView = false
    @StateObject var authModel: AuthViewModel
    @StateObject var imageManager: ImageManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack(alignment: .center){
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .padding(15)
                        }
                        Spacer()
              
                        
                    }
                    Text("Settings")
                }
                          
                       
                List{
                    Section{
                        Button(action: { setView = true }) {
                            Text("Account")
                        }.fullScreenCover(isPresented: $setView){
                            AccountSettingsView().environmentObject(imageManager)
                        }.navigationBarTitleDisplayMode(.automatic)
                        
                        Button(action: { notView = true }) {
                            Text("Notification")
                        }.fullScreenCover(isPresented: $notView){
                            NotificationSettingsView()
                        }
                        
                        Button(action: { privView = true }) {
                            Text("Privacy and Security")
                        }.fullScreenCover(isPresented: $privView){
                            SecuritySettingsView()
                        }
                    }
                    
                    Section {
                        Button(
                            action: {
                                AuthViewModel().signOut()
                            },
                            label: {
                                Text("Sign Out")
                                    .bold()
                                    .foregroundColor(.red)
                            }
                        )
                    }
                }
            }
        }.navigationBarBackButtonHidden(false)
      
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(authModel: AuthViewModel(), imageManager: ImageManager())
    }
}
