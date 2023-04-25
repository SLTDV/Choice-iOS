import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Choice",
    platform: .iOS,
    product: .app,
    dependencies: [
        TargetDependency.project(
            target: "Feature",
            path: .relativeToRoot("Projects/Feature"))
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
)
