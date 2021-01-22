//
//  productDetailVC.swift
//  Fit Kit
//
//  Created by John Reichel on 5/25/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit

class productDetailVC: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var addToCartButton: roundedButton!
    
    var product: Product!
    
    override func viewDidAppear(_ animated: Bool) {
        cartSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        productTitle.text = product.name
        productDescription.text = product.productDescription
        if let url = URL(string: product.imageURL) {
            productImage.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct))
        tap.numberOfTouchesRequired = 1
        bgView.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        if userService.isGuest {
            self.simpleAlert(title: "Hi friend!", message: "This is a feature registered user feature only")
            return
        }
        
        stripeCart.addItemToCart(item: product)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func keepShoppingClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func cartSetup() {
        if stripeCart.cartItems.contains(product) {
            addToCartButton.setTitle("Added!", for: .normal)
            addToCartButton.backgroundColor = UIColor.lightGray
            addToCartButton.isUserInteractionEnabled = false
        }
        UIView.animate(withDuration: 1) {
            self.addToCartButton.alpha = 1
        }
    }
}
