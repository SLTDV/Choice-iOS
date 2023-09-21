import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "GlobalThirdPartyLib",
    product: .framework,
    packages: [],
    dependencies: [
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Kingfisher,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.Alamofire,
        .SPM.Swinject,
        .SPM.Lottie,
        .SPM.Firebase,
        .SPM.GoogleMobileAds,
        .sdk(name: "JavaScriptCore", type: .framework)
    ],
    baseSetting: ["OTHER_LDFLAGS": "-ObjC"]
)
