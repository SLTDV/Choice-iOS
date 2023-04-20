import Foundation
import RxSwift
import Alamofire
import RxCocoa

protocol PostItemsProtocol: AnyObject {
    var newestPostData: BehaviorRelay<[Posts]> { get set }
    var bestPostData: BehaviorRelay<[Posts]> { get set }
    var pageData: PublishSubject<Int> { get set }
    var sizeData: PublishSubject<Int> { get set }
}

final class HomeViewModel: BaseViewModel {
    weak var delegate: PostItemsProtocol?
    private let tk = KeyChain()
    private var disposeBag = DisposeBag()
    private var newestPostCurrentPage = -1
    private var bestPostCurrentPage = -1
    
    func requestPostData(type: MenuOptionType, completion: @escaping (Result<Int, Error>) -> Void = { _ in }) {
        var url = ""
        newestPostCurrentPage += 1
        
        switch type {
        case .findNewestPostData:
            url = APIConstants.findNewestPostURL
        case .findBestPostData:
            url = APIConstants.findAllBestPostURL
        }
        
        let postRequest = PostRequest(page: newestPostCurrentPage)
        let page = URLQueryItem(name: "page", value: String(postRequest.page))
        let size = URLQueryItem(name: "size", value: String(postRequest.size))
        var relay = delegate?.newestPostData.value
        
        var components = URLComponents(string: url)
        components?.queryItems = [page, size]
        
        AF.request(components!,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor()
        ).responseDecodable(of: PostModel.self) { [weak self] response in
            switch response.result {
            case .success(let postData):
                completion(.success(postData.size))
                
                LoadingIndicator.hideLoading()
                relay?.append(contentsOf: postData.posts)
                self?.delegate?.newestPostData.accept(relay!)
                self?.delegate?.pageData.onNext(postData.page)
                self?.delegate?.sizeData.onNext(postData.size)
            case .failure(let error):
                completion(.failure(error))
                print("main error = \(error.localizedDescription)")
            }
        }
    }
    
    func requestVote(idx: Int, choice: Int) {
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
