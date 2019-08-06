//
//  suppliersSupliers.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 16/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import Firebase

// A type that can be initialized from a Firestore document.
protocol DocumentSerializableSuppliers {
    init?(dictionary: [String: Any])
}

struct supplierSuppliers {
    
    var name: String
    var address: String
    var phone: String
    var whatsapp: String
    var email: String
    var website: String
    var monday: String
    var tuesday: String
    var wednesday: String
    var thursday: String
    var friday: String
    var saturday: String
    var sunday: String
    var description: String
    
    var longitude: String
    var latitude: String
    
    var image: String
    var logo: String
    
    
    var dictionary: [String: Any] {
        return [
            
            "name": name,
            "Address": address,
            "Phone": phone,
            "Whatsapp": whatsapp,
            "Email": email,
            "Website": website,
            "Monday": monday,
            "Tuesday": tuesday,
            "Wednesday": wednesday,
            "Thursday": thursday,
            "Friday": friday,
            "Saturday": saturday,
            "Sunday": sunday,
            "Description": description,
            "Longitude": longitude,
            "Latitude": latitude,
            "Image": image,
            "Logo": logo
            
            
        ]
        
        
    }
    
}

extension supplierSuppliers: DocumentSerializableSuppliers {
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
        let address  = dictionary["Address"] as? String,
        let phone = dictionary["Phone"] as? String,
        let whatsapp = dictionary["Whatsapp"] as? String,
        let email = dictionary["Email"] as? String,
        let website = dictionary["Website"] as? String,
        let monday = dictionary["Monday"] as? String,
        let tuesday = dictionary["Tuesday"] as? String,
        let wednesday = dictionary["Wednesday"] as? String,
        let thursday = dictionary["Thursday"] as? String,
        let friday = dictionary["Friday"] as? String,
        let saturday = dictionary["Saturday"] as? String,
        let sunday = dictionary["Sunday"] as? String,
        let description = dictionary["Description"] as? String,
        let image = dictionary["Image"] as? String,
        let logo = dictionary["Logo"] as? String,
        let longitude = dictionary["Longitude"] as? String,
        let latitude = dictionary["Latitude"] as? String
        
         else { return nil }
       
        
        self.init(name: name, address: address, phone: phone, whatsapp: whatsapp, email: email, website: website, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday, description: description, longitude: longitude, latitude: latitude, image: image, logo: logo)
    }
    
    
}
