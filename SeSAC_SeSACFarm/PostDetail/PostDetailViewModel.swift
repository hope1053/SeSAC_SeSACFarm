//
//  PostDetailViewModel.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/03.
//

import Foundation

class PostDetailViewModel {
    
    var currentPost: Observable<PostElement> = Observable(PostElement(id: 0, text: "", user: Writer(id: 0, username: "", email: ""), createdAt: "", comments: []))
    
    func deletePost(completion: @escaping () -> Void) {
        let postID = currentPost.value.id
        APIService.deletePost(id: postID) { post, error in
            completion()
        }
        
    }
    
    func getComments(completion: @escaping (DetailComment) -> Void) {
        let postID = currentPost.value.id
        APIService.viewComments(postID: postID) { comment, error in
            guard let comment = comment else {
                return
            }
            print(comment)
            completion(comment)
        }
    }
    
}
