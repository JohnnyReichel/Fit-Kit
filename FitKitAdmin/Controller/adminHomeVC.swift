//
//  ViewController.swift
//  FitKitAdmin
//
//  Created by John Reichel on 5/12/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit

class adminHomeVC: homeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addCategoryButton = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryButton
    }
    
    @objc func addCategory() {
        performSegue(withIdentifier: segues.toAddEditCategory, sender: self)
    }

}

