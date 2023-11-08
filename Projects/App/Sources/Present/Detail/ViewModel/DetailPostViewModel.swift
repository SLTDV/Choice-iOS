import Foundation
import RxRelay
import RxSwift
import Alamofire
import JwtStore
import Swinject

protocol CommentDataProtocol: AnyObject {
    var detailPostModelRelay: BehaviorRelay<CommentModel> { get set }
}

final class DetailPostViewModel: BaseViewModel {
    weak var delegate: CommentDataProtocol?
    var commentCurrentPage = -1
    private let container = DIContainer.shared.resolve(JwtStore.self)!
    
    func requestCommentData(idx: Int) -> Observable<Int?> {
        let url = APIConstants.detailPostURL + "\(idx)"
        
        commentCurrentPage += 1
        let requestComment = RequestPostModel(page: commentCurrentPage)
        
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
                    self?.delegate?.detailPostModelRelay.accept(postData)
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
                break
            case .failure(let error):
                print("vote error = \(error.localizedDescription)")
            }
        }
    }
    
    func requestToCreateComment(idx: Int, content: String) -> Observable<Void> {
        let url = APIConstants.createCommentURL + "\(idx)"
        let params = [
            "content" : content
        ] as Dictionary
        
        return Observable.create { observer -> Disposable in
            
            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default,
                       interceptor: JwtRequestInterceptor(jwtStore: self.container))
            .validate()
            .responseData(emptyResponseCodes: [200, 201, 204]) { response in
                switch response.result {
                case .success:
                    observer.onNext(())
                case .failure(let error):
                    print("Error - CreateComment - \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func requestToDeleteComment(postIdx: Int, commentIdx: Int) -> Observable<Void> {
        let url = APIConstants.deleteCommentURL + "\(postIdx)/" + "\(commentIdx)"
        
        return Observable.create { [weak self] observer -> Disposable in
            AF.request(url,
                       method: .delete,
                       encoding: URLEncoding.queryString,
                       interceptor: JwtRequestInterceptor(jwtStore: self!.container))
            .validate()
            .responseData(emptyResponseCodes: [200, 201, 204]) { response in
                switch response.result {
                case .success:
                    observer.onNext(())
                case .failure(let error):
                    print("Error - DeleteComment - \(error.localizedDescription)")
                }
            }
            return Disposables.create()
        }
    }
    
    func requestToReportPost(postIdx: Int) -> Observable<Void> {
        let url = APIConstants.reportPostURL + "\(postIdx)"
        
        return Observable.create { (observer) -> Disposable in
            AF.request(url,
                       method: .post,
                       encoding: URLEncoding.queryString,
                       interceptor: JwtRequestInterceptor(jwtStore: self.container))
            .validate()
            .responseData(emptyResponseCodes: [200, 201, 204]) { response in
                switch response.result {
                case .success:
                    observer.onNext(())
                case .failure(let error):
                    print("Error - ReportPost - \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func requestToBlockUser(postIdx: Int) -> Observable<Void> {
        let url = APIConstants.blockUserURL + "\(postIdx)"
        
        return Observable.create { observer -> Disposable in
            AF.request(url,
                       method: .post,
                       encoding: URLEncoding.queryString,
                       interceptor: JwtRequestInterceptor(jwtStore: self.container))
            .validate()
            .responseData(emptyResponseCodes: [200, 201, 204]) { response in
                switch response.result {
                case .success:
                    observer.onNext(())
                case .failure(let error):
                    print("Erorr - BlockUser = \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func popToRootVC() {
        coordinator.navigate(to: .popVCIsRequired)
    }
    
}
