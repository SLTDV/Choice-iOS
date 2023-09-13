import ProjectDescription

public extension TargetDependency {
    struct Feature {}
    struct Core {}
    struct Domain {}
    struct Shared {}
}

public extension TargetDependency.Core {
    static let CoordinatorControl = TargetDependency.core(name: "CoordinatorControl")
    static let JwtStore = TargetDependency.core(name: "JwtStore")
    static let NetworksMonitor = TargetDependency.core(name: "NetworksMonitor")
}
