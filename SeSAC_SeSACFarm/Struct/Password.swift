//
//  Password.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/06.
//

import Foundation

struct Password: Codable {
    let currentPassword: String
    let newPassword: String
    let confirmNewPassword: String
}
