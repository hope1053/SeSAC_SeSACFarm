//
//  PostAddViewModel.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/03.
//

import Foundation

class PostEditorViewModel {
    var bodyText: Observable<String> = Observable("")
    var id: Int = 0
    
    func postDetail(completion: @escaping () -> Void) {
        APIService.addPost(text: bodyText.value) { post, error in
            completion()
        }
    }
    
    func editDetail(completion: @escaping (PostElement?) -> Void) {
        APIService.editPost(id: id, text: bodyText.value) { post, error in
            guard let post = post else {
                return
            }
            completion(post)
        }
    }
    
}
