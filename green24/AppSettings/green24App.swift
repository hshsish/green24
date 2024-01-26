
import SwiftUI
import Firebase
import FirebaseCore
import Foundation
import CoreData

@main
struct green24App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
                    .environmentObject(AuthViewModel())
                    .environmentObject(ImageManager())
                    .environmentObject(PostManager())
                    .environmentObject(YourViewModel())
            }
        }
    }
}
