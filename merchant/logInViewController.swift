//
//  logInViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 1/02/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class logInViewController: UIViewController, GIDSignInUIDelegate  {

    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Google Sign In
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
       //self.performSegue(withIdentifier: "login", sender: self)
    }
    


}
