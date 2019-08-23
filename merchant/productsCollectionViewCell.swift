//
//  productsCollectionViewCell.swift
//  merchant
//
//  Created by Eugenio Mercado on 10/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import XLPagerTabStrip
import AudioToolbox
import Lottie
import Firebase
import GoogleSignIn


// Delete button classess - Delegates
protocol cartCellDelegate: class {
    func didPressbutton(_ sender: UIButton)
}

// My Cart tableView class
class cartTableViewCell: UITableViewCell {
    weak var cellDelegate: cartCellDelegate?
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.productImage.threeCorners()
    }
    
    // Delete button function
    @IBAction func deleteButton(_ sender: UIButton) {
        cellDelegate?.didPressbutton(sender)
    }
}


// Products tableView class
class productTableViewTwoCell: UITableViewCell {
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageProduct.threeCorners()
    }
}


// Add Product collectionView class
class addProductCell: UICollectionViewCell {
    @IBAction func addNewButton(_ sender: Any) {
    }
}


// Products collectionView class
class productsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        priceView.threeCornersSmall()
        self.contentView.threeCorners()
        self.threeCorners()
        self.dropShadow()
    }
}


class productsCollectionViewController: UIViewController, UITextFieldDelegate, IndicatorInfoProvider {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var amountText: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructionsTwo: UIView!
    @IBOutlet weak var productButtonsBar: UIView!
    @IBOutlet weak var cartItemsLabel: UILabel!
    @IBOutlet weak var redCircleView: UIView!
    @IBOutlet weak var tableViewTwo: UITableView!
    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var addAmount: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableVIewThree: UITableView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var animationCart: UIImageView!
    @IBOutlet weak var bottomRect: UIView!
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var myProductsButton: UIButton!
    
    
    // Data Arrays
    var products = [Products1]()
    var filteredData: [Products1] = []
    var myCart = [Cart]()
    var myCartUz: [Cart] = []
    var cart: Cart?
    var selectedIndex: Int!
    var selectedIndex2: Int!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currency: String = ""
    let global = appCurrencies()
    
    var tillProducts: [tillProducts] = []
    var cartDocumentID: String = ""
    
    // Date & Time variables
    let date = Date()
    let formatter = DateFormatter()
    
