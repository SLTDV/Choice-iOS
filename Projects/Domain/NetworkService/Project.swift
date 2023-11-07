import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "NetworkService",
    product: .staticLibrary,
    dependencies: [
        .Core.JwtStore,
        
        .Shared.GlobalThirdPartyLib,
    ]
)
