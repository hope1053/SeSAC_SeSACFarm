//
//  RegisterViewModel.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/02.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    struct Input {
        let emailText: ControlProperty<String?>
        let usernameText: ControlProperty<String?>
        let passwordText: ControlProperty<String?>
        let passwordCheckText: ControlProperty<String?>
        let tapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: RxSwift.Observable<Bool>
        
        let emailValidStatus: RxSwift.Observable<Bool>
        let usernameValidStatus: RxSwift.Observable<Bool>
        let passwordValidStatus: RxSwift.Observable<Bool>
        let passwordConfirmStatus: RxSwift.Observable<Bool>
        
        let emailValidText: BehaviorRelay<String>
        let usernameValidText: BehaviorRelay<String>
        let passwordValidText: BehaviorRelay<String>
        let passwordConfirmText: BehaviorRelay<String>
        
        let tapEventResult: ControlEvent<Void>
    }
    
    func trasnform(input: Input) -> Output {
        let emailValidation = input.emailText
            .orEmpty
            .map { $0.contains("@") && $0.contains(".") }
            .share(replay: 1, scope: .whileConnected)
        
        let usernameValidation = input.usernameText
            .orEmpty
            .map { $0.count <= 10 }
            .share(replay: 1, scope: .whileConnected)
        
        let passwordValidation = input.passwordText
            .orEmpty
            .map { $0.count >= 8 }
            .share(replay: 1, scope: .whileConnected)

        let passwordConfirmValidation = RxSwift.Observable.combineLatest(input.passwordText, input.passwordCheckText) { $0 == $1 }
        
        let totalValidation = RxSwift.Observable.combineLatest(emailValidation, usernameValidation, passwordValidation, passwordConfirmValidation) { $0 && $1 && $2 && $3 }
        
        return Output(validStatus: totalValidation, emailValidStatus: emailValidation, usernameValidStatus: usernameValidation, passwordValidStatus: passwordValidation, passwordConfirmStatus: passwordConfirmValidation, emailValidText: emailValidText, usernameValidText: usernameValidText, passwordValidText: passwordValidText, passwordConfirmText: passwordConfirmText, tapEventResult: input.tapEvent)
    }
    
    var emailValidText = BehaviorRelay<String>(value: "이메일 형식을 지켜주세요")
    var usernameValidText = BehaviorRelay<String>(value: "닉네임은 10글자 이하로 작성해주세요")
    var passwordValidText = BehaviorRelay<String>(value: "비밀번호는 8글자 이상 작성해주세요")
    var passwordConfirmText = BehaviorRelay<String>(value: "비밀번호가 동일하지 않습니다")
    
    var username: Observable<String> = Observable("")
    var email: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    
    func postRegister(completion: @escaping () -> Void) {
        APIService.register(username: username.value, email: email.value, password: password.value) { user, error in
            guard let user = user else { return }
            
            UserDefaults.standard.set(user.user.username, forKey: "username")
            UserDefaults.standard.set(user.user.id, forKey: "id")
            UserDefaults.standard.set(user.user.email, forKey: "email")
            
            completion()
        }
    }
}
