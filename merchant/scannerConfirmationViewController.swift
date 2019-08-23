//
//  scannerConfirmationViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 26/7/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Lottie

class scannerConfirmationViewController: UIViewController,  UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantIDLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    // Data veriables
    var merchantName: String = ""
    var merchantID: String = ""
    var amounts: String = ""
    var skinnyPete = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adelitaSeJueConOtro()
        
        // Data placement
        merchantNameLabel!.text = merchantName
        merchantIDLabel!.text = merchantID
        skinnyAndFat()

        // Hide keyboard
        hideKeyboardOrangutan()

        // Button deactivated
        buttonDeactivated()
    }
    
    
    // Text parameters
    func skinnyAndFat() {
        skinnyPete = NSMutableAttributedString(string: amounts, attributes: [NSAttributedStringKey.font: UIFont (name: "Ubuntu-Bold", size: 40)!])
        skinnyPete.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Ubuntu-Light", size: 20.0)!, range: NSRange(location:0, length:3))
        
        amountLabel.attributedText = skinnyPete
        amountLabel.text = amounts
    }
    
    
    // Comfirm button function
    @IBAction func confirmButton(_ sender: Any) {
        self.performSegue(withIdentifier: "paySegue", sender: self)
    }
    
    
    
    // Data Transfer (send)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is confirmedPaymentViewController {
            let vc = segue.destination as! confirmedPaymentViewController
            vc.amount = amountLabel.text!
            vc.transaction = "Cash Payment"
            vc.type = "Product Payment"
            vc.companyName = merchantName
            vc.companyID = merchantID
        }
    }
    
    
    // Dissmiss viewController
    @objc func youAreDismissed() {
        //self.dismiss(animated: false, completion: nil)
        self.performSegue(withIdentifier: "backSegue", sender: self)
    }
    
    // Deactivated Button function
    func buttonDeactivated(){
        [pinTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        confirmButton.isEnabled = false
        confirmButton.backgroundColor = UIColor.lightGray
        
    }
    
    // Activate Confirm Button function
    @objc func editingChanged(_ textField: UITextField) {
        if pinTextField.text?.characters.count == 4 {
            if pinTextField.text?.characters.first == " " {
                pinTextField.text = ""
                
                return
            }
        }
        guard
            let confirm = pinTextField.text, !confirm.isEmpty
            
            else {
                self.confirmButton.isEnabled = false
                return
        }
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = UIColor.electricGreen
    }
    
    
    // Design patameters
    func adelitaSeJueConOtro () {
        confirmButton.layer.cornerRadius = 10
        pinTextField.addBottomBorder()
        pinTextField?.becomeFirstResponder()
    }
    
    
}



