//
//  stripeRubyViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 25/06/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Stripe

class stripeRubyViewController: STPAddCardViewController {

    var amountToPay: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       otherFunction()
       skinnyAndFat()
    
       
    }
    
    
    func skinnyAndFat() {
        let tabbar = tabBarController as! SelectViewController
        let nextAmount = String(describing: tabbar.amount)
        let stripeAmount = String(nextAmount.dropFirst(4))
        // let stripeFloat = (stripeAmount as NSString).floatValue
        amountToPay = stripeAmount
        title = amountToPay
        print(amountToPay)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    


    
    func otherFunction() {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: false)
        title = amountToPay
    }

}


extension stripeRubyViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        StripeClient.shared.completeCharge(with: token, amount: Int(amountToPay)! / 100) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                
                let alertController = UIAlertController(title: "Congrats", message: "You've been scammed by Honcho!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    //self.performSegue(withIdentifier: "receiptSegue", sender: self)
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            // 2
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
}

