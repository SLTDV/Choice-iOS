import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DesignSystem",
    product: .framework,
    dependencies: [
        .Shared.GlobalThirdPartyLib,
        .Shared.Utility
    ],
    resources: ["Resources/**"]
)
