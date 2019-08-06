//
//  logInGIDViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 20/02/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import GoogleSignIn
import Lottie
import Firebase

class logInGIDViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design Parameters
        welcome()
        letsMakeABeautifulLife()
        
        // Google sign in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Check if they're already signed in
        GIDSignIn.sharedInstance().signInSilently()
        
        
        // Timer
        buttonTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        letMeIn()
    }
    
    
    //Login Button function
    @IBAction func loginButton(_ sender: Any) {
        letMeIn()
        
    }
    
    
    // Sign In function
    func letMeIn(){
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    // Segue back to VC
 //   @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
  //  }
    
    
    // Animation function
    func welcome(){
        let dollarMoneys = AnimationView(name: "Chicken-feet")
        
        dollarMoneys.contentMode = .scaleAspectFill
        dollarMoneys.frame = animationView.bounds
        
        animationView.addSubview(dollarMoneys)
        dollarMoneys.play()
       // dollarMoneys.loopMode = false
    }
    
    
    // Design parameters function
    func letsMakeABeautifulLife(){
        loginButton.layer.cornerRadius = 10
    }
    
    
    // Google sign in function
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Problem at signing in with google with error : \(error)")
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
     
        automaticSegue()
 
    }
    
    
    // Google sign out function
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    // Google general function
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    // Show button
    func buttonTimer() {
        self.loginButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loginButton.isHidden = false
            self.loginButton.flash()
        }
    }
    
    // Automatic segues
    func automaticSegue() {
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.autoSegue), userInfo: nil, repeats: true)
        
    }
    @objc func autoSegue( timer1: Timer){
        self.performSegue(withIdentifier: "autoSegue", sender: self)
        
    }
    
}

// Animation
extension  UIButton{
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 0
        flash.toValue = 1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = false
        flash.repeatCount = 0
        layer.add(flash, forKey: nil)
    }
}

