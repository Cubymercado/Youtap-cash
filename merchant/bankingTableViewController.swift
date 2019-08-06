//
//  bankingTableViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 2/07/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit

class bankingTableViewController: UITableViewController {

    @IBOutlet weak var cardOne: UIView!
    @IBOutlet weak var cardTwo: UIView!
    @IBOutlet weak var cardThree: UIView!
    @IBOutlet weak var cardFour: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Design function
        timeToGetPrettyMate()
    }
    
    
    // Design parameters
    func timeToGetPrettyMate() {
        cardOne.cards()
        cardTwo.cards()
        cardThree.cards()
        cardFour.cards()
        UITabBar.appearance().backgroundColor = UIColor(red:0.00, green:0.16, blue:0.20, alpha:1.0)
                
       
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

  
}
