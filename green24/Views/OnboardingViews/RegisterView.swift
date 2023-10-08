
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseStorage
import Combine

struct RegisterView: View {

    @ObservedObject var authModel = AuthViewModel()
    @State private var isSecured: Bool = true
    @State var logStatus = false
    @State var newPassword : String = ""
    @State var passwordLabel : String = ""
    @State var rPassword : String = ""
    @State var readyToNavigate: Bool  = false

    var body: some View {
        VStack{
            TextField("Email", text: $authModel.email )
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .cornerRadius(5.0)
                .textContentType(.emailAddress)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                       .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                )   .padding([.trailing, .leading, .bottom])
            
            TextField("Username", text: $authModel.name)
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .cornerRadius(5.0)
                .textContentType(.username)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                       .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                )   .padding([.trailing, .leading, .bottom])
               
            
            ZStack(alignment: .trailing){
                
                Group {
                    if isSecured {
                        SecureField("Password", text: $authModel.password)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                    } else {
                        
                        TextField("  Password", text: $authModel.password)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    }
                }.overlay(
                    RoundedRectangle(cornerRadius: 5)
                       .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                )   .padding([.trailing, .leading, .bottom])
                
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: self.isSecured ? "eye" : "eye.slash")
                        .accentColor(.blue)
                        .padding(.trailing, 18)
                        .padding(.bottom)
                }
            }
            
            ZStack(alignment: .trailing){
                Group{
                    if isSecured {
                        
                        SecureField("Re-enter password" , text: $rPassword)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                    } else {
                        
                        TextField("Re-enter password", text: $rPassword)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    }
                }    .overlay(
                    RoundedRectangle(cornerRadius: 5)
                       .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                )    .padding([.trailing, .leading, .bottom])
                
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: self.isSecured ? "eye" : "eye.slash")
                        .accentColor(.blue)
                        .padding(.trailing, 18)
                        .padding(.bottom)
                }
            }
            
            if authModel.password != rPassword {
                       Text("Passwords don't match")
                           .foregroundColor(.red)
                   }
     
            
            Button(action: {
                if authModel.password != rPassword {
                    let alert = UIAlertController(title: "Error", message: "Password don't match",  preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }else{
                    authModel.signUp()
                    if logStatus == true {
                        readyToNavigate = true
                    }
                }
            }, label: {
                Text("signUp")
                    .font(.headline)
                    .padding()
                    .background(Color(uiColor: .secondarySystemFill))
                    .cornerRadius(5.0)
            })
        }.alert(authModel.errorMessage, isPresented: $authModel.showError, actions: {})
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
