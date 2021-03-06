//
//  StandardVC.swift
//  StripePayment
//
//  Created by Harendra Sharma on 16/06/18.
//  Copyright © 2018 Harendra Sharma. All rights reserved.
//

import UIKit
import Stripe

class StandardVC: UIViewController, STPAddCardViewControllerDelegate, STPShippingAddressViewControllerDelegate {
   
    
    var modelController = ModelController()
    
    var selectedAddress = String()
    var selectedShippingMethod = PKShippingMethod()

    @IBOutlet weak var msgBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Standard"
         msgBox.text = ""
       
      
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func PaymentTapped(_ sender: UIButton) {
                let paymentConfig = STPPaymentConfiguration.init()
        paymentConfig.publishableKey = "pk_test_qbjx68qwygLRCgKsjmiYKQ5d"
                paymentConfig.requiredBillingAddressFields = STPBillingAddressFields.full
        
                let theme = STPTheme.default()
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController(configuration: paymentConfig, theme: theme)
        addCardViewController.delegate = self

        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
       
//        let paymentConfig = STPPaymentConfiguration.init()
//        paymentConfig.requiredBillingAddressFields = STPBillingAddressFields.full
//
//        let theme = STPTheme.default()
//
//        let addCardVC = STPAddCardViewController.init(configuration: paymentConfig, theme: theme)
//        addCardVC.delegate = self
//
//        let navigationController = UINavigationController(rootViewController: addCardVC)
//                present(navigationController, animated: true)
//
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)

//        print("Printing Strip response:\(token.allResponseFields)\n\n")
//        print("Printing Strip Token:\(token.tokenId)")

        /*
        msgBox.text = "Transaction success! \n\nHere is the Token: \(token.tokenId)\nCard Type: \(token.card!.funding.rawValue)\n\nSend this token or detail to your backend server to complete this payment."
*/
        
    //addeed all below
        
        let cardParams = STPCardParams()
        
        print("Card Params: \(cardParams)")

                self.postStripeToken(token: token)
                self.msgBox.text = "Transaction success! \n\nHere is the Token: \(String(describing: token.tokenId))\nCard Type: \(String(describing: token.card!.funding))\n\nSend this token or detail to your backend server to complete this payment.)"
        
    }
    
    //added.
    func postStripeToken(token: STPToken) {
        let amount = "300"
        
        modelController.sendToBackend(token: token, amount: amount) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    
//    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
//        submitTokenToBackend(token, completion: { (error: Error?) in
//            if let error = error {
//                // Show error in add card view controller
//                completion(error)
//            }
//            else {
//                // Notify add card view controller that token creation was handled successfully
//                completion(nil)
//
//                // Dismiss add card view controller
//                self.dismiss(animated: true)
//            }
//        })
//    }
//
//    func submitTokenToBackend(_ token: STPToken, completion: @escaping(Error?) -> Void) {
//        let allFields = token.card?.address.line1
//        msgBox.text = "\(String(describing: allFields))"
//        completion(nil)
//    }
    
    @IBAction func shippingBarButtonTapped(_ sender: UIBarButtonItem) {
        
        handleShippingButtonTapped()
        
        
        
    }
    
    func handleShippingButtonTapped() {
        STPPaymentConfiguration.shared().requiredShippingAddressFields = [.postalAddress, .phoneNumber, .emailAddress, .name]
        // Setup shipping address view controller
        let shippingAddressViewController = STPShippingAddressViewController()
        shippingAddressViewController.delegate = self as STPShippingAddressViewControllerDelegate
        
        // Present shipping address view controller
        let navigationController = UINavigationController(rootViewController: shippingAddressViewController)
        present(navigationController, animated: true)
    }
    
    
    func shippingAddressViewControllerDidCancel(_ addressViewController: STPShippingAddressViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didEnter address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        print("didEnterAddress")
        print(address)
        let upsGroundShippingMethod = PKShippingMethod()
        upsGroundShippingMethod.amount = 0.00
        upsGroundShippingMethod.label = "UPS Ground"
        upsGroundShippingMethod.detail = "Arrives in 3-5 days"
        upsGroundShippingMethod.identifier = "ups_ground"
        
        let fedExShippingMethod = PKShippingMethod()
        fedExShippingMethod.amount = 5.99
        fedExShippingMethod.label = "FedEx"
        fedExShippingMethod.detail = "Arrives tomorrow"
        fedExShippingMethod.identifier = "fedex"
        
        if address.country == "US" {
            let availableShippingMethods = [upsGroundShippingMethod, fedExShippingMethod]
            let selectedShippingMethod = upsGroundShippingMethod
            
            completion(.valid, nil, availableShippingMethods, selectedShippingMethod)
        }
        else {
            completion(.invalid, nil, nil, nil)
        }
    }
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didFinishWith address: STPAddress, shippingMethod method: PKShippingMethod?) {
        print("didFinishWith")
        // Save selected address and shipping method
        
        selectedAddress = address.line1!
         selectedShippingMethod = method!
        
        
        debugPrint(address.line1! as Any)
        debugPrint(method as Any)
        
        // Dismiss shipping address view controller
        dismiss(animated: true)
    }
    
    
    
}
