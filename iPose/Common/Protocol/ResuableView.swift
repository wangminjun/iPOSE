//
//  ResuableView.swift
//  iPose
//
//  Created by 王振宇 on 16/8/11.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit

protocol ResuableView {}

extension ResuableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(self)
    }
}