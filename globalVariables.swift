//
//  globalVariables.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 7/8/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import Foundation
import UIKit


class appCurrencies {
    // Main app currency
    var appMainCurrency = UserDefaults.standard.string(forKey: "mainCurrency")
    var appMainCurrencyFlag = UserDefaults.standard.string(forKey: "mainCurrencyImage")
    
    // Secondary app currency
    var appTwoCurrencyName = UserDefaults.standard.string(forKey: "twoCurrencyName")
    var appTwoCurrency = UserDefaults.standard.string(forKey: "twoCurrency")
    var appTwoCurrencyFlag = UserDefaults.standard.string(forKey: "twoCurrencyImage")
    var appTwoCurrencyValue = UserDefaults.standard.string(forKey: "twoCurrencyValue")
    
    // Fees
    var touristFee = UserDefaults.standard.string(forKey: "touristFee")
    
    // Logo
    var merchantLogo = UserDefaults.standard.object(forKey: "logo")
}
