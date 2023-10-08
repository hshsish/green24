
import SwiftUI
import Combine

struct MainView: View {
    
    @ObservedObject var authModel = AuthViewModel()
    @State var selectedTab = ""
    @State var showNewChatsView : Bool = false
    
    var body: some View {
        VStack{
            TabView(selection: $selectedTab){
                NotificationView()
                    .tabItem{
                        Label("Notification", systemImage: "heart" )
                    }
                
                HomeView(acco: AccountSettingsView())
                    .tabItem {
                        Label("Home", systemImage: "globe")
                    }.tag("Home")
                
                CallView()
                    .tabItem {
                        Label("Calls", systemImage: "phone.down")
                    }
                
                MessageView()
                    .tabItem {
                        Label("Chats", systemImage: "bolt.horizontal")
                    }
                
                UserView()
                    .tabItem{
                        Label("Profile", systemImage: "face.smiling" )
                    }.tag("user")
            }
        }
    }
}

