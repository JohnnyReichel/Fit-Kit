//
//  adminProductsVC.swift
//  FitKitAdmin
//
//  Created by John Reichel on 5/26/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit

class adminProductsVC: productsVC {
    
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let newProductButton = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
        navigationItem.setRightBarButtonItems([newProductButton, editCategoryButton], animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        products.removeAll()
        tableView.reloadData()
    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: segues.toEditCategory, sender: self)
    }
    
    @objc func newProduct() {
        performSegue(withIdentifier: segues.toAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: segues.toAddEditProduct, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.toAddEditProduct {
            if let destination = segue.destination as? addEditProductsVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == segues.toEditCategory {
            if let destination = segue.destination as? addEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }
    override func productFavorited(product: Product) {
        return
    }
    override func productAddToCart(product: Product) {
        return
    }
}
