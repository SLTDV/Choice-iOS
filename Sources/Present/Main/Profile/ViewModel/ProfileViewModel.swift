import Foundation
import Alamofire
import RxSwift

protocol ProfileDataProtocol: AnyObject {
    var profileData: PublishSubject<[PostModel]> { get set }
}

class ProfileViewModel: BaseViewModel {
    weak var delegate: ProfileDataProtocol?
    
    func callToProfileData() {
        let url = APIConstants.profileURL
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,
                   method: .get,
                   headers: headers,
                   interceptor: JwtRequestInterceptor())
        .responseData { [weak self] response in
            
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode(ProfileModel.self, from: data)
                print("decodeResponse = \(decodeResponse)")
                self?.delegate?.profileData.onNext(decodeResponse?.postList ?? .init())
                print(self?.delegate?.profileData)
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
            
        }
    }
}
