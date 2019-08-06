//
//  stripeRubyViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 25/06/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Stripe

class stripeDefaultViewController: UIViewController{
    
    var amountToPay: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    

    
}


