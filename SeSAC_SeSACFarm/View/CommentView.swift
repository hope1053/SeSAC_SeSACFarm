//
//  CommentView.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/04.
//

import UIKit
import SnapKit

class CommentView: UIView {
    
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .orange
        return textView
    }()

    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.backgroundColor = UIColor().mainColor
        return button
    }()
    
    func configureView() {
        self.addSubview(commentTextView)
        self.addSubview(addButton)
        commentTextView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(commentTextView)
            make.leading.equalTo(commentTextView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .brown
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
