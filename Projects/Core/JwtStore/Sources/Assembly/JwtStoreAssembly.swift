import Swinject

public final class JwtStoreAssembly: Assembly {
    public init() {}
    public func assemble(container: Container) {
        container.register(JwtStore.self) { resolver in
            return KeyChainService(keychain: KeyChain())
        }.inObjectScope(.container)
    }
}
