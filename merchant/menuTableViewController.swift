//
//  menuTableViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 21/08/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//


import UIKit
import GoogleSignIn
import Kingfisher

class menuTableViewController: UITableViewController {
   
    @IBOutlet weak var settingsButton: UIBarButtonItem!

    let cellSpacingHeight: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()
     
       // Navbar
        newStyle()
        
    }

    
    // Settings button
    @IBAction func settingButton(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
        
    }

    // Table View functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    

    
      override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return cellSpacingHeight
     }
    

    // Section header and BG colours
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        //header.textLabel?.textColor =  UIColor(red:0.11, green:0.68, blue:0.83, alpha:1.0)
       //header.textLabel?.textColor =  UIColor (red:0.97, green:0.33, blue:0.20, alpha:1.0)
        header.textLabel?.textColor = UIColor.lightGray
        header.textLabel?.font = UIFont(name: "Ubuntu", size: 15)
        
        
    }
    
    // Navbar style
    func newStyle() {
        
        
        let profileNameGoogle = GIDSignIn.sharedInstance().currentUser.profile.givenName
        self.title = "Hi \(profileNameGoogle!)"
        
        let profilePhoto = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 32)
        let circleImage = RoundCornerImageProcessor(cornerRadius: 20)

        // Add profile button
        let button = UIButton(type: .custom)
        button.kf.setImage(with: profilePhoto, for: .normal, placeholder: nil, options: [.processor(circleImage)], progressBlock: nil, completionHandler: nil)
        button.addTarget(self, action: #selector(fbButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
   // Navigation button function
    @objc func fbButtonPressed() {
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }


}

