import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Interceptor",
    product: .staticFramework,
    dependencies: [
        TargetDependency.project(
            target: "Shared",
            path: .relativeToRoot("Projects/Shared"))
    ]
)
