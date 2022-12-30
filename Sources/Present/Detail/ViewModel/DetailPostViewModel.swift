import Foundation
import RxSwift
import Alamofire

protocol CommentDataProtocol: AnyObject {
    var authorname: PublishSubject<CommentModel> { get set }
    var commentData: PublishSubject<[CommentData]> { get set}
}

final class DetailPostViewModel: BaseViewModel {
    weak var delegate: CommentDataProtocol?
    
    func callToCommentData(idx: Int) {
        let url = APIConstants.detailPostURL + "\(idx)"
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: headers,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode([CommentData].self, from: data)
                self?.delegate?.commentData.onNext(decodeResponse ?? .init())
            case .failure(let error):
                print("main error = \(error.localizedDescription)")
            }
        }
    }
    
    
    func createComment(idx: Int, content: String) {
        let url = APIConstants.createCommentURL + "\(idx)"
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
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
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success:
                    print("comment")
            case .failure(let error):
                print("post error = \(String(describing: error.localizedDescription))")
            }
        }
    }
}
