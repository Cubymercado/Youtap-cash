//
//  addToTabViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 4/02/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import MapKit
import GoogleSignIn
import CoreData

class addToTabViewController: UIViewController {
    
    // Data Arrays
    var customers: Customers!
    var customer: Customers?
    var customersArray: [Customers] = []
    
    var productsTab: [ProductsTab] = []
    var productTab: [ProductsTab]?
    var productTabSingle: ProductsTab?
    
    var selectedIndex: Int!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var amount: String = ""
    var transaction: String = ""
   
    var productName: String = ""
    var productPrice: String = ""
    
    var transactionDate = NSDate()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var customerAddress: UILabel! 
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var receiptView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customerProfile: UIImageView!
    @IBOutlet weak var customerProfileView: UIView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchatEmail: UILabel!
    @IBOutlet weak var addToTab: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Show data
        configureEntryData(entry: customer!)
        googleMeUpBaby()
        getMeSomeData()
        
        // Design parameters
        hutzilopochtli()
        
    }
     
    
    // Info profile button
    @IBAction func infoButton(_ sender: Any) {
        profileView.isHidden = !profileView.isHidden
        receiptView.isHidden = !receiptView.isHidden
        customerProfileView.isHidden = !customerProfileView.isHidden
    }
    

    // Add to tab button
    @IBAction func addToTabButton(_ sender: Any) {
        
        saveMeHere()
        self.navigationController?.popViewController(animated: true)
        
        
       // if productsTab == nil{//new document
          /*  let name = productName
            let price = Int32(productPrice)
            let date = Date(timeIntervalSinceNow: 0)
            
            if let product = ProductsTab(price: Int32(productPrice), name: productName, date: date){
                customers?.addToRawProductsTab(product)
                do{
                    try product.managedObjectContext?.save()
                    self.navigationController?.popViewController(animated: true)
                    
                } catch{
                    print("Document could not be saved")
                }
            }*/
       // }
       /* else {//updating document
            productTabSingle?.update(price: Int32(productPrice), name: productName, date: Date(timeIntervalSinceNow: 0))
            do {
                let managedContext = productTabSingle?.managedObjectContext
                try managedContext?.save()
            } catch {
                print("The document context could not be saved.")
            }
            self.navigationController?.popViewController(animated: true)
            
        }*/
        
    }
    
    
    // Show customer details
    func configureEntryData(entry: Customers) {
        let name = entry.name
        let address = entry.address
        let phone = entry.phoneNumber
        let email = entry.email
        
        customerName!.text = name
        customerAddress!.text = address
        phoneNumber!.text = phone
        emailAddress!.text = email
        self.title = name
        
        let image = entry.profileicture as Data?
        profilePicture!.image =  UIImage(data: image!)
        customerProfile!.image = UIImage(data: image!)
        
    }
    
    
    // Get products tab data
    func getMeSomeData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<ProductsTab> = ProductsTab.fetchRequest()
        do{
            productsTab = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        }catch{
            print("Could not fetch categories")
        }
        print(productsTab.count)
        
    }

    
    // Get google marchant information
    func googleMeUpBaby(){
        merchantName?.text = GIDSignIn.sharedInstance().currentUser.profile.name
        merchatEmail?.text = GIDSignIn.sharedInstance().currentUser.profile.email
        
    }
    
    
    // Design parameters function
    func hutzilopochtli(){
    profilePicture.roundMyCircle()
    customerProfile.roundMyCircle()
    profileView.layer.cornerRadius = 15
    receiptView.layer.cornerRadius = 15
    profileView.isHidden = true
    map.layer.cornerRadius = 13
    totalAmount.text = amount
        addToTab.layer.cornerRadius = 10
    
    }
    
    // Save function
    func saveMeHere(){
        if let product = ProductsTab(price: Int32(productPrice), name: productName, date: transactionDate as Date){
    customers?.addToRawProductsTab(product)
            do{
                try product.managedObjectContext?.save()
        } catch{
            print("Document could not be saved")
            }
        }
    }
    
}


// Table view dataSource and delegates
extension addToTabViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productsTab.isEmpty {
            totalAmount.text = "IDR 0"
            
            return productsTab.count
            
        } else {
            
            // Totals calculator
            var sum = 0.0
            for item in productsTab {
            // for item in (customer?.productTabClass!)! {
                sum += Double(item.price)
            }
            let total = Int(sum)
            totalAmount.text = "IDR \(total)"
            
            return productsTab.count
            //return customer?.productTabClass?.count ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discountCell", for: indexPath) as! discountTableViewCell
        
        let price = productsTab[indexPath.row].price
        let xNSNumber = price as NSNumber
        
        cell.productName?.text = productsTab[indexPath.row].name
        cell.amountLabel?.text = "IDR \(xNSNumber.stringValue)"
        
        for item in productsTab {
            productName = item.name!
            productPrice = String(item.price)
           
        }
        
        return cell
        }

    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            // delete item at indexPath
            let item = self.productsTab[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.productsTab.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        delete.backgroundColor = UIColor(red: 246/255, green: 104/255, blue: 37/255, alpha: 1.0)
        
        return [delete]
    }
    
}

