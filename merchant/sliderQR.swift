//
//  sliderQR.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 26/7/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import Foundation
import XLPagerTabStrip


class sliderQR: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
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
            newCell?.label.textColor = UIColor(red:0.97, green:0.33, blue:0.20, alpha:1.0)
        }
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qrCode")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scanner")
        
        return [child_1, child_2]
}

}
