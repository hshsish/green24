
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseDatabaseSwift
import CoreData
import FirebaseFirestoreSwift

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var isEmailVerified : Bool = false
    @Published var isNumberVerified : Bool = false
    @Published var enterPassword : String = ""
    @Published var loginTextField : String = ""
    @Published var newPassword : String = ""
    @Published var reEnterPassword : String = ""
    @Published var hasChanges: Bool = false
    @Published var users = [User]()
    @Published var dat = DataManager()
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var userBio: String = ""
    @Published var number: String = ""
    @Published var email: String = ""
    @Published var nuserBio: String = ""
    @Published var photoURL: String = ""
    @Published var nextPage: Bool = false
    @Published var userProfilePicData: Data?
    @Published var errorMessage: String = ""
    @Published var showError: Bool  = false
    @Published var sendAuthAlert : Bool = false
    @State var readyToNavigate: Bool  = false
    @State var logStatus: Bool = false
    @Published var userok : User!
    @Published var user: Firebase.User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    var localuser: User?
    
    func getLocalUser() {
        let user =  dat.getUserLocally()
        if user != nil {
            self.name = user?.name ?? ""
            self.number = user?.number ?? ""
            self.userBio = user?.userBio ?? ""
            self.email = user?.email ?? ""
            self.photoURL = user?.photoURL ?? ""
            self.isEmailVerified = user?.isEmailVerified ?? false
            self.isNumberVerified = user?.isNumberVerified ?? false
            self.localuser = user
            
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }
    
    func removeSavedPostFromFirebase(userId: String, postId: String) {
        let savedPostsCollection = Firestore.firestore().collection("SavedPosts")
        
        let query = savedPostsCollection
            .whereField("userId", isEqualTo: userId)
            .whereField("postId", isEqualTo: postId)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Ошибка при получении документов: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Документы не найдены")
                return
            }
            
            for document in documents {
                savedPostsCollection.document(document.documentID).delete { error in
                    if let error = error {
                        print("Ошибка при удалении данных: \(error.localizedDescription)")
                    } else {
                        print("Данные успешно удалены из Cloud Firestore")
                    }
                }
            }
        }
    }
    
    func getSavedPostsFromFirebase(userId: String, completion: @escaping ([Post]) -> Void) {
        let savedPostsCollection = Firestore.firestore().collection("SavedPosts")
        
        let query = savedPostsCollection
            .whereField("userId", isEqualTo: userId)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Ошибка при получении документов: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Документы не найдены")
                completion([])
                return
            }
            let savedPostIds = documents.compactMap { $0["postId"] as? String }
            
            var savedPosts: [Post] = []
            let dispatchGroup = DispatchGroup()
            for postId in savedPostIds {
                dispatchGroup.enter()
                
                self.getPostByPostId(postId: postId) { post in
                    if let post = post {
                        savedPosts.append(post)
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(savedPosts)
            }
        }
    }
    
    func getPostByPostId(postId: String, completion: @escaping (Post?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Пользователь не аутентифицирован")
            completion(nil)
            return
        }
        
        let postsCollection = Firestore.firestore().collection("Posts").document(userUID).collection("userPosts")
        let query = postsCollection.whereField("id", isEqualTo: postId)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Ошибка при получении документа поста: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents, let document = documents.first else {
                print("Документ поста не найден")
                completion(nil)
                return
            }
        }
    }
    
    func savePostToFirebase(userId: String, postId: String) {
        
        let savedPostsCollection = Firestore.firestore().collection("SavedPosts")
        let newPostDocument = savedPostsCollection.document()
        let postData: [String: Any] = [
            "postId": postId,
            "userId": userId
        ]
        
        newPostDocument.setData(postData) { error in
            if let error = error {
                print("Ошибка при сохранении данных: \(error.localizedDescription)")
            } else {
                print("Данные успешно сохранены в Cloud Firestore")
            }
        }
    }
    
    func saveImage(image: UIImage) -> String {
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = UUID().uuidString
        let url = document.appendingPathComponent(fileName)
        print("filename\(fileName)")
        let data = image.jpegData(compressionQuality: 1)!
        do {
            try data.write(to: url)
        } catch {
            print(error)
        }
        return fileName
    }
    
    func loadProfileImage() -> UIImage {
        let defaultImage: UIImage = UIImage(named: "kk")!
        if (localuser?.photoURL == nil) {
            return defaultImage
        }
        
        guard let id = Auth.auth().currentUser?.uid else {
            
            return defaultImage
        }
        
        let fileName = "\(id)profilePhoto.png"
        
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = document.appendingPathComponent(fileName)
        var result: UIImage = defaultImage
        do {
            let data = try Data(contentsOf: url)
            result = UIImage(data: data)!
        } catch {
            print(error)
        }
        return result
    }
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.user = user
                
                guard let userUID = user?.uid else { return }
                Firestore.firestore().collection("Users").document(userUID).getDocument { (snapshot, error) in
                    if let data = snapshot?.data() {
                        self.name = data["name"] as? String ?? ""
                        self.email = data["email"] as? String ?? ""
                        self.userBio = data["userBio"] as? String ?? ""
                        self.number = data["number"] as? String ?? ""
                        self.photoURL = data["photoURL"] as? String ?? ""
                        self.isEmailVerified = data["isEmailVerified"] as? Bool ?? false
                        self.isNumberVerified = data["isNumberVerified"] as? Bool ?? false
                    }
                }
            }
        }
    }
    
    func login() {
        Task{
            do{
                
                try await Auth.auth().signIn(withEmail: email, password: password)
                dat.saveUserLocally(userBio: userBio, number: number ,name: name, email: email, photoURL: photoURL, isEmailVerified: isEmailVerified, isNumberVerified: isNumberVerified)
            }catch{
                await setError(error)
                print(error)
            }
        }
    }
    
    func changePassword() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: enterPassword )
        
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                print("Ошибка при подтверждении пароля: \(error.localizedDescription)")
            } else {
                Auth.auth().currentUser?.updatePassword(to: self.newPassword) { error in
                    if let error = error {
                        
                        print("Ошибка при изменении пароля: \(error.localizedDescription)")
                    } else {
                        
                        print("Пароль успешно изменен")
                    }
                }
            }
        }
    }
    
    func savePhoneNumber() {
        
        guard !number.isEmpty else {
            return
        }
        
        Auth.auth().currentUser?.updatePhoneNumber(PhoneAuthProvider.provider().credential(withVerificationID: "", verificationCode: "")) { (error) in
            if let error = error {
                print("Failed to save phone number: \(error.localizedDescription)")
            } else {
                print("Phone number saved successfully")
            }
        }
    }
    
    func checkEmailVerification(completion: @escaping (Bool) -> Void) {
        if let user = Auth.auth().currentUser {
            user.reload { [weak self] error in
                if error == nil {
                    let isNewValue = user.isEmailVerified
                    if self?.isEmailVerified != isNewValue {
                        self?.isEmailVerified = isNewValue
                        self?.savedata()
                    }
                    completion(isNewValue)
                } else {
                    print("Ошибка при обновлении данных пользователя: \(error!.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func sendEmailVerification(completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } else {
            let error = NSError(domain: "YourAppDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
            completion(error)
        }
    }
    
    func checkPassword(password: String) {
        Task{
            do{
                var userEmail = Auth.auth().currentUser?.email
                try await Auth.auth().signIn(withEmail: userEmail!, password: password)
                nextPage = true
                
            }catch{
                await setError(error)
                print("Failed to check in: \(error.localizedDescription)")
            }
        }
    }
    
    func signUp() {
        Task{
            do{
                try await Auth.auth().createUser(withEmail: email, password: password)
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                let user = User(id: userUID, email: email, userBio: userBio, number: number, name: name, photoURL: photoURL, isEmailVerified: isEmailVerified, isNumberVerified: isNumberVerified)
                let userDictionary = user.toDictionary()
                
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(userDictionary, completion: { [self] error in
                    if error == nil {
                        dat.saveUserLocally(userBio: userBio, number: number ,name: name, email: email, photoURL: photoURL, isEmailVerified: isEmailVerified, isNumberVerified: isNumberVerified)
                    }
                })
            } catch{
                await  setError(error)
            }
        }
    }
    
    func savedata(){
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                
                var localUser = User(id: userUID, email: localuser?.email ?? "", userBio: localuser?.userBio ?? "", number: localuser?.number ?? "", name: self.localuser?.name ?? "", photoURL: localuser?.photoURL ?? "", isEmailVerified: localuser?.isEmailVerified ?? false, isNumberVerified: localuser?.isNumberVerified ?? false)
                
                var user = User(id: userUID, email: self.email, userBio: userBio, number: number, name: name, photoURL: photoURL, isEmailVerified: isEmailVerified, isNumberVerified: isNumberVerified)
                
                let userDictionary = user.toDictionary()
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(userDictionary, completion: { [self] error in
                    if error == nil {
                        dat.saveUserLocally(userBio: userBio, number: number ,name: name, email: email, photoURL: photoURL, isEmailVerified: isEmailVerified, isNumberVerified: isNumberVerified)
                        if localUser != user {
                            print("111\(self.hasChanges)")
                            self.hasChanges.toggle()
                            
                        }
                    }
                })
            } catch{
                await  setError(error)
            }
        }
    }
    
    func signOut() {
        Task{
            do {
                try? Auth.auth().signOut()
                logStatus = false
                DataManager().deleteData()
            } catch {
                await  setError(error)
            }
        }
    }
    
    func setError(_ error: Error) async  {
        await MainActor.run(body: {
            readyToNavigate = false
            errorMessage = mapFirebaseError(error)
            showError.toggle()
            print(error)
        })
    }
}

func mapFirebaseError(_ error: Error) -> String {
    if let err = error as? NSError {
        switch err.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email address"
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Email address is already in use"
        case AuthErrorCode.userNotFound.rawValue:
            return "User with the specified email address was not found"
        case AuthErrorCode.wrongPassword.rawValue:
            return "Wrong password"
        case AuthErrorCode.weakPassword.rawValue:
            return "Weak password. Password should be at least 6 characters long"
        case AuthErrorCode.userDisabled.rawValue:
            return "User account is disabled"
        case AuthErrorCode.operationNotAllowed.rawValue:
            return "Operation not allowed"
        case AuthErrorCode.tooManyRequests.rawValue:
            return "Exceeded maximum number of attempts. Please try again later"
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
            return "Account exists with different credential"
            
        default:
            return "Unknown error: \(err.localizedDescription)"
        }
    } else {
        return "User is authenticated"
    }
}

internal func getUID() -> String {
    let uid = Auth.auth().currentUser?.uid
    return uid ?? "notFound"
}

extension User {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "email": email,
            "userBio": userBio,
            "number": number,
            "name": name,
            "photoURL": photoURL,
            "isEmailVerified": isEmailVerified,
            "isNumberVerified": isNumberVerified
        ]
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
        lhs.email == rhs.email &&
        lhs.userBio == rhs.userBio &&
        lhs.number == rhs.number &&
        lhs.name == rhs.name &&
        lhs.photoURL == rhs.photoURL &&
        lhs.isEmailVerified == rhs.isEmailVerified &&
        lhs.isNumberVerified == rhs.isNumberVerified
    }
}
