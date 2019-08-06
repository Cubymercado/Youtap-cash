//
//  promosTableViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 4/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseFirestore
import Kingfisher

class promoProductCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDate: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.productImage.threeCorners()
    }
    
}

class promosTableViewController: UITableViewController, IndicatorInfoProvider {

    // References to my products data
    var products: [promoProducts] = []
    var fileredProduct: [promoProducts] = []
    var selectedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Keyboard
        hideKeyboardOrangutan()
        
        // Data sources
        tableView.dataSource = self
        tableView.delegate = self
        
        query = baseQuery()
        print(Firestore.firestore().collection("Promotions").limit(to: 50))
        
        // Screen size function
        swapsies()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeQuery()
        
        //self.collectionView.reloadData()
        
        // Show navigation bar
        navigationController?.isNavigationBarHidden = false
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving()
    }
    
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    fileprivate func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        
        // Display data from Firestore, part one
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> promoProducts in
                if let model = promoProducts(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(promoProducts.self) with dictionary \(document.data())")
                }
            }
            
            self.products = models
            self.tableView.reloadData()
        }
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    
    // Firestore database
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("Promotions").limit(to: 50)
    }
    
    
    // iPad and iPhone function
    func swapsies(){
        
        let model = UIDevice.current.model
        if model == "iPad" {
            tableView.isHidden = true
            // collectionView.isHidden = false
            
        } else {
            tableView.isHidden = false
            // collectionView.isHidden = true
            
        }
        
        
    }

    
    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PROMOTIONS")
        
    }
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! promoProductCell
        
        let product = products[indexPath.row]
        let url = URL(string: product.image)
        
        cell.productName?.text = product.product
        cell.productDate?.text = product.expiracy
        cell.productPrice?.text = product.specialPrice
        
        DispatchQueue.main.async{
            cell.productImage?.kf.setImage(with: url)
        }
        
        return cell
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    

}
