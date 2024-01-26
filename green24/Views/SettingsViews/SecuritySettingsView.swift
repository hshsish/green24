
import SwiftUI

struct SecuritySettingsView: View {
    
    @State private var settingsDetent = PresentationDetent.height(320)
    @State var resetPasswordView : Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                    }).padding(.leading, 15)
                        .padding(5)
                    
                    Spacer()
                }
                List{
                    Section{
                        Button("Reset password") {
                            self.resetPasswordView = true
                        }
                    }
                    .sheet(isPresented: $resetPasswordView) {
                        PasswordView()
                            .presentationDetents(
                                [.height(320)],
                                selection: $settingsDetent
                            )
                    }
                }
            }
        }
    }
}

struct SecuritySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SecuritySettingsView()
    }
}
