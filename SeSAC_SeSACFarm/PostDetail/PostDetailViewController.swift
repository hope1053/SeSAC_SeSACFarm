//
//  PostDetailViewController.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/03.
//

import UIKit
import SnapKit

class PostDetailViewController: UIViewController {
    
    let detailTableView = UITableView()
    
    let viewModel = PostDetailViewModel()
    var currentPost: PostElement?
    var currentCommentList: DetailComment = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.register(PostDetailTableViewCell.self, forCellReuseIdentifier: PostDetailTableViewCell.identifier)
        
        view.backgroundColor = .white
        connectView()
        configureView()
        loadCommenets()
    }
    
    func loadCommenets() {
        viewModel.getComments {
            print(self.currentCommentList)
            self.detailTableView.reloadData()
        }
    }
    
    func connectView() {
        viewModel.currentPost.bind { post in
            self.currentPost = post
        }
        
        viewModel.currentComments.bind { commentList in
            self.currentCommentList = commentList
        }
    }
    
    func configureView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
        view.addSubview(detailTableView)
        
        detailTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func menuButtonTapped() {
        let writerID = currentPost?.user.id
        // 로그인 다시 한 번 진행 후 확인해야함
        let myID = UserDefaults.standard.value(forKey: "id") as? Int
        
        if writerID == myID {
            showActionSheet()
        } else {
            showAlert()
        }
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: "메뉴", message: "", preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "수정", style: .default) { _ in
            let vc = PostEditorViewController()
            let id = self.currentPost?.id ?? 0
            let text = self.currentPost?.text ?? ""
            
            vc.type = .edit
            vc.viewModel.id = id
            vc.viewModel.bodyText.value = text
            
            vc.editCompletionHandler = { post in
                self.viewModel.currentPost.value = post
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.checkAlert()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "알림", message: "본인이 작성한 글만 수정 및 삭제할 수 있습니다!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkAlert() {
        let alert = UIAlertController(title: "알림", message: "글을 삭제하시겠습니까?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.viewModel.deletePost {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentCommentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewCell.identifier, for: indexPath) as? PostDetailTableViewCell else {
            return UITableViewCell()
        }
        let row = currentCommentList[indexPath.row]
        
        cell.usernameLabel.text = row.user.username
        cell.commentLabel.text = row.comment
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PostHeaderView()
        
        headerView.usernameLabel.text = currentPost?.user.username
        let changedDate = Date().dateStringToDate(currentPost!.createdAt)
        headerView.dateLabel.text = changedDate
        headerView.textLabel.text = currentPost?.text
        headerView.commentLabel.text = "댓글 \(currentPost!.comments.count)개"
        return headerView
    }
}
