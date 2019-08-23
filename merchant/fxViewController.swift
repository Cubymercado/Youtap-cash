//
//  fxViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 14/8/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Kingfisher

class fxViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var oneCurrencyLabel: UITextField!
    @IBOutlet weak var twoCurrencyLabel: UITextField!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var oneCurrencyFlag: UIImageView!
    @IBOutlet weak var twoCurrencyFlag: UIImageView!
    @IBOutlet weak var oneCurrencyName: UITextField!
    @IBOutlet weak var twoCurrencyName: UITextField!
    @IBOutlet weak var whiteCard: UIView!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
     let global = appCurrencies()
    var globalTotal: String = ""
    var globalResult: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stressIsSoBadForYouThatItsSoHardToLookPretty()
        setTheCurrenciesMatey()
        oneCurrencyLabel.addTarget(self, action: #selector(currencyConvertor(_:)), for:.editingChanged)
        
    }
    
    
    // Fees button
    @IBAction func feesButton(_ sender: Any) {
        self.performSegue(withIdentifier: "feeSegue", sender: self)
    }
    
    
    // Convert currency function
  @objc func currencyConvertor(_ sender:Any) {
    if oneCurrencyLabel.text!.isEmpty {
    
    let inputValue = "0"
        let doubleValue = Float(inputValue)!
        let feeValue = global.touristFee ?? "0"
        let doubleFeeValue = Float(feeValue)!
        let exchangeRate = global.appTwoCurrencyValue ?? "1"
        let doubleExchange = Float(exchangeRate)!
        let result = doubleValue * doubleExchange
        let total = (doubleValue * doubleExchange) + (doubleFeeValue)
    
        globalResult = String(describing: result)
        globalTotal = String(describing: total)
        twoCurrencyLabel.text = String(describing: result)
        totalLabel.text = String(describing: total)
        
            } else {
        let inputValue = oneCurrencyLabel.text!
        let doubleValue = Float(inputValue)!
        let feeValue = global.touristFee ?? "0"
        let doubleFeeValue = Float(feeValue)!
        let exchangeRate = global.appTwoCurrencyValue ?? "1"
        let doubleExchange = Float(exchangeRate)!
        let result = doubleValue * doubleExchange
        let total = (doubleValue * doubleExchange) + (doubleFeeValue)
        
        globalResult = String(describing: result)
        globalTotal = String(describing: total)
        twoCurrencyLabel.text = String(describing: result)
        totalLabel.text = String(describing: total)
        }
    }

    
    // Set currencies
    func setTheCurrenciesMatey() {
        let flag = global.appMainCurrencyFlag
        let flag2 = global.appTwoCurrencyFlag
        
        let url = URL(string: flag ?? "https://www.countryflags.io/nz/flat/16.png")
        let url2 = URL(string: flag2 ?? "https://www.countryflags.io/nz/flat/16.png")
        let fees = global.touristFee ?? "0"
        let rate = global.appTwoCurrencyValue ?? "1"
        let one = global.appMainCurrency ?? "NZD"
        let two = global.appTwoCurrency ?? "NZD"
        
        oneCurrencyName.text = one
        twoCurrencyName.text = two
        feesLabel.text = "\(rate) \(two) per \(one) + \(fees) \(two) on fees"
        "1 \(one) "
        oneCurrencyFlag.kf.setImage(with: url)
        twoCurrencyFlag.kf.setImage(with: url2)
    }
    
   
    // Design parameters
    func stressIsSoBadForYouThatItsSoHardToLookPretty() {
        whiteCard.cards()
        oneCurrencyLabel.addBottomBorder()
        twoCurrencyLabel.addBottomBorder()
        oneCurrencyLabel.text = "1"
        twoCurrencyLabel.text = "0"
        exchangeButton.contentEdgeInsets.left = 17
        exchangeButton.buttonCornersFour()
        oneCurrencyLabel?.becomeFirstResponder()
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
    }
    
}
