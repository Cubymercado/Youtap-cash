//
//  catalogProductsViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 1/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Foundation
import Kingfisher
import XLPagerTabStrip


// Cell class
class catalogProductCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.productImage.threeCorners()
    }
}

class catalogProductsViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var tableView: UITableView!
    
    // References to my products data
    var products: [productsCatalogAll] = []
    var fileredProduct: [productsCatalogAll] = []
    var selectedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Hide Keyboard
        hideKeyboardOrangutan()
        
        // Data sources
        tableView.dataSource = self
        tableView.delegate = self
        //collectionView.dataSource = self
       // collectionView.delegate = self
        
        query = baseQuery()
        observeQuery()
        
        print(Firestore.firestore().collection("warungsStock").limit(to: 350))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeQuery()
        //self.collectionView.reloadData()
        navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            let models = snapshot.documents.map { (document) -> productsCatalogAll in
                if let model = productsCatalogAll(dictionary: document.data()) {
                    return model 
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(productsCatalogAll.self) with dictionary \(document.data())")
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
        return Firestore.firestore().collection("suySingCatalogue").limit(to: 300)
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
        return IndicatorInfo(title: "CATALOGUE")
    }
    
    // Navbar style
    func newStyle() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    }
 
}


// IPhone Table View Datasource and Delegate
extension catalogProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return products.count
        
    }
    
    // Firestore data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! catalogProductCell
            let product = products[indexPath.row]
            let url = URL(string: product.productImageSquare)
            
            cell.productName?.text = product.name
            cell.productSize?.text = product.size
            cell.productCategory?.text = product.category
            
            DispatchQueue.main.async{
                cell.productImage?.kf.setImage(with: url)
            }
        
        // Selection colour
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.89, alpha:1.0)
        cell.selectedBackgroundView = backgroundView
            
            return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let controller = newAddFromCatalogViewController.fromStoryboard()
            controller.product = products[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: false)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.groupTableViewBackground
        self.title = "Catalog Products"
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor =  UIColor(red:0.19, green:0.24, blue:0.32, alpha:1.0)
        header.textLabel?.font = UIFont(name: "Ubuntu-Regular", size: 15)
        
    }
    
}





/* IPad Collection View Datasource and Delegate
extension catalogProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let controller = addFromCatalogViewController.fromStoryboard()
            controller.product = products[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: false)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! catalogCollectionViewCell
            
            let product = products[indexPath.row]
            let url = URL(string: product.image)
            
            cell.productLabel?.text = product.product
            cell.descriptionLabel?.text = product.size
            
            DispatchQueue.main.async{
                cell.productImage?.kf.setImage(with: url)
            }
            
            return cell
        
    
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return products.count
        
    
}

} */
