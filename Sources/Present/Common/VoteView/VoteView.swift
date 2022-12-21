//
//  VoteView.swift
//  Choice
//
//  Created by 민도현 on 2022/12/20.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class VoteView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let firstVoteTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    private let secondVoteTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    private let firstVoteButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.79, green: 0.81, blue: 0.83, alpha: 1)
    }
    
    private let secondVoteButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.79, green: 0.81, blue: 0.83, alpha: 1)
    }
    
    private let firstVoteCheckLabel = UILabel().then {
        $0.isHidden = true
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .white
        $0.text = "✓"
    }
    
    private let secondVoteCheckLabel = UILabel().then {
        $0.isHidden = true
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .white
        $0.text = "✓"
    }
    
    private let firstVotingCount = UILabel().then {
        $0.isHidden = true
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    private let secondVotingCount = UILabel().then {
        $0.isHidden = true
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    private let versusCircleLabel = UIView().then {
        $0.backgroundColor = .white
        $0.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25.5
        $0.layer.cornerCurve = .continuous
    }
    
    private let versusLabel = UILabel().then {
        $0.text = "vs"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 12, weight: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        setLayout()
        
        voteButtonDidTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func voteButtonDidTap() {
        firstVoteButton.rx.tap
            .bind(onNext: {
                self.classifyVoteButton(voteType: .first)
            }).disposed(by: disposeBag)
        
        secondVoteButton.rx.tap
            .bind(onNext: {
                self.classifyVoteButton(voteType: .second)
            }).disposed(by: disposeBag)
    }
    
    private func classifyVoteButton(voteType: classifyVoteButtonType) {
        switch voteType {
        case .first:
            self.firstVoteCheckLabel.isHidden = false
        case .second:
            self.secondVoteCheckLabel.isHidden = false
        }
        
        self.firstVoteButton.frame = .zero
        self.secondVoteButton.frame = .zero
        
        self.firstVoteButton.backgroundColor = ChoiceAsset.Colors.firstVoteColor.color
        self.secondVoteButton.backgroundColor = ChoiceAsset.Colors.secondVoteColor.color
        
        self.firstVoteButton.isEnabled = false
        self.secondVoteButton.isEnabled = false
        
        UIView.animate(withDuration: 2.0) {
            self.firstVoteButton.frame = CGRect(x: 0, y: 0, width: 80, height: 0)
            self.secondVoteButton.frame = CGRect(x: 0, y: 0, width: -80, height: 0)
        }
    }
    
    private func addView() {
        self.addSubviews(firstVoteTitleLabel, secondVoteTitleLabel, firstVoteButton, secondVoteButton, versusCircleLabel)
        firstVoteButton.addSubviews(firstVoteCheckLabel, firstVotingCount)
        secondVoteButton.addSubviews(secondVoteCheckLabel, secondVotingCount)
        versusCircleLabel.addSubview(versusLabel)
    }
    
    private func setLayout() {
        firstVoteTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
        }
        
        secondVoteTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
        firstVoteButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(firstVoteTitleLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(secondVoteButton.snp.leading).offset(-10)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 30)
            $0.height.equalTo(100)
        }
        
        secondVoteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(secondVoteTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(firstVoteButton.snp.trailing).offset(10)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 30)
            $0.height.equalTo(100)
        }
        
        firstVoteCheckLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.equalToSuperview().inset(12)
        }
        
        secondVoteCheckLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        versusCircleLabel.snp.makeConstraints {
            $0.top.equalTo(firstVoteTitleLabel.snp.bottom).offset(35)
            $0.size.equalTo(50)
            $0.leading.equalTo(firstVoteButton.snp.trailing).offset(-20)
            $0.trailing.equalTo(secondVoteButton.snp.leading).offset(20)
        }
        
        versusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func changeVoteTitleData(with model: [PostModel]) {
        firstVoteTitleLabel.text = model[0].firstVotingOption
        secondVoteTitleLabel.text = model[0].secondVotingOption
    }
}