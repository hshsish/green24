
import SwiftUI
import Contacts


struct ContactRow: View {
    
    let contact: CNContact
    
    var body: some View {
        HStack{
            
            if let imageData = contact.thumbnailImageData,
                          let uiImage = UIImage(data: imageData) {
                           Image(uiImage: uiImage)
                               .resizable()
                               .frame(width: 45, height: 45)
                               .clipShape(Circle())
                       } else {
                           Image(systemName: "person.crop.circle")
                               .resizable()
                               .frame(width: 45, height: 45)
                               .foregroundColor(.gray)

                       }
            
            VStack(alignment: .leading) {
                Text("\(contact.givenName) \(contact.familyName)")
                    .font(.headline)
                
                if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                    Text(phoneNumber)
                        .font(.subheadline)
                }
            }
            
            Spacer()
            
            Image(systemName: "phone")
                .foregroundColor(.blue)
            
        }.frame(height: 45)
            .frame(maxWidth: .infinity)
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(contact: CNContact())
    }
}

