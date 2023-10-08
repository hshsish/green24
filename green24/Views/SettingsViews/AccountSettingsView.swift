

import SwiftUI

struct AccountSettingsView: View {
    
    @Environment(\.presentationMode) var presentatioMode
    @EnvironmentObject var authModel : AuthViewModel
    @EnvironmentObject var imageManager : ImageManager
    @State var isDataChanged : Bool = false
    @State var message : String = ""
    @State var titleMessage : String = ""
    @State var showGallery : Bool = false
    @State var showScaleEditor : Bool = false
    @State var photoURL: UIImage?
    @State var emailTextField : String = ""
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    self.presentatioMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                }).padding(.leading, 15)
                
                Spacer()
            }
            
            VStack{
                Button(action: {
                    showGallery = true
                    
                }, label: {
//                    Image("userPhoto")
                    Image(uiImage: authModel.loadProfileImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                }
                )
                
                Button(action: {
                    showGallery = true
                    
                }, label: {
                    Text("Set New Photo")
                })
                                .sheet(isPresented: $showGallery) {
                                    ImagePickerView(selectedImage: $photoURL)
                                        .onDisappear {
                                            if let selectedImage = photoURL {
                                                imageManager.uploadPhoto(selectedImage, for: authModel.localuser)
    
                                                                       authModel.savedata()
                                                                       authModel.showAlert = true
                                           
                                                                       print("Фото выбрано и ImagePicker закрыт3")
                                                                   }
                                        }
                                }
            }.frame(height: 250)
            Section {
                
                TextField("Username", text: $authModel.name)
                    .frame(height: 40)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .onChange(of: authModel.name) { newValue in
                        titleMessage = "Saved successfully"
                        message = "Your name changed"
                    }.overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                    )
                ZStack {
                    if authModel.email.isEmpty {
                        
                        TextField("Email", text: $emailTextField)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .onChange(of: authModel.email) {newValue in
                                titleMessage = "Saved successfully"
                                message = "Your email changed"
                            }.overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                            )
                    } else {
                        TextField("Email", text: $authModel.email)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .onChange(of: authModel.email) {newValue in
                                titleMessage = "Saved successfully"
                                message = "Your email changed"
                            }.overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                            )
                    }
                    
                    HStack {
                        Spacer()
                        if authModel.localuser?.isEmailVerified != true {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.orange)
                                .padding(.trailing, 15)
                        }
                    }
                }
                
                if authModel.localuser?.isEmailVerified != true {
                    HStack{
                        Spacer()
                        Button(action:{
                            authModel.sendEmailVerification()
                        }) {
                            HStack {
                                Text("Please verify your email")
                                    .foregroundStyle(.orange)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.orange)
                                    .padding(.trailing, 15)
                            }
                        }
                    }
                }
                
                TextField("Bio", text: $authModel.userBio)
                    .frame(height: 40)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .onChange(of: authModel.userBio) {newValue in
                        titleMessage = "Saved successfully"
                        message = "Your bio changed"
                    }.overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                    )
                ZStack{
                    TextField("Number", text: $authModel.number)
                        .frame(height: 40)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .onChange(of: authModel.number) {newValue in
                            titleMessage = "Saved successfully"
                            message = "Your number changed"
                        }.overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                        )
                    HStack {
                        Spacer()
                        if authModel.localuser?.isEmailVerified == true {
                        } else {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.orange)
                                .padding(.trailing, 15)
                        }
                    }
                }
                
                if authModel.localuser?.isEmailVerified != true {
                    HStack{
                        Spacer()
                        Button(action:{
                            authModel.sendEmailVerification()
                        }) {
                            HStack {
                                Text("Please verify your phone number")
                                    .foregroundStyle(.orange)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.orange)
                                    .padding(.trailing, 15)
                            }
                        }
                    }
                }
                
            }.padding([.leading, .top], 15)
            
            Button(action: {
                if authModel.email.isEmpty {
                    authModel.email = emailTextField
                }
                print(authModel.email)
                authModel.showAlert = true
                authModel.savedata()
   
            }, label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.blue)
                    .accentColor(.white)
                    .cornerRadius(5)
                    .padding([.trailing, .leading], 10)
            }) .alert(isPresented: $authModel.showAlert, content: {
                Alert(title: Text("\(titleMessage)"), message:Text("\(message)"))
            }).padding(.bottom, 60)
        }.onAppear {
            authModel.checkEmailVerification{ isNewValue in
                if isNewValue {
                    print("Email был верифицирован")
                } else {
                    print("Email не верифицирован или произошла ошибка")
                }
            }
        }.onChange(of: authModel.sendAuthAlert) { newValue in
            titleMessage = "Send successfully"
            message = "Your number changed"
        }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView().environmentObject(AuthViewModel())
    }
}
