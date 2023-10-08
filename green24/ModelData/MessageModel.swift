
import Foundation

struct Message {
    let text: String
    let senderId: String
    let timestamp: Date
}
    struct ChatUser: Identifiable {

        var id: String { uid }
        let uid, email, profileImageUrl: String
    }
