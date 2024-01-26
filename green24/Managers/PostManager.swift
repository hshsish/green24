import UIKit
import CoreLocation
import Foundation
import Firebase
import SwiftUI
import CoreData
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseFirestoreSwift

class PostManager: ObservableObject{
    
    @EnvironmentObject var authModel: AuthViewModel
    @Published var post = [Post]()
    @Published var numberOfPosts: Int = 0
    @Published var postWasDone: Bool = false
    @Published var showPostAlert = false
    @Published var toggleLike: Bool = false
    @Published var commentText: String = ""
    @Published var comments = [Comment]()
    @Published var newComm: String = ""
    @Published var wasSaved: Bool = false
    
    private var userUID: String? {
           return Auth.auth().currentUser?.uid
       }

       private var db: Firestore {
           return Firestore.firestore()
       }
    
    func addComment(postID: String) {
       
        guard let userUID = userUID, !commentText.isEmpty else { return }

        let newComment = Comment(id: UUID().uuidString, postID: postID, userID: userUID, text: commentText, createdDate: Date())
        self.newComm = newComment.text
      
        let commentDictionary = newComment.commentToDictionary()
        Firestore.firestore().collection("PostComments").document(postID).collection("Comments").addDocument(data: commentDictionary) { [self] error in
            if let error = error {
                print("Ошибка при добавлении документа: \(error)")
            } else {
                self.comments.insert(newComment, at: 0)
                self.commentText = ""
            }
        }
    }

