//
//  SettingViewController.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/05.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
    
    let currentPasswordTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "현재 비밀번호"
        textField.addTarget(self, action: #selector(currentPasswordChanged), for: .editingChanged)
        return textField
    }()
    
    let newPasswordTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "새로운 비밀번호"
        textField.addTarget(self, action: #selector(currentPasswordChanged), for: .editingChanged)
        return textField
    }()
    
    let newPasswordCheckTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "새로운 비밀번호 확인"
        textField.addTarget(self, action: #selector(currentPasswordChanged), for: .editingChanged)
        return textField
    }()
    
    let confirmButton: MainButton = {
        let button = MainButton()
        button.setTitle("변경하기", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func connectView() {
        viewModel.currentPassword.bind { password in
            self.currentPasswordTextField.text = password
        }
        
        viewModel.newPassword.bind { password in
            self.newPasswordTextField.text = password
        }
        
        viewModel.confirmNewPassword.bind { password in
            self.newPasswordCheckTextField.text = password
        }
    }
    
    func configureView() {
        title = "비밀번호 변경하기"
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        [currentPasswordTextField, newPasswordTextField, newPasswordCheckTextField, confirmButton].forEach { subView in
            view.addSubview(subView)
        }
        
        currentPasswordTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalToSuperview().multipliedBy(0.045)
        }
        
        newPasswordTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview()
            make.top.equalTo(currentPasswordTextField.snp.bottom).offset(10)
            make.height.equalTo(currentPasswordTextField)
        }
        
        newPasswordCheckTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview()
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(10)
            make.height.equalTo(newPasswordTextField)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview()
            make.top.equalTo(newPasswordCheckTextField.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
    }
    
    @objc func currentPasswordChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField == currentPasswordTextField {
            viewModel.currentPassword.value = text
        } else if textField == newPasswordTextField {
            viewModel.newPassword.value = text
        } else {
            viewModel.confirmNewPassword.value = text
        }
    }
    
    @objc func confirmButtonTapped() {
        viewModel.changePassword {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
