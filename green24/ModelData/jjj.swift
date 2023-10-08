

import Foundation
//List(posts, id: \.id) { post in
//    VStack{
//        VStack{
//            HStack{
//                Button(action: {
//                    
//                }, label: {
//                    Image("userPhoto")
//                        .resizable()
//                        .frame(width: 40, height: 40)
//                        .clipShape(Circle())
//                        .padding(.leading)
//                    
//                })
//                VStack(alignment: .leading){
//                    Text(authModel.name)
//                        .padding([.top, .trailing])
//                        .font(.body)
//                    Text("location")
//                        .padding([.bottom, .trailing])
//                        .font(.callout)
//                }.frame(height: 50)
//                    .padding(.trailing)
//                
//                Spacer()
//                Button(action: {
//                    
//                }, label: {
//                    Image(systemName:"ellipsis")
//                        .frame(width: 40, height: 40)
//                        .clipShape(Circle())
//                        .padding([.top, .trailing])
//                        .font(.title2)
//                    
//                })
//                //                    }
//            }.frame(height: 50)
//            
//            Image("profilePhoto")
//                .resizable()
//                .frame(maxWidth: .infinity, maxHeight: 400)
//            
//            Text(post.postText)
//            
//            Text("hhhhhh")
//            HStack{
//                
//                Button(action: {
//                    
//                }, label: {
//                    Image(systemName:"heart")
//                        .padding([.bottom, .leading])
//                })
//                
//                Button(action: {
//                    
//                }, label: {
//                    Image(systemName:"message")
//                        .padding(.bottom)
//                })
//                
//                Button(action: {
//                    
//                }, label: {
//                    Image(systemName:"arrowshape.turn.up.right")
//                        .padding(.bottom)
//                })
//                Spacer()
//                Button(action: {
//                    
//                }, label: {
//                    Image(systemName:"bookmark")
//                        .padding([.bottom, .trailing])
//                })
//            }.font(.title2)
//        }.frame(maxHeight: 350)
//    }
//}.onAppear {
//    PostManager.fetchPosts()
//    print("lsls")
//}
