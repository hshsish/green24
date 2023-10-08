

import UIKit
import CoreLocation
import Foundation
import Firebase
import SwiftUI

class postManager: ObservableObject{
    
    @Published var post = [Post]()
    @EnvironmentObject var authModel : AuthViewModel
    @Published var pwc : Bool = false
    @Published var postText = ""
    @Published var postImageURL = ""
    
    
//    func createPost(id: String, postText: String) {
//        let db = Firestore.firestore()
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let post = Post(id: userUID , createdDate: Date(), postText: postText, postImageURL: postImageURL)
//        do {
//            let _ = try db.collection("posts").addDocument(data: post as! [String : Any])
//            pwc = true
//        } catch {
//            print("Error adding post: \(error.localizedDescription)")
//            pwc = false
//        }
//    }
    
    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("posts")
            .getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching posts: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                var posts = [Post]()
                for document in snapshot.documents {
                    self.post = snapshot.documents.map { item in
                        return Post(id: item.documentID, createdDate: Date(), postText: item["postText"] as? String ?? "", postImageURL: item["postImageURL"] as! String)
                        
                    }
                    let data = document.data()
                    let id = document.documentID
                    let text = data["postText"] as? String ?? ""
                    let postImageURL = data["postImageURL"] as? String ?? ""
                    //                   let body = data["body"] as? String ?? ""
                    let post = Post(id: id, createdDate: Date(), postText: text, postImageURL: postImageURL)
                    posts.append(post)
                }
                self.post = posts
                print(posts)
            }
    }
}


//class PostViewModel: NSObject, ObservableObject {
//    @Published var post: Post?
//    @Published var image: UIImage?
//    @Published var caption = ""
//    @Published var location: ParseGeoPoint?
//    var currentPlacemark: CLPlacemark? {
//        willSet {
//            if let currentLocation = newValue?.location {
//                location = try? ParseGeoPoint(location: currentLocation)
//            } else {
//                location = nil
//            }
//            objectWillChange.send()
//        }
//    }
//    private var authorizationStatus: CLAuthorizationStatus
//    private var lastSeenLocation: CLLocation?
//    private let locationManager: CLLocationManager

//    init(post: Post? = nil) {
//        if post != nil {
//            self.post = post
//        } else {
//            self.post = Post(image: nil)
//        }
//        locationManager = CLLocationManager()
//        authorizationStatus = locationManager.authorizationStatus
//
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
//        locationManager.startUpdatingLocation()
//    }

    // MARK: Intents
//    func requestPermission() {
//        locationManager.requestWhenInUseAuthorization()
//    }

//    func save() async throws -> Post {
//        guard let image = image,
//              let compressed = image.compressTo(3),
//              var currentPost = post else {
//            return Post()
//        }
//        currentPost.image = ParseFile(data: compressed)
//        currentPost.caption = caption
//        currentPost.location = location
//        return try await currentPost.save()
//    }

//    class func queryLikes(post: Post?) -> Query<Activity> {
//        guard let pointer = try? post?.toPointer() else {
//            Logger.home.error("Should have created pointer.")
//            return Activity.query().limit(0)
//        }
//        let query = Activity.query(ActivityKey.post == pointer,
//                                   ActivityKey.type == Activity.ActionType.like)
//            .order([.descending(ParseKey.createdAt)])
//        return query
//    }
//
//    class func queryComments(post: Post?) -> Query<Activity> {
//        guard let pointer = try? post?.toPointer() else {
//            Logger.home.error("Should have created pointer.")
//            return Activity.query().limit(0)
//        }
//        let query = Activity.query(ActivityKey.post == pointer,
//                                   ActivityKey.type == Activity.ActionType.comment)
//            .order([.descending(ParseKey.createdAt)])
//        return query
//    }
//}

//extension PostViewModel: CLLocationManagerDelegate {
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
//    }
//
//    func locationManager(_ manager: CLLocationManager,
//                         didUpdateLocations locations: [CLLocation]) {
//        lastSeenLocation = locations.first
//        fetchCountryAndCity(for: locations.first)
//    }

//    func fetchCountryAndCity(for location: CLLocation?) {
//        guard let location = location else { return }
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location) { (placemarks, _) in
//            self.currentPlacemark = placemarks?.first
//        }
//    }
//}
