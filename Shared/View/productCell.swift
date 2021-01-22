//
//  productCell.swift
//  Fit Kit
//
//  Created by John Reichel on 5/20/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit
import Kingfisher

protocol productCellDelegate : class {
    func productFavorited(product: Product)
    func productAddToCart(product: Product)
}

class productCell: UITableViewCell {
    
    @IBOutlet weak var productImage: roundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate : productCellDelegate?
    private var product : Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configeCell(product: Product, delegate: productCellDelegate) {
        self.product = product
        self.delegate = delegate
        productTitle.text = product.name
        if let url = URL(string: product.imageURL) {
            let placeholder = UIImage(named: appImages.placeholder)
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        if userService.favorites.contains(product) {
            favoriteButton.setImage(UIImage(named: appImages.filledStar), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: appImages.emptyStar), for: .normal)
        }
    }
    
    
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
    
    
}
