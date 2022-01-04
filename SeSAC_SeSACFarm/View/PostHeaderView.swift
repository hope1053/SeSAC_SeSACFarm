//
//  DetailPost.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/04.
//

import UIKit
import SnapKit

class PostHeaderView: UIView {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    func configureView() {
        [usernameLabel, dateLabel, textLabel, commentLabel].forEach { subView in
            self.addSubview(subView)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.leading.equalTo(usernameLabel)
        }

        textLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
        }

        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(20)
            make.leading.equalTo(dateLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
