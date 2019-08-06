//
//  SecondViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 13/06/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class SecondViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var uiView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    // Status bar colour
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            //return .lightContent
            return .default
        }
    }
    
}


    


