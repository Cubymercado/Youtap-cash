//
//  transactionsTableViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 24/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import XLPagerTabStrip




class transactionsTableViewController: UITableViewController, UISearchBarDelegate, IndicatorInfoProvider {

    @IBOutlet weak var greetingView: UIView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var transaction: [Transactions3] = []
    var selectedIndex: Int!
    
    var filteredData: [Transactions3] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardOrangutan()
       // createSearchBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }

    func fetchData() {
        
        do {
            transaction = try context.fetch(Transactions3.fetchRequest())
            filteredData = transaction
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }
    
    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "TRANSACTIONS")
        
    }
    
}


/*/ Table view data
extension transactionsTableViewController {
    
    // Row's data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var imageName: String!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! transactionsTableViewCell
        
        cell.amountLabel?.text = filteredData[indexPath.row].amount
        cell.transactionType?.text = filteredData[indexPath.row].type
        cell.paymentType?.text = filteredData[indexPath.row].payment

        
    // Image selector depending on transaction
       switch filteredData[indexPath.row].type {
       
       case "Product Payment":
        imageName = "Receipt-payment.png"
        
       case "Teleco":
        imageName = "Receipt-teleco.png"
        
       case "Water Bill":
        imageName = "Receipt-water-bill.png"
        
       case "Electricity Bill":
        imageName = "Receipt-lelectricity.png"
        
       case "Insurance":
        imageName = "Receipt-insurance.png"
        
       case "Cash Out":
        imageName = "Receipt-cash-out.png"
        
       case "Cash In":
        imageName = "Receipt-cash-in.png"
        
       case "Transfer":
        imageName = "Receipt-transfers.png"
        
            
        default: break
        }
        
        cell.transactionImage!.image = UIImage(named: imageName)
        
        
        return cell
    }
    
    
    // Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredData.isEmpty {
            greetingView.isHidden = false
            
            return filteredData.count
        } else {
            
            greetingView.isHidden = true
            
        return filteredData.count
            
        }
        
    }
    
    // Selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "detailsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("works selected")
    }
    
    // Delete row
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            // delete item at indexPath
            let item = self.filteredData[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            
            // delete item at indexPath
            print("Thehumuhumunukunukuapua'a is the coolest fush in der Welt")
            
        }
        
        delete.backgroundColor = UIColor(red: 246/255, green: 104/255, blue: 37/255, alpha: 1.0)
        share.backgroundColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1.0)
        
        
        return [delete,share]
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsSegue" {
            let editVC = segue.destination as! transactionReceiptViewController
            editVC.transaction = filteredData[selectedIndex!]
            
            print(" no works selected")
        }
        
    }
    
    
    // Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
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

   

}*/
