//
//  PostEditviewController.swift
//  SeSAC_SimpleSNS
//
//  Created by 최혜린 on 2022/01/03.
//

import Foundation
import UIKit

class PostEditViewController: UIViewController {
    
    let textView = PostEditorView()
    
    override func loadView() {
        self.view = textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
