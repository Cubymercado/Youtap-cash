//
//  reviewOrderViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 26/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData
import Lottie

class orderReviewCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
}

class paymentCell: UITableViewCell {
    @IBOutlet weak var paymenyAmount: UILabel!
    
}

class paymentCellB: UITableViewCell {
    @IBOutlet weak var paymentAmount: UILabel!
    
    
}


class reviewOrderViewController: UIViewController {

    // References to my products data
    var myProducts: [Cart] = []
    var product: Cart?
    var filteredData: [Cart] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndex: Int!
    let global = appCurrencies()
    var currency: String = ""
    
    let paymentsArray = ["cellA", "cellB"]
    
    // Variables
    var totalAmountToPay: String = ""
    var newSupplierImage: String = ""
    var newSupplierName: String = ""
    var newSupplierAddress: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTwo: UITableView!
    @IBOutlet weak var supplierImage: UIImageView!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var supplierAddress: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var totalAmountButton: UILabel!
    @IBOutlet weak var blurredBackground: UIImageView!
    @IBOutlet weak var successAnimation: UIView!
    @IBOutlet weak var orderPlacedLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Design patameters
        lakePupukiIsFullOfPooPooKi()
        
        // Data
        fetchData()
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

    
    // Cancel button function
    @IBAction func cancelButton(_ sender: Any) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("the squirrels are ready")
            
                } catch {
            }
        self.dismiss(animated: false, completion: nil)
    }
    
    // Confirm button function
    @IBAction func confirmButton(_ sender: Any) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("the squirrels are ready")
            
        } catch {
    }

        // Animation shenanigans
        blurredBackground.frame = self.view.bounds
        blurredBackground.blurImage()
        self.view.addSubview(self.blurredBackground)
        blurredBackground.isHidden = false
        popUpView.frame = self.view.bounds
        self.view.addSubview(self.popUpView)
        popUpView.isHidden = false
        self.view.addSubview(self.successAnimation)
        successAnimation.isHidden = false
        tickTockTickTock()
        self.view.addSubview(self.orderPlacedLabel)
        orderPlacedLabel.isHidden = false
        
        let timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
  
    }
    
    // Dismiss function
    @objc func youAreDismissed() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // Animation function
    func tickTockTickTock(){
        let tick = AnimationView(name: "truck_running")
        tick.contentMode = .scaleAspectFit
        tick.frame = successAnimation.bounds
        
        successAnimation.addSubview(tick)
        tick.play()
    }
    
    // Design Parameters function
    func lakePupukiIsFullOfPooPooKi() {
        confirmButton.backgroundColor = UIColor.electricGreen
        confirmButton.contentEdgeInsets.left = 20
        supplierName.text = newSupplierName
        supplierAddress.text = newSupplierAddress
        supplierImage.threeCorners()
        orderPlacedLabel.isHidden = true
        orderPlacedLabel.textColor = UIColor.electricGreen
        popUpView.isHidden = true
        
        popUpView.layer.cornerRadius = 15
        popUpImage.layer.cornerRadius = 15
        
        
        let url = URL(string: (newSupplierImage))
        supplierImage?.kf.setImage(with: url)
    }
}

// Table view data
extension reviewOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewTwo {
            return paymentsArray.count
            
        } else {
        
        var sum = 0.0
        for item in myProducts {
            
            sum += Double(item.price) * Double(item.inventory)
        }
        
        let total = Int(sum)
        totalPrice.text = "IDR \(total)"
        totalAmountButton.text = "IDR \(total)"
            
        let xNSNumber = total as NSNumber
        totalAmountToPay = xNSNumber.stringValue
            
        return myProducts.count
    }
}
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewTwo {
            if indexPath.row == 0 {
                let cellA = tableView.dequeueReusableCell(withIdentifier: "cellA", for: indexPath) as! paymentCell
                
                let totalPriceDouble = Double(totalAmountToPay)
                let discount = totalPriceDouble! * 0.10
                let discountedPrice = totalPriceDouble! - discount
                
                let doubleString = discountedPrice as NSNumber
                
                cellA.paymenyAmount.text = "IDR \(doubleString.stringValue)"
                
                return cellA
                
            } else if indexPath.row == 1 {
                    let cellB = tableView.dequeueReusableCell(withIdentifier: "cellB", for: indexPath) as! paymentCellB
                    
                    cellB.paymentAmount.text = "IDR \(totalAmountToPay)"
                    
                    return cellB
            }
            return UITableViewCell()

        } else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! orderReviewCell
        
        cell.productName?.text = myProducts[indexPath.row].product
        
        let inventory = myProducts[indexPath.row].inventory
        let xNSNumberInventory = inventory as NSNumber
        cell.productQuantity?.text = "x \(xNSNumberInventory.stringValue)"
        
        let price = myProducts[indexPath.row].price
        let xNSNUmberPrice = price as NSNumber
        cell.productPrice?.text = "IDR \(xNSNUmberPrice.stringValue)"
        
        return cell
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableViewTwo {
            if indexPath.row == 0 {
                let totalPriceDouble = Double(totalAmountToPay)
                let discount = totalPriceDouble! * 0.10
                let discountedPrice = totalPriceDouble! - discount
                let doubleString = discountedPrice as NSNumber
                
                totalAmountButton.text = "IDR \(doubleString.stringValue)"
                
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .checkmark
                    let view = UIView()
                    cell.selectedBackgroundView = view
                }
                
            } else if indexPath.row == 1 {
                totalAmountButton.text = "IDR \(totalAmountToPay)"
            
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .checkmark
                    let view = UIView()
                    cell.selectedBackgroundView = view
                
                    }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            
            let view = UIView()
            view.backgroundColor = UIColor.white
            cell.selectedBackgroundView = view
            
        }
    }
}
