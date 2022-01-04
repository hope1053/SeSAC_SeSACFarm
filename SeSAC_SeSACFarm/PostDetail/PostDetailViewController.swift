//
//  PostDetailViewController.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/03.
//

import UIKit
import SnapKit

class PostDetailViewController: UIViewController {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    let viewModel = PostDetailViewModel()
    var currentPost: PostElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        connectView()
        configureView()
        
        self.viewModel.getComments { comment in
            print(comment)
        }
    }
    
    func connectView() {
        viewModel.currentPost.bind { post in
            self.currentPost = post
        }
    }
    
    func configureView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
        [usernameLabel, dateLabel, textLabel, commentLabel].forEach { subView in
            view.addSubview(subView)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.leading.equalToSuperview().offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.leading.equalTo(usernameLabel)
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(20)
            make.leading.equalTo(dateLabel)
        }
        
        usernameLabel.text = currentPost?.user.username
        let changedDate = Date().dateStringToDate(currentPost!.createdAt)
        dateLabel.text = changedDate
        textLabel.text = currentPost?.text
        commentLabel.text = "댓글 \(currentPost!.comments.count)개"
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
