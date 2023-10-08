//
//  CoreDataManager.swift
//  green24
//
//  Created by Karina Kazbekova on 22.02.23.
//

import Foundation
import CoreData
import FirebaseFirestore

class DataManager {
    
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
    func saveDataLocally(){
        
    }
    
    func saveUserLocally(name: String, email: String) {
        
        let userEntity = UserEntity(context: persistentContainer.viewContext)
        userEntity.name = name
        userEntity.email = email
//        userEntity.userBio = userBio
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
            let user = User(email: userEntity.email ?? "", name: userEntity.name ?? "")
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
//            try context.save()
        } catch let error as NSError {
            print("Could not delete data. \(error), \(error.userInfo)")
        }
    }
}

