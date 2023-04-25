import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Feature",
    product: .staticFramework,
    dependencies: [
        TargetDependency.project(
            target: "Service",
            path: .relativeToRoot("Projects/Service"))
    ]
)
