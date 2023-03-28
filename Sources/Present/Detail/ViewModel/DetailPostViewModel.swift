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
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.queryString,
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
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.queryString,
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
    
    func createComment(idx: Int, content: String, completion: @escaping () -> ()) {
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
                self.callToCommentData(idx: idx)
                completion()
            case .failure(let error):
                print("post error = \(String(describing: error.localizedDescription))")
            }
        }
    }
}
