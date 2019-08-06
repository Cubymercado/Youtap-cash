//
//  suggestedProductsViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 1/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class suggestedProductCell: UITableViewCell {
    
    @IBOutlet weak var productInage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var descriptionProduct: UILabel!
    @IBOutlet weak var categoryProduct: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
}

class suggestedProductsViewController: UIViewController, IndicatorInfoProvider {

    // References to my products data
    var myProducts: [Suggested1] = []
    var filteredData: [Suggested1] = []
    var product: Suggested1?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndex: Int!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Data sources
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.collectionView.reloadData()
        // Show navigation bar
        navigationController?.isNavigationBarHidden = false
        
    }
    
    // Get data function
    func fetchData() {
        do {
            myProducts = try context.fetch(Suggested1.fetchRequest())
            filteredData = myProducts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                //self.collectionView.reloadData()
            }
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }

    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SUGGESTED")
        
    }
    
}


// IPhone Table View Datasource and Delegate
extension suggestedProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProducts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestedCell", for: indexPath) as! suggestedProductCell
        
        cell.productName?.text = myProducts[indexPath.row].productName
        cell.descriptionProduct?.text = myProducts[indexPath.row].productDescription
        cell.categoryProduct?.text = myProducts[indexPath.row].productCategory
        
        if let data = myProducts[indexPath.row].productImage as Data? {
        cell.productInage.image = UIImage(data:data)
        
                } else {
            
            }
        
        let price = myProducts[indexPath.row].price
        let xNSNumber = price as NSNumber
        cell.priceLabel?.text = "IDR \(xNSNumber.stringValue)"
        
        // Selection colour
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.89, alpha:1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        product = myProducts[indexPath.row]
        self.performSegue(withIdentifier: "editSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("I'll see you in the next life when we both become cats")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let editVC = segue.destination as! suggestedPRoductViewController
            editVC.suggestedProduct = product
        }
    }
    
    
}

// Delete itemes function
extension suggestedProductsViewController {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            // delete item at indexPath
            let item = self.myProducts[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.myProducts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        delete.backgroundColor = UIColor(red: 246/255, green: 104/255, blue: 37/255, alpha: 1.0)
        
        return [delete]
    }
    
}




