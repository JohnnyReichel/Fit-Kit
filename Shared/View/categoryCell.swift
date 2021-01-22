//
//  categoryCell.swift
//  Fit Kit
//
//  Created by John Reichel on 5/19/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit
import Kingfisher

class categoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 5
    }
    
    func configureCell(category: category) {
        categoryLabel.text = category.name
        if let url = URL(string: category.imageURL) {
            let placeholder = UIImage(named: "placeholder")
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            categoryImage.kf.indicatorType = .activity
            categoryImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }

}
