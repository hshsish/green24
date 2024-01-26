
import SwiftUI

struct NewPasswordView: View {
    
    @State var buttonColor : Color = .gray
    @State var isSecured : Bool = true
    @EnvironmentObject var authModel : AuthViewModel
    
    private var passwordsMatch: Bool {
        return authModel.newPassword == authModel.reEnterPassword && !authModel.newPassword.isEmpty && !authModel.reEnterPassword.isEmpty
    }

    var body: some View {
        VStack{
            Image(systemName: "lock")
                .font(.title)
                .foregroundStyle(.blue)
            
            Text("Create password")
                .bold()
                .padding()
            
            Divider()
            
            ZStack(alignment: .trailing){
                Group {
                    if isSecured {
                        SecureField("Create password", text: $authModel.newPassword)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                    } else {
                        TextField("Create password", text:  $authModel.newPassword)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                    }
                }.overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                )
                
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: self.isSecured ? "eye" : "eye.slash")
                        .accentColor(.blue)
                        .padding(15)
//                        .padding(.bottom)
                }
            }
//            .padding([.top, .bottom], 10)
            
            ZStack(alignment: .trailing){
                Group {
                    if isSecured {
                        SecureField("Re-enter password", text: $authModel.reEnterPassword)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                    } else {
                        TextField("Re-enter password", text:  $authModel.reEnterPassword)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                    }
                }
//                .onChange(of: newPassword) { value in
//                    buttonColor = value.isEmpty ? .gray : .blue
//                }
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                )
             

                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: self.isSecured ? "eye" : "eye.slash")
                        .accentColor(.blue)
                        .padding(.trailing, 15)
//                        .padding(.bottom)
                }
            }
            
            Button(action: {
     
                if authModel.reEnterPassword  != authModel.newPassword {
                    let alert = UIAlertController(title: "Error", message: "Password don't match",  preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                } else {
                    authModel.changePassword()
                    
                }
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(passwordsMatch ? Color.blue : Color.gray)
                    .accentColor(.white)
                    .cornerRadius(5)
            }
                .padding(.top, 10)
        }.padding()
    }
}

struct NewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NewPasswordView().environmentObject(AuthViewModel())
    }
}
