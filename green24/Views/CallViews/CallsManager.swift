
import Foundation
import Contacts

 func fetchContacts(completion: @escaping (Result<[CNContact], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let store = CNContactStore()
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            var contacts = [CNContact]()
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
                completion(.success(contacts))
            } catch {
                completion(.failure(error))
            }
        }
    }


