//
//  user.swift
//  Fit Kit
//
//  Created by John Reichel on 5/28/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import Foundation

struct user {
    var id: String
    var email: String
    var username: String
    var stripeID: String
    
    init(
        id:String = "",
        email: String = "",
        username: String = "",
        stripeID: String = ""
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.stripeID = stripeID
    }
    
    init(data: [String : Any]) {
        id = data["id"] as? String ?? ""
        email = data["email"] as? String ?? ""
        username = data["username"] as? String ?? ""
        stripeID = data["stripeID"] as? String ?? ""
    }
    
    static func modelToData(User: user) -> [String:Any] {
        let data : [String:Any] = [
            "id" : User.id,
            "email" : User.email,
            "username" : User.username, 
            "stripeID" : User.stripeID
        ]
        return data
    }
    
}
