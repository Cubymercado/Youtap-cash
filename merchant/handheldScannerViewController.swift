//
//  handheldScannerViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 21/06/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import Firebase

class handheldScannerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelOrder: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var barcodeText: UITextField!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var bottomBar: UIView!
    
    // Search variables
    var dataProduct = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var products = [String]()
    var laserNumber: String =  ""

    
    // Cart variables
    var myCart = [Cart]()
    var myCartUz: [Cart] = []
    var cart: Cart?
    var selectedIndex: Int!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var productPicture: UIImage!
    var cartDocumentID: String = ""
    var skinnyPete = NSMutableAttributedString()
    var amount: String = ""
    var totalSend: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCart()
        makeThatGCgoodLookin()
        hideKeyboardOrangutan()
        //skinnyAndFat()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
       ahoi()
       
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.barcodeText.becomeFirstResponder()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
     ahoi()
    }
    
    
    // Reload cart data
    func reloadCart() {
        if constantCart.fetchObject() != nil {
            myCartUz = constantCart.fetchObject()!
            self.tableView.reloadData()
        }
    }
    
    
    // Handheld scannerfunction
    func ahoi() {
        barcodeText.addTarget(self, action: #selector(testText(textField:)), for: .editingChanged)
    }
    
   @objc func testText(textField: UITextField) {
   let cuntNumbers = barcodeText.text?.count
    if cuntNumbers == 13 {
        laserNumber = barcodeText.text!
        print (laserNumber)
        laserTagIsLaserLife()
        barcodeText.text  = ""
    } else {
      
        
        }
    }
    
    
    // Scanner function
    func scanScanLaser(){
        let scanned = barcodeText.text
        if scanned == "" {
            print ("scanning")
        } else {
            laserNumber = barcodeText.text!
            print(laserNumber)
            laserTagIsLaserLife()
            barcodeText.text = ""
            self.barcodeText.becomeFirstResponder()
            
        }
    }

    
    // Scanner value search
    func laserTagIsLaserLife() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Products1")
        let searchString = laserNumber
        request.predicate = NSPredicate(format: "barcode == %@", searchString)
        
        do {
            let result = try dataProduct.fetch(request)
            if result.count > 0{
                let name = (result[0] as AnyObject).value(forKey: "name") as! String
                let price = (result[0] as AnyObject).value(forKey: "price") as! NSNumber
                let picture: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Random-product"))! as NSData
                let kfPicture = (result[0] as AnyObject).value(forKey: "image") as! NSData
                
                products.append(laserNumber)
                self.tableView.reloadData()
                
                // Add firebase
                let db = Firestore.firestore()
                var docRef: DocumentReference? = nil
                docRef = db.collection("tillProducts").addDocument (data: ["product": name, "description":  "scanned", "price": "IDR \(price.stringValue)",
                    
                ]) { err in
                    if let err = err {
                        
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(docRef!.documentID)")
                    }
                }
                
                // Save data to table view till
                if (name != nil) && price.stringValue != "" {
                    if constantCart.saveObject(product: name, price: Int(truncating: price), inventory: 1, productImage: kfPicture, productDescription: "scanned", documentID: docRef!.documentID) {
                    }
                    if constantCart.fetchObject() != nil {
                        myCartUz = constantCart.fetchObject()!
                        
                        // Display data on table view
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                thaLasaIsCraza()
                print("There's not enough rocks in the cave mr. Honey badger") }
        } catch {
        }
    }
    
    
    // Add amount function
    func thaLasaIsCraza() {
        let alertController = UIAlertController(title: "Unknown Product", message: "Enter the product and a price", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Product name"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            // Keyboard type for UITextField
            secondTextField.keyboardType = .numberPad
            
            let product = firstTextField.text
            let price = Int(secondTextField.text!)
            let picture: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Random-product"))! as NSData
            let image: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Random-product"))! as NSData
            
            // Save project to my cart
            if constantCart.saveObject(product: product!, price: price!, inventory: 1, productImage: picture, productDescription: "manual entry", documentID: self.cartDocumentID) {
            }
            
            // Save product to suggested products
            if constantSuggestedProducts.saveObject(name: product!, price: price!, description: "Manual entry", category: "Manual entry", barcode: self.laserNumber, image: image) {
            }
            print("the kiwi bird it's browsing")
            
            if constantCart.fetchObject() != nil {
                self.myCartUz = constantCart.fetchObject()!
                self.tableView.reloadData()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Product price"
            textField.keyboardType = .decimalPad
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
 
    // Checkout button action
    @IBAction func checkoutButton(_ sender: Any) {
        self.performSegue(withIdentifier: "paySegue", sender: self)
        
    }
    
    
    // Cancel button function
    @IBAction func cancelButton(_ sender: Any) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("the squirrels are ready")
            
        } catch {
            
        }
        
        if constantCart.fetchObject() != nil {
            myCartUz = constantCart.fetchObject()!
        }
        boomShakaLaka()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    // Haptic feedback
    func boomShakaLaka() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
    }
    
    
    // Data transfer to payments (send)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is smallChangeViewController {
            let vc = segue.destination as? smallChangeViewController
            vc?.amount = amount
            vc?.type = "Product Payment"
            
        } else {
            
            if segue.identifier == "quantitySegue" {
                let editVC = segue.destination as! productQuantityViewController
                editVC.myCart = cart
                
                print("here's the product the cat will steal from the cupboard ")
            }
        }
    }
    
    // Design parameters
    func makeThatGCgoodLookin() {
        cancelOrder.layer.cornerRadius = 10
        checkoutButton.layer.cornerRadius = 10
        tableView.roundTopCorners()
        bottomBar.bottomCorners()
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
        
    }
    
    // Text design parameters
    func skinnyAndFat() {
        skinnyPete = NSMutableAttributedString(string: amount, attributes: [NSAttributedStringKey.font: UIFont (name: "Ubuntu-Regular", size: 40)!])
        skinnyPete.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Ubuntu-Light", size: 20.0)!, range: NSRange(location:0, length:3))
        
        totalAmount.attributedText = skinnyPete
        totalAmount.text = amount
        
    }
    

}

