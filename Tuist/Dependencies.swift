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
                requirement: .upToNextMajor(from: "5.6.4")),
            .remote(
                url: "https://github.com/Swinject/Swinject",
                requirement: .upToNextMajor(from: "2.8.3")),
            .remote(
                url: "https://github.com/airbnb/lottie-spm.git",
                requirement: .upToNextMajor(from: "4.2.0")),
            .remote(
                url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
                requirement: .upToNextMajor(from: "10.9.0")),
            .remote(
                url: "https://github.com/firebase/firebase-ios-sdk.git",
                requirement: .upToNextMajor(from: "10.4.0"))
        ],
    platforms: [.iOS]
)
