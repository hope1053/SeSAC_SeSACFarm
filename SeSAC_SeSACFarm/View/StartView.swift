//
//  StartView.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/02.
//

import Foundation
import UIKit

import SnapKit

class StartView: UIView {
    
    var type: String = ""
    
    let emailTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "이메일 주소"
        return textField
    }()
    
    let emailValidateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .red
        return label
    }()
    
    let nickNameTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "닉네임"
        return textField
    }()
    
    let usernameValidateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .red
        return label
    }()
    
    let passwordTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "비밀번호"
        return textField
    }()
    
    let passwordValidateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .red
        return label
    }()
    
    let passwordCheckTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "비밀번호 확인"
        return textField
    }()
    
    let passwordConfirmValidateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .red
        return label
    }()
    
    let startButton: MainButton = {
        let button = MainButton()
        button.setTitle("시작하기", for: .normal)
        return button
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    
    required init(type: String) {
        super.init(frame: .zero)
        self.type = type
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        
        self.addSubview(stackView)
        
        [emailTextField, emailValidateLabel, nickNameTextField, usernameValidateLabel, passwordTextField, passwordValidateLabel, passwordCheckTextField, passwordConfirmValidateLabel, startButton].forEach { subView in
            self.stackView.addArrangedSubview(subView)
        }
        
        emailValidateLabel.isHidden = true
        usernameValidateLabel.isHidden = true
        passwordValidateLabel.isHidden = true
        passwordConfirmValidateLabel.isHidden = true
        
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        if type == "register" {
            stackView.snp.makeConstraints { make in
                make.height.equalToSuperview().multipliedBy(0.4)
            }
        } else {
            nickNameTextField.isHidden = true
            passwordCheckTextField.isHidden = true
            stackView.snp.makeConstraints { make in
                make.height.equalToSuperview().multipliedBy(0.18)
            }
        }
    }
}
