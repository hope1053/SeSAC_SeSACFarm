//
//  LoginViewModel.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/02.
//

import Foundation

enum currentStatus: String {
    case error
    case success
}

class LoginViewModel {
    var email: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    
    func postLogin(completion: @escaping (currentStatus) -> Void) {
        APIService.login(identifier: email.value, password: password.value) { user, error in

            guard error == nil else {
                completion(.error)
                return
            }
            
            guard let user = user else { return }
    
            UserDefaults.standard.set(user.jwt, forKey: "token")
            UserDefaults.standard.set(user.user.username, forKey: "username")
            UserDefaults.standard.set(user.user.id, forKey: "id")
            UserDefaults.standard.set(user.user.email, forKey: "email")
            
            completion(.success)
        }
    }
}
