//
//  ordersCartViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 26/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit

class ordersCartTableCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.productImage.threeCorners()
    }

}

class ordersCartViewController: UIViewController {

    // References to my products data
    var myProducts: [Cart] = []
    var product: Cart?
    var filteredData: [Cart] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndex: Int!
    
    var supplierImage: String = ""
    var supplierName: String = ""
    var supplierAddress: String = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeOrder: UIButton!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Design parameters
        lakeTaupoIsNotAnOceanYouGoose()
        
        // Data
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    
    // Get products data function
    func fetchData() {
        do {
            myProducts = try context.fetch(Cart.fetchRequest())
            filteredData = myProducts
            DispatchQueue.main.async {
                self.tableView.reloadData()
              
            }
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }
    
    // Button function
    @IBAction func placeOrderButton(_ sender: Any) {
        performSegue(withIdentifier: "placeOrderSegue", sender: self)
    }
    
    // Data transfer to payments (send)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is reviewOrderViewController
        {
            let vc = segue.destination as? reviewOrderViewController
            vc?.newSupplierName = supplierName
            vc?.newSupplierAddress = supplierAddress
            vc?.newSupplierImage = supplierImage
            
        }
        
    }
    
    // Design Parameters function
    func lakeTaupoIsNotAnOceanYouGoose() {
        placeOrder.backgroundColor = UIColor.actionBlue
        placeOrder.contentEdgeInsets.left = 20
    }
}


extension ordersCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ordersCartTableCell
        
        cell.productName?.text = myProducts[indexPath.row].product
        cell.productSize?.text = myProducts[indexPath.row].productDescription
       
        let inventory = myProducts[indexPath.row].inventory
        let xNSNumberInventory = inventory as NSNumber
        cell.productQuantity?.text = "x \(xNSNumberInventory.stringValue)"
        
        let price = myProducts[indexPath.row].price
        let xNSNUmberPrice = price as NSNumber
        cell.productPrice?.text = "Rp \(xNSNUmberPrice.stringValue)"
        
        let data = myProducts[indexPath.row].productImage as Data?
        cell.productImage?.image = UIImage(data:data!)
        
        return cell
        
    } 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var sum = 0.0
        for item in myProducts {
            
            
            sum += Double(item.price) * Double(item.inventory)
            
        }
        
        let total = Int(sum)
        totalPrice.text = "Rp \(total)"
        
        return myProducts.count
        
        
    }
 
}

// Delete itemes function
extension ordersCartViewController{
    
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
