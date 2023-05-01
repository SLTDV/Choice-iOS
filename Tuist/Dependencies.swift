import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: [
            .remote(
                url: "https://github.com/SnapKit/SnapKit",
                requirement: .upToNextMajor(from: "5.6.0")),
            .remote(
                url: "https://github.com/devxoul/Then",
                requirement: .upToNextMajor(from: "3.0.0")),
            .remote(
                url: "https://github.com/onevcat/Kingfisher",
                requirement: .upToNextMajor(from: "7.6.2")),
            .remote(
                url: "https://github.com/ReactiveX/RxSwift",
                requirement: .upToNextMajor(from: "6.5.0")),
            .remote(
                url: "https://github.com/Alamofire/Alamofire",
                requirement: .upToNextMajor(from: "5.6.4"))
        ],
    platforms: [.iOS]
)
