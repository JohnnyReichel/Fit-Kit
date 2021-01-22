//
//  checkoutVC.swift
//  Fit Kit
//
//  Created by John Reichel on 6/1/20.
//  Copyright © 2020 John Reichel. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions
import FirebaseFirestore
import SwiftyJSON

class checkoutVC: UIViewController, cartItemDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var shippingMethodButton: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var processingFeeLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var paymentContext : STPPaymentContext!
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setUpTableView()
        setUpPaymentInformation()
        setUpStripeConfig()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: identifiers.carItemCell, bundle: nil), forCellReuseIdentifier: identifiers.carItemCell)
    }
    
    func setUpPaymentInformation() {
        subtotalLabel.text = stripeCart.subTotal.penniesToFormattedCurrency()
        processingFeeLabel.text = stripeCart.processingFees.penniesToFormattedCurrency()
        shippingCostLabel.text = stripeCart.shippingFees.penniesToFormattedCurrency()
        totalLabel.text = stripeCart.total.penniesToFormattedCurrency()
    }
    
    func setUpStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]
        let customerContext = STPCustomerContext(keyProvider: stripeAPI)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        paymentContext.paymentAmount = stripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        paymentContext.requestPayment()
        activityIndicator.startAnimating()
    }
    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
    }
    @IBAction func shippingMethodClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
    
    func removeItem(product: Product) {
        stripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        setUpPaymentInformation()
        paymentContext.paymentAmount = stripeCart.total
    }
}

extension checkoutVC: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodButton.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodButton.setTitle("Select Method", for: .normal)
        }
        
        if let shippingMethod = paymentContext.selectedShippingMethod {
            shippingMethodButton.setTitle(shippingMethod.label, for: .normal)
            stripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100)
            setUpPaymentInformation()
        } else {
            shippingMethodButton.setTitle("Select Method", for: .normal)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let data : [String: Any] = [
            "total_amount" : stripeCart.total,
            "customer_id" : userService.User.stripeID,
            "payment_method_id" : paymentResult.paymentMethod?.stripeId ?? "",
            "idempotency" : idempotency,
        ]
                
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", message: "Unable to make charge.")
                completion(STPPaymentStatus.error, error)
                return
            }
            
            let date = Date()
            let formate = date.getFormattedDate(format: "MM-dd-yyyy")
            var itemInformation = [String : Any]()
            var encoded = [JSON()]
            
            for soldItem in stripeCart.cartItems {
                itemInformation = ["text":soldItem.name,"image":soldItem.imageURL,"price":soldItem.price]
                
                let jsonData = JSON(itemInformation)
                encoded.append(jsonData)
            }
            let decoded = encoded.description
            let name = paymentContext.shippingAddress?.name
            let address01 = paymentContext.shippingAddress?.line1
            let address02 = paymentContext.shippingAddress?.line2
            let city = paymentContext.shippingAddress?.city
            let state = paymentContext.shippingAddress?.state
            let zip = paymentContext.shippingAddress?.postalCode
            
            let emailData : [String : Any] = [
                "name" : name ?? "",
                "total" : stripeCart.total.penniesToFormattedCurrency(),
                "timestamp" : formate,
                "jsonText": decoded,
                "email" : userService.User.email,
                "address01" : address01 ?? "",
                "address02" : address02 ?? "",
                "city" : city ?? "",
                "state" : state ?? "",
                "zip" : zip ?? ""
            ]
            
            
            Functions.functions().httpsCallable("emailMessage").call(emailData) { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    self.simpleAlert(title: "Error", message: "Unable to make charge.")
                    completion(STPPaymentStatus.error, error)
                    return
                }
            }
        
            stripeCart.clearCart()
            self.tableView.reloadData()
            self.setUpPaymentInformation()
            completion(.success, nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title: String
        let message: String
        activityIndicator.stopAnimating()
    
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "Thank you for your purchase!"
        case .userCancellation:
            return
        default:
            title = "Error"
            message = error?.localizedDescription ?? ""
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 Days"
        upsGround.identifier = "ups_ground"
        
        let fedex = PKShippingMethod()
        fedex.amount = 5.99
        fedex.label = "Fedex"
        fedex.detail = "Arrives Tomorrow"
        fedex.identifier = "fedex"
        
        if address.country == "US" {
            completion(.valid, nil, [upsGround, fedex], fedex)
        } else {
            completion(.invalid, nil, nil, nil)
        }
    }
}

extension checkoutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifiers.carItemCell, for: indexPath) as? cartItemCell {
            let product = stripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


