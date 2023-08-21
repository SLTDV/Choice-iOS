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
    var isMineData: Bool { get set }
}

final class DetailPostViewModel: BaseViewModel {
    weak var delegate: CommentDataProtocol?
    var commentCurrentPage = -1
    private let container = AppDelegate.container.resolve(JwtStore.self)!
    
    func requestCommentData(idx: Int) -> Observable<Int> {
        let url = APIConstants.detailPostURL + "\(idx)"
        
        commentCurrentPage += 1
        let requestComment = PostRequest(page: commentCurrentPage)
        
        let page = URLQueryItem(name: "page", value: String(requestComment.page))
        let size = URLQueryItem(name: "size", value: String(requestComment.size))
        var components = URLComponents(string: url)
        components?.queryItems = [page, size]
        
        return Observable.create { [weak self] (observer) -> Disposable in
            AF.request(components!,
                       method: .get,
                       encoding: URLEncoding.queryString,
                       interceptor: JwtRequestInterceptor(jwtStore: self!.container))
            .validate()
            .responseDecodable(of: CommentModel.self) { [weak self] response in
                switch response.result {
                case .success(let postData):
                    observer.onNext(postData.size)
                    self?.delegate?.writerImageStringData.onNext(postData.image)
                    self?.delegate?.writerNameData.onNext(postData.writer)
                    self?.delegate?.isMineData = postData.isMine
                    var relay = self?.delegate?.commentData.value
                    relay?.append(contentsOf: postData.commentList)
                    self?.delegate?.commentData.accept(relay!)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                    print("comment = \(error.localizedDescription)")
                }
            }
            
            return Disposables.create()
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
                   interceptor: JwtRequestInterceptor(jwtStore: container))
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
    
    func requestToDeleteComment(postIdx: Int, commentIdx: Int, completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    func requestToReportPost(postIdx: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = APIConstants.reportPostURL + "\(postIdx)"
        AF.request(url,
                   method: .post,
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
    
    func requestToBlockUser(postIdx: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = APIConstants.blockUserURL + "\(postIdx)"
        AF.request(url,
                   method: .post,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor(jwtStore: container))
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                print("Erorr - BlockUser = \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func popToRootVC() {
        coordinator.navigate(to: .popVCIsRequired)
    }
    
}
