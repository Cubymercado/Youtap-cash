//
//  mySalesViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 13/5/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit

class mySalesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newStyle()
    }
    
    
    // Navbar style
    func newStyle() {
        navigationController?.isNavigationBarHidden = true
    }
    

}
