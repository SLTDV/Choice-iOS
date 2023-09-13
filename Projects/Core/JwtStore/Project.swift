import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "JwtStore",
    product: .staticFramework,
    dependencies: [
        .Core.DesignSystem,
        
        .Shared.GlobalThirdPartyLib
    ]
)
