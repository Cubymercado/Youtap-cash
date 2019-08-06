//
//  stackViewSupplierViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 23/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import Kingfisher


class stackViewSupplierViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var supplierAddress: UILabel!
    @IBOutlet weak var supplierPhoneNumber: UILabel!
    @IBOutlet weak var supplierWhatsApp: UILabel!
    @IBOutlet weak var supplierEmail: UILabel!
    @IBOutlet weak var supplierWebsite: UILabel!
    @IBOutlet weak var monday: UILabel!
    @IBOutlet weak var tuesday: UILabel!
    @IBOutlet weak var wednesday: UILabel!
    @IBOutlet weak var thursday: UILabel!
    @IBOutlet weak var friday: UILabel!
    @IBOutlet weak var saturday: UILabel!
    @IBOutlet weak var sunday: UILabel!
    
    // Variables
    var supplier: supplierSuppliers?
    var suppliers: [supplierSuppliers] = []
    var latitude: String = ""
    var longitude: String = ""
    var supplierNameTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide keyboard
        hideKeyboardOrangutan()
    
        // Map funciton
        configureEntryData(entry: supplier!)
        
        // Data
        whatYouHaveInStoreCuz()

        // Design parameters
        pleaseBloodyWorkCunt()
        
    }
    
    // Show data function
    func whatYouHaveInStoreCuz(){
        
        supplierAddress.text = supplier?.address
        supplierPhoneNumber.text = supplier?.phone
        supplierWhatsApp.text = supplier?.whatsapp
        supplierEmail.text = supplier?.email
        supplierWebsite.text = supplier?.website
        monday.text = supplier?.monday
        tuesday.text = supplier?.tuesday
        wednesday.text = supplier?.wednesday
        thursday.text = supplier?.thursday
        friday.text = supplier?.friday
        saturday.text = supplier?.saturday
        sunday.text = supplier?.sunday 
        
        latitude = (supplier?.latitude)!
        longitude = (supplier?.longitude)!
        
    }
    
    // Data transfer function (receiving)
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> stackViewSupplierViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "stackViewSupplierViewController") as! stackViewSupplierViewController
        return controller
    }
    
    func configureEntryData(entry: supplierSuppliers) {
        
        // Map view location
        let doubleLatitude = NumberFormatter().number(from: entry.latitude)?.doubleValue
        let doubleLongitude = NumberFormatter().number(from: entry.longitude)?.doubleValue
        
        let initialLocation = CLLocation(latitude: doubleLatitude!, longitude: doubleLongitude! )
        
        centerMapOnLocation(location: initialLocation)
 
        let artwork = Artwork(title: "\(supplierNameTitle)",
            locationName: "\(supplierNameTitle)",
            discipline: "\("possum")",
            coordinate: CLLocationCoordinate2D(latitude: doubleLatitude!, longitude: doubleLongitude!))
        map.addAnnotation(artwork)
        
    }
    
    // Map function
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    // Map pin function
    class Artwork: NSObject, MKAnnotation {
        let title: String?
        let locationName: String
        let discipline: String
        let coordinate: CLLocationCoordinate2D
        
        init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.locationName = locationName
            self.discipline = discipline
            self.coordinate = coordinate
            
            super.init()
        }
        
        var subtitle: String? {
            return locationName
        }
    }
    
    // Info button function
    @IBAction func infoButton(_ sender: Any) {
        infoView.isHidden = !infoView.isHidden
    }
    
    @IBAction func cartButton(_ sender: Any) {
        performSegue(withIdentifier: "cartSegue", sender: self)
  
        
    }
    
    // Data transfer to payments (send)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ordersCartViewController
        {
            let vc = segue.destination as? ordersCartViewController
            vc?.supplierName = supplier!.name
            vc?.supplierAddress = supplier!.address
            vc?.supplierImage = supplier!.logo
            
        }
        
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        
    }
    
    
    // Design parameters function
    func pleaseBloodyWorkCunt() {
        self.title = supplier!.name
        infoView.isHidden = true
        
    }
}
