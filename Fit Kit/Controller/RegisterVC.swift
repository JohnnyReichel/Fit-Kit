//
//  RegisterVC.swift
//  Fit Kit
//
//  Created by John Reichel on 5/14/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class RegisterVC: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmTextfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordCheck: UIImageView!
    @IBOutlet weak var confirmPasswordCheck: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        passwordTextfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        confirmTextfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textfieldDidChange(_ textfield: UITextField) {
        
        guard let passwordText = passwordTextfield.text else { return }
        
        if textfield == confirmTextfield {
            passwordCheck.isHidden = false
            confirmPasswordCheck.isHidden = false
        } else {
            if passwordText.isEmpty {
                passwordCheck.isHidden = true
                confirmPasswordCheck.isHidden = true
                confirmTextfield.text = ""
            }
        }
        
        if passwordTextfield.text == confirmTextfield.text {
            passwordCheck.image = UIImage(named: appImages.greenCheck)
            confirmPasswordCheck.image = UIImage(named: appImages.greenCheck)
        } else {
            passwordCheck.image = UIImage(named: appImages.redCheck)
            confirmPasswordCheck.image = UIImage(named: appImages.redCheck)
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        
            guard let email = emailTextfield.text,
                let password = passwordTextfield.text,
                let username = usernameTextfield.text else {
                
                simpleAlert(title: "Error", message: "Please fill in all fields")
                return
        }
        
        guard let confirmPassword = confirmTextfield.text , confirmPassword == password else {
            simpleAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
            if email.isEmpty || password.isEmpty || username.isEmpty {
                print("Missing Input Field")
            } else {
                activityIndicator.startAnimating()
                
                guard let authUser = Auth.auth().currentUser else { return }
                let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                authUser.link(with: credential) { (result, error) in
                    if let error = error {
                        debugPrint(error)
                        Auth.auth().handleAuthError(error: error, vc: self)
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    guard let fireUser = result?.user else { return }
                    let fitUser = user.init(id: fireUser.uid, email: email, username: username, stripeID: "")
                    self.createFirestoreUser(User: fitUser)
                }
            }
    }
    
    func createFirestoreUser(User: user) {
        let newUserRef = Firestore.firestore().collection("users").document(User.id)
        let data = user.modelToData(User: User)
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleAuthError(error: error, vc: self)
                debugPrint("Unable to upload new user document: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
}
