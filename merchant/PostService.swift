//
//  PostService.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 19/6/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    static func create(for image: UIImage) {
        let imageRef = Storage.storage().reference().child("advert_image.jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }
    }
}
