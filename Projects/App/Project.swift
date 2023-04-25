import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Choice",
    platform: .iOS,
    product: .app,
    dependencies: [
        .Projcet.Feature
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
)
