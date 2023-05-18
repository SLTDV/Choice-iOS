import Foundation
import RxRelay
import RxSwift
import Alamofire
import JwtStore
import Swinject

protocol CommentDataProtocol: AnyObject {
    var writerNameData: PublishSubject<String> { get set  }
    var writerImageStringData: PublishSubject<String?> { get set }
    var commentData: BehaviorRelay<[CommentList]> { get set }
}

final class DetailPostViewModel: BaseViewModel {
    weak var delegate: CommentDataProtocol?
    var commentCurrentPage = -1
    private let container = AppDelegate.container.resolve(JwtStore.self)!
    
    func requestCommentData(idx: Int, completion: @escaping (Result<Int, Error>) -> Void = { _ in }) {
        let url = APIConstants.detailPostURL + "\(idx)"
        
        commentCurrentPage += 1
        let requestComment = PostRequest(page: commentCurrentPage)
        
        let page = URLQueryItem(name: "page", value: String(requestComment.page))
        let size = URLQueryItem(name: "size", value: String(requestComment.size))
        var components = URLComponents(string: url)
        components?.queryItems = [page, size]
        
        AF.request(components!,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor(jwtStore: container))
        .validate()
        .responseDecodable(of: CommentModel.self) { [weak self] response in
            switch response.result {
            case .success(let postData):
                completion(.success(postData.size))
                print(postData.page, postData.size)
                self?.delegate?.writerImageStringData.onNext(postData.image)
                self?.delegate?.writerNameData.onNext(postData.writer)
                var relay = self?.delegate?.commentData.value
                relay?.append(contentsOf: postData.commentList)
                self?.delegate?.commentData.accept(relay!)
            case .failure(let error):
                print("comment = \(error.localizedDescription)")
            }
        }
    }
    
    func requestToCreateComment(idx: Int, content: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = APIConstants.createCommentURL + "\(idx)"
        let params = [
            "content" : content
        ] as Dictionary
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   interceptor: JwtRequestInterceptor(jwtStore: container))
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure((error)))
            }
        }
    }
    
    func requestToDeleteComment(postIdx: Int, commentIdx: Int, completion: @escaping (Result<Void, Error>) -> ()) {
        let url = APIConstants.deleteCommentURL + "\(postIdx)/" + "\(commentIdx)"
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor(jwtStore: container))
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
