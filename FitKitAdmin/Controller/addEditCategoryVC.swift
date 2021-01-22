//
//  addEditCategoryVC.swift
//  FitKitAdmin
//
//  Created by John Reichel on 5/25/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher


class addEditCategoryVC: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var categoryImage: roundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    
    var categoryToEdit: category?

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTouchesRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
        
        if let category = categoryToEdit {
            nameText.text = category.name
            addButton.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imageURL) {
                categoryImage.contentMode = .scaleAspectFill
                categoryImage.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
        guard let image = categoryImage.image,
            let categoryName = nameText.text, !categoryName.isEmpty else {
            simpleAlert(title: "Error", message: "Must add category image and name")
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
    
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload image")
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
        var Category = category.init(name: nameText.text!,
                                     id: "",
                                     imageURL: url,
                                     timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            Category.id = categoryToEdit.id
        } else {
            docRef = Firestore.firestore().collection("categories").document()
            Category.id = docRef.documentID 
        }
        
        let data = category.modelToDate(category: Category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to retrieve imageURL")
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

extension addEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImage.contentMode = .scaleAspectFill
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
