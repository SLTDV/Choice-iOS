import UIKit
import SnapKit
import Then

final class DetailMenuModalViewController: UIViewController {
    private let reportIconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.circle")
        $0.tintColor = .systemRed
        $0.contentMode = .scaleAspectFill
    }

    private let reportTextButton = UIButton().then {
        $0.setTitle("게시물 신고", for: .normal)
        $0.setTitleColor(UIColor.systemRed, for: .normal)
    }
    
    private let blockUserIconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.badge.xmark")
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
    private let blockUserTextButton = UIButton().then {
        $0.setTitle("사용자 차단", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
    }
    
    private let shareInstarIconImageView = UIImageView().then {
        $0.image = ChoiceAsset.Images.instarIcon.image
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
    private let shareInstarTextButton = UIButton().then {
        $0.setTitle("Instargram 에 공유", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        addView()
        setLayout()
    }
    
    private func addView() {
        view.addSubviews(reportIconImageView, reportTextButton,
                         blockUserIconImageView, blockUserTextButton,
                         shareInstarIconImageView, shareInstarTextButton)
    }
    
    private func setLayout() {
        reportIconImageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(32)
            $0.width.equalToSuperview().dividedBy(15.6)
            $0.height.equalToSuperview().dividedBy(9)
        }
        
        reportTextButton.snp.makeConstraints {
            $0.centerY.equalTo(reportIconImageView)
            $0.left.equalTo(reportIconImageView.snp.right).offset(14)
            $0.width.equalToSuperview().dividedBy(4)
        }
        
        blockUserIconImageView.snp.makeConstraints {
            $0.top.equalTo(reportIconImageView.snp.bottom).offset(20)
            $0.left.equalTo(reportIconImageView)
            $0.width.equalToSuperview().dividedBy(15.6)
            $0.height.equalToSuperview().dividedBy(9)
        }
        
        blockUserTextButton.snp.makeConstraints {
            $0.centerY.equalTo(blockUserIconImageView)
            $0.left.equalTo(blockUserIconImageView.snp.right).offset(14)
            $0.width.equalToSuperview().dividedBy(4)
        }
        
        shareInstarIconImageView.snp.makeConstraints {
            $0.top.equalTo(blockUserIconImageView.snp.bottom).offset(20)
            $0.left.equalTo(reportIconImageView)
            $0.width.equalToSuperview().dividedBy(16.6)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
        shareInstarTextButton.snp.makeConstraints {
            $0.centerY.equalTo(shareInstarIconImageView)
            $0.left.equalTo(shareInstarIconImageView.snp.right).offset(14)
            $0.width.equalToSuperview().dividedBy(2.4)
        }
    }
}
