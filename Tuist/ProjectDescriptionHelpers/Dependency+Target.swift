import ProjectDescription

public extension TargetDependency {
    struct Feature {}
    struct Core {}
    struct Domain {}
    struct Shared {}
}

public extension TargetDependency.Core {
    static let JwtStore = TargetDependency.core(name: "JwtStore")
    static let NetworksMonitor = TargetDependency.core(name: "NetworksMonitor")
    static let DesignSystem = TargetDependency.core(name: "DesignSystem")
}

public extension TargetDependency.Shared {
    static let GlobalThirdPartyLib = TargetDependency.shared(name: "GlobalThirdPartyLib")
    static let Utility = TargetDependency.shared(name: "Utility")
}
