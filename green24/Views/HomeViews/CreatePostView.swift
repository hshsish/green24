
import SwiftUI
import UIKit

struct CreatePostView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var postDescription = ""
    @State var showPostAlert = false
    @State private var isPhotoEditorPresented = false
    @EnvironmentObject var postManager: PostManager
    @EnvironmentObject var authModel: AuthViewModel
    @State var showGallery : Bool = false
    @State var selectedImage: UIImage?

    var body: some View {
        VStack{
            HStack(alignment: .center){
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                }.padding(.leading, 15)
                
                Spacer()
                
                Text("NewPublication")
                    .font(.title2)
                Spacer()
        
//                Button(action: {
//
//                }) {
//                    Image(systemName: "")
//                        .font(.title2)
//                }
//                .padding(.trailing, 15)
                
            }.padding(.top, 50)
            
            Divider()
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .onTapGesture {
                        isPhotoEditorPresented.toggle()
                    }.sheet(isPresented: $isPhotoEditorPresented) {
//                        PhotoEditorSwiftUIView {
//                            isPhotoEditorPresented.toggle()
//                        }
                    }
            }
            
            TextEditor(text: $postDescription)
                .multilineTextAlignment(.leading)
                .frame(maxHeight: .infinity)
                .onTapGesture {
                           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                       }
            HStack{
                
                Button(action: {
                    showGallery = true
                }) {
                    Image(systemName: "plus")
                }    .sheet(isPresented: $showGallery) {
                    ImagePickerView(selectedImage: $selectedImage)
                        }
                
                .padding(.leading, 15)
                
                Button(action: {
                    
                }) {
                    Image(systemName: "mappin")
                }.padding()
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Image(systemName: "at.badge.plus")
                }.padding(.trailing, 15)
            }.font(.title2)

                Button(action: {
                    if let imageURL = selectedImage {
                        postManager.uploadPhoto(selectedImage!, description: postDescription)
                    } else {
                        postManager.createPost(imageURL: "", caption: postDescription) { success, errorMessage in
                            if success {
                                print("Пост успешно создан")
                            } else {
                                print("Ошибка при создании поста: \(errorMessage ?? "Неизвестная ошибка")")
                            }
                        }
                    }
                
//                    postManager.uploadPhoto(selectedImage!, description: postDescription)
                }) {
                    Text("Share")
                        .font(.title2)
                               .foregroundColor(.white)
                               .frame(maxWidth: .infinity, maxHeight: 65)
                               .background(Color.blue)
            }
        } .alert("Your post was successfully published", isPresented: $postManager.showPostAlert) {
                        Button("OK") {
                            dismiss()
                        }
                    }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
