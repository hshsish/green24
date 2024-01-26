
import Foundation

struct Post: Encodable, Identifiable {
    
    var id: String
    var postImageURL: String?
    var postCaption: String?
    var author: String
    var createdAt: Date
    var likes: [Like]
    var save: Int
    
    enum CodingKeys: CodingKey{
        case id
        case postImageURL
        case postCaption
        case author
        case createdAt
        case likes
        case save
    }
}

struct Like: Encodable, Identifiable {
    
    var id: String
    var userID: String
    var likes: Int
    
    enum CodingKeys: CodingKey{
        case id
        case userID
        case likes
    }
    
    static func == (lhs: Like, rhs: Like) -> Bool {
        return lhs.id == rhs.id && lhs.userID == rhs.userID && lhs.likes == rhs.likes
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "userID": userID,
            "likes": likes
        ]
    }
}

struct Comment: Encodable, Identifiable, Hashable {
    
    var id: String
    var postID: String
    var userID: String
    var text: String
    var createdDate: Date
    
    enum CodingKeys: CodingKey{
        case id
        case postID
        case userID
        case text
        case createdDate
    }
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id && lhs.postID == rhs.postID && lhs.userID == rhs.userID && lhs.text == rhs.text && lhs.createdDate == rhs.createdDate
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "postID": postID,
            "userID": userID,
            "text": text,
            "createdDate": createdDate
        ]
    }
    
}

struct Save: Encodable {
    
    var userID: String
    var postID: String
    
    enum CodingKeys: CodingKey{
        case userID
        case postID
    }
    
    static func == (lhs: Save, rhs: Save) -> Bool {
        return lhs.userID == rhs.userID && lhs.postID == rhs.postID
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "postID": postID,
            "userID": userID
        ]
    }
}
