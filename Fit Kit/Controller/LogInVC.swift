//
//  LogInVC.swift
//  Fit Kit
//
//  Created by John Reichel on 5/14/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit
import Firebase

class LogInVC: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        let vc = forgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    @IBAction func loginClicked(_ sender: Any) {
        
        guard let email = emailTextfield.text,
            let password = passwordTextfield.text else {
            simpleAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        if email.isEmpty || password.isEmpty {
            print("Missing Input Field")
        } else {
            activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
          
            if let error = error {
                debugPrint(error)
                Auth.auth().handleAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
            }
        }
    }
    @IBAction func guestClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
