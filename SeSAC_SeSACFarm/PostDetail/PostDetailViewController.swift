//
//  PostDetailViewController.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/03.
//

import UIKit
import SnapKit

enum buttonType: String {
    case post
    case comment
}

class PostDetailViewController: UIViewController {
    
    let detailTableView = UITableView(frame: .zero, style: .grouped)
    let commentView = CommentView()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var adjustmentHeight: CGFloat = keyboardFrame.height - view.safeAreaInsets.bottom
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            commentView.frame.origin.y -= adjustmentHeight
            print("willshow", commentView.frame)
        } else {
            commentView.frame.origin.y += adjustmentHeight
            print("willhide", commentView.frame)
        }
    }
    
    func loadCommenets() {
        viewModel.getComments {
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
        
        viewModel.commentText.bind { comment in
            self.commentView.commentTextView.text = comment
        }
    }
    
    func configureView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
        view.addSubview(detailTableView)
        view.addSubview(commentView)
        detailTableView.backgroundColor = .white
        
        detailTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        commentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        commentView.commentTextView.delegate = self
        commentView.addButton.addTarget(self, action: #selector(commentAddButtonTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        detailTableView.addGestureRecognizer(tap)
    }
    
    @objc func commentAddButtonTapped() {
        commentView.commentTextView.resignFirstResponder()
        commentView.commentTextView.text = ""
        switch viewModel.currentStatus {
        case .postComment:
            viewModel.postComment {
                self.loadCommenets()
            }
        case .editComment:
            viewModel.updateComment {
                self.loadCommenets()
            }
        }
    }
    
    @objc func tapGesture() {
        commentView.commentTextView.resignFirstResponder()
    }
    
    @objc func menuButtonTapped() {
        let writerID = currentPost?.user.id
        // 로그인 다시 한 번 진행 후 확인해야함
        let myID = UserDefaults.standard.value(forKey: "id") as? Int
        
        if writerID == myID {
            showActionSheet(type: .post)
        } else {
            showAlert()
        }
    }
    
    func showActionSheet(type: buttonType, index: Int? = 0) {
        let alert = UIAlertController(title: "메뉴", message: "", preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "수정", style: .default) { _ in
            switch type {
            case .post:
                let vc = PostEditorViewController()
                let id = self.currentPost?.id ?? 0
                let text = self.currentPost?.text ?? ""
                
                vc.type = .edit
                vc.viewModel.id = id
                vc.viewModel.bodyText.value = text
                
                vc.editCompletionHandler = { post in
                    self.viewModel.currentPost.value = post
                    self.detailTableView.reloadData()
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            case .comment:
                self.commentView.commentTextView.becomeFirstResponder()
                self.viewModel.readyUpdateComment(index: index!) { comment in
                    self.commentView.commentTextView.text = comment.comment
                }
            }
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.checkAlert(type: type)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "알림", message: "본인이 작성한 글/댓글만 수정 및 삭제할 수 있습니다!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkAlert(type: buttonType, index: Int? = 0) {
        let alert = UIAlertController(title: "알림", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            switch type {
            case .post:
                self.viewModel.deletePost {
                    self.navigationController?.popViewController(animated: true)
                }
            case .comment:
                self.viewModel.deleteComment {
                    self.loadCommenets()
                }
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
        cell.commentEditButtonClosure = {
            let writerID = row.user.id
            // 로그인 다시 한 번 진행 후 확인해야함
            let myID = UserDefaults.standard.value(forKey: "id") as? Int
            
            if writerID == myID {
                self.showActionSheet(type: .comment, index: indexPath.row)
            } else {
                self.showAlert()
            }
        }
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

extension PostDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.commentText.value = textView.text ?? ""
    }
}
