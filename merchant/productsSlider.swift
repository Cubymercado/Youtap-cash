//
//  productsSlider.swift
//  merchant
//
//  Created by Eugenio Mercado on 1/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import XLPagerTabStrip


class productsSlider: ButtonBarPagerTabStripViewController {
    
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

        newStyle()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(red:0.00, green:0.14, blue:0.22, alpha:1.0)
            newCell?.label.textColor = UIColor(red:0.97, green:0.33, blue:0.20, alpha:1.0)
        }
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "catalog")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myProducts")
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "suggested")
        
        return [child_1, child_2, child_3]
    }
    
    // Go back button
    @IBAction func goBackButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // Scan button
    @IBAction func scanButton(_ sender: Any) {
        self.performSegue(withIdentifier: "scanProductSegue", sender: self)
        
    }
    
    // Add product button
    @IBAction func addProductButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addProduct", sender: self)
    }
    
    // Navbar style
    func newStyle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
      
    }
    
}
