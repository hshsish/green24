
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseStorage
import Combine


/*
1 - фото пользоваеля - сохранение
отображение
 сохранение качества
 настройки фото
 
 2 - пользоателя не выкидывает в случае удаления аккаунта
 UserData(string,data) - login/sighin - UD loading and save locally -
 //  - UD was changed(old data was deleted - data was updated on db(str) - save DATA locally(data)- saveuserlocally(str)- loading and display)/ save locally / save on db / loading - sigh out - delete local user
*/
 
struct ContentView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var imageManager: ImageManager
    
    var body: some View {
        Group {
            if authModel.user != nil {
                MainView(selectedTab: "user")
            } else {
                LoginView()
            }
        }
        .onAppear {
         
            authModel.getLocalUser()
            authModel.listenToAuthState()
            print("contentView/localUser/\(authModel.localuser)")
           
//            if authModel.localuser?.isEmailVerified != true {
//                authModel.checkEmailVerification()
//                print("contrntviewINemailverif\(authModel.isEmailVerified)")
//            } else {
//                print("contrntviewINemailverif\(authModel.isEmailVerified)")
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthViewModel()).environmentObject(ImageManager())
    }
}
