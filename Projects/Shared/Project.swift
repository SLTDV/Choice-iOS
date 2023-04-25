import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Shared",
    product: .staticFramework,
    packages: [
        .SnapKit,
        .Then,
        .Kingfisher,
        .RxSwift,
        .RxCocoa,
        .Alamofire
    ],
    dependencies: [
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Kingfisher,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.Alamofire
    ]
)
