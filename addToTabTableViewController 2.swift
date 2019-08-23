//
//  addToTabTableViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 31/7/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData

class addToTabTableViewController: UITableViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tabName: UILabel!
    @IBOutlet weak var tabPhoneNumber: UILabel!
    @IBOutlet weak var tabEmailAddress: UILabel!
    @IBOutlet weak var cardOne: UIView!
    @IBOutlet weak var cardTwo: UIView!
    @IBOutlet weak var cardThree: UIView!
    @IBOutlet weak var addToTabButton: UIButton!
    
    // Data Arrays
    var customers: Customers!
    var customer: Customers?
    var customersArray: [Customers] = []
    
    var selectedIndex: Int!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var amount: String = ""
    var transaction: String = ""
    var productName: String = ""
    var productPrice: String = ""
    var transactionDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Show data
       
        configureEntryData(entry: customer!)
   
        // Design parameters
        hutzilopochtli()
        
    }
    
    // Add to tab button
    @IBAction func addToTabButton(_ sender: Any) {
        
        saveMeHere()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Show customer details
    func configureEntryData(entry: Customers) {
        let name = entry.name
        let address = entry.address
        let phone = entry.phoneNumber
        let email = entry.email
        
        tabName!.text = name
       // tabAddress!.text = address
        tabPhoneNumber!.text = phone
        tabEmailAddress!.text = email
        self.title = name
        
        let image = entry.profileicture as Data?
       //     profilePicture!.image =  UIImage(data: image!)
        
    }

    
    // Design parameters function
    func hutzilopochtli(){
        profilePicture.roundMyCircle()
        cardOne.cards()
        cardTwo.cards()
        cardThree.cards()
        addToTabButton.layer.cornerRadius = 10
        addToTabButton.titleLabel?.text = "Add \(amount) to tab"
        
        //navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
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


    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 4
    }

   
}
