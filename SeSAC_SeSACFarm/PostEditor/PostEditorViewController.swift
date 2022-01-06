//
//  PostAddViewController.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/03.
//

import Foundation
import UIKit
import SnapKit

enum EditingType: String {
    case add
    case edit
}

class PostEditorViewController: UIViewController {
    
    var editCompletionHandler: ((PostElement) -> Void)?
    var postCompletionHandler: (() -> Void)?
    
    var type: EditingType = .add
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    let viewModel = PostEditorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        connectView()
    }
    
    func configureView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        switch type {
        case .add:
            title = "새싹농장 글쓰기"
        case .edit:
            title = "새싹농장 글 수정하기"
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completedButtonTapped))
        
        view.addSubview(detailTextView)
        detailTextView.delegate = self
        detailTextView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaInsets).offset(10)
            make.trailing.equalTo(view.safeAreaInsets).offset(-10)
            let height = UIScreen.main.bounds.height * 0.6
            make.height.equalTo(height)
        }
    }
    
    func connectView() {
        viewModel.bodyText.bind { detailText in
            self.detailTextView.text = detailText
        }
    }
    
    @objc func completedButtonTapped() {
        switch type {
        case .add:
            viewModel.postDetail {
                self.postCompletionHandler?()
                self.navigationController?.popViewController(animated: true)
            }
        case .edit:
            viewModel.editDetail { post in
                self.editCompletionHandler?(post!)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension PostEditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bodyText.value = textView.text ?? ""
    }
}
