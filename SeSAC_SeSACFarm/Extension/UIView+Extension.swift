//
//  UIView+Extension.swift
//  SeSAC_SeSACFarm
//
//  Created by 최혜린 on 2022/01/06.
//

import UIKit

extension UIView {
    func addShadow(_ size: CGSize) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 1
    }
}
