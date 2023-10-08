
import SwiftUI

struct UserView: View {
//    @ObservedObject var session : AuthViewModel
    @State var isShowingOptions = false
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("username")
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .accentColor(.blue)
                            .padding(.trailing, 10)
                        
                    }
                    
                    NavigationLink(destination: SettingsView(authModel: AuthViewModel()),
                                   isActive: $isShowingOptions) {
                       EmptyView()
                    }
                    
                    Button(action: {
                        self.isShowingOptions = true
                    }) {
                        Image(systemName: "text.justify")
                            .accentColor(.blue)
                            .padding(.trailing, 10)
                    }
                }.font(.title2)
                
                HStack{
                    
                    Button(action: {
                        
                    }, label: {
                        Image("userPhoto")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .padding([.bottom, .leading], 5)
                    })
                    
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
                    Text("status")
                        .padding(.leading, 10)
                        .font(.body)
                    Spacer()
                }
                
                HStack{
                    ScrollView(.horizontal) {
                        
                        Button(action: {
                            
                        }, label: {
                            Image("userPhoto")
                                .resizable()
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                                .padding()
                        })
                
                    }
             
                }
            }.padding(.bottom)
            Divider()
            
            ScrollView{
                Section{
                    ForEach(1..<10) { rowIndex in
                        Button(action: {
                            
                        }, label: {
                            Image("userPhoto")
                                .resizable()
                                .frame(width: 90, height: 90)
                        })
                    }.
                }
            }
            
        }.navigationBarBackButtonHidden(true)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
