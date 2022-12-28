import Foundation
import RxSwift
import Alamofire

protocol PostItemsProtocol: AnyObject {
    var postItemsData: PublishSubject<[PostModel]> { get set }
}

final class MainViewModel: BaseViewModel {
    weak var delegate: PostItemsProtocol?
    
    func callToFindData(type: MenuOptionType) {
        lazy var url = ""
        
        switch type {
        case .findNewestPostData:
            url = APIConstants.findNewestPostURL
        case .findBestPostData:
            url = APIConstants.findAllBestPostURL
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: headers,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode([PostModel].self, from: data)
                self?.delegate?.postItemsData.onNext(decodeResponse ?? .init())
            case .failure(let error):
                print("main error = \(error.localizedDescription)")
            }
        }
    }
    
    func pushAddPostVC() {
        coordinator.navigate(to: .addPostIsRequired)
    }
}
