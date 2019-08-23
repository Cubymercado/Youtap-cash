//
//  File.swift
//  merchant
//
//  Created by Eugenio Mercado on 31/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import XLPagerTabStrip


class sliderMenu: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor(red:0.97, green:0.33, blue:0.20, alpha:1.0)
        settings.style.buttonBarItemFont = UIFont(name: "Ubuntu-Regular", size: 14)!
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(red:0.00, green:0.14, blue:0.22, alpha:1.0)
            //oldCell?.label.textColor = UIColor(red:0.16, green:0.28, blue:0.34, alpha:1.0)
            newCell?.label.textColor = UIColor(red:0.97, green:0.33, blue:0.20, alpha:1.0)
        }
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "payments")
         let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calculator")
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "services")
        
        return [child_1, child_2, child_3]
    }
    
}


