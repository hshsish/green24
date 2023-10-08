
import SwiftUI
import CoreData
import Foundation
import Firebase
import Combine
import FirebaseStorage

struct UserView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @State var go2StoryView = false
    @State private var inputImage: UIImage?
    @State private var nextPage : Bool = false
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text(authModel.name)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                        
                        
                    }
                    
                    
                    Button {
                        nextPage = true
                    } label: {
                        Image(systemName: "text.justify")
                            .padding(15)
                    }.sheet(isPresented: $nextPage) {
                        SettingsView(authModel: authModel, imageManager: ImageManager())
                                        }
                }.font(.title2)
                
                HStack{
                    
                    Button(action: {
//                        authModel.loadProfileImage()
                    }, label: {
                        
                        Image(uiImage: authModel.loadProfileImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        //переделать с юрл на дату
              
                    }) .padding([.bottom, .leading], 5)
                    
                    HStack{
                        VStack(alignment: .center){
                            
                            Button(action: {
                                
                            }, label: {
                                Text("0")
                                    .font(.title2)
                            })
                            
                            Text("posts")
                            
                        }.padding()
                        
                        VStack{
                            
                            Button(action: {
                                
                            }, label: {
                                Text("0")
                                    .font(.title2)
                            })
                            
                            Text("followers")
                            
                        }.padding()
                        
                        VStack{
                            
                            Button(action: {
                                
                            }, label: {
                                Text("0")
                                    .font(.title2)
                            })
                            
                            Text("following")
                                .font(.callout)
                            
                        }.padding()
                        
                    }.frame(maxWidth: .infinity)
                }
                HStack{
                    Text(authModel.userBio)
                        .padding(.leading, 10)
                        .font(.body)
                    Spacer()
                }
                
                
                ScrollView(.horizontal) {
                    HStack{
                        NavigationLink(destination: StoryView(),
                                       isActive: $go2StoryView) {
                            EmptyView()
                        }.navigationBarHidden(true)
                        
                        Button(action: {
                            go2StoryView = true
                        }, label: {
                            Image("profilePhoto")
                                .resizable()
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                                .padding(5)
                        })
                        
                        Button(action: {
                            
                        }, label: {
                            Image("profilePhoto")
                                .resizable()
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                                .padding(5)
                        })
                    }
                }
            }
            
            Divider()
            
            ScrollView{
                
                //                PostUserView(images: [])
                
            }
            
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
