//
//  SettinViewModel.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/05.
//

import Foundation

class SettingViewModel {
    
    var currentPassword: Observable<String> = Observable("")
    var newPassword: Observable<String> = Observable("")
    var confirmNewPassword: Observable<String> = Observable("")
    
    func changePassword(completion: @escaping () -> Void) {
        APIService.changePW(current: currentPassword.value, new: newPassword.value, confirmNew: confirmNewPassword.value) { user, error in
            completion()
        }
    }
}
