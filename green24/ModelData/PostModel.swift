
import Foundation

struct Post: Codable, Identifiable{
    
    var id: String
    var createdDate: Date
    var postText: String
    var postImageURL: String
}
