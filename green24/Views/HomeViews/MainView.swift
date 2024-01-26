
import SwiftUI
import Combine

struct MainView: View {
    
    @ObservedObject var authModel = AuthViewModel()
    @State var selectedTab = ""
    @State var showNewChatsView : Bool = false
    @ObservedObject var viewModel = YourViewModel()
    
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
                    .environmentObject(YourViewModel())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem{
                        Label("Profile", systemImage: "face.smiling" )
                    }.tag("user")
            }.onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}

