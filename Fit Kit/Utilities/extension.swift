//
//  extension.swift
//  Fit Kit
//
//  Created by John Reichel on 5/17/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit
import Foundation
import Firebase

extension UIViewController {
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension Int {
    func penniesToFormattedCurrency() -> String {
        let dollars = Double(self)/100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        return "$0.00"
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
