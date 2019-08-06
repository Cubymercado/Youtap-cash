//
//  tabManagerPaymentViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 31/7/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData

class tabCell: UICollectionViewCell {
    @IBOutlet weak var tabImage: UIImageView!
    @IBOutlet weak var tabTitle: UILabel!
    @IBOutlet weak var tabAmount: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.cards()
        self.cards()
        self.dropShadow()
    }
    
}


class tabManagerPaymentViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMeSomeData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    }

    
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
    
    
    // Get data function and order by date
    func myDataMyPreciousData() {
        let request = Customers.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            myCustomers = try context.fetch(request) as! [Customers]
            filteredData = myCustomers
            collectionView.reloadData()
            
        } catch {
            print("Data no have")
        }
    }
    
    
    // Back Button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // Add new customer function
    @IBAction func addNewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addTabSegue", sender: self)
    }
    
    
    //Date Function
    func tellMeTheTimeJimbo() {
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
    }
    
    
    // Other functions
    func getMeSomeData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Customers> = Customers.fetchRequest()
        do {
            myCustomers = try managedContext.fetch(fetchRequest)
            collectionView.reloadData()
            
        } catch {
            print("Could not fetch categories")
        }
        print(myCustomers.count)
    }
    


}


// Collection view fetch Data functions
extension tabManagerPaymentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCustomers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCell", for: indexPath) as! tabCell
        
        cell.tabTitle!.text = myCustomers[indexPath.row].name
        cell.tabAmount?.text = amount
        if let data = myCustomers[indexPath.row].profileicture as Data? {
        cell.tabImage.image = UIImage(data:data)
            
            } else {
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "tabSegue", sender: self)
        
        
        print("tab selected")
    }
    
    
}
