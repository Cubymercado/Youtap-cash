//
//  suppliersTableViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 16/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Foundation
import Kingfisher

class supplierProductCell: UITableViewCell {
    
    
    @IBOutlet weak var supplierImage: UIImageView!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var supplierDescription: UILabel!
    @IBOutlet weak var supplierLogo: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        whiteView.dropShadow()
        
    }
    
}

class suppliersTableViewController: UITableViewController {

    // References to suppliers
    var suppliers: [supplierSuppliers] = []
    var filteredSupplier: [supplierSuppliers] = []
    var selectedIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide keyboard
        hideKeyboardOrangutan()
        
        // Data sources
        tableView.dataSource = self
        tableView.delegate = self
        
        query = baseQuery()
        print(Firestore.firestore().collection("suppliers").limit(to: 50))
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeQuery()

        // Show navigation bar
        //navigationController?.isNavigationBarHidden = true
        
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
            let models = snapshot.documents.map { (document) -> supplierSuppliers in
                if let model = supplierSuppliers(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(supplierSuppliers.self) with dictionary \(document.data())")
                }
            }
            
            self.suppliers = models
            self.tableView.reloadData()
        }
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    
    // Firestore database
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("suppliers").limit(to: 50)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suppliers.count
    }

    // Firestore data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! supplierProductCell
        
        let supplier = suppliers[indexPath.row]
        let url = URL(string: supplier.image)
        let logoImage = URL(string: supplier.logo)
        
        cell.supplierName?.text = supplier.name
        cell.supplierDescription?.text = supplier.description
        
        DispatchQueue.main.async{
            cell.supplierImage?.kf.setImage(with: url)
            cell.supplierLogo?.kf.setImage(with: logoImage)
        }
         
        return cell
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = stackViewSupplierViewController.fromStoryboard()
        controller.supplier = suppliers[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: false)
        
    }
    

}
