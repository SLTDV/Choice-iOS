import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "Choice"
let organizationName = "com.dohyeon"

let project = Project(
    name: projectName,
    organizationName: organizationName, packages: [
        .SnapKit,
        .Then,
        .Kingfisher,
        .RxSwift,
        .RxCocoa
    ],
    targets: [
        Target(
            name: "\(projectName)",
            platform: .iOS,
            product: .app,
            bundleId: "\(organizationName).\(projectName)",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
            infoPlist: .file(path: Path("Support/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .SPM.SnapKit,
                .SPM.Then,
                .SPM.Kingfisher,
                .SPM.RxSwift,
                .SPM.RxCocoa
            ]
        )
    ]
)
