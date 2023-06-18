import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Shared
import SafariServices

protocol AgreementComponentViewDelegate: AnyObject {
    func privacyPolicyUrlLinkButtonDidTap(_ view: AgreementComponentView)
}

final class AgreementComponentView: UIView {
    private let disposeBag = DisposeBag()
    weak var delegate: AgreementComponentViewDelegate?
    
    private let checkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        $0.tintColor = .gray
        $0.isEnabled = false
    }
    
    private let optionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    private let linkTextButton = UIButton().then {
        $0.setTitle("보기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setTitleColor(UIColor.gray, for: .normal)
        $0.setUnderline()
    }
    
    private func linkTextButtonDidTap() {
        linkTextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.privacyPolicyUrlLinkButtonDidTap(self)
        }.disposed(by: disposeBag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        linkTextButtonDidTap()
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        self.addSubviews(checkButton, optionLabel, linkTextButton)
    }
    
    private func setLayout() {
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        optionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkButton.snp.trailing).offset(13)
        }
        
        linkTextButton.snp.makeConstraints {
            $0.centerY.equalTo(optionLabel)
            $0.leading.equalTo(optionLabel.snp.trailing).offset(10)
        }
    }
    
    func setCheckButton() {
        checkButton.tintColor = .black
    }
    
    func setOptionLabel(_ text: String) {
        optionLabel.text = text
    }
}
