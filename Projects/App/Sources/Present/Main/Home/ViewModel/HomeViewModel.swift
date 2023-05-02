import Foundation
import RxSwift
import Alamofire
import RxCocoa
import Shared
import Interceptor

protocol PostItemsProtocol: AnyObject {
    var postData: BehaviorRelay<[Posts]> { get set }
}

final class HomeViewModel: BaseViewModel {
    weak var delegate: PostItemsProtocol?
    private var disposeBag = DisposeBag()
    var newestPostCurrentPage = -1
    var bestPostCurrentPage = -1
    
    func requestPostData(type: MenuOptionType, completion: @escaping (Result<Int, Error>) -> Void = { _ in }) {
        var url = ""
        var postRequest: PostRequest?
        switch type {
        case .findNewestPostData:
            url = APIConstants.findNewestPostURL
            newestPostCurrentPage += 1
            postRequest = PostRequest(page: newestPostCurrentPage)
        case .findBestPostData:
            url = APIConstants.findAllBestPostURL
            bestPostCurrentPage += 1
            postRequest = PostRequest(page: bestPostCurrentPage)
        }
        
        let page = URLQueryItem(name: "page", value: String(postRequest!.page))
        let size = URLQueryItem(name: "size", value: String(postRequest!.size))
        
        var components = URLComponents(string: url)
        components?.queryItems = [page, size]
        
        AF.request(components!,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor()
        ).responseDecodable(of: PostModel.self) { [weak self] response in
            switch response.result {
            case .success(let postData):
                LoadingIndicator.hideLoading()
                completion(.success(postData.size))
                
                var relay = self?.delegate?.postData.value
                relay?.append(contentsOf: postData.posts)
                self?.delegate?.postData.accept(relay!)
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
