import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Environment.appName,
    platform: .iOS,
    product: .app,
    dependencies: [
        TargetDependency.project(
            target: "Shared",
            path: .relativeToRoot("Projects/Shared")),
        TargetDependency.project(
            target: "JwtStore",
            path: .relativeToRoot("Projects/Core/JwtStore")),
        TargetDependency.project(
            target: "NetworksMonitor",
            path: .relativeToRoot("Projects/Core/NetworksMonitor"))
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
)
