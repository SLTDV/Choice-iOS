import Network
import UIKit

public class NetworksStatus: UIViewController {
    let monitor = NWPathMonitor()
    public static let shared = NetworksStatus()
    
    public func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                if path.usesInterfaceType(.wifi) {
                    print("wifi mode")
                } else if path.usesInterfaceType(.cellular) {
                    print("cellular mode")
                } else if path.usesInterfaceType(.wiredEthernet) {
                    print("ethernet mode")
                }
            } else {
                print("not connected")
            }
        }
    }
    
    private func showChangedNetworkAlert() {
        let alert = UIAlertController(title: "네트워크 변경 감지!", message: "네트워크 변경이 감지되었습니다. 앱을 다시 실행해주세요.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
