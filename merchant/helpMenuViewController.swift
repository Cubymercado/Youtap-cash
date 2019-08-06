//
//  helpMenuViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 30/08/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit

class helpMenuViewController: UIViewController {

    // Data Arrays
    let help = ["faq", "contact", "tc", "about"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

// Collection Views Extensions
extension helpMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return help.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: help[indexPath.item], for: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch (indexPath.item) {
            
        case 0:
            self.performSegue(withIdentifier: "faq", sender: self)
            
        case 1:
            self.performSegue(withIdentifier: "contactSegue", sender: self)
            
        case 2:
            self.performSegue(withIdentifier: "tnc", sender: self)
        
        default:
            break
            
        }
            
        print ("Finally \(help[indexPath.row])")
        
    }
    
    
}
