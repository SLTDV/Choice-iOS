import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "GiveMeMedicine"
let organizationName = "com.dohyeon"

let project = Project(
    name: projectName,
    organizationName: organizationName, packages: [
        .SnapKit,
        .Then
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
                .SPM.Then
            ]
        )
    ]
)
