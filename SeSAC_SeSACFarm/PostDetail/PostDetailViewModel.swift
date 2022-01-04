//
//  PostDetailViewModel.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/03.
//

import UIKit

class PostDetailViewModel {
    
    var currentPost: Observable<PostElement> = Observable(PostElement(id: 0, text: "", user: Writer(id: 0, username: "", email: ""), createdAt: "", comments: []))
    var currentComments: Observable<DetailComment> = Observable([])
    var commentText: Observable<String> = Observable("")
    
    func deletePost(completion: @escaping () -> Void) {
        let postID = currentPost.value.id
        APIService.deletePost(id: postID) { post, error in
            completion()
        }
        
    }
    
    func getComments(completion: @escaping () -> Void) {
        let postID = currentPost.value.id
        APIService.viewComments(postID: postID) { comment, error in
            guard let comment = comment else {
                return
            }
            self.currentComments.value = comment
            completion()
        }
    }
    
    func postComment(completion: @escaping () -> Void) {
        APIService.addComment(comment: commentText.value, post: currentPost.value.id) { comment, error in
            print(comment)
            completion()
        }
    }
}

//extension PostDetailViewModel: TableViewCellRepresentable {
//    var numberOfRowsInSection: Int {
//        currentComments.value.count
//    }
//    
//    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
//            return UITableViewCell()
//        }
//        cell.backgroundColor = .white
//        return cell
//    }
//    
//    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UIViewController {
//        print(indexPath)
//        return UIViewController()
//    }
//    
//    
//}
