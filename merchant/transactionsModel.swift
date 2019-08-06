//
//  transactionsModel.swift
//  merchant
//
//  Created by Eugenio Mercado on 27/06/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

class transactionsModel {
    
    var id: String?
    var amount: String?
    var paymentType: String?
    var place: String?
    
    init (id: String?, amount: String?, paymentType: String?, place: String?, type: String?) {
        
        self.id = id
        self.amount = amount
        self.paymentType = paymentType
        self.place = place

    }
    
}
