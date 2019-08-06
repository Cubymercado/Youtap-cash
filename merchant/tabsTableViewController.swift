//
//  tabsTableViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 4/02/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreData



class tabsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customerPicture: UIImageView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var cutomerTotalMoneyOwed: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    
    override func layoutSubviews() {
    self.customerPicture.roundMyCircle()
    
    }
    
}


class tabsTableViewController: UITableViewController, IndicatorInfoProvider  {
    
    // References to customers data
    var myCustomers: [Customers] = []
    var filteredData: [Customers] = []
    var customers: Customers?
    
    var amount:String = ""
    var type: String = ""
    var companyName: String = ""
    var companyID: String = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndex: Int!

    // Date variables
    let date = Date()
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Get data
        getMeSomeData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
       // myDataMyPreciousData()
        getMeSomeData()
        
    }
    
    
    // Get data function and order by date
    func myDataMyPreciousData() {
        let request = Customers.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            myCustomers = try context.fetch(request) as! [Customers]
            filteredData = myCustomers
            self.tableView.reloadData()
            
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }
    
    
    // Back Button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    //Date Function
    func tellMeTheTimeJimbo() {
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
    }
    
    
    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TABS")
    }
    
    
    // Add new customer function
    @IBAction func addNewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addTabSegue", sender: self)
    }
    
    
    // Other functions
    func getMeSomeData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Customers> = Customers.fetchRequest()
        do{
            myCustomers = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
            
        }catch{
            
            print("Could not fetch categories")
        }
        print(myCustomers.count)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCustomers.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! tabsTableViewCell
        let customBoy = myCustomers[indexPath.row]
        
        //cell.customerName?.text = "\(String(describing: myCustomers[indexPath.row].name)) \(String(describing: customBoy.productTabClass?.count)))"
        cell.customerName!.text = myCustomers[indexPath.row].name
        cell.customerPhone?.text = myCustomers[indexPath.row].phoneNumber
        cell.cutomerTotalMoneyOwed?.text = amount

        // Image
        if let data = myCustomers[indexPath.row].profileicture as Data? {
            cell.customerPicture.image = UIImage(data:data)
            
                } else {
        
        }
    
        return cell
    
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            // delete item at indexPath
            
            let item = self.myCustomers[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.myCustomers.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        delete.backgroundColor = UIColor(red: 246/255, green: 104/255, blue: 37/255, alpha: 1.0)
        
        return [delete]
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "customerTabSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("tab selected")
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? addToTabViewController,
            let selectedRow = self.tableView.indexPathForSelectedRow?.row else{
                return
        }
        destination.customer = myCustomers[selectedRow]
        
       /* if segue.identifier == "customerTabSegue" {
            let editVC = segue.destination as! addToTabViewController
            editVC.customers = filteredData[selectedIndex!]
            editVC.amount = amount
            
            print(" no works selected")
        }*/
        
    }


}
