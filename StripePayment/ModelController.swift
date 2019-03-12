//
//  ModelController.swift
//  StripePayment
//
//  Created by Nelson Gonzalez on 3/8/19.
//  Copyright © 2019 Harendra Sharma. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class ModelController {
    
    
    func sendToBackend(token: STPToken, amount: String, completion: @escaping(Error?)->Void) {
        let baseUrl = URL(string:"https://www.flowerdeliverymiami.net/payment.php")!
        let params = ["stripeToken": token.tokenId,
                      "amount": amount,
                      "currency": "usd",
                      "description": "Purchasing Something",
                      "shipping": "Name: Nelson Telephone: 305565 Address Line 1: 12 samoset City: Rockland State: ME Zip Code: 04841 Notes: just stuff", "email": "email@test.com", "customer_email": "email@test.com"]
        
        guard let body = try? JSONEncoder().encode(params) else { return }
        var request = URLRequest(url: baseUrl)
        
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print(error)
                completion(error)
            }
            if let response = response {
                print("Response: \(response)")
                
                completion(nil)
            }
            print("Success!")
            completion(nil)
            }.resume()
    }
    
    func createToken(cardParams: STPCardParams, completion: @escaping(STPToken?, Error?) ->Void) {
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            print("Printing Strip response:\(String(describing: token?.allResponseFields))\n\n")
            print("Printing Strip Token:\(String(describing: token?.tokenId))")
            
            
            
            if error != nil {
                print(error!.localizedDescription)
                completion(nil, error)
            }
            
            if token != nil {
                completion(token, nil)

            }
        }
    }
    
    
   
}
