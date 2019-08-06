//
//  dashboardTransactionsTableViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 12/6/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData



// Transactions tableView cell class
class dashboardTransactionsCell: UITableViewCell {
    
    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var transactionTitle: UILabel!
    @IBOutlet weak var transactionPrice: UILabel!
    @IBOutlet weak var transactionDescription: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
}


class dashboardTransactionsTableViewController: UIViewController {
    
    // Data arrays
    var transaction: [Transactions3] = []
    var filteredData: [Transactions3] = []
    var transactions = [Transactions3]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndex: Int!
    var totalAmount: String = ""
    let formatter = DateFormatter()
    let formatterTime = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
    
    }

    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    
    // Data trasnsfer to dashboard   ----->
    func sendDataToVc(myString : String) {
        let Vc = parent as! dashboardViewController
        Vc.dataFromContainer(containerData: myString)
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

    
    @IBAction func createTourPressed(_ sender: UIButton) {
        // Call here delegate methods to tell parent about the action
       // delegate?.buttonClickedByUser()
        
        
    }
}


extension dashboardTransactionsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var imageName: String!
        let tdate = filteredData[indexPath.row].date
        formatter.dateFormat = "dd.MM.yyyy"
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardTransactionsCell", for: indexPath) as! dashboardTransactionsCell
        
        cell.transactionPrice?.text = filteredData[indexPath.row].amount
        cell.transactionTitle?.text = filteredData[indexPath.row].type
        cell.transactionDate?.text = filteredData[indexPath.row].payment
        cell.transactionDescription?.text = formatter.string(from: tdate!)
        
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.isEmpty {
            return filteredData.count
    
        } else {
            
            var sum = 0.0
            for item in filteredData {
                
                let number = item.amount!
                let dropped = number.dropFirst(4)
                sum += Double(dropped)!
            }
            
            let total = Int(sum)
            totalAmount = String(total)
             sendDataToVc(myString: totalAmount)   //   <-----
            return filteredData.count
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "detailsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
        shakingBunny()
    }
    
    
    // Delete row
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
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
            
            print("no works selected")
        }
    }
    
    
    // Haptic feedback
    func shakingBunny() {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
    }
    

}
    

