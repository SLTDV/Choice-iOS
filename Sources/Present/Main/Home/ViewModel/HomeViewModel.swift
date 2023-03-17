import Foundation
import RxSwift
import Alamofire
import RxCocoa

protocol PostItemsProtocol: AnyObject {
    var postItemsData: PublishSubject<[PostModel]> { get set }
}

final class HomeViewModel: BaseViewModel {
    weak var delegate: PostItemsProtocol?
    private let tk = KeyChain()
    private var disposeBag = DisposeBag()
    
    struct Input {
        var voteButtonDidTap: Observable<(Int, Int)>
    }
    
    struct Output {
        var firstVoteCountData: Observable<Int>
        var secondVoteCountData: Observable<Int>
    }
    
    func transform(_ input: Input) -> Output {
        let firstVoteRelay = BehaviorRelay(value: 0)
        
        let secondVoteRealy = BehaviorRelay(value: 0)
        
        let vote = input.voteButtonDidTap
            .withUnretained(self)
            .flatMap { owner, args in owner.votePost(idx: args.0, choice: args.1) }
            .share(replay: 2)
        
        vote.map(\.0)
            .bind(onNext: firstVoteRelay.accept(_:))
            .disposed(by: disposeBag)
        
        vote.map(\.1)
            .bind(onNext: secondVoteRealy.accept(_:))
            .disposed(by: disposeBag)
        
        return Output(
            firstVoteCountData: firstVoteRelay.asObservable(),
            secondVoteCountData: secondVoteRealy.asObservable()
        )
    }
    
    func votePost(idx: Int, choice: Int) -> Observable<(Int, Int)> {
        let url = APIConstants.addVoteNumberURL + "\(idx)"
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let params = [
            "choice" : choice
        ] as Dictionary
        
        return Observable.create { observer in
            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default,
                       headers: headers,
                       interceptor: JwtRequestInterceptor())
            .responseDecodable(of: VoteModel.self) { response in
                let first = response.value?.firstVotingCount ?? 0
                let second = response.value?.secondVotingCount ?? 0
                observer.onNext((first, second))
            }
            return Disposables.create()
        }
    }
    
    func callToAddVoteNumber(idx: Int, choice: Int) {
        let url = APIConstants.addVoteNumberURL + "\(idx)"
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let params = [
            "choice" : choice
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
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            default:
                return
            }
        }
    }
    
    func callToFindData(type: MenuOptionType) {
        lazy var url = ""
        
        switch type {
        case .findNewestPostData:
            url = APIConstants.findNewestPostURL
        case .findBestPostData:
            url = APIConstants.findAllBestPostURL
        }
        
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
                let decodeResponse = try? JSONDecoder().decode([PostModel].self, from: data)
                self?.delegate?.postItemsData.onNext(decodeResponse ?? .init())
            case .failure(let error):
                print("main error = \(error.localizedDescription)")
            }
        }
    }
    
    func pushAddPostVC() {
        coordinator.navigate(to: .addPostIsRequired)
    }
    
    func pushDetailPostVC(model: PostModel) {
        coordinator.navigate(to: .detailPostIsRequired(model: model))
    }
    
    func pushProfileVC() {
        coordinator.navigate(to: .profileIsRequired)
    }
}
