import Foundation
import CoreData
import FirebaseFirestore
import Firebase

class DataManager: ObservableObject {
    
    static let shared = DataManager()
    
    let persistentContainer: NSPersistentContainer
    let firestoreDB: Firestore
    
    init() {
        persistentContainer = NSPersistentContainer(name: "UserDataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Core Data stack: \(error)")
            }
        }
        firestoreDB = Firestore.firestore()
    }
    
    func saveUserLocally(userBio: String, number: String, name: String, email: String, photoURL: String, isEmailVerified: Bool, isNumberVerified: Bool) {
        let userEntity = UserEntity(context: persistentContainer.viewContext)
        
        userEntity.name = name
        userEntity.email = email
        userEntity.userBio = userBio
        userEntity.number = number
        userEntity.photoURL = photoURL
        userEntity.isEmailVerified = isEmailVerified
        userEntity.isNumberVerified = isNumberVerified
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save user locally: \(error)")
        }
    }
    
    func getUserLocally() -> User? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let userEntities = try? persistentContainer.viewContext.fetch(fetchRequest)
        
        if let userEntity = userEntities?.last {
            let user = User(email: userEntity.email ?? "", userBio: userEntity.userBio ?? "", number: userEntity.number ?? "", name: userEntity.name ?? "", photoURL: userEntity.photoURL ?? "", isEmailVerified: userEntity.isEmailVerified, isNumberVerified: userEntity.isNumberVerified)
            return user
        } else {
            return nil
        }
    }
    
    func deleteData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let context = persistentContainer.viewContext
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete data. \(error), \(error.userInfo)")
        }
    }
}
