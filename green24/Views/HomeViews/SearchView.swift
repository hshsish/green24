
import SwiftUI
import Firebase

struct SearchView: View {
    @State var searchText = ""
    @State var users: [User] = []
    let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText, onCommit: search)
                .padding()
                .onChange(of: searchText) { newValue in
                    search()
                }
            
            List(users) { user in
                HStack{
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    Text(user.name)
                }
            }
        }
    }
    
    func search() {
        db.collection("Users")
        //              .whereField("name", isEqualTo: searchText)
            .whereField("name", isGreaterThanOrEqualTo: searchText)
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                users = documents.map { document in
                    User(id: document.documentID,
                         email: document.data()["email"] as? String ?? "",
                         userBio: document.data()["userBio"] as? String ?? "",
                         number: document.data()["number"] as? String ?? "" ,
                         name: document.data()["name"] as? String ?? "",
                         photoURL: document.data()["photoURL"] as? String ?? "",
                         isEmailVerified: document.data()["isEmailVerified"] as? Bool ?? false,
                         isNumberVerified: document.data()["isNumberVerified"] as? Bool ?? false)
                }
            }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
