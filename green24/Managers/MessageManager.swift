
import Foundation
import Firebase
import Combine

//class MessageManager:  ObservableObject{
//    
//  @Published var authModel:  AuthViewModel
//    @Published var text : String = ""
//    @Published var errorMessage = ""
//    let db = Firestore.firestore()
//
//
//    func addMessage(_ message: Message, completion: @escaping (Error?) -> Void) {
//        let data: [String: Any] = [
//            "text": message.text,
//            "senderId": message.senderId,
//            "timestamp": message.timestamp
//        ]
//
//        db.collection("messages").addDocument(data: data) { error in
//            completion(error)
//        }
//    }
//
////    func handleSend() {
////        print(text)
////        guard let fromId = Auth.auth().currentUser?.uid else { return }
////print(fromId)
////
////        guard let toId = chatUser?.uid else { return }
////
////        let document = db.collection("messages")
////            .document(fromId)
////            .collection(toId)
////            .document()
////
////        let messageData = ["fromId": fromId, "toId": toId, "text": text, "timestamp": Timestamp()] as [String : Any]
////
////        document.setData(messageData) { error in
////            if let error = error {
////                print(error)
////                self.errorMessage = "Failed to save message into Firestore: \(error)"
////                return
////            }
//
////            print("Successfully saved current user sending message")
////            self.text = ""
////        }
////
////        let recipientMessageDocument = db.collection("messages")
////            .document(toId)
////            .collection(fromId)
////            .document()
////
////        recipientMessageDocument.setData(messageData) { error in
////            if let error = error {
////                print(error)
////                self.errorMessage = "Failed to save message into Firestore: \(error)"
////                return
////            }
////
////            print("Recipient saved message as well")
////        }
////    }
//}
//
