import UIKit
import Alamofire
import RxSwift

protocol ProfileDataProtocol: AnyObject {
    var nicknameData: PublishSubject<String> { get set }
    var imageData: PublishSubject<String?> { get set }
    var postListData: PublishSubject<[Posts]> { get set }
}

final class ProfileViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    weak var delegate: ProfileDataProtocol?
    
    func callToProfileData() {
        let url = APIConstants.profileURL
        
        AF.request(url,
                   method: .get,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode(ProfileModel.self, from: data)
                self?.delegate?.postListData.onNext(decodeResponse?.postList ?? .init())
                self?.delegate?.nicknameData.onNext(decodeResponse?.nickname ?? "")
                self?.delegate?.imageData.onNext(decodeResponse?.image)
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
    
    func callToChangeNickname(nickname: String) {
        let url = APIConstants.changeNicknameURL
        let params = [
            "nickname" : nickname
        ] as Dictionary
        
        AF.request(url,
                   method: .patch,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success:
                LoadingIndicator.hideLoading()
                self?.delegate?.nicknameData.onNext(nickname)
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
    
    func callToDeleteData(type: OptionItemType) {
        lazy var url = ""
        
        switch type {
        case .callToLogout:
            url = APIConstants.logoutURL
        case .callToMembershipWithdrawal:
            url = APIConstants.membershipWithdrawalURL
        }
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success:
                self?.navigateToSignInVC()
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
    
    func callToProfileImageUpload(profileImage: UIImage) -> Observable<ProfileImageModel> {
        var url = APIConstants.profileImageUploadURL
        
        var headers: HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        
        return Observable.create { (observer) -> Disposable in
            AF.upload(multipartFormData: { multipartFormData in
                if let image = profileImage.pngData() {
                    multipartFormData.append(image, withName: "profileImage", fileName: "\(image).png", mimeType: "image/png")
                }
            },to: url, method: .post, headers: headers, interceptor: JwtRequestInterceptor())
            .validate().responseData(emptyResponseCodes: [200, 201, 204]) { response in
                switch response.result {
                case .success(let data):
                    let decodeResponse = try? JSONDecoder().decode(ProfileImageModel.self, from: data)
                    url = APIConstants.changeProfileImageURL
                    headers = ["Content-Type": "application/json"]
                    
                    let params = [
                        "image" : decodeResponse?.profileImageUrl ?? .init()
                    ] as Dictionary
                    
                    AF.request(url,
                               method: .patch,
                               parameters: params,
                               encoding: JSONEncoding.default,
                               headers: headers,
                        interceptor: JwtRequestInterceptor())
                    .validate()
                    .responseData(emptyResponseCodes: [200, 201, 204]) { response in
                        switch response.result {
                        case .success:
                            LoadingIndicator.hideLoading()
                            observer.onNext(decodeResponse ?? .init(profileImageUrl: ""))
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
                case .failure(let error):
                    observer.onError(error)
                    print("profileImageUpload Error = \(error.localizedDescription)")
                }
            }
            return Disposables.create()
        }
    }
    
    func callToDeletePost(postIdx: Int) {
        let url = APIConstants.deletePostURL + "\(postIdx)"
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success:
                self?.callToProfileData()
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
    
    func navigateToSignInVC() {
        coordinator.navigate(to: .logOutIsRequired)
    }
}