    func getAllComments(forPostID postID: String, completion: @escaping ([Comment]?, Error?) -> Void) {
        let commentsCollection = Firestore.firestore().collection("PostComments").document(postID).collection("Comments")
        commentsCollection.order(by: "createdDate", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                let comments = snapshot!.documents.compactMap { document in
                    Comment(
                        id: document["id"] as? String ?? "",
                        postID: document["postID"] as? String ?? "",
                        userID: document["userID"] as? String ?? "",
                        text: document["text"] as? String ?? "",
                        createdDate: (document["createdDate"] as? Timestamp)?.dateValue() ?? Date()
                    )
                }

                completion(comments, nil)
            }
        }
    }
    
    func printNumberOfUserPosts() -> Int {
        let numberOfPosts = self.post.count
        print("Количество постов пользователя: \(numberOfPosts)")
        self.numberOfPosts = numberOfPosts
        return numberOfPosts
    }
    
    func fetchUserPosts() {
        guard let user = Auth.auth().currentUser else {
            print("Пользователь не аутентифицирован")
            return
        }
        
        let userUID = user.uid
        let userPostsCollection = Firestore.firestore().collection("Posts").document(userUID).collection("userPosts")
        
        var fetchedPosts: [Post] = []
        
        let dispatchGroup = DispatchGroup()
        
        userPostsCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Ошибка при получении постов из Firestore: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Нет документов")
                return
            }
            
            for document in documents {
                dispatchGroup.enter()
                
                let data = document.data()
                
                if let post = self.parsePostData(data: data) {
                    fetchedPosts.append(post)
                }
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                let sortedPosts = fetchedPosts.sorted { $0.createdAt > $1.createdAt }
                self.post = sortedPosts
                self.printNumberOfUserPosts()
               
            }
        }
    }
    
    func addLikeToPost(likeCount: Int) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Пользователь не аутентифицирован")
            return
        }
        
        if let postid = post.first?.id {
      
            let like = Like(id: UUID().uuidString, userID: userUID, likes: likeCount)
            if let postIndex = post.firstIndex(where: { $0.id == postid }) {
                let hasLiked = post[postIndex].likes.contains { $0.userID == userUID }
                
                if !hasLiked {
                        post[postIndex].likes.append(like)
                    let newLikeCount = post[postIndex].likes.count
                    Firestore.firestore().collection("Posts").document(userUID).collection("userPosts").document(postid).updateData(["likes": post[postIndex].likes.map { $0.toDictionary() }, "likeCount": newLikeCount]) { error in
                        if let error = error {
                            print("Ошибка при обновлении лайка в Firestore: \(error.localizedDescription)")
                        } else {
                            self.toggleLike = true
                            print("Лайк успешно добавлен к посту")
                        }
                    }
                } else {
                    print("Пользователь уже поставил лайк к этому посту")
                }
            } else {
                print("Пост не найден")
            }
        } else {
            print("Массив постов пуст")
        }
    }
    
    private func parsePostData(data: [String: Any]) -> Post? {
        for (key, value) in data {
            print("Ключ: \(key), Значение: \(value)")
        }
        
        guard
            let id = data["id"] as? String,
            let postImageURL = data["postImageURL"] as? String,
            let postCaption = data["postCaption"] as? String,
            let author = data["author"] as? String,
            let createdAtTimestamp = (data["createdAt"] as? Timestamp)?.dateValue().timeIntervalSince1970,
            let likesData = data["likes"] as? [[String: Any]],
            let commentsData = data["comments"] as? [[String: Any]],
            let save = data["save"] as? Int
        else {
            print("Ошибка при извлечении данных для поста.")
            return nil
        }
        
        let createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        
        var likes: [Like] = []
        for likeData in likesData {
            if let like = parseLikeData(data: likeData) {
                likes.append(like)
            }
        }
        
        var comments: [Comment] = []
        for commentData in commentsData {
            if let comment = parseCommentData(data: commentData) {
                comments.append(comment)
            }
        }
        
        return Post(
            id: id,
            postImageURL: postImageURL,
            postCaption: postCaption,
            author: author,
            createdAt: createdAt,
            likes: likes,
            save: save
        )
    }
    
    private func parseLikeData(data: [String: Any]) -> Like? {
        
        guard let id = data["id"] as? String,
              let userID = data["userID"] as? String,
              let likes = data["likes"] as? Int else {
            return nil
        }
        
        return Like(id: id, userID: userID, likes: likes)
    }
    
    private func parseCommentData(data: [String: Any]) -> Comment? {
        
        guard  let id = data["id"] as? String,
            let postID = data["postID"] as? String,
              let userID = data["userID"] as? String,
              let text = data["text"] as? String,
              let createdDate = data["createdDate"] as? Date else {
            return nil
        }
        
        return Comment(id: id, postID: postID, userID: userID, text: text, createdDate: createdDate)
    }
    
    func createPost(imageURL: String?, caption: String?, completion: @escaping (Bool, String?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Пользователь не аутентифицирован")
            completion(false, "Пользователь не аутентифицирован")
            return
        }

        var post: Post

        if let imageURL = imageURL, let caption = caption {
            post = Post(id: UUID().uuidString, postImageURL: imageURL, postCaption: caption, author: userUID, createdAt: Date(), likes: [], save: 0)
        } else if let caption = caption, imageURL == nil {
            post = Post(id: UUID().uuidString, postImageURL: nil, postCaption: caption, author: userUID, createdAt: Date(), likes: [], save: 0)
        } else if let imageURL = imageURL, caption == nil {
            post = Post(id: UUID().uuidString, postImageURL: imageURL, postCaption: nil, author: userUID, createdAt: Date(), likes: [], save: 0)
        } else {
            completion(false, "Не предоставлены данные для создания поста")
            return
        }

        let postDictionary = post.toDictionary()

        let postsCollection = Firestore.firestore().collection("Posts").document(userUID).collection("userPosts").document()

        postsCollection.setData(postDictionary, completion: { error in
            if let error = error {
                print("Ошибка сохранения поста в Firestore: \(error.localizedDescription)")
                completion(false, "Ошибка сохранения поста в Firestore: \(error.localizedDescription)")
            } else {
                print("Пост успешно сохранен")
                completion(true, nil)
            }
        })
    }
    
    func uploadPhoto(_ photoURL: UIImage, description: String) {
        guard let imageData = photoURL.pngData() else {
            let error = NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get PNG representation of image"])
            print(error)
            return
        }
        
        if let id = Auth.auth().currentUser?.uid {
            let uniqueID = UUID().uuidString
            let fileName = "\(uniqueID)_profilePhoto.png"
            print("FileName: \(fileName)")
            
            let storageRef = Storage.storage().reference().child("user_\(id)_photos/\(fileName)")
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error in upload: \(error)")
                } else {
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print("Error getting download URL: \(error)")
                        } else if let url = url {
                            self.createPost(imageURL: url.absoluteString, caption: description, completion: {_,_ in 
                                
                            })
                        } else {
                            let error = NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL for uploaded image"])
                            print(error)
                        }
                    }
                }
            }
        }
    }
}

extension Post {
    
    func toDictionary() -> [String: Any] {
        let uid = Auth.auth().currentUser?.uid
        return [
            "id": id,
            "postImageURL": postImageURL ?? "",
            "postCaption": postCaption ?? "",
            "author": uid ?? "",
            "createdAt": createdAt,
            "likes": likes.map { $0.toDictionary() },
            "save": save
        ]
    }
}

extension Comment {
    func commentToDictionary() -> [String: Any] {
        return [
            "postID": postID,
            "userID": userID,
            "text": text,
            "createdDate": createdDate
        ]
    }
}
