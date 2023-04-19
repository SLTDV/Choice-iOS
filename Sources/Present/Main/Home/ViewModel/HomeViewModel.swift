import Foundation
import RxSwift
import Alamofire
import RxCocoa

protocol PostItemsProtocol: AnyObject {
    var postItemsData: BehaviorRelay<[Posts]> { get set }
    var pageData: PublishSubject<Int> { get set }
    var sizeData: PublishSubject<Int> { get set }
}

final class HomeViewModel: BaseViewModel {
    weak var delegate: PostItemsProtocol?
    private let tk = KeyChain()
    private var disposeBag = DisposeBag()
    private var currentPage = -1
    
    func callToFindData(type: MenuOptionType, size: Int) {
        lazy var url = ""
        currentPage += 1
        let postRequest = PostRequest(page: currentPage)
        switch type {
        case .findNewestPostData:
            url = APIConstants.findNewestPostURL
        case .findBestPostData:
            url = APIConstants.findAllBestPostURL
        }
        var components = URLComponents(string: url)
        let page = URLQueryItem(name: "page", value: String(currentPage))
        let size = URLQueryItem(name: "size", value: String(size))
        
        components?.queryItems = [page, size]
        AF.request(components!,
                   method: .get,
                   parameters: postRequest.toDictionary(),
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                LoadingIndicator.hideLoading()
                let decodePostModel = try? JSONDecoder().decode(PostModel.self, from: data)
                self?.delegate?.postItemsData.accept(decodePostModel?.posts ?? .init())
                self?.delegate?.pageData.onNext(decodePostModel?.page ?? .zero)
                self?.delegate?.sizeData.onNext(decodePostModel?.size ?? .zero)
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
            case .success:
                print("success")
            case .failure(let error):
                print("vote error = \(error.localizedDescription)")
            }
        }
    }
    
    func pushAddPostVC() {
        coordinator.navigate(to: .addPostIsRequired)
    }
    
    func pushDetailPostVC(model: Posts) {
        coordinator.navigate(to: .detailPostIsRequired(model: model))
    }
    
    func pushProfileVC() {
        coordinator.navigate(to: .profileIsRequired)
    }
}
