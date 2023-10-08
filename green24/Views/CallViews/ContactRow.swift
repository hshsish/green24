
import SwiftUI
import Contacts

struct ContactRow: View {
    
    let contact: CNContact
    
    var body: some View {
        HStack {
            Text("\(contact.givenName) \(contact.familyName)")
                .font(.headline)
                .padding()
            
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                Text(phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
            }
            Spacer()
            
            Image(systemName: "phone")
                .foregroundColor(.blue)
                .padding()
        }
        .frame(height: 50)
        .background(Color(uiColor: .tertiarySystemFill))
        .clipShape(Capsule())
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(contact: CNContact())
    }
}
