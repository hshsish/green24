
//import Foundation
//import SwiftUI
//
//class AppManager: ObservableObject {
//    
////    @ObservedObject var previousUser : DataManager
//    @EnvironmentObject var authModel : AuthViewModel
//    
//    func setAlert(){
//            var message = ""
//            print(message)
//        if authModel.localuser?.name != "" {
//                message += "Username: \(authModel.name)\n"
//            }
//
//            if authModel.localuser?.email != "" {
//                message += "Email: \(authModel.email)\n"
//            }
//
//        if authModel.localuser?.number != "" {
//                message += "Number: \(authModel.number)\n"
//            }
//
//        if authModel.localuser?.userBio != "" {
//                message += "Bio: \(authModel.userBio)\n"
//            }
//
//            if message == "" {
//       print(message)
//                return
//            }
//
//            let alert = UIAlertController(title: "Изменения", message: message, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
//            alert.addAction(okAction)
//            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//        }
//}
