//
//  AuthViewModel.swift
//  green24
//
//  Created by Karina Kazbekova on 06.02.23.
//

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
    
    @Published var users = [User]()
    @Published var dat = DataManager()
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var userBio: String = ""
    @Published var userBioLink: String = ""
    @Published var email: String = ""
    @Published var userProfilePicData: Data?
    @Published var errorMessage: String = ""
    @Published var showError: Bool  = false
    @State var readyToNavigate: Bool  = false
    @State var logStatus: Bool = false
    
    var user: Firebase.User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    var localuser: User?
    
    func getLocalUser() {
        let user = dat.getUserLocally()
        if user != nil {
            self.name = user?.name ?? ""
            self.localuser = user
        }
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
                    }
                }
            }
        }
    }
    
    func signUp() {
        Task{
            do{
                try await Auth.auth().createUser(withEmail: email, password: password)
                print("1step")
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                let user = User(id: userUID, email: email, userBio: userBio, userBioLink: userBioLink, name: name)
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { [self] error in
                    if error == nil {
                        dat.saveUserLocally(name: name, email: email)
                    }
                })
            } catch{
                await  setError(error)
            }
        }
    }
    
    func login() {
        Task{
            do{
                try await Auth.auth().signIn(withEmail: email, password: password)
                dat.saveUserLocally(name: name, email: email)
            }catch{
                await setError(error)
                print(error)
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
            errorMessage = error.localizedDescription
            showError.toggle()
            print(error)
        })
    }
    
    func observeReachability() {
          let reachability = NetworkReachabilityManager()

          reachability?.startListening(onUpdatePerforming: { status in
              switch status {
              case .notReachable:
                  print("Network not reachable")
              case .unknown :
                  print("Network unknown")
              case .reachable(.cellular):
                  print("Network reachable through cellular")
              case .reachable(.ethernetOrWiFi):
                  print("Network reachable through WiFi")
              }
          })
      }
}

//    var email: String = "" {
//        willSet {
//            if !isSettingForFirstTime {
//                isHasChanges = true
//            }
//            objectWillChange.send()
//        }
//    }
