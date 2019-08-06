//
//  myProductsViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 1/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProductsCell: UITableViewCell {
    
    // Variables
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productInventory: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.productImage.threeCorners()
    }
    
}


class myProductsViewController: UIViewController, IndicatorInfoProvider {

    // References to my products data
    var myProducts: [Products1] = []
    var product: Products1?
    var filteredData: [Products1] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndex: Int!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Data sources
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
        self.tableView.reloadData()
        //collectionView.dataSource = self
        //collectionView.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.collectionView.reloadData()
        self.tableView.reloadData()
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

    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "MY PRODUCTS")
        
    }
    
}

// IPhone Table View Datasource and Delegate
extension myProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myProducts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! ProductsCell
        
            cell.productName?.text = myProducts[indexPath.row].name
            cell.productCategory?.text = myProducts[indexPath.row].category
            cell.productSize?.text = myProducts[indexPath.row].size
        
            let price = myProducts[indexPath.row].price
            let xNSNumber = price as NSNumber
            cell.productPrice?.text = "IDR \(xNSNumber.stringValue)" 
        
            let inventory =  myProducts[indexPath.row].inventory
            let inventoryNumber = inventory as NSNumber
    
            cell.productInventory?.text = "\(inventoryNumber.stringValue) items"
        

            if let data = myProducts[indexPath.row].image as Data? {
                cell.productImage?.image = UIImage(data:data)
                
            } else {
                cell.productImage?.image = UIImage(named: "features")
            }
        
            return cell
        
        // Selection colour
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.89, alpha:1.0)
        cell.selectedBackgroundView = backgroundView
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            product = myProducts[indexPath.row]
            performSegue(withIdentifier: "editSegue", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        
            print("I'll see you in the next life when we both become cats")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "editSegue" {
                let editVC = segue.destination as! newEditProductViewController
                editVC.product = product
        }
    }
    
}


// Delete itemes function
extension myProductsViewController {
    
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



/* IPad Collection View Datasource and Delegate
extension myProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
 
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
 
        return 1
    }
 
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
            selectedIndex = indexPath.row
            self.performSegue(withIdentifier: "editProductSegue", sender: self)
            collectionView.deselectItem(at: indexPath, animated: false)
 
            print("I'll see you in the next life when we both become cats")
 
    }
 
 
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

 
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! catalogCollectionViewCell
 
            let product = products[indexPath.row]
            let url = URL(string: product.image)
 
            cell2.productLabel?.text = product.product
            cell2.descriptionLabel?.text = product.size
 
            DispatchQueue.main.async{
                cell2.productImage?.kf.setImage(with: url)
            }
 
 
            return cell2

 
 
    }
 
 
 
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

 
            return myProducts.count
 
        }

 
 
}*/


