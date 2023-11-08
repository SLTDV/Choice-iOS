import Foundation
import Alamofire
import RxSwift
import RxCocoa
import JwtStore
import Swinject

protocol PostItemsProtocol: AnyObject {
    var postData: BehaviorRelay<[PostList]> { get set }
}

final class HomeViewModel: BaseViewModel {
    weak var delegate: PostItemsProtocol?
    private let disposeBag = DisposeBag()
    var newestPostCurrentPage = -1
    var bestPostCurrentPage = -1
    private let container = DIContainer.shared.resolve(JwtStore.self)!
    
    func requestPostData(
        type: MenuOptionType,
        completion: @escaping (Result<Int, Error>) -> Void = { _ in }
    ) {
        var req: RequestPostModel?
        switch type {
        case .findNewestPostData:
            newestPostCurrentPage += 1
            req = RequestPostModel(page: newestPostCurrentPage)
        case .findBestPostData:
            bestPostCurrentPage += 1
            req = RequestPostModel(page: bestPostCurrentPage)
        }
        
        AF.request(
            HomeTarget.requestPostData(
                RequestPostModel(
                    type: type,
                    page: req!.page,
                    size: req!.size
                )
            )
        ).responseDecodable(of: PostModel.self) { [weak self] response in
            switch response.result {
            case .success(let postData):
                completion(.success(postData.size))
                var relay = self?.delegate?.postData.value
                relay?.append(contentsOf: postData.postList)
                self?.delegate?.postData.accept(relay!)
            case .failure(let error):
                completion(.failure(error))
                print("main error = \(error.localizedDescription)")
            }
        }
    }
    
    func requestVote(idx: Int, choice: Int) {
        AF.request(
            HomeTarget.requestToVote(
                RequestVoteModel(
                    idx: idx,
                    choice: choice
                )
            )
        ).responseData(emptyResponseCodes: [200, 201, 204]) { response in
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
    
    func pushDetailPostVC(model: PostList, type: ViewControllerType) {
        coordinator.navigate(to: .detailPostIsRequired(model: model, type: type))
    }
    
    func pushProfileVC() {
        coordinator.navigate(to: .profileIsRequired)
    }
}
