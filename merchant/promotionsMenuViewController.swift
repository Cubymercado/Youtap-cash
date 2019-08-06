//
//  promotionsMenuViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 30/08/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit

class promotionsMenuViewController: UIViewController {

    // Data Arrays
    let promotions = ["promotions"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

// Collection Views Extensions

extension promotionsMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return promotions.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: promotions[indexPath.item], for: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch (indexPath.item) {
            
        case 0:
            self.performSegue(withIdentifier: "promos", sender: self)
            
        default:
            break
        }
        
        print ("Finally \(promotions[indexPath.row])")
        
    }
    
    
}
