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

    var currentCommentList: DetailComment = []
    
    let viewModel = PostDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectView()
        configureView()
        loadCommenets()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func loadCommenets() {
        viewModel.getComments {
            self.detailTableView.reloadData()
        }
    }
    
    func connectView() {
        viewModel.currentPost.bind { post in
            self.detailTableView.reloadData()
        }
        
        viewModel.currentComments.bind { commentList in
            self.currentCommentList = commentList
        }
        
        viewModel.commentTextField.bind { comment in
            self.commentView.commentTextView.text = comment
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
        view.addSubview(detailTableView)
        view.addSubview(commentView)
        
        detailTableView.backgroundColor = .white
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(PostDetailTableViewCell.self, forCellReuseIdentifier: PostDetailTableViewCell.identifier)
        
        detailTableView.snp.makeConstraints { make in
            let commentViewHeight = UIScreen.main.bounds.height * 0.08
            make.trailing.leading.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-commentViewHeight)
        }
        
        commentView.commentTextView.delegate = self
        commentView.addButton.addTarget(self, action: #selector(commentAddButtonTapped), for: .touchUpInside)
        commentView.layer.masksToBounds = false
        commentView.layer.shadowColor = UIColor.black.cgColor
        commentView.layer.shadowOffset = CGSize(width:0, height: -4)
        commentView.layer.shadowOpacity = 0.1
        commentView.layer.shadowRadius = 1
        
        commentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        detailTableView.addGestureRecognizer(tap)
    }
}

// MARK: Selector
extension PostDetailViewController {
    @objc func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let adjustmentHeight: CGFloat = keyboardFrame.height - view.safeAreaInsets.bottom
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            commentView.frame.origin.y -= adjustmentHeight
        } else {
            commentView.frame.origin.y += adjustmentHeight
        }
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
        let writerID = viewModel.userID
        let myID = UserDefaults.standard.value(forKey: "id") as? Int
        
        writerID == myID ? showActionSheet(type: .post) : showAlert()
    }
}

// MARK: Alert, ActionSheet
extension PostDetailViewController {
    func showActionSheet(type: buttonType, index: Int? = 0) {
        let alert = UIAlertController(title: "메뉴", message: "", preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "수정", style: .default) { _ in
            switch type {
            case .post:
                let vc = PostEditorViewController()
                let id = self.viewModel.postID
                let text = self.viewModel.postDetailText
                
                vc.type = .edit
                vc.viewModel.id = id
                vc.viewModel.bodyText.value = text
                vc.editCompletionHandler = { post in
                    self.viewModel.currentPost.value = post
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

// MARK: TableViewDelegate, Datasource
extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numOfComments
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewCell.identifier, for: indexPath) as? PostDetailTableViewCell else {
            return UITableViewCell()
        }
        let row = viewModel.cellForRowAt(at: indexPath)
        
        cell.usernameLabel.text = row.user.username
        cell.commentLabel.text = row.comment
        cell.commentEditButtonClosure = {
            let writerID = row.user.id
            let myID = UserDefaults.standard.value(forKey: "id") as? Int
            
            writerID == myID ? self.showActionSheet(type: .comment, index: indexPath.row) : self.showAlert()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PostHeaderView()
        headerView.usernameLabel.text = viewModel.userName
        headerView.dateLabel.text = viewModel.createdDate
        headerView.textLabel.text = viewModel.postDetailText
        headerView.commentLabel.text = "댓글 \(viewModel.numOfComments)개"
        return headerView
    }
}

// MARK: TextViewDelegate
extension PostDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.commentTextField.value = textView.text ?? ""
    }
}
