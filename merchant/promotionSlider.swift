//
//  File.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 30/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import XLPagerTabStrip


class promotionSlider: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        settings.style.selectedBarBackgroundColor = UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0)
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(red:0.00, green:0.14, blue:0.22, alpha:1.0)
            newCell?.label.textColor = UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0)
        }
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "promos")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "stock")
        
        return [child_1, child_2]
    }
    
    
    
}

