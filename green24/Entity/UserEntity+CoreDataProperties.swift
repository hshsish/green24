
import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var userBio: String?
    @NSManaged public var number: String?
    @NSManaged public var photoURL: String?
    @NSManaged public var isEmailVerified: Bool
    @NSManaged public var isNumberVerified: Bool
    
}

extension UserEntity : Identifiable {

}
