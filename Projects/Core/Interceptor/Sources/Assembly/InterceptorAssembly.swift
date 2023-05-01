import Swinject
import Alamofire

public final class JwtStoreAssembly: Assembly {
    public init() {}
    public func assemble(container: Container) {
        container.register(RequestInterceptor.self) { _ in JwtRequestInterceptor() }
    }
}
