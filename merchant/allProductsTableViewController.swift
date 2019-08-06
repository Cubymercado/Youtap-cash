//
//  allProductsTableViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 16/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseFirestore
import Kingfisher


// Cell class
class supplierProductsCellOne: UITableViewCell {
    
    @IBOutlet weak var supplierImage: UIImageView!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var supplierPrice: UILabel!
    @IBOutlet weak var supplierDescription: UILabel!
    
}

class allProductsTableViewController: UITableViewController, IndicatorInfoProvider {

    // Variables
    var products: [suppliersProducts] = []
    var filteredSupplier: [suppliersProducts] = []
    var selectedIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide keyboard
        hideKeyboardOrangutan()
        
        // Data sources
        tableView.dataSource = self
        tableView.delegate = self
        
        query = baseQuery()
        print(Firestore.firestore().collection("supplierOneSingle").limit(to: 150))
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeQuery()
 
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
            let models = snapshot.documents.map { (document) -> suppliersProducts in
                if let model = suppliersProducts(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(suppliersProducts.self) with dictionary \(document.data())")
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
        return Firestore.firestore().collection("supplierOneSingle").limit(to: 150)
    }


    // Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    // Firestore data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! supplierProductsCellOne
        
        let product = products[indexPath.row]
        let url = URL(string: product.productImageSquare)
        
        let price = product.unitPrice
        let priceString = price as NSNumber
        let result = priceString.stringValue
        
        cell.supplierName?.text = product.name
        cell.supplierDescription?.text = product.description
        cell.supplierPrice?.text = "IDR \(result)"
        
        DispatchQueue.main.async{
            cell.supplierImage?.kf.setImage(with: url)
            
        }
        
        return cell 
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = orderProductViewController.fromStoryboard()
        controller.product = products[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: false)
    }

    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ALL PRODUCTS")
        
    }

}

