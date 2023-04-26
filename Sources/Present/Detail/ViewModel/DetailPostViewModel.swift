import Foundation
import RxRelay
import RxSwift
import Alamofire

protocol CommentDataProtocol: AnyObject {
    var writerNameData: PublishSubject<String> { get set  }
    var writerImageStringData: PublishSubject<String?> { get set }
    var commentData: BehaviorRelay<[CommentData]> { get set }
}

final class DetailPostViewModel: BaseViewModel {
    weak var delegate: CommentDataProtocol?
    var commentCurrentPage = -1
    
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
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseDecodable(of: CommentModel.self) { [weak self] response in
            switch response.result {
            case .success(let postData):
                completion(.success(postData.size))
                print(postData.page, postData.size)
                self?.delegate?.writerImageStringData.onNext(postData.image)
                self?.delegate?.writerNameData.onNext(postData.writer)
                self?.delegate?.commentData.accept(postData.comment)
            case .failure(let error):
                print("comment = \(error.localizedDescription)")
            }
        }
    }
    
    func requestToCreateComment(idx: Int, content: String, completion: @escaping () -> ()) {
        let url = APIConstants.createCommentURL + "\(idx)"
        let params = [
            "content" : content
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
                completion()
            case .failure(let error):
                print("post error = \(String(describing: error.localizedDescription))")
            }
        }
    }
    
    func requestToDeleteComment(postIdx: Int, commentIdx: Int, completion: @escaping (Result<Void, Error>) -> ()) {
        let url = APIConstants.deleteCommentURL + "\(postIdx)/" + "\(commentIdx)"
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor())
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
