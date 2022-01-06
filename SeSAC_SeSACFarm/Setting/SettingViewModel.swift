//
//  SettinViewModel.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/05.
//

import Foundation

enum changePWStatus: String {
    case error
    case success
    case differentInput
}

class SettingViewModel {
    
    var currentPassword: Observable<String> = Observable("")
    var newPassword: Observable<String> = Observable("")
    var confirmNewPassword: Observable<String> = Observable("")
    
    func changePassword(completion: @escaping (changePWStatus) -> Void) {
        if newPassword.value == confirmNewPassword.value {
            APIService.changePW(current: currentPassword.value, new: newPassword.value, confirmNew: confirmNewPassword.value) { user, error in
                guard error == nil else {
                    completion(.error)
                    return
                }
                completion(.success)
            }
        } else {
            completion(.differentInput)
        }
    }
}
