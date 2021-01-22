//
//  product.swift
//  Fit Kit
//
//  Created by John Reichel on 5/20/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageURL: String
    var timeStamp: Timestamp
    var stock: Int
    
    init(
        name: String,
        id: String,
        category: String,
        price: Double,
        productDescription: String,
        imageURL: String,
        timeStamp: Timestamp = Timestamp(),
        stock: Int = 0
        ) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageURL = imageURL
        self.timeStamp = timeStamp
        self.stock = stock
    }
    
    init(data: [String:Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
    
    static func modelToDate(product: Product) -> [String:Any] {
        let data : [String:Any] = [
            "name" : product.name,
            "id" : product.id,
            "category" : product.category,
            "price" : product.price,
            "productDescription" : product.productDescription,
            "imageURL" : product.imageURL,
            "timeStamp" : product.timeStamp,
            "stock" : product.stock
        ]
        return data
    }
}

extension Product : Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