extension handheldScannerViewController: UITableViewDelegate, UITableViewDataSource, cartCellDelegate {
    func didPressbutton(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            
            let db = Firestore.firestore()
            db.collection("tillProducts").document("\(self.myCartUz[indexPath.row].documentID!)").delete() { err in if let err = err {
                print ("ooops")
            } else {
                print("yaaay")
                }
            }
            
            let item = self.myCartUz[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.myCartUz.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
    
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myCartUz.isEmpty {
            totalAmount.text = ""
            checkoutButton.setTitle("IDR 0,000", for: .normal)
           // checkoutButton.content.c

            
            return myCartUz.count
            
        } else {
            
            // Totals calculator
            var sum = 0.0
            for item in myCartUz {
                sum += Double(item.price)
            }
            
            let total = Int(sum)
            
            amount = "IDR \(total)"
            totalSend = String(total)
           // totalAmount.text = "IDR \(total)"
            checkoutButton.setTitle(amount, for: .normal)
            checkoutButton.contentEdgeInsets.left = 20

            return myCartUz.count
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! cartTableViewCell
        
        cell.productName?.text = myCartUz[indexPath.row].product
        
        let price = myCartUz[indexPath.row].price
        let xNSNumber = price as NSNumber
        cell.descriptionLabel?.text = myCartUz[indexPath.row].productDescription
        cell.productPrice?.text = "IDR \(xNSNumber.stringValue)"
        
        let dataS = myCartUz[indexPath.row].productImage as Data?
        cell.productImage.image = UIImage(data: dataS!)
        
        // Delete button action
        cell.cellDelegate = self
        cell.tag = indexPath.row
        
        
        // Selection colour
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.89, alpha:1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    
    
    
}
