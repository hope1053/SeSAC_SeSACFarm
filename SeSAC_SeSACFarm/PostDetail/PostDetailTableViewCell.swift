//
//  PostDetailTableViewCell.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/04.
//

import UIKit
import SnapKit

class PostDetailTableViewCell: UITableViewCell {
    
    static let identifier = "PostDetailTableViewCell"
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(commentEditButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func commentEditButtonTapped() {
        print("tapped")
    }
    
    func configureView() {
        [usernameLabel, commentLabel, editButton].forEach { subView in
            self.addSubview(subView)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(15)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(usernameLabel)
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(usernameLabel.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
