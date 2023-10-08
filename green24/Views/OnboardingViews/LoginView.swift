

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseStorage
import Combine

struct LoginView: View {
    
    enum picker : String {
        case login, signUp
    }
    
    var logStatus: Bool {
        return Auth.auth().currentUser != nil
    }
    
    @EnvironmentObject private var authModel: AuthViewModel
    @State var isEditing = false
    @State private var isSecured: Bool = true
    @State var authPicker: picker = picker.login
    @State var newPassword : String = ""
    @State var passwordLabel : String = ""
    @State var rPassword : String = ""
    @State var title : String = ""
    @State var isAuthenticated = false
    @State var readyToNavigate: Bool  = false

    
    var body: some View {
//            NavigationStack{
                VStack {
                    VStack {
                        HStack(alignment: .top) {
                            
                            Text("system")
                            Image(systemName: "globe")
                        }
                        .padding(10.0)
                        .foregroundStyle(.blue)
                        
                        Picker("picker", selection: $authPicker) {
                            
                            Text("Login")
                                .tag(picker.login)
                            Text("Sign Up")
                                .tag(picker.signUp)
                        }
                        .padding()
                        .pickerStyle(SegmentedPickerStyle())
                        .cornerRadius(5.0)
                    }
                    .frame(height: 100.0)
                    
                    VStack() {
                        
                        if authPicker.rawValue == "login" {
                            
                            TextField("Username or email", text: $authModel.loginTextField)
                                .frame(height: 40)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
//                                .background(Color(uicColor: .tertiarySystemFill))
                                .cornerRadius(5)
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
                                        TextField("Password", text:  $authModel.password)
                                            .frame(height: 40)
                                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                            
                                    }
                                }
                                .overlay(
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
                        }
                        
                        if authPicker.rawValue == "signUp" {
                            
                            RegisterView()
                        }
                        
                        VStack{
                            
                            if authPicker.rawValue == "login" {
                                
                                Button(action: {
                                    authModel.login()
                                    if logStatus == true {
                                        readyToNavigate = true
                                    }
                                }, label: {
                                    
                                    Text("Login")
                                        .font(.headline)
                                        .padding()
                                        .background(Color(uiColor: .tertiarySystemFill))
//                                        .foregroundStyle(.black)
                                        .cornerRadius(5.0)
                                })
                            }
                        }
                        .navigationDestination(isPresented: $readyToNavigate) {
                            MainView()
                                .navigationBarHidden(true)
                        }
                    }
                    .frame(height: 260.0, alignment: .top)
//                }
            }
            .alert(authModel.errorMessage, isPresented: $authModel.showError, actions: {})
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}
