

import SwiftUI
import Firebase

struct ResetPasswordView: View {
    
    @State var resPicker : resetPicker = resetPicker.number
    @EnvironmentObject var authModel : AuthViewModel
//    @Environment(\.dismiss) var dismiss
    @State var readyForFreddie : Bool = false
    @State var accountSettings : Bool = false
    
    enum resetPicker : String {
        case number, email
    }
    
    var body: some View {
        VStack{
//            NavigationView {
                VStack{
                    ZStack{
                        HStack{
                            Button(action: {
                                //                            readyForFreddie = true
//                                dismiss()
                            }, label: {
                                Image(systemName: "chevron.backward")
                                    .font(.title2)
                            }).padding(.leading, 10)
                            Spacer()
                        }     .navigationDestination(isPresented: $readyForFreddie) {
                            PasswordView()
                                .navigationBarHidden(true)
                        }
                        
                        Text("Reset password")
                            .bold()
                    }
                    
                    Divider()
                    
                    Picker("resetPicker", selection: $resPicker) {
                        
                        Text("with email")
                            .tag(resetPicker.email)
                        Text("with number")
                            .tag(resetPicker.number)
                        
                    }
                    .padding([.leading, .trailing], 15)
                    .pickerStyle(SegmentedPickerStyle())
                    .cornerRadius(5.0)
                    
                    if resPicker.rawValue == "number" {
                        if !authModel.number.isEmpty {
                            
                            let numbers = authModel.number
                            let firstTwoDigits = String(numbers.prefix(2))
                            let lastTwoDigits = String(numbers.suffix(2))
                            
                            (Text("This phone number will be used to confirm this\n action: ")
                                .foregroundColor(.gray) +
                             Text("+ \(firstTwoDigits) • • • \(lastTwoDigits)")
                                .foregroundColor(.black))
                            .multilineTextAlignment(.center)
                            .padding(.top, 50)
                            Spacer()
                            Button(action: {
                                
                                
                            }) {
                                Text("Continue")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(Color.blue)
                                    .accentColor(.white)
                                    .cornerRadius(5)
                            }.padding(5)
                        } else {
                            
                            Text("Your number has not yet been linked to this page.")
                                .multilineTextAlignment(.center)
                                .padding(.top, 30)
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                accountSettings = true
                   
                            }, label: {
                                Text("Want to add it now?")
                                    .padding(.top, 7)
                                    .foregroundColor(.blue)
                            }).fullScreenCover(isPresented: $accountSettings){
                                AccountSettingsView()
                            }.navigationBarTitleDisplayMode(.automatic)
                            
                        }
                        
                    }
                    
                    if resPicker.rawValue == "email" {
                        if !authModel.email.isEmpty {
                     
                            let email = authModel.email
                            
                            let firstTwoLetters = String(email.prefix(2))
                            
                            let lastLetters = email.split(separator: "@")[1]
              
                            (Text("This email will be used to confirm this\n action: ")
                                .foregroundColor(.gray) +
                             Text("\(firstTwoLetters) • • • @\(String(lastLetters))")
                                .foregroundColor(.black))
                            .multilineTextAlignment(.center)
                            .padding(.top, 50)
                            Spacer()
                            Button(action: {
                                
                                
                            }) {
                                Text("Continue")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(Color.blue)
                                    .accentColor(.white)
                                    .cornerRadius(5)
                            }.padding(5)
                        } else {
                            
                            Text("Your email has not yet been linked to this page.")
                                .multilineTextAlignment(.center)
                                .padding(.top, 30)
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                accountSettings = true
                                
                            }, label: {
                                Text("Want to add it now?")
                                    .padding(.top, 7)
                                    .foregroundColor(.blue)
                            }).fullScreenCover(isPresented: $accountSettings){
                                AccountSettingsView()
                            }.navigationBarTitleDisplayMode(.automatic)
                            
                            
                        }
                    }
                    
               
                    Spacer()
                }         .padding(10)
//            }
//        }   .navigationDestination(isPresented: $accountSettings) {
//            AccountSettingsView()
//                .navigationBarHidden(true)
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView().environmentObject(AuthViewModel())
    }
}
