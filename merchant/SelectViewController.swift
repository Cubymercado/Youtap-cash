//
//  SelectViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 17/06/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit

class SelectViewController: UITabBarController {

    var amount:String = ""
    var type: String = ""
    var companyName: String = ""
    var companyID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TabBar font
        UITabBarItem.appearance()
            .setTitleTextAttributes(
                [NSAttributedStringKey.font: UIFont(name: "Ubuntu-Regular", size: 10)!],
                for: .normal)
        
    // Select shop viewController by default
    self.selectedIndex = 1
        
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
  
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
    }
    
    
   

}
