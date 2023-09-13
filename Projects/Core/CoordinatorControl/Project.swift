import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "CoordinatorControl",
    product: .staticFramework,
    dependencies: [
        TargetDependency.project(
            target: "Shared",
            path: .relativeToRoot("Projects/Shared"))
    ]
)
