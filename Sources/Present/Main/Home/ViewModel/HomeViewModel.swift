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
    private var currentPage = 0
    
    func callToFindData(type: MenuOptionType) {
        lazy var url = ""
//        currentPage += 1
        let postRequest = PostRequest(page: currentPage)
        let page = URLQueryItem(name: "page", value: String(postRequest.page))
        let size = URLQueryItem(name: "size", value: String(postRequest.size))
        
        switch type {
        case .findNewestPostData:
            url = APIConstants.findNewestPostURL
        case .findBestPostData:
            url = APIConstants.findAllBestPostURL
        }
        
        var components = URLComponents(string: url)
        components?.queryItems = [page, size]
        AF.request(components!,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor()
        ).responseDecodable(of: PostModel.self) { [weak self] response in
            switch response.result {
            case .success(let postData):
                print(postData
                )
                LoadingIndicator.hideLoading()
                self?.delegate?.postItemsData.accept(postData.posts)
                self?.delegate?.pageData.onNext(postData.page)
                self?.delegate?.sizeData.onNext(postData.size)
            case .failure(let error):
                print("main error = \(error.localizedDescription)")
            }
        }
        
        
        
        //        .validate()
        //        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
        //            switch response.result {
        //            case .success(let data):
        //                LoadingIndicator.hideLoading()
        //                let decodePostModel = try? JSONDecoder().decode(PostModel.self, from: data)
        //                self?.delegate?.postItemsData.accept(decodePostModel?.posts ?? .init())
        //                self?.delegate?.pageData.onNext(decodePostModel?.page ?? .zero)
        //                self?.delegate?.sizeData.onNext(decodePostModel?.size ?? .zero)
        //            case .failure(let error):
        //                print("main error = \(error.localizedDescription)")
        //            }
        //        }
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
