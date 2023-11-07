import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Environment.appName,
    platform: .iOS,
    product: .app,
    dependencies: [
        .Domain.NetworkService,
        
        .Core.DesignSystem,
        .Core.JwtStore,
        .Core.NetworksMonitor,
        
        .Shared.GlobalThirdPartyLib
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
)
