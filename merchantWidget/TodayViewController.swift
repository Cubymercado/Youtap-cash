//
//  TodayViewController.swift
//  merchantWidget
//
//  Created by Eugenio Mercado on 18/06/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var balanceLabel: UILabel!

    // Variables
    var transferredAmount: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 150)
        }
    }
    
    // Data transfer from transactions   <-----
    func dataFromContainer(containerData : String){
        transferredAmount = containerData
        balanceLabel.text = "IDR \(transferredAmount)"
    }

    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        completionHandler(NCUpdateResult.newData)
    }
    

    
}
