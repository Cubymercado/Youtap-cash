//
//  usersModel.swift
//  merchant
//
//  Created by Eugenio Mercado on 22/06/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import Firebase

class usersModel {
    
    var name: String?
    var email: String?
    var uid: String?
    var ref: DatabaseReference!
    var key: String?
    var surname: String?
    
    init(snapshot: DataSnapshot){
        
        key = snapshot.key
        ref = snapshot.ref
        name = (snapshot.value! as! NSDictionary)["name"] as? String
        email = (snapshot.value! as! NSDictionary)["email"] as? String
        uid = (snapshot.value! as! NSDictionary)["uid"] as? String
        surname = (snapshot.value! as! NSDictionary)["Surname"] as? String
    }
    
    func getFullName() -> String {
        return ("\(name!) \(surname!)")
    }
    
    func getUID() -> String {
        return("\(uid!)")
    }
    
}


