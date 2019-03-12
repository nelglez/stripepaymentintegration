//
//  ShippingVC.swift
//  StripePayment
//
//  Created by Nelson Gonzalez on 3/8/19.
//  Copyright © 2019 Harendra Sharma. All rights reserved.
//

import UIKit
import Stripe

class ShippingVC: UIViewController {
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var addressLine1: UITextField!
    
    var address = STPAddress()
    let fedExShippingMethod = PKShippingMethod()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    func handleShippingButtonTapped() {
//        // Setup shipping address view controller
//        let shippingAddressViewController = STPShippingAddressViewController()
//        shippingAddressViewController.delegate = self
//
//        // Present shipping address view controller
//        let navigationController = UINavigationController(rootViewController: shippingAddressViewController)
//        present(navigationController, animated: true)
//    }
//
//    // MARK: STPShippingAddressViewControllerDelegate
//
//    func shippingAddressViewControllerDidCancel(_ addressViewController: STPShippingAddressViewController) {
//        // Dismiss shipping address view controller
//        dismiss(animated: true)
//    }
    
//    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didEnter address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
    
    
    
    func shippingAddressViewController(didEnter address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
            
        
        address.name = fullName.text
        address.line1 = addressLine1.text
        address.city = city.text
        address.country = country.text
        address.state = state.text
        address.postalCode = zipCode.text
        address.email = email.text
        address.phone = phoneNumber.text
        
        //**Need To allow User to Pick a shipping method.
        
        let upsGroundShippingMethod = PKShippingMethod()
        upsGroundShippingMethod.amount = 0.00
        upsGroundShippingMethod.label = "UPS Ground"
        upsGroundShippingMethod.detail = "Arrives in 3-5 days"
        upsGroundShippingMethod.identifier = "ups_ground"
        
      //  let fedExShippingMethod = PKShippingMethod()
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
    
//    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didFinishWith address: STPAddress, shippingMethod method: PKShippingMethod?) {
    
         func shippingAddressViewController(didFinishWith address: STPAddress, shippingMethod method: PKShippingMethod?) {
        // Save selected address and shipping method
       // selectedAddress = address
       // selectedShippingMethod = method
        
        // Dismiss shipping address view controller
        dismiss(animated: true)
    }
    
    
    @IBAction func AddShippingButtonPressed(_ sender: UIButton) {
        
        shippingAddressViewController(didEnter: address) { (shippingStatus, error, _, shippingMethod) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            }
            
            
                print("Shipping Status: \(shippingStatus.rawValue)")
            print("Shipping Details: \(shippingMethod?.detail ?? "Default method")")
            
            //Here clear all text fileds and segue to payment credit card screen.
           
            
        }
        
        shippingAddressViewController(didFinishWith: address, shippingMethod: fedExShippingMethod)
        //Here Send Info To server....
        print("Address: \(String(describing: address.line1))")
    }
    
}
