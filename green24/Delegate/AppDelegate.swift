
import SwiftUI
import Foundation
import Firebase
import UIKit
import FirebaseCore
import CoreData


class AppDelegate: NSObject, UIApplicationDelegate {
    
    @EnvironmentObject var authModel : AuthViewModel
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
          observeReachability()
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
}


