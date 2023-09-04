import UIKit
import RxSwift
import RxCocoa

final class DetailOptionModalViewModel {
    let optionData = BehaviorRelay<[OptionData]>(value: [])
    
    let optionList = [
        OptionData(image: UIImage(systemName: "exclamationmark.circle")!,
                   text: "게시물 신고",
                   color: UIColor.systemRed),
        OptionData(image: UIImage(systemName: "person.crop.circle.badge.xmark")!,
                   text: "사용자 차단",
                   color: UIColor.black),
        OptionData(image: ChoiceAsset.Images.instarIcon.image,
                   text: "Instagram에 공유",
                   color: UIColor.black)
    ]
    
    init() {
        optionData.accept(optionList)
    }
}
