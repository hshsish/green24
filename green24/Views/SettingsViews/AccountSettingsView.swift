
import SwiftUI

struct AccountSettingsView: View {
    
    @Environment(\.presentationMode) var presentatioMode
    @EnvironmentObject var authModel: AuthViewModel
    @EnvironmentObject var imageManager: ImageManager
    @State var isDataChanged: Bool = false
    @State var message: String = ""
    @State var titleMessage: String = ""
    @State var showGallery: Bool = false
    @State var showScaleEditor: Bool = false
    @State var showVerificationAlert: Bool = false
    @State var photoURL: UIImage?
    @State var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var primaryButtonTitle = ""
    @State private var primaryButtonAction: (() -> Void)?
    //    var shouldShowAlert: Bool {
    //        return imageManager.showAlert && authModel.hasChanges
    //    }
    
    private func setupEmailVerificationAlert() {
        alertTitle = "Email Verification"
        alertMessage = "Your email is not verified. Please verify your email to unlock full functionality."
        primaryButtonTitle = "Send Verification"
        primaryButtonAction = {
            authModel.sendEmailVerification { error in
                if let error = error {
                    print("Ошибка при отправке электронной почты для верификации: \(error.localizedDescription)")
                    //                    showAlert = true
                    alertTitle = "ops"
                    alertMessage = "iap"
                } else {
                    print("Электронное письмо для верификации успешно отправлено")
                    //                    showAlert = true
                    alertTitle = "no ops"
                    alertMessage = "no iap"
                }
            }
            print("send")
        }
    }
    
    //    private func setupNumberVerificationAlert() {
    //        alertTitle = "Number Verification"
    //        alertMessage = "Your number is not verified. Please verify your number to unlock full functionality."
    //        primaryButtonTitle = "Send Verification"
    //        primaryButtonAction = {
    //            // Добавьте код для повторной отправки верификации по номеру телефона
    //            // authModel.resendNumberVerification()
    //        }
    //    }
    
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
                    VStack{
                        Image(uiImage: authModel.loadProfileImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .onChange(of: authModel.photoURL) { newValue in
                                titleMessage = "Saved successfully"
                                message = "Your photo changed"
                            }
                        
                        Text("Set New Photo")
                            .font(.body)
                    }
                })
                .sheet(isPresented: $showGallery) {
                    ImagePickerView(selectedImage: $photoURL)
                        .onDisappear {
                            if let selectedImage = photoURL {
                                let fileName = imageManager.saveImage(image: selectedImage)
                                
                                if !fileName.isEmpty {
                                    
                                    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                    let imageURL = documentDirectory.appendingPathComponent(fileName)
                                    
                                    if let loadedImage = UIImage(contentsOfFile: imageURL.path) {
                                        photoURL = loadedImage
            
                                    } else {
                                        print("Не удалось загрузить изображение по указанному пути: \(imageURL)")
                                    }
                                } else {
                                    print("Имя файла пустое. Изображение не было сохранено.")
                                }
                                print("Фото выбрано и ImagePicker закрыт3")
                            }
                        }
                }
            }.frame(height: 250)
                
                TextField("Username", text: $authModel.name)
                    .frame(height: 40)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .onChange(of: authModel.name) { newValue in
                        titleMessage = "Saved successfully"
                        message = "Your name changed"
                    }.onSubmit({
                    
                        authModel.savedata()
                
                    })
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                    )
                    .padding(.top, 15)
                
                
                ZStack {
                    if authModel.email.isEmpty {
                        
                        TextField("Email", text: $authModel.email)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .onChange(of: authModel.email) {newValue in
                                titleMessage = "Saved successfully"
                                message = "Your email changed"
                            }.onSubmit({
                                authModel.savedata()
                            })
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                            )
                    } else {
                        
                        TextField("Email", text: $authModel.email)
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .onChange(of: authModel.email) {newValue in
                                titleMessage = "Saved successfully"
                                message = "Your email changed"
                            }.onSubmit({
                                authModel.savedata()
                            }).overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                            )
                    }
                    
                    HStack {
                        Spacer()
                        if authModel.localuser?.isEmailVerified != true {
                            Button {
                                
                            } label: {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundStyle(.orange)
                                    .padding(.trailing, 15)
                                    .onTapGesture {
                                        print("sllsllslslsls")
                                        showAlert = true
                                    }
                            }
                        }
                    }
                }.padding(.top, 15)
                
                TextField("Bio", text: $authModel.userBio)
                    .frame(height: 40)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .onChange(of: authModel.userBio) {newValue in
              
                        titleMessage = "Saved successfully"
                        message = "Your bio changed"
                    }.onSubmit({
                        authModel.savedata()
              
                    })
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                    ).padding(.top, 15)
                
                ZStack{
                    
                    TextField("Number", text: $authModel.number)
                        .frame(height: 40)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .onChange(of: authModel.number) {newValue in
                            titleMessage = "Saved successfully"
                            message = "Your number changed"
                        }.onSubmit({
                            authModel.savedata()
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.init(uiColor: .tertiarySystemFill), lineWidth: 1)
                        )
                    
                    HStack {
                        Spacer()
                        if authModel.localuser?.isEmailVerified != true {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.orange)
                                .padding(.trailing, 15)
                                .onTapGesture {
                                    showAlert.toggle()
                                }
                        }
                    }
                }.padding(.top, 15)
//            }
            
            Button(action: {
                //                if authModel.email.isEmpty {
                //                    authModel.email = emailTextField
                //                }
                authModel.savedata()
                
            }, label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.blue)
                    .accentColor(.white)
                    .cornerRadius(5)
                    .padding([.trailing, .leading, .top], 15)
            })
        }
        .alert(isPresented: Binding<Bool>(
            get: { authModel.hasChanges || showAlert },
            set: { _ in }
        )) {
            if authModel.hasChanges {
                
                return Alert(
                    title: Text("\(titleMessage)"),
                    message: Text("\(message)"),
                    dismissButton: .default(Text("cancel"), action: {
                        authModel.hasChanges.toggle()
                    })
                )
            } else if showAlert {
                let userEmail = authModel.localuser?.email
                
                let firstSixLetters = String(userEmail?.prefix(6) ?? "")
                let lastLetters = String(userEmail?.prefix(3) ?? "")
                return Alert(
                    
                    title: Text("Email verification"),
                    message: Text("We will send a verification letter to your email \(firstSixLetters)***")
                    
                )
            } else {
                return Alert(
                    title: Text(""),
                    message: Text("")
                )
            }
        }
        .padding(.bottom, 60)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView().environmentObject(AuthViewModel())
    }
}
