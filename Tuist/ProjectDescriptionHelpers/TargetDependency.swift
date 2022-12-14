import ProjectDescription

extension TargetDependency{
    public struct SPM {}
}

public extension TargetDependency.SPM {
    static let SnapKit = TargetDependency.package(product: "SnapKit")
    static let Then = TargetDependency.package(product: "Then")
}

public extension Package {
    static let SnapKit = Package.remote(
        url: "https://github.com/SnapKit/SnapKit",
        requirement: .upToNextMajor(from: "5.6.0"))
    static let Then = Package.remote(
        url: "https://github.com/devxoul/Then",
        requirement: .upToNextMajor(from: "3.0.0"))
}
