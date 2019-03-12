//
//  ApplePayVC.swift
//  StripePayment
//
//  Created by Harendra Sharma on 16/06/18.
//  Copyright © 2018 Harendra Sharma. All rights reserved.
//

import UIKit
import Stripe

class ApplePayVC: UIViewController, STPPaymentContextDelegate, STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentIcon: UIImageView!
    
    let modelController = ModelController()
   // let paymentContext: STPPaymentContext
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.paymentButton.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.paymentButton.alpha = 1
                }
            }, completion: nil)
        }
    }

    var product = ""
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.title = "Apple Pay"
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
          //  self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        //self.activityIndicator.animating = paymentContext.loading
        self.paymentButton.isEnabled = paymentContext.selectedPaymentMethod != nil
        self.paymentLabel.text = paymentContext.selectedPaymentMethod?.label
        self.paymentIcon.image = paymentContext.selectedPaymentMethod?.image
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {

//        modelController.completeCharge(paymentResult,
//                                     amount: //self.paymentContext.paymentAmount,
//                                     shippingAddress: self.paymentContext.shippingAddress,
//                                     shippingMethod: self.paymentContext.selectedShippingMethod,
//                                     completion: completion)

    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "You bought a \(self.product)!"
        case .userCancellation:
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapBuy(_ sender: UIButton) {
       // self.paymentContext.requestPayment()
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
    }
    
}