    // Static cell ///REMOVE LATER
    private let addCell = "addProduct"
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ladiesAndGentsThisMamboNrFive()
        reloadCart()
        let profileNameGoogle = GIDSignIn.sharedInstance().currentUser.profile.givenName
        profileName?.text = "Hi \(profileNameGoogle!)"
        currency = global.appMainCurrency ?? "NZD"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMeSomeData()
        hideKeyboardOrangutan()
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // Get data from products function
    func getMeSomeData(){
        collectionView.dataSource = self
        if constantProducts.fetchObject() != nil {
            products = constantProducts.fetchObject()!
            collectionView.reloadData()
            grayView.isHidden = true
            tableViewTwo.dataSource = self
            tableViewTwo.delegate = self
            tableView.reloadData()
        }
    }
    
    
    // Colours from HEX
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    // Round Corners top
    func roundCorners(cornerRadius: Double) {
       tableView.layer.cornerRadius = CGFloat(cornerRadius)
        tableView.clipsToBounds = true
       tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    
    // Round Corners bottom
    func roundCornersBottom(cornerRadius: Double) {
        productButtonsBar.layer.cornerRadius = CGFloat(cornerRadius)
        productButtonsBar.clipsToBounds = true
        productButtonsBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    
    // Get data from Core Data for tableViewTwo
    func fetchData() {
        do {
            products = try context.fetch(Products1.fetchRequest())
            filteredData = products
            DispatchQueue.main.async {
                self.tableViewTwo.reloadData()
            }
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }
 
    
    // Reordering cells function
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    
 // Data transfer to payments (send)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is smallChangeViewController {
            let vc = segue.destination as? smallChangeViewController
            vc?.amount = amountText.text!
            vc?.type = "Product Payment"
        } else {
            
            if segue.identifier == "quantitySegue" {
                let editVC = segue.destination as! productQuantityViewController
                editVC.myCart = cart
                
                print("here's the product the cat will steal from the cupboard ")
            }
        }
    }
     
    // Reload cart data
    func reloadCart() {
        if constantCart.fetchObject() != nil {
            myCartUz = constantCart.fetchObject()!
            self.tableView.reloadData()
        }
    }

    
    // List button
    @IBAction func listButton(_ sender: Any) {
        collectionView.isHidden = !collectionView.isHidden
        tableViewTwo.isHidden = !tableViewTwo.isHidden
        fetchData()
    }
    
    
    // My shop button
    @IBAction func myProducts(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addProduct", sender: self)
    }
    
    
    // Shopping cart button
    @IBAction func shoShoppingListButton(_ sender: Any) {
       
         grayView.isHidden = !grayView.isHidden
        
    }
    
    @IBAction func amountTextButton(_ sender: Any) {
        grayView.isHidden = !grayView.isHidden
    }
    
    
    // Ok button action
    @IBAction func okButton(_ sender: Any) {
        self.performSegue(withIdentifier: "paySegue", sender: self)
        kaboomShake()
 
    }
    
    
    // Scan button
    @IBAction func scanButton(_ sender: Any) {
        self.performSegue(withIdentifier: "scanSegue", sender: self)
        shakingBunny()
    }
    
    
    // Cancel button
    @IBAction func cancelButton(_ sender: Any) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            print("the squirrels are ready")
        } catch {
    
        }
        grayView.isHidden = true
        redCircleView.isHidden = true
        amountText.text = ""
        if constantCart.fetchObject() != nil {
            myCartUz = constantCart.fetchObject()!
            self.tableView.reloadData()
            counterLabel.isHidden = true
        }
        boomShakaLaka()
    }
    
    
    // Add product button
    @IBAction func addProduct(_ sender: Any) {
        self.performSegue(withIdentifier: "addProduct", sender: self)
    }
    
    
    // Cart Btton
    @IBAction func closeButton(_ sender: Any) {
        grayView.isHidden = !grayView.isHidden
    }
    
    
    // Add amount button
    @IBAction func addAmount(_ sender: Any) {
        let alertController = UIAlertController(title: "Sell an unsaved product", message: "Enter a product (optional) and its price", preferredStyle: UIAlertController.Style.alert)
        
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
            if constantCart.saveObject(product: product!, price: price!, inventory: 1, productImage: picture, productDescription: "Description", documentID: self.cartDocumentID) {
                }
            
            // Save product to suggested products
            if constantSuggestedProducts.saveObject(name: product!, price: price!, description: "Description", category: "Category", barcode: "0000000000", image: image) {
                
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
    

    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "MY PRODUCTS")
        
    }
    
    // Segue back to VC
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    
    // Design parameters
    func ladiesAndGentsThisMamboNrFive(){
        
        // Hidden views
        redCircleView.isHidden = true
        tableViewTwo.isHidden = true
        grayView.isHidden = true
        bottomRect.isHidden = true
        
        
        // Redious and Insets
        okButton.contentEdgeInsets.left = 20
        okButton.buttonCornersFour()
        amountText.textColor = UIColor.white
        roundCorners(cornerRadius: 10)
        roundCornersBottom(cornerRadius: 10)
        
        // Add Amount button parameters
        addAmount.layer.cornerRadius = 10
        
        // Cancel button parameters
        cancelButton.layer.cornerRadius = 10
        
        // Reordering cells
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
        // Add product button
        addProductButton.layer.cornerRadius = 10
        
        // Empty cart
        deleteEverything()
    }
    
    
    // Haptic feedback
    func shakingBunny() {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
    }
    
    func kaboomShake(){
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }
    
    func boomShakaLaka() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
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


// Collection view fetch Data functions
extension productsCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if products.isEmpty {
            
            // Show Instructions
            instructionsTwo.isHidden = false
            bottomRect.isHidden = true
            cartButton.isHidden = true
           
