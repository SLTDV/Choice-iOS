import Foundation
import RxSwift
import Alamofire

protocol PostItemsPresentable: AnyObject {
    var postItemsData: PublishSubject<[PostModel]> { get set }
}

class MainViewModel: BaseViewModel {
    weak var delegate: PostItemsPresentable?
    
    func getFindAllData() {
        
    }
}
