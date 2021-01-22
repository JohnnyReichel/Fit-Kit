//
//  addEditProductsVC.swift
//  FitKitAdmin
//
//  Created by John Reichel on 5/26/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class addEditProductsVC: UIViewController {
    
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productImageView: roundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: roundedButton!
    
    
    var productToEdit: Product?
    var selectedCategory: category!
    
    var name = ""
    var price = 0.0
    var productDescription = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTouchesRequired = 1
        productImageView.isUserInteractionEnabled = true
        productImageView.addGestureRecognizer(tap)
        
        if let product = productToEdit {
            productNameTextfield.text = product.name
            productDescriptionTextView.text = product.productDescription
            productPriceTextField.text = String(product.price)
            addButton.setTitle("Save Changes", for: .normal)
            if let url = URL(string: product.imageURL) {
                productImageView.contentMode = .scaleAspectFill
                productImageView.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
        guard let image = productImageView.image,
            let name = productNameTextfield.text, !name.isEmpty,
            let description = productDescriptionTextView.text, !description.isEmpty,
            let priceString = productPriceTextField.text,
            let price = Double(priceString) else {
                simpleAlert(title: "Missing Fields", message: "Please fill out all required fields")
                return
        }
        
        self.name = name
        self.productDescription = description
        self.price = price
        
        activityIndicator.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload new image")
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, message: "Unable to download URL")
                    return
                }
                
                guard let url = url else { return }
                self.uploadDocument(url: url.absoluteString)
            }
            
        }
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var product = Product.init(name: name, id: "", category: selectedCategory.id, price: price, productDescription: productDescription, imageURL: url)
        
        if let productToEdit = productToEdit {
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        let data = Product.modelToDate(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload firestore document")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, message: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", message: message)
        self.activityIndicator.stopAnimating()
    }
    
}

extension addEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        productImageView.contentMode = .scaleAspectFill
        productImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