            return products.count
            
        } else {
        
            // Show buttons
            cartButton.isHidden = false
            instructionsTwo.isHidden = true
            
        return products.count
    }
}
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellProduct", for: indexPath) as! productsCollectionViewCell
   
    cell.productLabel.text = products[indexPath.row].name
    cell.descriptionLabel.text = products[indexPath.row].size
    
    let price = products[indexPath.row].price
    let xNSNumber = price as NSNumber
 
    cell.priceLabel.text = "\(currency) \(xNSNumber.stringValue)"
    
        if let data = products[indexPath.row].image as Data? {
            cell.imageProduct.image = UIImage(data:data)
      
        } else {
            cell.imageProduct.image = UIImage(named: "features")
        }
        return cell
    }
    
    
    // Cell animation when pressed
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? productsCollectionViewCell {
                cell.imageProduct.transform = .init(scaleX: 0.8, y: 0.8)
                cell.contentView.backgroundColor = UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? productsCollectionViewCell {
                cell.imageProduct.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    
    // Unwind segue
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        
    }
    
    
    // Delete functions
    func deleteEverything() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("the squirrels are ready")
            
        } catch {
            // Error Handling
            
        }
        
        if constantCart.fetchObject() != nil {
            myCartUz = constantCart.fetchObject()!
        }
    }
}


// Collection view favourite products
extension productsCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let price = products[indexPath.row].price
        let xNSNumber = price as NSNumber
        let picture: NSData = (products[indexPath.row].image!) as NSData

        // Add firebase
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("tillProducts").addDocument (data: ["product": products[indexPath.row].name!,
                                                                   "description":  products[indexPath.row].size!,
                                                                   "price": "\(currency) \(xNSNumber.stringValue)",
        ]) { err in
            if let err = err {
                
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docRef!.documentID)")
                self.cartDocumentID = docRef!.documentID
            }
        }
        // Till System save
        if (products[selectedIndex].name != nil) && xNSNumber.stringValue != "" {
            if constantCart.saveObject(product: products[selectedIndex].name!, price: Int(products[selectedIndex].price), inventory: 1, productImage: picture as NSData, productDescription: products[selectedIndex].size!, documentID: docRef!.documentID){
            }
  
       // Save to productsTab
            let productTab = ProductsTab(price: Int32(products[selectedIndex].price), name: products[selectedIndex].name!, date: date )
            do{
                try productTab?.managedObjectContext?.save()
                self.navigationController?.popViewController(animated: true)
                
            }catch{
                print("Could not save category")
            }
            print("my life is saved")
            
            if constantCart.fetchObject() != nil {
                myCartUz = constantCart.fetchObject()!
                self.tableView.reloadData()
            }
        
            // System sound and vibrations
            shakingBunny()

            func confettiPoom(){
                let confetti = AnimationView(name: "cart2")
                confetti.contentMode = .scaleAspectFill
                confetti.frame = animationCart.bounds
                animationCart.addSubview(confetti)
                animationCart.imageTint(color: UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.0))
                
                confetti.play()
            }
                counterLabel.isHidden = false
                confettiPoom()
        }
        
        // Count cart items
        let cartItems = tableView.numberOfRows(inSection: 0)
        let cartItemsNumber = cartItems as NSNumber
        let cartItemsString: String = cartItemsNumber.stringValue
        counterLabel.text = cartItemsString
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        }
    }


// Table views
extension productsCollectionViewController: UITableViewDelegate, UITableViewDataSource, cartCellDelegate {
    
    // Delete button
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
            
