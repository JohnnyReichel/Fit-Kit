//
//  userService.swift
//  Fit Kit
//
//  Created by John Reichel on 5/28/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let userService = _userService()

final class _userService {
    var User = user()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    var favoriteListener : ListenerRegistration? = nil
    
    var isGuest : Bool {
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        let userRef = db.collection("users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else { return }
            self.User = user.init(data: data)
        })
        
        let favoriteRef = userRef.collection("favorites")
        favoriteListener = favoriteRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    func favoriteSelected(product: Product) {
        let favoritesRef = Firestore.firestore().collection("users").document(User.id).collection("favorites")
        
        if favorites.contains(product) {
            favorites.removeAll{ $0 == product }
            favoritesRef.document(product.id).delete()
        } else {
            favorites.append(product)
            let data = Product.modelToDate(product: product)
            favoritesRef.document(product.id).setData(data)
        }
    }
    
    
    
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        favoriteListener?.remove()
        favoriteListener = nil
        User = user()
        favorites.removeAll()
    }
    
}
