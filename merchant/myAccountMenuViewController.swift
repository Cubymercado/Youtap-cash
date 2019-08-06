//
//  myAccountMenuViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 30/08/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit

class myAccountMenuViewController: UIViewController {

    // Data Arrays
     let myAccount = ["transactions", "insights"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

// Collection Views Extensions

extension myAccountMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myAccount.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myAccount[indexPath.item], for: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch (indexPath.item) {
    
        case 0:
            self.performSegue(withIdentifier: "transactions", sender: self)
            
        case 1:
            self.performSegue(withIdentifier: "insights", sender: self)
            
     
            
    
            
        default:
            break
        }
        
        print ("Finally the baboon found some \(myAccount[indexPath.item])")
        
    }
    
    
}
