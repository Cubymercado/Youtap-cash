//
//  walletViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 11/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import XLPagerTabStrip


class transactionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // Design parameters
    static let transactionType = (UIFont.titles, UIColor.darkBlue)
    static let paymentType = (UIFont.descriptions, UIColor.lightGray)
    static let amountLabel = (UIFont.titles, UIColor.darkBlue)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}


class walletViewController: UIViewController, UITextFieldDelegate, IndicatorInfoProvider {

    // Data arrays
    var transaction: [Transactions3] = []
    var filteredData: [Transactions3] = []
    var transactions = [Transactions3]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndex: Int!
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide keyboard
        hideKeyboardOrangutan()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        
        // Show navigation bar
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // Get data function and order by date
    func fetchData() {
        let request = Transactions3.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            transactions = try context.fetch(request) as! [Transactions3]
            filteredData = transactions
            self.tableView.reloadData()
            
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }
    
    
    // Unwind segue
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        
    }
    
    
    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "TRANSACTIONS")
        
    }
 
}


extension walletViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredData.count
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "detailsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("works selected")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var imageName: String!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! transactionsTableViewCell
        
        cell.amountLabel?.text = filteredData[indexPath.row].amount
        cell.transactionType?.text = filteredData[indexPath.row].type
        cell.dateLabel?.text = filteredData[indexPath.row].payment
        
        // Image selector depending on transaction
        switch filteredData[indexPath.row].type {
            
        case "Product Payment":
            imageName = "Payment-50.png"
            
        case "Teleco":
            imageName = "Data-50.png"
            
        case "Water Bill":
            imageName = "Water-50.png"
            
        case "Electricity Bill":
            imageName = "Electricity-50.png"
            
        case "Insurance":
            imageName = "Insurance-50.png"
            
        case "Cash Out":
            imageName = "Cash-out-50.png"
            
        case "Cash In":
            imageName = "Cash-in-50.png"
            
        case "Transfer":
            imageName = "Transfer-50.png"
            
        case "ATM Withdrawal":
            imageName = "Withdrawal-50.png"
            
            
        default: break
        }
        
        cell.transactionImage!.image = UIImage(named: imageName)
        
        // Selection colour
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.89, alpha:1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    // Delete row
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            // delete item at indexPath
            let item = self.filteredData[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }

        delete.backgroundColor = UIColor(red: 246/255, green: 104/255, blue: 37/255, alpha: 1.0)
     
        return [delete]

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let editVC = segue.destination as! transactionReceiptViewController
            editVC.transaction = filteredData[selectedIndex!]
            
            print(" no works selected")
        }
        
    }
    
    
    
    // Keyboard hiding functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -165, up: true)
        
    }
    
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -165, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    
}

