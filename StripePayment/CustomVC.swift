//
//  CustomVC.swift
//  StripePayment
//
//  Created by Harendra Sharma on 16/06/18.
//  Copyright © 2018 Harendra Sharma. All rights reserved.
//

import UIKit
import Stripe

class CustomVC: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var Expiry: UITextField!
    @IBOutlet weak var cvc: UITextField!
    @IBOutlet weak var msgBox: UITextView!
    @IBOutlet weak var amountTextField: UITextField!
    
    var modelController = ModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Custom"
       
          msgBox.text = ""
        
        // Add payment card text field to view
    }

    @IBAction func PaymentTapped(_ sender: UIButton) {
         msgBox.text = ""
        let comps = Expiry.text?.components(separatedBy: "/")
        let f = UInt(comps!.first!)
        let l = UInt(comps!.last!)
        
        let cardParams = STPCardParams()
        cardParams.name = name.text!
        cardParams.number = number.text!
        cardParams.expMonth = f!
        cardParams.expYear =  l!
        cardParams.cvc = cvc.text!
        
        //**Add zipcode to this..
        
        modelController.createToken(cardParams: cardParams) { (token, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if token != nil {
                self.postStripeToken(token: token!)
                self.msgBox.text = "Transaction success! \n\nHere is the Token: \(String(describing: token!.tokenId))\nCard Type: \(String(describing: token!.card!.funding))\n\nSend this token or detail to your backend server to complete this payment.)"
                
            }
            
        }

//        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
//            print("Printing Strip response:\(String(describing: token?.allResponseFields))\n\n")
//            print("Printing Strip Token:\(String(describing: token?.tokenId))")
//
//
//
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//
//            if token != nil {
//                 self.postStripeToken(token: token!)
//                self.msgBox.text = "Transaction success! \n\nHere is the Token: \(String(describing: token!.tokenId))\nCard Type: \(String(describing: token!.card!.funding))\n\nSend this token or detail to your backend server to complete this payment.)"
//
//            }
//        }
    }
    
    func postStripeToken(token: STPToken) {
        let amount = "300"
        
        modelController.sendToBackend(token: token, amount: amount) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

}
