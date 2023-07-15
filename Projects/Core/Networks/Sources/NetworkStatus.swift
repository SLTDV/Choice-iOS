import Network

public class NetworksStatus {
    let monitor = NWPathMonitor()
    public static let shared = NetworksStatus()
    
    private init() {}
    
    public func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("connected")
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
}
