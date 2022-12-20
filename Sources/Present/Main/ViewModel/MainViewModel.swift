import Foundation
import RxSwift

protocol PostItemsPresentable: AnyObject {
    var postItemsData: PublishSubject<[PostModel]> { get set }
}

class MainViewModel: BaseViewModel {
    weak var delegate: PostItemsPresentable?
}
