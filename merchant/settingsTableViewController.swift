//
//  settingsTableViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 13/6/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import GoogleSignIn
import Kingfisher
import Firebase


class settingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var advertisments: [advertImages] = []
    var cartDocumentID: String = ""
    var selectedIndex: Int!
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profilePhone: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var colorThemeSwitch: UISwitch!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var advertCollectionView: UICollectionView!
  
    
    
    // Variables
    var imagePicker:UIImagePickerController!
    var newLogo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design function
        boogieboobieboo()
        heresAllMyDataBigBrother()
        pickMepickMe()
       
    }

    
    // Profile information fuuction
    func heresAllMyDataBigBrother(){
        profileName?.text = GIDSignIn.sharedInstance()?.currentUser.profile.name
        profileEmail?.text = GIDSignIn.sharedInstance().currentUser.profile.email
        
        let profilePhoto = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 76)
        profilePicture.kf.setImage(with: profilePhoto)
        profilePicture.roundMyCircle()
    }
    
    
    func pickMepickMe (){
        let tap = UITapGestureRecognizer(target: self, action: Selector("playpusAttack"))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tap)
        
    }
    
    
    // Objc functions & segues
    @objc func playpusAttack() {
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    // Logout button action
    @IBAction func logOutButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        self.performSegue(withIdentifier: "unwindToViewController", sender: self)

    }

    
   // Design parameters
    func boogieboobieboo() {
        logOutButton.buttonCornersFour()
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
    }
    

 
}


