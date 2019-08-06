//
//  embedPaymentViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 26/06/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Stripe

class embedPaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)
        
    }
    

}

extension embedPaymentViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        StripeClient.shared.completeCharge(with: token, amount: 100) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                
                let alertController = UIAlertController(title: "Congrats", message: "You've been scammed by Honcho!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.performSegue(withIdentifier: "receiptSegue", sender: self)
                    //self.navigationController?.popViewController(animated: true)
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
