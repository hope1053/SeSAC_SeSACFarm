//
//  PostListViewModel.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/02.
//

import UIKit

enum currentStatus: String {
    case invalidToken
}

class PostViewModel {
    var postList: Observable<Post> = Observable([])
    
    func getPostList(completion: @escaping (currentStatus?) -> Void) {
        APIService.viewPosts { post, error in
            if error == .invalidToken {
                completion(.invalidToken)
                return
            }
            
            guard let post = post else {
                return
            }
            self.postList.value = post
            
            completion(nil)
        }
    }
}

extension PostViewModel: TableViewCellRepresentable {
    
    var numberOfRowsInSection: Int {
        postList.value.count
    }
    
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let row = postList.value[indexPath.row]
        
        cell.userLabel.text = row.user.username
        cell.postDetailLabel.text = row.text
        let changedDate = Date().dateStringToDate(row.createdAt)
        cell.dateLabel.text = changedDate
        cell.commentLabel.text = "댓글\(row.comments.count)개"
        
        return cell
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UIViewController {
        let vc = PostDetailViewController()
        let post = postList.value[indexPath.row]
        vc.viewModel.currentPost.value = post
        return vc
    }
}
