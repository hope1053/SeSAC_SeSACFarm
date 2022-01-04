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
    
    var type: EditingType = .add
    
    let detailTextView = UITextView()
    let viewModel = PostEditorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        detailTextView.delegate = self
        
        configureView()
        connectView()
    }
    
    func configureView() {
        switch type {
        case .add:
            title = "새싹농장 글쓰기"
        case .edit:
            title = "새싹농장 글 수정하기"
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completedButtonTapped))
        
        view.addSubview(detailTextView)
        detailTextView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
                self.navigationController?.popViewController(animated: true)
            }
        case .edit:
            viewModel.editDetail { post in
                print(post)
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
