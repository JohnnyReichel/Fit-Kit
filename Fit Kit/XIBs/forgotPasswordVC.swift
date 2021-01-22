//
//  forgotPasswordVC.swift
//  Fit Kit
//
//  Created by John Reichel on 5/18/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit
import Firebase

class forgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func resetClicked(_ sender: Any) {
        
        guard let email = emailTextfield.text, emailTextfield.text?.isEmpty == false else {
                simpleAlert(title: "Error", message: "Please enter an email")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleAuthError(error: error, vc: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
