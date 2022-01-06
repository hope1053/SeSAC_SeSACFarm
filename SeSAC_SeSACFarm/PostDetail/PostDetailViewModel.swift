//
//  PostDetailViewModel.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/03.
//

import UIKit

enum buttonStatus: String {
    case postComment
    case editComment
}

class PostDetailViewModel {
    
    var currentPost: Observable<PostElement> = Observable(PostElement(id: 0, text: "", user: Writer(id: 0, username: "", email: ""), createdAt: "", comments: []))
    var currentComments: Observable<DetailComment> = Observable([])
    var commentTextField: Observable<String> = Observable("")
    var currentCommentIndex: Int = -1
    var currentStatus: buttonStatus = .postComment
    
    func deletePost(completion: @escaping () -> Void) {
        let postID = currentPost.value.id
        APIService.deletePost(id: postID) { post, error in
            completion()
        }
    }
    
    func getComments() {
        let postID = currentPost.value.id
        APIService.viewComments(postID: postID) { comment, error in
            guard let comment = comment else {
                return
            }
            self.currentComments.value = comment
        }
    }
    
    func postComment(completion: @escaping () -> Void) {
        APIService.addComment(comment: commentTextField.value, post: currentPost.value.id) { comment, error in
            self.getComments()
            completion()
        }
    }
    
    func readyUpdateComment(index: Int, completion: @escaping (DetailCommentElement) -> Void) {
        currentStatus = .editComment
        currentCommentIndex = index
        let currentComment = currentComments.value[currentCommentIndex]
        completion(currentComment)
    }
    
    func updateComment(completion: @escaping () -> Void) {
        let id = currentComments.value[currentCommentIndex].id
        APIService.updateComment(comment: commentTextField.value, postID: currentPost.value.id, commentID: id) { comment, error in
            self.getComments()
            self.currentCommentIndex = -1
            completion()
        }
    }
    
    func deleteComment(index: Int, completion: @escaping () -> Void) {
        let id = currentComments.value[index].id
        APIService.deleteComment(id: id) { comment, error in
            self.getComments()
            completion()
        }
    }
}

extension PostDetailViewModel {
    var userID: Int {
        currentPost.value.user.id
    }
    
    var userName: String {
        currentPost.value.user.username
    }
    
    var postID: Int {
        currentPost.value.id
    }
    
    var postDetailText: String {
        currentPost.value.text
    }
    
    var createdDate: String {
        Date().dateStringToDate(currentPost.value.createdAt)
    }
    
}

extension PostDetailViewModel {
    
    var numberOfRowsInSection: Int {
        currentComments.value.count
    }
    
    func cellForRowAt(at indexPath: IndexPath) -> DetailCommentElement {
        return currentComments.value[indexPath.row]
    }
}
