import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "NetworksMonitor",
    product: .staticFramework,
    dependencies: [
        TargetDependency.project(
            target: "Shared",
            path: .relativeToRoot("Projects/Shared"))
    ]
)
