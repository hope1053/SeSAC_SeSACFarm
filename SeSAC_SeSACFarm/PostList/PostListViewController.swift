//
//  PostViewController.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/02.
//

import Foundation
import UIKit

import SnapKit

class PostListViewController: UIViewController {
    
    let postTableView = UITableView()
    
    let addPostButton: MainButton = {
        let button = MainButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.cornerRadius = UIScreen.main.bounds.width * 0.18 * 0.5
        button.addTarget(self, action: #selector(addPostButtonTapped), for: .touchUpInside)
        let buttonConfiguration = UIImage.SymbolConfiguration(pointSize: 30)
        button.setPreferredSymbolConfiguration(buttonConfiguration, forImageIn: .normal)
        return button
    }()
    
    let viewModel = PostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.value(forKey: "token") as! String)
        
        connectView()
        configureView()
        viewModel.getTotalPostNum()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData()
        loadPosts()
    }
    
    func connectView() {
        viewModel.postList.bind { post in
            self.postTableView.reloadData()
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        title = "새싹농장"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingButtonTapped))
        
        [postTableView, addPostButton].forEach { subView in
            self.view.addSubview(subView)
        }
        
        postTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.prefetchDataSource = self
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        
        addPostButton.addShadow(CGSize(width:1, height: 4))
        addPostButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.18)
            make.height.equalTo(addPostButton.snp.width)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
    
    func loadPosts() {
        self.viewModel.getPostList { status in
            switch status {
            case .invalidToken:
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
                windowScene.windows.first?.makeKeyAndVisible()
            case .none:
                return
            }
        }
    }
    
    @objc func addPostButtonTapped() {
        let vc = PostEditorViewController()
        vc.type = .add
        vc.postCompletionHandler = {
            self.view.makeToast("게시물이 작성됐습니다", duration: 1.0, position: .top)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingButtonTapped() {
        let vc = SettingViewController()
        vc.completion = {
            self.view.makeToast("비밀번호가 변경됐습니다", duration: 1.0, position: .top)
        }
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
}


extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.cellForRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = viewModel.didSelectRowAt(tableView, indexPath: indexPath)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension PostListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.numberOfRowsInSection == indexPath.row + 1 && viewModel.numberOfRowsInSection < viewModel.totalNum {
                viewModel.startNum += 100
                loadPosts()
            }
        }
    }
}
