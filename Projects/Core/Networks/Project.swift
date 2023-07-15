import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Networks",
    product: .staticFramework,
    dependencies: [
        TargetDependency.project(
            target: "Shared",
            path: .relativeToRoot("Projects/Shared"))
    ]
)
