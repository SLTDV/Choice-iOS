import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class VoteViewModel {
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
        
        let vote =  input.voteButtonDidTap
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
            .validate()
            .responseDecodable(of: VoteModel.self) { response in
                let first = response.value?.firstVotingCount ?? 0
                let second = response.value?.secondVotingCount ?? 0
                observer.onNext((first, second))
            }
            return Disposables.create()
        }
    }
}
