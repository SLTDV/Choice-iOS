import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Environment.appName,
    platform: .iOS,
    product: .app,
    dependencies: [
        .Core.CoordinatorControl,
        .Core.DesignSystem,
        .Core.JwtStore,
        .Core.NetworksMonitor,
        
        .Shared.GlobalThirdPartyLib,
        .Shared.Utility
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist"),
    baseSetting: ["OTHER_LDFLAGS": "-ObjC"]
)
