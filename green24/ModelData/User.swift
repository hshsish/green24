
import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct User:Encodable, Identifiable {
    
    @DocumentID var id: String?
    var email: String
    var userBio: String
    var number: String
    var name: String
    var photoURL: String
    var isEmailVerified: Bool
    var isNumberVerified: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case email
        case userBio
        case number
        case name
        case photoURL
        case isEmailVerified
        case isNumberVerified
    }
}
