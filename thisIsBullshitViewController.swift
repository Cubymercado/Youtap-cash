//
//  thisIsBullshitViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 13/8/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class thisIsBullshitViewController: UIViewController, UITextFieldDelegate {

    let global = appCurrencies()
    var secondaryCurrency: supportedCurrencies?
    var mainCurrency: String = ""
    var twoCurrency: String = ""
    var twoFlag: String = ""
    var twoCurrencyName: String = ""
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var amountInField: UILabel!
    @IBOutlet weak var addCurrencyButton: UIButton!
    @IBOutlet weak var whiteCard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whatIsWhatSaidTheWhitch()
        showMeDaMoney()
 
    }
    
    
    // Data transfer function (receiving)
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> thisIsBullshitViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "thisIsBullshitViewController") as! thisIsBullshitViewController
        return controller
    }
    
    
    // Show main currency data
    func showMeDaMoney(){
        let theCurrency = secondaryCurrency?.currency
        let currencyName = secondaryCurrency?.name
     //self.navigationItem.titleView = navTitleWithImageAndText(titleText: currencyName!)
        self.title = currencyName!
        twoCurrency = theCurrency!
        twoCurrencyName = currencyName!
        mainCurrency = global.appMainCurrency ?? "NZD"
        twoFlag = secondaryCurrency?.image ?? "https://www.countryflags.io/nz/flat/16.png"
        amountInField.text = "According to me 1 \(mainCurrency)0.75 to \(theCurrency!) equals:"
    }
    
    
    // Add currency button
    @IBAction func addCurrencyButton(_ sender: Any) {
        let newCurrency = amountField.text ?? "0"
        UserDefaults.standard.set("\(newCurrency)", forKey: "twoCurrencyValue")
        UserDefaults.standard.set("\(twoCurrency)", forKey: "twoCurrency")
        UserDefaults.standard.set("\(twoFlag)", forKey:  "twoCurrencyImage")
        UserDefaults.standard.set("\(twoCurrencyName)", forKey:  "twoCurrencyName")
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // Design parameters
    func whatIsWhatSaidTheWhitch(){
        self.amountField.becomeFirstResponder()
        addCurrencyButton.buttonCornersFour()
        amountField.addBottomBorder()
        whiteCard.cards()
    }
    
    
}
