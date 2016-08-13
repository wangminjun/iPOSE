//
//  PoseImageCollectionCell.swift
//  iPose
//
//  Created by 王振宇 on 16/8/11.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Kingfisher

class PoseImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

extension PoseImageCollectionCell {
    func fillData(url: String) {
        imageView.kf_setImageWithURL(NSURL(string: url)!)
    }
}
