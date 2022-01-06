//
//  RegisterViewController.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/02.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    let startView = StartView(type: "register")
    let viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = startView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "새싹농장 가입하기"
        
        connectView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func adjustInputView() {
        bind()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func bind() {
        let input = RegisterViewModel.Input(emailText: startView.emailTextField.rx.text, usernameText: startView.nickNameTextField.rx.text, passwordText: startView.passwordTextField.rx.text, passwordCheckText: startView.passwordCheckTextField.rx.text, tapEvent: startView.startButton.rx.tap)
        let output = viewModel.trasnform(input: input)
        
        output.validStatus
            .bind(to: startView.startButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.emailValidStatus
            .bind(to: startView.emailValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.usernameValidStatus
            .bind(to: startView.usernameValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.passwordValidStatus
            .bind(to: startView.passwordValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.passwordConfirmStatus
            .bind(to: startView.passwordConfirmValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.emailValidText
            .asDriver()
            .drive(startView.emailValidateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.usernameValidText
            .asDriver()
            .drive(startView.usernameValidateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.passwordValidText
            .asDriver()
            .drive(startView.passwordValidateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.passwordConfirmText
            .asDriver()
            .drive(startView.passwordConfirmValidateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.tapEventResult
            .subscribe { _ in
                self.viewModel.postRegister {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func connectView() {
        viewModel.email.bind { email in
            self.startView.emailTextField.text = email
        }
        
        viewModel.username.bind { username in
            self.startView.nickNameTextField.text = username
        }
        
        viewModel.password.bind { password in
            self.startView.passwordTextField.text = password
        }
        
        startView.emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        startView.nickNameTextField.addTarget(self, action: #selector(nickNameTextFieldDidChange), for: .editingChanged)
        startView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        
//        startView.startButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc func emailTextFieldDidChange(_ textField: UITextField) {
        viewModel.email.value = textField.text ?? ""
    }
    
    @objc func nickNameTextFieldDidChange(_ textField: UITextField) {
        viewModel.username.value = textField.text ?? ""
    }
    
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        viewModel.password.value = textField.text ?? ""
    }
    
    @objc func registerButtonTapped() {
        self.view.endEditing(true)
        viewModel.postRegister {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
