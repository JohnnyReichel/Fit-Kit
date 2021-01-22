//
//  constants.swift
//  Fit Kit
//
//  Created by John Reichel on 5/14/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}

struct StoryboardID {
    static let LoginVC = "loginVC"
}

struct appImages {
    static let greenCheck = "green_check"
    static let redCheck = "red_check"
    static let filledStar = "filled_star"
    static let emptyStar = "empty_star"
    static let placeholder = "placeholder"
}

struct appColors {
    static let blue = #colorLiteral(red: 0.2274509804, green: 0.2666666667, blue: 0.3607843137, alpha: 1)
    static let offWhite = #colorLiteral(red: 0.9626371264, green: 0.959995091, blue: 0.9751287103, alpha: 1)
    static let red = #colorLiteral(red: 0.8739202619, green: 0.4776076674, blue: 0.385545969, alpha: 1)
}

struct identifiers {
    static let categoryCell = "categoryCell"
    static let productCell = "productCell"
    static let carItemCell = "cartItemCell"
}

struct segues {
    static let toProducts = "toProductsVC"
    static let toAddEditCategory = "toAddEditCategory"
    static let toEditCategory = "toEditCategory"
    static let toAddEditProduct = "toAddEditProduct"
    static let toFavorites = "toFavorites"
}
