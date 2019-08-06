//
//  confirmedPaymentViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 6/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Lottie
import CoreData
import Firebase
import FirebaseFirestore


class confirmedPaymentViewController: UIViewController, CLLocationManagerDelegate {

    
    // Data Variables
    var amount: String = ""
    var transaction: String = ""
    var type: String = ""
    var companyName: String = ""
    var companyID: String = ""
    
    var myCartUz: [Cart] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var skinnyPete = NSMutableAttributedString()
    
    // Date & Time variables
    let date = Date()
    let formatter = DateFormatter()
    let formatterTime = DateFormatter()
    let locationManager = CLLocationManager()

    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var receiptBg: UIView!
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var transactionID: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var animationContailer: UIView!
    @IBOutlet weak var animationBView: UIView!
    @IBOutlet weak var payButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Animation 
        tickTockTickTock()
        
        // Current date, time & location
        whatsTheDate()
        catchMeIfYouCanCunt()
        
        // Design
        pimpMyApp()
        skinnyAndFat()
        
        // Transfer data (receiving)
        transactionType.text = String(describing: transaction)
        typeLabel.text = String(describing: type)
        transactionName.text = String(describing: transaction)
        transactionID.text = String(describing: companyID)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //Location functions
    func catchMeIfYouCanCunt(){
        // Location stamp
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let latitude = Float(locValue.latitude)
        let floatLatitude = latitude as NSNumber
        let longitude = Float(locValue.longitude)
        let floatLongitude = longitude as NSNumber
        
        latitudeLabel!.text = floatLatitude.stringValue
        longitudeLabel!.text = floatLongitude.stringValue
        
    }
    
    
    // Text parameters
    func skinnyAndFat() {
        skinnyPete = NSMutableAttributedString(string: amount, attributes: [NSAttributedStringKey.font: UIFont (name: "Ubuntu-Bold", size: 40)!])
        skinnyPete.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Ubuntu-Light", size: 20.0)!, range: NSRange(location:0, length:3))
        
        moneyLabel.attributedText = skinnyPete
        moneyLabel.text = amount
    }
    
    
    // Dissmiss button function
    @IBAction func dismissButton(_ sender: Any) {
        if (moneyLabel.text != nil) && dateLabel.text != "" && timeLabel.text != "" && transactionType.text != "" {
            
            if constantTransactions.saveObject(amount: moneyLabel.text!, time: timeLabel.text!, payment: transactionType.text!, type:typeLabel.text!, latitude: latitudeLabel.text!, longitude: longitudeLabel.text!){
                for Transactions3 in constantTransactions.fetchObject()! {
                    
                    print("\(Transactions3.amount!)'its the money the platypus stole on the \(Transactions3.date!)")
                }
            
           self.performSegue(withIdentifier: "dismissSegue", sender: self)
        
        }
    }
        
}
    
    
    // Date & time function
    func whatsTheDate(){
        formatter.dateFormat = "dd.MM.yyyy"
        formatterTime.timeStyle = .medium
        
        let result = formatter.string(from: date)
        let resultTime = formatterTime.string(from: date)
        
        dateLabel.text = result
        timeLabel.text = resultTime
        
    }
    
    
    // Animation function
    func tickTockTickTock(){
        let tick = AnimationView(name: "Accepted")
        //animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tick.contentMode = .scaleAspectFit
        tick.frame = animationContailer.bounds
        
        animationContailer.addSubview(tick)
        tick.play()
        
    }
    
    // Design parameters
    func pimpMyApp() {
        receiptBg.whiteTopCorners()
        animationBView.layer.cornerRadius = animationBView.frame.size.width/2
        animationBView.clipsToBounds = true
        payButton.layer.cornerRadius = 10
        navigationController?.isNavigationBarHidden = true
    }
    
    
    
   
    // Delete firestore collection
    func yoNiggaImmaSmokeYa() {
        let db = Firestore.firestore()
    
    }
    

}




