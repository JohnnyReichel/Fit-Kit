//
//  category.swift
//  Fit Kit
//
//  Created by John Reichel on 5/19/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct category {
    var name: String
    var id: String
    var imageURL: String
    var isActive: Bool = true
    var timeStamp: Timestamp
    
    init(
        name: String,
        id: String,
        imageURL: String,
        isActive: Bool = true,
        timeStamp: Timestamp) {
        self.name = name
        self.id = id
        self.imageURL = imageURL
        self.isActive = isActive
        self.timeStamp = timeStamp
    }
    
    init(data: [String:Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToDate(category: category) -> [String:Any] {
        let data : [String : Any] = [
            "name" : category.name,
            "id" : category.id,
            "imageURL" : category.imageURL,
            "isActive" : category.isActive,
            "timeStamp" : category.timeStamp
        ]
        return data
    }
}
