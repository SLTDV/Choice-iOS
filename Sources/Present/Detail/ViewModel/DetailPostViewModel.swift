import Foundation
import RxSwift
import Alamofire

protocol CommentDataProtocol: AnyObject {
    var writerNameData: PublishSubject<String> { get set  }
    var writerImageStringData: PublishSubject<String> { get set }
    var commentData: PublishSubject<[CommentData]> { get set }
}

final class DetailPostViewModel: BaseViewModel {
    weak var delegate: CommentDataProtocol?
    
    func deleteComment(commentIdx: Int) {
        let url = APIConstants.deleteCommentURL + "\(commentIdx)"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.queryString,
                   headers: headers,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { response in
            switch response.result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callToCommentData(idx: Int) {
        let url = APIConstants.detailPostURL + "\(idx)"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: headers,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try! JSONDecoder().decode(CommentModel.self, from: data)
                self?.delegate?.writerImageStringData.onNext(decodeResponse.image)
                self?.delegate?.writerNameData.onNext(decodeResponse.writer)
                self?.delegate?.commentData.onNext(decodeResponse.comment)
            case .failure(let error):
                print("comment = \(error.localizedDescription)")
            }
        }
    }
    
    func createComment(idx: Int, content: String, completion: @escaping (Bool) -> ()) {
        let url = APIConstants.createCommentURL + "\(idx)"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let params = [
            "content" : content
        ] as Dictionary
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { response in
            switch response.result {
            case .success:
                print("success")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    LoadingIndicator.showLoading()
                    completion(true)
                }
            case .failure(let error):
                print("post error = \(String(describing: error.localizedDescription))")
                completion(false)
            }
        }
    }
}
