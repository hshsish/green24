
import SwiftUI
import Firebase

struct PasswordView: View {
    
    @State var isSecured : Bool = true
    @State var password : String = ""
    @State var buttonColor : Color = .gray
    @State var forgotPage : Bool =  false
    @EnvironmentObject var authModel : AuthViewModel
    @FocusState var nameIsFocused : Bool
    
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Text("Enter the password")
                        .bold()
                }
                
                Divider()
                
                Text("To continue, please confirm that you're the owner of this account")
                    .multilineTextAlignment(.center)
                    .padding(.all)
                
                ZStack(alignment: .trailing){
                    Group {
                        if isSecured {
                            SecureField("Enter your password", text: $password)
                                .frame(height: 40)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                .focused($nameIsFocused)
                        } else {
                            TextField("Enter your password", text:  $password)
                                .frame(height: 40)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                .focused($nameIsFocused)
                        }
                    }.overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                    )
                    .onChange(of: password) { value in
                        buttonColor = value.isEmpty ? .gray : .blue
                    }
                    .padding([.trailing, .leading, .bottom])
                    
                    Button(action: {
                        isSecured.toggle()
                    }) {
                        Image(systemName: self.isSecured ? "eye" : "eye.slash")
                            .accentColor(.blue)
                            .padding(.trailing, 18)
                            .padding(.bottom)
                    }
                }
                
                NavigationLink(destination: ResetPasswordView(),
                               isActive: $forgotPage) {
                    EmptyView()
                }
                Button(action: {
                    nameIsFocused = false
                    forgotPage = true
                    
                }) {
                    Text("Forgot password?")
                        .accentColor(.blue)
                }.padding(15)
                NavigationLink(destination: NewPasswordView(),
                               isActive: $authModel.nextPage) {
                    EmptyView()
                }
                
                Button(action: {
                    nameIsFocused = false
                    authModel.checkPassword(password: password)
               
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(buttonColor)
                        .accentColor(.white)
                        .cornerRadius(5)
                }.padding(5)
            }
            .alert(authModel.errorMessage, isPresented: $authModel.showError, actions: {})
            .onDisappear{
                
                authModel.enterPassword = password
                password = ""
            }
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView().environmentObject(AuthViewModel())
    }
}
