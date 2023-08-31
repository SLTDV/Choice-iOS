import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Shared

final class DetailMenuModalViewController: UIViewController {
    private let reportIconImage = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.circle")
        $0.tintColor = .systemRed
        $0.contentMode = .scaleAspectFill
    }

    private let reportTextButton = UIButton().then {
        $0.setTitle("게시물 신고", for: .normal)
        $0.setTitleColor(UIColor.systemRed, for: .normal)
    }
    
    private let blockUserIconImage = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.badge.xmark")
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
    private let blockUserTextButton = UIButton().then {
        $0.setTitle("사용자 차단", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
    }
    
    private let shareInstaIconImage = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.circle")
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
    private let shareInstaTextButton = UIButton().then {
        $0.titleLabel?.text = "Instargram 에 공유"
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        addView()
        setLayout()
    }
    
    private func addView() {
        view.addSubviews(reportIconImage, reportTextButton,
                         blockUserIconImage, blockUserTextButton,
                         shareInstaIconImage, shareInstaTextButton)
    }
    
    private func setLayout() {
        reportIconImage.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(32)
            $0.width.equalToSuperview().dividedBy(15.6)
            $0.height.equalToSuperview().dividedBy(9)
        }
        
        reportTextButton.snp.makeConstraints {
            $0.centerY.equalTo(reportIconImage.snp.centerY)
            $0.left.equalTo(reportIconImage.snp.right).offset(14)
            $0.width.equalToSuperview().dividedBy(4)
        }
        
        blockUserIconImage.snp.makeConstraints {
            $0.top.equalTo(reportIconImage.snp.bottom).offset(20)
            $0.left.equalTo(reportIconImage)
            $0.width.equalToSuperview().dividedBy(15.6)
            $0.height.equalToSuperview().dividedBy(9)
        }
        
        blockUserTextButton.snp.makeConstraints {
            $0.centerY.equalTo(blockUserIconImage)
            $0.left.equalTo(reportIconImage.snp.right).offset(14)
            $0.width.equalToSuperview().dividedBy(4)
        }
    }
}
