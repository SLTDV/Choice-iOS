import Network
import UIKit

public protocol ShowNetworkChangeAlertProtocol: AnyObject {
    func failedNetworkConnectionAlert()
    func changedNetworkConnectionAlert()
}

public class NetworksStatus {
    let monitor = NWPathMonitor()
    var previousNWInterfaceType: NWInterface.InterfaceType?
    var currentNWInterfaceType: NWInterface.InterfaceType?
    var isInitialNetworkChange = true
    public weak var delegate: ShowNetworkChangeAlertProtocol?
    
    public static let shared = NetworksStatus()
    
    public func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            self?.checkNetworkStatusChange(newStatus: path)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func checkNetworkStatusChange(newStatus: NWPath) {
        if newStatus.status == .satisfied {
            if newStatus.usesInterfaceType(.wifi) {
                self.currentNWInterfaceType = .wifi
            } else if newStatus.usesInterfaceType(.cellular) {
                self.currentNWInterfaceType = .cellular
            } else if newStatus.usesInterfaceType(.wiredEthernet) {
                self.currentNWInterfaceType = .wiredEthernet
            }
        } else {
            delegate?.failedNetworkConnectionAlert()
            return
        }
        
        if isInitialNetworkChange {
            isInitialNetworkChange = false
            previousNWInterfaceType = currentNWInterfaceType
            return
        }
        
        if newStatus.status != .satisfied {
            delegate?.failedNetworkConnectionAlert()
        } else {
            if previousNWInterfaceType != currentNWInterfaceType {
                delegate?.changedNetworkConnectionAlert()
            }
        }
        previousNWInterfaceType = currentNWInterfaceType
    }
}
