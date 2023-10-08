
import SwiftUI

struct ScaleEditorView: View {
//    let image: UIImage
    @State var scale: CGFloat = 1.0
    @EnvironmentObject var imageManager : ImageManager

    
    var body: some View {
        VStack {
//            Image(uiImage: imageManager.photoURL!)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .scaleEffect(scale)
//                .gesture(MagnificationGesture()
//                            .onChanged { value in
//                                scale = value.magnitude
//                            })
            
           
            Button(action: {
//                imageManager.uploadPhoto(imageManager.photoURL, for: User(name: "", photoURL: "")) { result in
//                    switch result {
//                     case .success(let url):
//                         // Обновите UI или выполните другие действия после успешной загрузки фотографии
//                         print("Фотография успешно загружена: \(url.absoluteString)")
//                     case .failure(let error):
//                         // Обработайте ошибку, если загрузка фотографии не удалась
//                         print("Ошибка при загрузке фотографии: \(error.localizedDescription)")
//                     }
//                }
            }, label: {
                Text("Set New Photo")
            })
        }
        .navigationTitle("Редактирование масштаба")
    }
}
struct ScaleEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ScaleEditorView()
    }
//image: UIImage(), imageManager: ImageManager(authModel: AuthViewModel), usr: User())
}
