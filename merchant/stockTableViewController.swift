//
//  stockTableViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 30/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class stockProductsCell: UITableViewCell {
    
    // Variables
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productStock: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.productImage.threeCorners()
    }
    
}


class stockTableViewController: UITableViewController, IndicatorInfoProvider {

    // References to my products data
    var myProducts: [Products1] = []
    var product: Products1?
    var filteredData: [Products1] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Data sources
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
     
    }

    // Get products data function
    func fetchData() {
        do {
            myProducts = try context.fetch(Products1.fetchRequest())
            filteredData = myProducts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                //self.collectionView.reloadData()
            }
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myProducts.count
    }
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! stockProductsCell
        
        cell.productName?.text = myProducts[indexPath.row].name
        cell.productCategory?.text = myProducts[indexPath.row].category
        cell.productDescription?.text = myProducts[indexPath.row].size
        
        let price = myProducts[indexPath.row].inventory
        let xNSNumber = price as NSNumber
        cell.productStock?.text = xNSNumber.stringValue
        
        if let data = myProducts[indexPath.row].image as Data? {
            cell.productImage?.image = UIImage(data:data)
            
        } else {
            cell.productImage?.image = UIImage(named: "features")
        }
         
        return cell
        
    }

    
    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "STOCK")
    }
    
}
