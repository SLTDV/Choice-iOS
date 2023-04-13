import Foundation
import RxSwift
import Alamofire
import RxCocoa

protocol PostItemsProtocol: AnyObject {
    var postItemsData: BehaviorRelay<[PostModel]> { get set }
}

final class HomeViewModel: BaseViewModel {
    weak var delegate: PostItemsProtocol?
    private let tk = KeyChain()
    private var disposeBag = DisposeBag()
    
    func callToFindData(type: MenuOptionType) {
        lazy var url = ""
        
        switch type {
        case .findNewestPostData:
            url = APIConstants.findNewestPostURL
        case .findBestPostData:
            url = APIConstants.findAllBestPostURL
        }
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode([PostModel].self, from: data)
                self?.delegate?.postItemsData.accept(decodeResponse ?? .init())
            case .failure(let error):
                print("main error = \(error.localizedDescription)")
            }
        }
    }
    
    func callToAddVoteNumber(idx: Int, choice: Int) {
        let url = APIConstants.addVoteNumberURL + "\(idx)"
        let params = [
            "choice" : choice
        ] as Dictionary
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try! JSONDecoder().decode(VoteModel.self, from: data)
                print(decodeResponse)
                print("success")
            case .failure(let error):
                print("vote error = \(error.localizedDescription)")
            }
        }
    }
    
    func pushAddPostVC() {
        coordinator.navigate(to: .addPostIsRequired)
    }
    
    func pushDetailPostVC(model: PostModel) {
        coordinator.navigate(to: .detailPostIsRequired(model: model))
    }
    
    func pushProfileVC() {
        coordinator.navigate(to: .profileIsRequired)
    }
}
