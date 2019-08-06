//
//  supplierInfoViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 22/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class supplierInfoViewController: UIViewController {

    // Variables
    var supplier: supplierSuppliers?
    var latitude: String = ""
    var longitude: String = ""
    var supplierNameTitle: String = ""
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var supplierName: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Data
        supplyMeWithInfo()
        configureEntryData(entry: supplier!)
        
        // Design parameters
        makeMeprettyBaby()
       
    }
    
    // Show data function
    func supplyMeWithInfo() {
        supplierName.text = supplier?.name
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
        supplierNameTitle = supplier!.name
        
    }
    
    // Data transfer function (receiving)
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> supplierInfoViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "supplierInfoViewController") as! supplierInfoViewController
        return controller
    }
    
    func configureEntryData(entry: supplierSuppliers) {
    
    // Map view location
        let doubleLatitude = NumberFormatter().number(from: entry.latitude)?.doubleValue
        let doubleLongitude = NumberFormatter().number(from: entry.longitude)?.doubleValue
    
    let initialLocation = CLLocation(latitude: doubleLatitude!, longitude: doubleLongitude! )
    
    centerMapOnLocation(location: initialLocation)
    
    // show artwork on map
   
    
    let artwork = Artwork(title: "\("possum")",
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
   
    // Design parameters function
    func makeMeprettyBaby () {
        self.title = supplier?.name
        
    }


}
