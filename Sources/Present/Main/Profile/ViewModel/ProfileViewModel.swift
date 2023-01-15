import Foundation
import Alamofire
import RxSwift

protocol ProfileDataProtocol: AnyObject {
    var nicknameData: PublishSubject<String> { get set }
    var postListData: PublishSubject<[PostModel]> { get set }
}

final class ProfileViewModel: BaseViewModel {
    weak var delegate: ProfileDataProtocol?
    
    func callToProfileData() {
        let url = APIConstants.profileURL
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,
                   method: .get,
                   headers: headers,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode(ProfileModel.self, from: data)
                self?.delegate?.postListData.onNext(decodeResponse?.postList ?? .init())
                self?.delegate?.nicknameData.onNext(decodeResponse?.nickname ?? .init())
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
    
    func callToChangeNickname(nickname: String) {
        let url = APIConstants.changeNicknameURL
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let params = [
            "nickname" : nickname
        ] as Dictionary
        
        AF.request(url,
                   method: .patch,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success:
                self?.delegate?.nicknameData.onNext(nickname)
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
}
