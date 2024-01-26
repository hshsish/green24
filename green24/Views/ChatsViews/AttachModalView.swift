
import Foundation
import SwiftUI
import MobileCoreServices

struct AttachModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var selectedTab = 0 
    @State var showImagePicker = false
    @State var showDocumentPicker = false
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
     
                Button("Выбрать из галереи") {
               
                    presentationMode.wrappedValue.dismiss()
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: .photoLibrary) { image in
                    
                    }
                }
                .tabItem {
                    Image(systemName: "photo")
                    Text("Галерея")
                }
                .tag(0)

                Button("Выбрать документ") {
                    presentationMode.wrappedValue.dismiss()
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker(allowedContentTypes: [kUTTypePDF as String, kUTTypeText as String]) { url in
                    
                    }
                }
                .tabItem {
                    Image(systemName: "doc")
                    Text("Документы")
                }
                .tag(1)
            }
            .padding(.top, 20)

            Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.top, 20)
        }
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias PickedHandler = (UIImage) -> Void

    var sourceType: UIImagePickerController.SourceType
    var onPicked: PickedHandler?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPicked: onPicked)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var onPicked: PickedHandler?

        init(onPicked: PickedHandler?) {
            self.onPicked = onPicked
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                onPicked?(image)
            }
            picker.dismiss(animated: true)
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController
    typealias PickedHandler = (URL) -> Void
    
    var allowedContentTypes: [String]
    var onPicked: PickedHandler?
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
          let picker = UIDocumentPickerViewController(documentTypes: allowedContentTypes, in: .import)
          picker.delegate = context.coordinator 
          return picker
      }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


class Coordinator: NSObject, UIDocumentPickerDelegate {
    let parent: DocumentPicker

    init(_ parent: DocumentPicker) {
        self.parent = parent
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            parent.onPicked!(url)
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    }
}

