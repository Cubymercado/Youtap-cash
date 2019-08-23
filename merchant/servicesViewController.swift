//
//  servicesViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 1/07/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class servicesViewController: UIViewController, IndicatorInfoProvider  {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewBg: UIView!
    
    // Variables
    let services = ["Cash in", "Cash out", "Fx", "Airtime", "Data", "Ecommerce", "Water", "Electricity", "Loans", "Insurance"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       lifeIsBeautiful()
        
    }
    
    
    // Title indicator function
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "SERVICES")
    }
   
    // Design parameters
    func lifeIsBeautiful(){
        viewBg.cards()
        collectionView.cards()
        
    }
    
    // Unwind segue
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
    }

    
}


extension servicesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: services[indexPath.item], for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (indexPath.item) {
            
        case 0:
            self.performSegue(withIdentifier: "cashInSegue", sender: self)
            
        case 1:
            self.performSegue(withIdentifier: "cashOutSegue", sender: self)
            
        case 2:
            self.performSegue(withIdentifier: "fxSegue", sender: self)
     
        default:
            break
            
        }
        
        
    }
    
    
}
