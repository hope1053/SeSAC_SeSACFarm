//
//  APIService.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/02.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
    case invalidToken
}

class APIService {
    static func register(username: String, email: String, password: String, completion: @escaping (User?, APIError?) -> Void) {
        var request = URLRequest(url: Endpoint.register.url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "username=\(username)&email=\(email)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func login(identifier: String, password: String, completion: @escaping (User?, APIError?) -> Void) {
        var request = URLRequest(url: Endpoint.login.url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "identifier=\(identifier)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func changePW(current: String, new: String, confirmNew: String, completion: @escaping (UserClass?, APIError?) -> Void) {
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        
        var request = URLRequest(url: Endpoint.changePW.url)
        request.httpMethod = Method.POST.rawValue
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = Password(currentPassword: current, newPassword: new, confirmNewPassword: confirmNew)
        let updateJsonData = try? JSONEncoder().encode(updateData)
        
        URLSession.uploadRequest(endpoint: request, data: updateJsonData!, completion: completion)
    }
    
    static func viewPosts(startNum: Int, completion: @escaping (Post?, APIError?) -> Void) {
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        var urlComponent = URLComponents(string: "\(Endpoint.post.url)")
        urlComponent?.queryItems = [
            URLQueryItem(name: "_sort", value: "created_at:desc"),
            URLQueryItem(name: "_start", value: "\(startNum)"),
            URLQueryItem(name: "_limit", value: "100")
        ]
        var request = URLRequest(url: (urlComponent?.url!)!)
        request.httpMethod = Method.GET.rawValue
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func addPost(text: String, completion: @escaping (PostElement?, APIError?) -> Void) {
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        var request = URLRequest(url: Endpoint.post.url)
        request.httpMethod = Method.POST.rawValue
        let data = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")

        URLSession.uploadRequest(endpoint: request, data: data!, completion: completion)
    }
    
    static func editPost(id: Int, text: String, completion: @escaping (PostElement?, APIError?) -> Void) {
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        
        var request = URLRequest(url: Endpoint.editPost(id: id).url)
        request.httpMethod = Method.PUT.rawValue
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = postData(text: text)
        let updateJsonData = try? JSONEncoder().encode(updateData)
        
        URLSession.uploadRequest(endpoint: request, data: updateJsonData!, completion: completion)
    }
    
    static func deletePost(id: Int, completion: @escaping (PostElement?, APIError?) -> Void) {
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        
        var request = URLRequest(url: Endpoint.editPost(id: id).url)
        request.httpMethod = Method.DELETE.rawValue
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func viewComments(postID: Int, completion: @escaping (DetailComment?, APIError?) -> Void) {
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        
        var urlComponent = URLComponents(string: "\(Endpoint.comment.url)")
        urlComponent?.queryItems = [URLQueryItem(name: "post", value: "\(postID)")]
        var request = URLRequest(url: (urlComponent?.url!)!)
        request.httpMethod = Method.GET.rawValue
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func addComment(comment: String, post: Int, completion: @escaping (DetailCommentElement?, APIError?) -> Void) {
        var request = URLRequest(url: Endpoint.comment.url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "comment=\(comment)&post=\(post)".data(using: .utf8, allowLossyConversion: false)
        
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func updateComment(comment: String, postID: Int, commentID: Int, completion: @escaping (DetailCommentElement?, APIError?) -> Void) {
        print(comment, postID, commentID)
        var request = URLRequest(url: Endpoint.editComment(id: commentID).url)
        request.httpMethod = Method.PUT.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = commentData(comment: comment, post: postID)
        let updateJsonData = try? JSONEncoder().encode(updateData)
//        request.httpBody = "comment=\(comment)&post=\(postID)".data(using: .utf8, allowLossyConversion: false)
//        request.httpBody = updateJsonData
        
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.uploadRequest(endpoint: request, data: updateJsonData!, completion: completion)
    }
    
    static func deleteComment(id: Int, completion: @escaping (DetailCommentElement?, APIError?) -> Void) {
        var request = URLRequest(url: Endpoint.editComment(id: id).url)
        request.httpMethod = Method.DELETE.rawValue
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func getTotalPostNum(completion: @escaping (Int?, APIError?) -> Void) {
        let loginToken = UserDefaults.standard.value(forKey: "token") ?? ""
        var request = URLRequest(url: Endpoint.totalPost.url)
        request.httpMethod = Method.GET.rawValue
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(endpoint: request, completion: completion)
    }
}
