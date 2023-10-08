

import SwiftUI

struct NotificationSettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                }).padding(.leading, 20)
                Spacer()
            }
            Spacer()
            Text("NotificationSettingsView")
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
