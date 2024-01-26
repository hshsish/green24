
import Foundation
import SwiftUI
import Firebase
import Combine
import CoreData
import FirebaseStorage

class ImageManager: ObservableObject{
    
    @Environment(\.managedObjectContext) private var viewContext
    @Published var showAlert: Bool = false
    @Published var image: UIImage?
    
    @MainActor
    
    
   func uploadPhoto(_ photoURL: UIImage, description: String, for user: User?) {
       guard let imageData = photoURL.pngData() else {
           let error = NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get PNG representation of image"])
           print(error)
           return
       }
       
       if let id = Auth.auth().currentUser?.uid {
           let uniqueID = UUID().uuidString
           let fileName = "\(uniqueID)_profilePhoto.png"
           print("FileName: \(fileName)")
           
           let storageRef = Storage.storage().reference().child("user_\(id)_photos/\(fileName)")
           storageRef.putData(imageData, metadata: nil) { metadata, error in
               if let error = error {
                   print("Error in upload: \(error)")
               } else {
                   storageRef.downloadURL { url, error in
                       if let error = error {
                           print("Error getting download URL: \(error)")
                       } else if let url = url {
                  
                       } else {
                           let error = NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL for uploaded image"])
                           print(error)
                       }
                   }
               }
           }
       }
   }

    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            self.image = image

            return image
            
        }
        
        return nil
    }
    

//    func uploadPhoto(_ photoURL: UIImage, for user: User?) {
//        guard let imageData = photoURL.pngData() else {
//            let error = NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get PNG representation of image"])
//            print(error)
//            return
//        }
//        
//        let photoURl = photoURL
//        
//        if let id = Auth.auth().currentUser?.uid {
//            let fileName = "\(id)profilePhoto.png"
//            print("FileName: \(fileName)")
//            
//            let storageRef = Storage.storage().reference().child("user_\(id)_photos/\(fileName)")
//            storageRef.putData(imageData, metadata: nil) { metadata, error in
//                if let error = error {
//                    print("Error in upload: \(error)")
//                } else {
//                    storageRef.downloadURL { url, error in
//                        if let error = error {
//                            print("Error getting download URL: \(error)")
//                        } else if let url = url {
//                            guard let userUID = Auth.auth().currentUser?.uid else { return }
//                            Firestore.firestore().collection("Users").document(userUID).setData(["photoURL": url.absoluteString], merge: true) { [self] error in
//                                if let error = error {
//                                    print("Error in Firestore setData: \(error)")
//                                } else {
//                                    print("Successfully uploaded and updated data.")
////                                    saveImage(image: photoURl)
//                                    print(fileName)
//                                    print(imageData)
//                                
//                                }
//                            }
//                        } else {
//                            let error = NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL for uploaded image"])
//                            print(error)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
   func saveImage(image: UIImage) -> String {
            let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            if let userUID = Auth.auth().currentUser?.uid {
                let fileName = "\(userUID)profilePhoto.png"
                
                
                let url = document.appendingPathComponent(fileName)
                print("filename\(fileName)")
                let data = image.jpegData(compressionQuality: 1)!
                do {
                    try data.write(to: url)
                    print("succInImageManagersaveIMG\(fileName)")
                } catch {
                    print(error)
                }
                return fileName
            }
            return ""
        }
}
