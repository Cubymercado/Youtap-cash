//
//  touristFeeViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 14/8/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit

class touristFeeViewController: UIViewController {
    
    @IBOutlet weak var touristFeeTitle: UILabel!
    @IBOutlet weak var touristFee: UITextField!
    @IBOutlet weak var whiteCard: UIView!
    @IBOutlet weak var addFee: UIButton!
    
    let global = appCurrencies()
    var currency: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whatIsWhatSaidTheWhitch()
        doThisDoThat()
    }
    
    
    // Main actions
    func doThisDoThat() {
        currency = global.appMainCurrency ?? "NZD"
        touristFeeTitle.text = "Enter an amount in \(currency) "
    }
    
    
    // Buttons action
    @IBAction func addFeeAction(_ sender: Any) {
        let newTouristFee = touristFee.text
        UserDefaults.standard.set("\(newTouristFee!)", forKey: "touristFee")
         self.dismiss(animated: false, completion: nil)
    }
    
    
    // Design parameters
    func whatIsWhatSaidTheWhitch(){
        self.touristFee.becomeFirstResponder()
        addFee.buttonCornersFour()
        touristFee.addBottomBorder()
        whiteCard.cards()
    }

}
