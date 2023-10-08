
import Foundation
import Alamofire

func observeReachability() {
      let reachability = NetworkReachabilityManager()

      reachability?.startListening(onUpdatePerforming: { status in
          switch status {
          case .notReachable:
              print("Network not reachable")
          case .unknown :
              print("Network unknown")
          case .reachable(.cellular):
              print("Network reachable through cellular")
          case .reachable(.ethernetOrWiFi):
              print("Network reachable through WiFi")
          }
      })
  }
