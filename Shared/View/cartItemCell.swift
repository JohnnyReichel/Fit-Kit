//
//  cartItemCell.swift
//  Fit Kit
//
//  Created by John Reichel on 6/1/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit

protocol cartItemDelegate : class {
    func removeItem(product: Product)
}

class cartItemCell: UITableViewCell {
    
    @IBOutlet weak var productImage: roundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    private var item: Product!
    weak var delegate: cartItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(product: Product, delegate: cartItemDelegate) {
        self.delegate = delegate
        self.item = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitle.text = "\(product.name) | \(price) | "
        }
        if let url = URL(string: product.imageURL) {
            productImage.kf.setImage(with: url)
        }
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
        delegate?.removeItem(product: item)
    }
}
