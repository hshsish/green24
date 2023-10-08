
import SwiftUI

struct ChatView: View {
    @State var text : String = ""
    @State var showAttachModal = false
    @Environment(\.presentationMode) var presentationMode
    let senderId: String = "000"

    var body: some View {
        VStack{
            ZStack{
                VStack(alignment: .center){
                    Text("username")
                    Text("last seen recently")
                        .foregroundColor(.gray)
                }
                
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .padding(.leading, 10)
                    })
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Image("userPhoto")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                    }).padding(.trailing, 10)
                }
            }.frame(height: 36)
            
            ZStack{
                Color.init(uiColor: .tertiarySystemFill)
                
                GeometryReader { gp in
                    ScrollView(showsIndicators: false){
                     
                            VStack(alignment: .leading) {
                                Spacer()
                                HStack{
                                    Spacer()
                                    Text("fakeMessage")
                                        .padding()
                                        .background(.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                        .frame(alignment: .bottom)
                                        .padding()
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: gp.size.height)
                        }
                }
            }
            
            HStack{
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("  Message")
                            .foregroundColor(.gray)
                            .padding([.leading, .top], 19)
                    }
                    TextEditor(text: $text)
                        .multilineTextAlignment(.leading)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 40, maxHeight: 500, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .cornerRadius(16)
                        .padding([.leading, .top, .bottom], 10)
                }
                
                Button(action: {
                    showAttachModal = true
                    
                }, label:{
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showAttachModal) {
                    AttachModalView()
                    
                }
                
                Button(action: {
                    if !text.isEmpty {
//                        self.messageManager.sendData(user: self.chatUser, message: self.messageManager.text)
//                        self.messageManager.text = ""
//                        var message = Message(text: messageManager.text, senderId: senderId, timestamp: Date())
//                        messageManager.addMessage(message) { error in
//                            if let error = error {
//                                print("Error adding text: \(error.localizedDescription)")
//                            } else {
//                                messageManager.text = ""
//                            }
//                        }
                    } else {
                   
                    }
                }, label: {
                    if !text.isEmpty {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                    } else {
                        Image(systemName: "mic")
                            .font(.title2)
                    }
                }).padding(.trailing, 10)
            }
        }.navigationBarBackButtonHidden(true)
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(messageManager: mes)
//    }
//}
