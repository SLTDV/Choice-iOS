import UIKit

class AddPostViewController: BaseVC<AddPostViewModel> {
    
    private let addMainImageView = UIImageView().then {
        $0.backgroundColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    }
    
    private let plusIconImageView = UIImageView().then {
        $0.image = .init(systemName: "plus")
        $0.tintColor = .gray
        $0.contentMode = .scaleAspectFill
    }
    
    private let inputTitleTextField = UITextField().then {
        $0.placeholder = "제목입력"
        $0.textColor = .lightGray
        $0.borderStyle = .none
    }
    
    private let divideLine = UIView().then {
        $0.backgroundColor = .init(red: 0.37, green: 0.36, blue: 0.36, alpha: 1)
    }
    
    private let inputDescriptionTextView = UITextView().then {
        $0.text = "내용입력"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .lightGray
        $0.backgroundColor = .white
    }
    
    private let topicTitleLabel = UILabel().then {
        $0.text = "주제를 입력해주세요"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
    }
    
    private lazy var firstSetTopicButton = UIButton().then {
        $0.setTitle("주제1", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = .init(red: 0.629, green: 0.629, blue: 0.629, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    private lazy var secondSetTopicButton = UIButton().then {
        $0.setTitle("주제2", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = .init(red: 0.629, green: 0.629, blue: 0.629, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    private lazy var pushAddPostViewButton = UIButton().then {
        $0.setTitle("계속", for: .normal)
        $0.setTitleColor( .white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    override func configureVC() {
        self.navigationItem.title = "게시물 작성"
        inputDescriptionTextView.delegate = self
    }
    
    override func addView() {
        view.addSubviews(addMainImageView, plusIconImageView, inputTitleTextField, divideLine, inputDescriptionTextView,
                         topicTitleLabel, firstSetTopicButton, secondSetTopicButton, pushAddPostViewButton)
    }
    
    override func setLayout() {
        addMainImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(99)
            $0.height.equalTo(223)
            $0.leading.trailing.equalToSuperview()
        }
        
        plusIconImageView.snp.makeConstraints {
            $0.height.equalTo(25)
            $0.center.equalTo(addMainImageView)
        }
        
        inputTitleTextField.snp.makeConstraints {
            $0.top.equalTo(addMainImageView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        divideLine.snp.makeConstraints {
            $0.top.equalTo(inputTitleTextField.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        inputDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(divideLine.snp.bottom).offset(20)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        topicTitleLabel.snp.makeConstraints {
            $0.top.equalTo(inputDescriptionTextView.snp.bottom).offset(95)
            $0.leading.equalToSuperview().offset(32)
        }
        
        firstSetTopicButton.snp.makeConstraints {
            $0.top.equalTo(topicTitleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(211)
            $0.height.equalTo(89)
        }
        
        secondSetTopicButton.snp.makeConstraints {
            $0.top.equalTo(topicTitleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(211)
            $0.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(89)
        }
    
        pushAddPostViewButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(39)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(49)
        }
    }
}

extension AddPostViewController: UITextViewDelegate {
    
    private func setTextViewPlaceholder() {
        if inputDescriptionTextView.text == "" {
            inputDescriptionTextView.text = "내용입력"
            inputDescriptionTextView.textColor = UIColor.lightGray
        } else if inputDescriptionTextView.text == "내용입력"{
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}
