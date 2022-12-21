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

class VoteView: UIView {
    
    private let firstVoteTitleLabel = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    private let secondVoteTitleLabel = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    private let firstVoteView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.99, green: 0.53, blue: 0.53, alpha: 1)
    }
    
    private let secondVoteView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.53, green: 0.71, blue: 0.99, alpha: 1)
    }
    
    private let firstVoteCheckLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .white
        $0.text = "✓"
    }
    
    private let secondVoteCheckLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .white
        $0.text = "✓"
    }
    
    private let firstVotingCount = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    private let secondVotingCount = UILabel().then {
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
        
        UIView.animate(withDuration: 2.0) {
            self.firstVoteView.frame = CGRect(x: 0, y: 0, width: 40, height: 0)
            self.secondVoteView.frame = CGRect(x: 0, y: 0, width: -40, height: 0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        self.addSubviews(firstVoteTitleLabel, secondVoteTitleLabel, firstVoteView, secondVoteView, versusCircleLabel)
        firstVoteView.addSubviews(firstVoteCheckLabel, firstVotingCount)
        secondVoteView.addSubviews(secondVoteCheckLabel, secondVotingCount)
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
        
        firstVoteView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(firstVoteTitleLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(secondVoteView.snp.leading).offset(-10)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width / 3 - 30)
            $0.height.equalTo(100)
        }
        
        secondVoteView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(secondVoteTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(firstVoteView.snp.trailing).offset(10)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width / 1.5 - 30)
            $0.height.equalTo(100)
        }
        
        versusCircleLabel.snp.makeConstraints {
            $0.top.equalTo(firstVoteTitleLabel.snp.bottom).offset(35)
            $0.size.equalTo(50)
            $0.leading.equalTo(firstVoteView.snp.trailing).offset(-20)
            $0.trailing.equalTo(secondVoteView.snp.leading).offset(20)
        }
        
        versusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func changeVoteTitleData(with model: [PostModel]) {
        firstVoteTitleLabel.setTitle(model[0].firstVotingOption, for: .normal)
        secondVoteTitleLabel.setTitle(model[0].secondVotingOption, for: .normal)
    }
}
