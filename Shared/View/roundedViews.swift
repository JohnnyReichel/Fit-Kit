//
//  roundedViews.swift
//  Fit Kit
//
//  Created by John Reichel on 5/14/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import Foundation
import UIKit

class roundedButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

class roundedShadowView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = appColors.blue.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize.zero
    }
}

class roundedImageView : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}
