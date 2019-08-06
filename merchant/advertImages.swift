//
//  advertImages.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 18/6/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import Foundation
import Firebase

/*protocol DocumentSerializableAdvertImages {
    init?(dictionary: [String: Any])
}*/

struct advertImages {
    var promotionLabel: String
    var advertImage: String
    var id: String
    
    var dictionary: [String: Any] {
        return [
            
            "PromotionLabel" : promotionLabel,
            "AdvertImage": advertImage
            
        ]
    }
    
}

extension advertImages {
    init?(dictionary: [String: Any], id: String) {
        guard let advertImage = dictionary["AdvertImage"] as? String
            
            else {return nil}
        let promotionLabelSimple = dictionary["PromotionLabel"] as? String
        let defaultPromotionLabel: String = promotionLabelSimple ?? "x"
        
        self.init(promotionLabel: defaultPromotionLabel, advertImage: advertImage, id: id)
        
    }
    
    
}
