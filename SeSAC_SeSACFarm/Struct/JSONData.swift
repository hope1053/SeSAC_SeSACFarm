//
//  JSONData.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/04.
//

import Foundation

struct postData: Codable {
    let text: String
}

struct commentData: Codable {
    let comment: String
    let post: Int
}
