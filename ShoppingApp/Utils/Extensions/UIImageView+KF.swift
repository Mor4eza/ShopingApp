//
//  UIImageView+KF.swift
//  ShoppingApp
//
//  Created by Morteza on 3/1/22.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: bounds.size)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