            let cartItems = tableView.numberOfRows(inSection: 0)
            let cartItemsNumber = cartItems as NSNumber
            let cartItemsString: String = cartItemsNumber.stringValue
            counterLabel.text = cartItemsString
     
        }
        
    }
    
    // Delete Slider
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            let db = Firestore.firestore()
            db.collection("tillProducts").document("\(self.myCartUz[indexPath.row].documentID!)").delete() { err in
                if let err = err {
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
            
            let cartItems = tableView.numberOfRows(inSection: 0)
            let cartItemsNumber = cartItems as NSNumber
            let cartItemsString: String = cartItemsNumber.stringValue
            self.counterLabel.text = cartItemsString
            
            // delete item at indexPath
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.myCartUz.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        delete.backgroundColor = UIColor(red: 246/255, green: 104/255, blue: 37/255, alpha: 1.0)
        
        return [delete]
    }

   
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
       let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
  
            return indexPath
        }
        return nil
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewTwo {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! productTableViewTwoCell
            let price = filteredData[indexPath.row].price
            let xNSNumber = price as NSNumber
            
            cell2.productLabel?.text = filteredData[indexPath.row].name
            cell2.detailsLabel?.text = filteredData[indexPath.row].size
            cell2.priceLabel?.text = "\(currency) \(xNSNumber.stringValue)"
            
            if let data = filteredData[indexPath.row].image as Data? {
                cell2.imageProduct.image = UIImage(data:data)
                
            }
            // Selection colour
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.89, alpha:1.0)
            cell2.selectedBackgroundView = backgroundView
            return cell2
            
        } else {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! cartTableViewCell
       
        cell.productName?.text = myCartUz[indexPath.row].product
        
        let price = myCartUz[indexPath.row].price
        let xNSNumber = price as NSNumber
        cell.descriptionLabel?.text = myCartUz[indexPath.row].productDescription
        cell.productPrice?.text = "\(currency) \(xNSNumber.stringValue)"
            
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
    
    
    // My cart row function 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == tableViewTwo {
            return filteredData.count
            
         } else {

        if myCartUz.isEmpty {
            amountText.text = ""
            grayView.isHidden = true
            redCircleView.isHidden = true
            okButton.isEnabled = false
            okButton.setTitle("\(currency) 0", for: .normal)
            okButton.contentEdgeInsets.left = 85
            bottomRect.isHidden = true
            okButton.isHidden = true
            cartView.isHidden = true
            
            return myCartUz.count
            
        } else {
    
            // Totals calculator
            var sum = 0.0
            for item in myCartUz {
     
                sum += Double(item.price)
            }
            let total = Int(sum)
            amountText.text = "\(currency) \(total)"
            redCircleView.isHidden = false
            okButton.isEnabled = true
            okButton.setTitle("Checkout", for: .normal)
            okButton.contentEdgeInsets.left = 20
            bottomRect.isHidden = false
            okButton.isHidden = false
            cartView.isHidden = false
            
            return myCartUz.count
    
            }
        }
}
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView == tableViewTwo {
    
    selectedIndex = indexPath.row
    let price = products[indexPath.row].price
    let xNSNumber = price as NSNumber
    let picture: NSData = (products[indexPath.row].image!) as NSData
        
        // Add Product to Firebase
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("tillProducts").addDocument (data: ["product": products[indexPath.row].name!,
                                                                   "description":  products[indexPath.row].size!,
                                                                   "price": "\(currency) \(xNSNumber.stringValue)",
            // "image": products[indexPath.row].image!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docRef!.documentID)")
            }
        }
        

    // Till System save
    if (products[selectedIndex].name != nil) && xNSNumber.stringValue != "" {
        if constantCart.saveObject(product: products[selectedIndex].name!,  price: Int(products[selectedIndex].price), inventory: 1, productImage: picture as NSData, productDescription: products[selectedIndex].size!, documentID: docRef!.documentID) {
        }
        
        cartDocumentID = docRef!.documentID
        if constantCart.fetchObject() != nil {
            myCartUz = constantCart.fetchObject()!
            self.tableView.reloadData()
        }
        
        // System sound and vibrations
        let systemSoundId: SystemSoundID = 1103
        AudioServicesAddSystemSoundCompletion(systemSoundId, nil, nil, { (customSoundId, _) -> Void in
            AudioServicesDisposeSystemSoundID(customSoundId)
        }, nil)
        AudioServicesPlayAlertSound(systemSoundId)
    }
        
        func confettiPoom(){
            let confetti = AnimationView(name: "cart2")
            confetti.contentMode = .scaleAspectFill
            confetti.frame = animationCart.bounds
            animationCart.addSubview(confetti)
            animationCart.imageTint(color: UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.0))
            confetti.play()
        }
        
        counterLabel.isHidden = false
        confettiPoom()
    
    // Count cart items
    let cartItems = myCartUz.count
    let cartItemsNumber = cartItems as NSNumber
    let cartItemsString: String = cartItemsNumber.stringValue
    counterLabel.text = cartItemsString

    } else if tableView == tableVIewThree {
      
        cart = myCartUz[indexPath.row]
        self.performSegue(withIdentifier: "quantitySegue", sender: self)
       // tableView.deselectRow(at: indexPath, animated: true)
    }
}
    
   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}





