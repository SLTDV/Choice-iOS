import UIKit
import RxSwift
import RxCocoa
import Shared

enum ContentsPlaceHolder {
    static let titleText = "제목입력 (2~16)"
    static let contentText = "내용입력 (0~100)"
}

final class AddContentsViewController: BaseVC<AddContentsViewModel> {
    private let disposeBag = DisposeBag()

    private let inputTitleTextField = BoxTextField(type: .countTextField).then {
        $0.placeholder = ContentsPlaceHolder.titleText
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let divideLine = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let inputContentTextView = UITextView().then {
        $0.text = ContentsPlaceHolder.contentText
        $0.textContainerInset = UIEdgeInsets(top: 18, left: 8, bottom: 18, right: 8)
        $0.textColor = .placeholderText
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = SharedAsset.grayMedium.color.cgColor
    }
    
    private let textCountLabel = UILabel().then {
        $0.text = "0 / 100"
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .placeholderText
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor( .white, for: .normal)
        $0.backgroundColor = SharedAsset.grayMedium.color
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
    }
    
    private func bindUI() {
        inputTitleTextField.rx.text.orEmpty
            .map { $0.count }
            .bind(with: self) { owner, count in
                let isValid = (2...16).contains(count)
                owner.nextButton.isEnabled = isValid
                owner.nextButton.backgroundColor = isValid ? .black : SharedAsset.grayMedium.color
            }.disposed(by: disposeBag)
    }
    
    private func limitText() {
        inputTitleTextField.rx.text.orEmpty
            .map { $0.count <= 16 ? $0 : String($0.prefix(16)) }
            .bind(to: inputTitleTextField.rx.text)
            .disposed(by: disposeBag)
        
        inputContentTextView.rx.text.orEmpty
            .map { $0.count <= 100 ? $0 : String($0.prefix(100)) }
            .bind(to: inputContentTextView.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindCountTextLabel() {
        inputContentTextView.rx.text
            .orEmpty
            .filter { $0 != ContentsPlaceHolder.contentText }
            .map { text in
                let count = min(text.count, 100)
                return "\(count) / 100"
            }
            .bind(to: textCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func textSetUp() {
        inputContentTextView.rx.didBeginEditing
            .bind(with: self){ owner, _ in
                if(owner.inputContentTextView.text == ContentsPlaceHolder.contentText){
                    owner.inputContentTextView.text = ""
                    owner.inputContentTextView.textColor = .black
                }
                owner.inputContentTextView.layer.borderColor = UIColor.black.cgColor
            }.disposed(by: disposeBag)
        
        inputContentTextView.rx.didEndEditing
            .bind(with: self){ owner, _ in
                if owner.inputContentTextView.text == "" {
                    owner.inputContentTextView.text = ContentsPlaceHolder.contentText
                    owner.inputContentTextView.textColor = .placeholderText
                }
                owner.inputContentTextView.layer.borderColor = SharedAsset.grayMedium.color.cgColor
            }.disposed(by: disposeBag)
    }
    
    private func nextButtonDidTap() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                LoadingIndicator.showLoading(text: "")
                owner.pushAddImageVC()
            }.disposed(by: disposeBag)
    }
    
    private func pushAddImageVC() {
        let title = inputTitleTextField.text
        var content = inputContentTextView.text
        
        if content == ContentsPlaceHolder.contentText {
            content = ""
        }
        
        self.viewModel.pushAddImageVC(title: title!, content: content!)
        LoadingIndicator.hideLoading()
    }
    
    override func configureVC() {
        navigationItem.title = "게시물 작성"
        
        nextButtonDidTap()
        limitText()
        textSetUp()
        bindCountTextLabel()
        bindUI()
    }
    
    override func addView() {
        view.addSubviews(inputTitleTextField, divideLine,
                         inputContentTextView, textCountLabel, nextButton)
    }
    
    override func setLayout() {
        inputTitleTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.height.equalTo(58)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        inputContentTextView.snp.makeConstraints {
            $0.top.equalTo(inputTitleTextField.snp.bottom).offset(25)
            $0.height.equalTo(150)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(inputContentTextView.snp.trailing).inset(10)
            $0.bottom.equalTo(inputContentTextView.snp.bottom).inset(10)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets.bottom).inset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
    }
}
