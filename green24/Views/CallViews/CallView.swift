
import SwiftUI
import Contacts

struct CallView: View {
    
    @State private var contacts = [CNContact]()
    @State var contactsPicker : picker = picker.calls
     
    enum picker : String {
        case calls, contacts
    }
    
    var body: some View {
        
        VStack{
            
           
            Picker("picker", selection: $contactsPicker) {
                
                Text("Calls")
                    .tag(picker.calls)
                Text("Contacts")
                    .tag(picker.contacts)
            }
            .padding(.top, 20)
            .padding([.leading, .trailing], 15)
            .pickerStyle(SegmentedPickerStyle())
            .cornerRadius(5.0)

            if contactsPicker.rawValue == "contacts" {
                VStack{
                    List(contacts, id: \.self) { contact in
                        
                        ContactRow(contact: contact)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
               
            } else {
                ScrollView{
                    
                    CallRow()
                        .listRowSeparator(.hidden)
                 
                }   .listStyle(.plain)
                    .scrollContentBackground(.hidden)
            }
        } .onAppear {
            fetchContacts { result in
                switch result {
                case .success(let contacts):
                    self.contacts = contacts
                case .failure(let error):
                    print("Failed to fetch contacts: \(error.localizedDescription)")
                }
            }
        }

    }
}

struct CallView_Previews: PreviewProvider {
    static var previews: some View {
        CallView()
    }
}
