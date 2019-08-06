//
//  cashInViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 15/7/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit

class cashInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var whiteCard: UIView!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var cashInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeMePretty()
    }
    
    
    
// Design parameters
    func makeMePretty() {
        whiteCard.cards()
        amountField.addBottomBorder()
        cashInButton.layer.cornerRadius = 10
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
    }
    
   

}
