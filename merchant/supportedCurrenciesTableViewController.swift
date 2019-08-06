//
//  supportedCurrenciesTableViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 6/8/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher

class supportedCurrencyCell: UITableViewCell {
    
    @IBOutlet weak var currencyName: UITextField!
    @IBOutlet weak var currencyCode: UITextField!
    @IBOutlet weak var currencyFlag: UIImageView!
    @IBOutlet weak var whiteCard: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.whiteCard.cards()
        
    }
    
}

class supportedCurrenciesTableViewController: UITableViewController {

    // References to my products data
    var currencies: [supportedCurrencies] = []
    var fileredProduct: [supportedCurrencies] = []
    var selectedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        query = baseQuery()
        observeQuery()
        newStyle()
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
            let models = snapshot.documents.map { (document) -> supportedCurrencies in
                if let model = supportedCurrencies(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(supportedCurrencies.self) with dictionary \(document.data())")
                }
            }
            self.currencies = models
            self.tableView.reloadData()
        }
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    
    // Firestore database
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("supportedCurrencies").limit(to: 300)
    }
    
    
    // Navbar style
    func newStyle() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! supportedCurrencyCell
        let currency = currencies[indexPath.row]
        let url = URL(string: currency.image)
        
        cell.currencyName?.text = currency.name
        cell.currencyCode?.text = currency.code
   
        DispatchQueue.main.async{
            cell.currencyFlag?.kf.setImage(with: url)
        }
        
        return cell
    }

}
