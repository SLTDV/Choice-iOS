import UIKit
import RxSwift
import RxCocoa

struct MyData {
    let image: UIImage?
    let text: String?
    let color: UIColor?
}

final class DetailOptionModalViewModel {
    let optionData: BehaviorRelay<[MyData]>
    
    init() {
        let initialData: [MyData] = [
            MyData(image: UIImage(systemName: "exclamationmark.circle"),
                   text: "게시물 신고",
                   color: UIColor.systemRed),
            MyData(image: UIImage(systemName: "person.crop.circle.badge.xmark"),
                   text: "사용자 차단",
                   color: UIColor.black),
            MyData(image: ChoiceAsset.Images.instarIcon.image,
                   text: "Instargram 에 공유",
                   color: UIColor.black)
        ]
        
        self.optionData = BehaviorRelay<[MyData]>(value: initialData)
    }
}

