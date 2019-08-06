//
//  ordersHistoryViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 16/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class ordersHistoryTableViewController: UITableViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PREVIOUS")
        
    }
}
