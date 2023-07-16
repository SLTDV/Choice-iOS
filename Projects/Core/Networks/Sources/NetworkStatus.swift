import Network
import UIKit

public protocol showNetworkChangeAlertProtocol: AnyObject {
    func failedNetworkConnectionAlert()
    func changedNetworkConnectionAlert()
}

public class NetworksStatus {
    let monitor = NWPathMonitor()
    var previousNWInterfaceType: NWInterface.InterfaceType?
    var isInitialNetworkChange = true
    public weak var delegate: showNetworkChangeAlertProtocol?
    
    public static let shared = NetworksStatus()
    
    public func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            self?.checkNetworkStatusChange(newStatus: path)
        }
    }
    
    private func checkNetworkStatusChange(newStatus: NWPath) {
        guard let previousNWInterfaceType = previousNWInterfaceType else {
            if newStatus.status == .satisfied {
                if newStatus.usesInterfaceType(.wifi) {
                    self.previousNWInterfaceType = .wifi
                    print("wifi mode")
                } else if newStatus.usesInterfaceType(.cellular) {
                    self.previousNWInterfaceType = .cellular
                    print("cellular mode")
                } else if newStatus.usesInterfaceType(.wiredEthernet) {
                    self.previousNWInterfaceType = .wiredEthernet
                    print("ethernet mode")
                }
            } else {
                delegate?.failedNetworkConnectionAlert()
            }
            return
        }
        
        if isInitialNetworkChange {
            isInitialNetworkChange = false
            return
        }
        
        if newStatus.status != .satisfied {
            delegate?.failedNetworkConnectionAlert()
        } else {
            if previousNWInterfaceType != .other {
                print("other!!!")
                delegate?.changedNetworkConnectionAlert()
            }
        }
    }
}
