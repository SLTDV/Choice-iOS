import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "NetworkService",
    product: .staticLibrary,
    dependencies: [
        .Shared.GlobalThirdPartyLib,
    ]
)
