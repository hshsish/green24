
import SwiftUI
import AVFoundation

struct CameraView: View {
    
    var maxVideoDuration: Int = 15
   
    @State var videoAllowed: Bool = true
    @State var isSaved: Bool = false
    @State var isRecording: Bool = false
    @Environment(\.dismiss) var dismiss
    @StateObject var camera = CameraModel()
    @GestureState var isPressing = false
    @State var zoomScale: CGFloat = 1.0
    let captureDevice = AVCaptureDevice.default(for: .video)
    @GestureState private var magnifyBy = CGFloat(1.0)
    let captureSession = AVCaptureSession()
    let videoDevice = AVCaptureDevice.default(for: .video)
    
    var body: some View {
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            
            if camera.isTaken {
                RecordingPreview(url: camera.previewURL)
                    .ignoresSafeArea()
            }
            
            VStack{
                HStack{
                    if !camera.isTaken && !camera.isRecording {
                        Button(action: {
                            dismiss()
                            
                        }) {
                            Image(systemName: "arrowtriangle.backward")
                                .foregroundColor(Color.white)
                                .font(.system(size: 30))
                                .frame(width: 40,height: 40)
                                .padding(.leading,5)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if camera.flashOn == false{
                                camera.toggleTorch(on: true)
                            } else {
                                camera.toggleTorch(on: false)
                            }
                        }) {
                            Image(systemName: camera.flashOn ? "bolt.fill" : "bolt.slash.fill")
                                .foregroundColor(Color.white)
                                .font(.system(size: 30))
                                .frame(width: 40,height: 40)
                                .padding()
                            
                        }
                        
                        Button {
                            if camera.position == .back {
                                camera.position = .front
                            } else {
                                camera.position = .back
                            }
                            camera.setUp()
                            
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(Color.white)
                                .font(.system(size: 30))
                                .frame(width: 40,height: 40)
                                .padding(.trailing)
                        }
                    }
                    
                    if camera.isTaken{
                        Button(action:{ camera.retakePic()
                        }) {
                            Image(systemName: "arrowtriangle.backward")
                                .foregroundColor(Color.white)
                                .font(.system(size: 30))
                                .frame(width: 40,height: 40)
                                .padding(.leading)
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                HStack{
                    
                    if camera.isTaken  {
                        Button(action: {
                
                        }) {
                            Image("userPhoto")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .padding(.leading)
                            
                            Text("Add your story")
                                .foregroundColor(Color.white)
                                .fontWeight(.semibold)
                                .padding(9)
                            
                        }.foregroundColor(Color.white)
                            .background(Color.gray.opacity(0.7))
                            .clipShape(Capsule())
                        
                        Button(action:{
                            if camera.wasVideo == true {
                                camera.saveVideo()
                            } else{
                                camera.savePic()
                            }
                            
                        }) {
                            Label{
                                Text(camera.isSaved ? "saved" : "save")
                            } icon: {
                                Image(systemName: camera.isSaved ?  "square.and.arrow.down.fill" : "square.and.arrow.down")
                            }
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                            .padding(9)
                            .background(Color.gray.opacity(0.7))
                            .clipShape(Capsule())
                        }
                    }else{
                        Button{
                            if camera.isRecording {
                                camera.stopRecording()
                                isRecording = false
                            } else {
                                camera.takePic()
                            }
                        } label: {
                            ZStack{
                                
                                Circle()
                                    .fill(isRecording ? .red : .black)
                                    .opacity(0.2)
                                    .frame (width: 75, height: 75)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2.5)
                                    .frame(width: 65, height: 65)
                            }
                        }.gesture(
                            LongPressGesture(minimumDuration: 1.0, maximumDistance: .infinity)
                                .onEnded { _ in
                                    camera.startRecordinng()
                                    isRecording = true
                                }
                        )
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5).onEnded({ value in
                                if camera.recordPermission == .granted && videoAllowed{
                                    withAnimation {
                                        camera.video = true
                                        camera.setUp()
                                        isRecording = true
                                        camera.startRecordinng()
                                    }
                                }
                            })
                        ).buttonStyle(.plain)
                    }
                }.frame(height: 65)
            }
        }.onAppear {
            camera.checkPermission()
            camera.checkAudioPermission()
        }.onTapGesture(count: 2) {
            if camera.position == .back {
                camera.position = .front
            } else {
                camera.position = .back
            }
            camera.setUp()
        }
        //        .gesture(MagnificationGesture()
        //            .onChanged { scale in
        //                camera.updateZoom(scale)
        //            }
        //        )
        .navigationBarBackButtonHidden(true)
    }
}


struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
