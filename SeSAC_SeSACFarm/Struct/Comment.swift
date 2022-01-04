//
//  Comment.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/04.
//

import Foundation

struct DetailCommentElement: Codable {
    let id: Int
    let comment: String
    let user: commentWriter
    let post: writtenPost
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, comment, user, post
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Post
struct writtenPost: Codable {
    let id: Int
    let text: String
    let user: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, text, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - User
struct commentWriter: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias DetailComment = [DetailCommentElement]
