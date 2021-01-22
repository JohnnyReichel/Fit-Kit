//
//  stripeCart.swift
//  Fit Kit
//
//  Created by John Reichel on 6/1/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import Foundation

let stripeCart = _stripeCart()

final class _stripeCart {
    var cartItems = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    var shippingFees = 0
    
    var subTotal: Int {
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    var processingFees : Int {
        if subTotal == 0 {
            return 0
        }
        
        let sub = Double(subTotal)
        let feesAndSub = Int(sub * stripeCreditCardCut) + flatFeeCents
        return feesAndSub
    }
    
    var total: Int {
        return subTotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
    }
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    func clearCart() {
        cartItems.removeAll()
    }
}
