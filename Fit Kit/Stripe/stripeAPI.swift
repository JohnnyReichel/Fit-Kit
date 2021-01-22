//
//  stripeAPI.swift
//  Fit Kit
//
//  Created by John Reichel on 6/2/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let stripeAPI = _stripeAPI()

class _stripeAPI: NSObject, STPCustomerEphemeralKeyProvider {
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        let data = [
            "stripe_version": apiVersion,
            "customer_id": userService.User.stripeID
        ]
        
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(nil,error)
                return
            }
            guard let key = result?.data as? [String:Any] else {
                completion(nil,nil)
                return
            }
            completion(key,nil)
        }
    }
}
