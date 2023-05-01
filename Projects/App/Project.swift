import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Choice",
    platform: .iOS,
    product: .app,
    dependencies: [
        TargetDependency.project(
            target: "JwtStore",
            path: .relativeToRoot("Projects/Core/JwtStore")),
        TargetDependency.project(
            target: "Shared",
            path: .relativeToRoot("Projects/Shared"))
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
)
