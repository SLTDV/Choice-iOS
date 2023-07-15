import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Shared",
    product: .framework,
    packages: [],
    dependencies: [
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Kingfisher,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxGesture,
        .SPM.Alamofire,
        .SPM.Swinject,
        .SPM.Lottie
    ],
    resources: ["Resources/**"]
)
