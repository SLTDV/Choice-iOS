import Swinject

public final class JwtStoreAssembly: Assembly {
    public init() {}
    public func assemble(container: Container) {
        container.register(JwtStore.self) { resolver in
            JwtRequestInterceptor(jwtStore: resolver.resolve(JwtStore.self)!) as! any JwtStore
        }.inObjectScope(.container)
    }
}
