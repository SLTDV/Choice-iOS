import UIKit
import RxSwift
import RxCocoa
import Shared

final class AddPostViewController: BaseVC<AddPostViewModel> {
    private let disposeBag = DisposeBag()

    private let inputTitleTextField = BoxTextField(type: .countTextField).then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.placeholder = "제목입력 (2~16)"
        $0.borderStyle = .none
    }
    
    private let divideLine = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let inputDescriptionTextView = BoxTextField(type: .countTextField).then {
        $0.placeholder = "내용입력 (2~100)"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private lazy var addPostViewButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor( .white, for: .normal)
        $0.backgroundColor = SharedAsset.grayMedium.color
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
    }
    
    @objc private func tapMethod(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapMethod(_:)))
    
    private func bindUI() {
        let titleTextObservable = inputTitleTextField.rx.text.orEmpty
        let descriptionTextObservable = inputDescriptionTextView.rx.text.orEmpty
            .filter { $0 != "내용입력 (2~100)" }
        
        Observable.combineLatest(
            titleTextObservable,
            descriptionTextObservable,
            resultSelector: { s1, s2 in (2...16).contains(s1.count) && (2...100).contains(s2.count) }
        )
        .bind(with: self, onNext: { owner, arg in
            owner.addPostViewButton.isEnabled = arg
            owner.addPostViewButton.backgroundColor = arg ? .black : SharedAsset.grayMedium.color
        }).disposed(by: disposeBag)
    }
    
    override func configureVC() {
        navigationItem.title = "게시물 작성"
        
        bindUI()
    }
    
    override func addView() {
        view.addSubviews(inputTitleTextField, divideLine,
                         inputDescriptionTextView, addPostViewButton)
    }
    
    override func setLayout() {
        inputTitleTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(58)
        }
        
        divideLine.snp.makeConstraints {
            $0.top.equalTo(inputTitleTextField.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        inputDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(divideLine.snp.bottom).offset(20)
            $0.height.equalTo(113)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        addPostViewButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(49)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

extension AddPostViewController: UITextViewDelegate {
    private func setTextViewPlaceholder() {
        if ((inputDescriptionTextView.text?.isEmpty) != nil) {
            inputDescriptionTextView.text = "내용입력 (2~100)"
            inputDescriptionTextView.textColor = UIColor.lightGray
        } else if inputDescriptionTextView.text == "내용입력 (2~100)" {
            inputDescriptionTextView.text = ""
            inputDescriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setTextViewPlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setTextViewPlaceholder()
        }
    }
}
