import Swinject

public final class JwtStoreAssembly: Assembly {
    public init() {}
    public func assemble(container: Container) {
        container.register(JwtStore.self) { resolver in
            KeyChainService(keychain: resolver.resolve(KeyChain.self)!)
        }.inObjectScope(.container)
    }
}
