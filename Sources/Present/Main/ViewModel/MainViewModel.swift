import Foundation
import RxSwift
import Alamofire

protocol PostItemsPresentable: AnyObject {
    var postItemsData: PublishSubject<[PostModel]> { get set }
}

final class MainViewModel: BaseViewModel {
    weak var delegate: PostItemsPresentable?
    
    func callToFindData(type: MenuOptionType) {
        lazy var url = ""
        
        switch type {
        case .findNewestPostData:
            url = APIConstants.findNewestPost
        case .findBestPostData:
            url = APIConstants.findAllBestPost
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: headers).validate()
        .responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode([PostModel].self, from: data)
                self?.delegate?.postItemsData.onNext(decodeResponse ?? .init())
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
    
    func pushAddPostVC() {
        coordinator.navigate(to: .addPostIsRequired)
    }
}
