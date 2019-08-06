//
//  scannedProductAddViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 18/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import Lottie
import Firebase

class scannedProductAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productSize: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productCategory: UITextField!
    @IBOutlet weak var saveProductButton: UIButton!
    @IBOutlet weak var successAnimation: UIView!
    @IBOutlet weak var blurredBackground: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var productAdded: UILabel!
    @IBOutlet weak var inventoryLabel: UILabel!
    
    // Variables
    var imagePicker:UIImagePickerController!
    var barcodeProduct: String = ""
    var inventoryAmount: String = ""
    
    // Catalog variables
    var products:  [productsCatalogAll] = []
    
    // UI Picker
    var categories = ["Biscuits","Chocolate","Coffee","Cooking","Crackers","Chips","Drinks","Food","Household","Milk","Noodles", "Personal Care", "Seasonings", "Stationary"]
    
    // Scan search
    var dataProduct = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Design parameters
        theyreTakingTheHobbitsToIzengard()

        // Hide keyboard
        hideKeyboardOrangutan()
        
        // Image picker function
        imagePickerOne()
        
        // Load data
        barcodeProduct = String(describing: barcodeProduct)
        inventoryAmount = "1"
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    // Image Picker one function
    func imagePickerOne() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(imageTap)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        // UI Picker 1
        let pickerView = UIPickerView()
        pickerView.delegate = self
        productCategory.inputView = pickerView
        pickerView.backgroundColor = .white
        pickerView.setValue(UIColor(red:0.19, green:0.24, blue:0.32, alpha:1.0), forKeyPath: "textColor")
        
    }
 
    
    // Show product
    @IBAction func showBtn(_ sender: Any) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        let searchString = barcodeProduct
        request.predicate = NSPredicate(format: "barcode == %@", searchString)
        
        do {
            let result = try dataProduct.fetch(request)
            if result.count > 0{
                let name = (result[0] as AnyObject).value(forKey: "name") as! String
                let price = (result[0] as AnyObject).value(forKey: "price") as! String
                
                let data = (result[0] as AnyObject).value(forKey: "image")
                productImage?.image = UIImage(data:data as! Data)

                self.productName?.text = name
                self.productPrice?.text = price
                
            } else {
                self.productName?.text = "Honcho no friends"
            }
        } catch {
            print("There's not enough rocks in the cave mr. Honey badger")
        }
    }
    
    
    // Inventory slider function
    @IBAction func inventorySlider(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        saveProductButton.setTitle("Add \(currentValue) to my products", for: .normal)
        inventoryAmount = String(describing: currentValue)
        inventoryLabel.text = "\(String(describing: currentValue)) items"
    }
    
    @IBAction func sliderValueChange(_ sender: Any) {
        
    }
   
    
    /*/ Save to products function
    @IBAction func saveButton(_ sender: Any) {
        let picture: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
     
        if (productName.text != nil) && productPrice.text != "" {
            if constantProducts.saveObject(name: productName.text!, price: Int(productPrice.text!)!, category: productCategory.text!, size: productSize.text!, inventory: Int(inventoryAmount)!, barcode: barcodeProduct, image: picture as NSData ) {
                
                
                //for Products in constantProducts.fetchObject()! {
                    
              //  }
                
                // Animation shenanigans
                blurredBackground.frame = self.view.bounds
                blurredBackground.blurImageDark()
                self.view.addSubview(self.blurredBackground)
                blurredBackground.isHidden = false
                
                self.view.addSubview(self.popUp)
                popUp.isHidden = false
                productAdded.isHidden = false
                popUpImage.isHidden = false
                
                self.view.addSubview(self.successAnimation)
                successAnimation.isHidden = false
                tickTockTickTock()
                
                let timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
                
            }
            
            popUpImage.image = UIImage(data: picture as Data)
            productAdded.text = "\(productName.text!) has been added to your products"
        }*/

        /*//////////// Add firebase
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("Indogrocer").addDocument (data: ["Name":  productName.text!,
                                                                 "Brand": productName.text!,
                                                                 "Category": productCategory.text!,
                                                                 "Description": "n/a",
                                                                 "Product Image Rectangle": "https://firebasestorage.googleapis.com/v0/b/honcho-app.appspot.com/o/Generic-honcho-image.png?alt=media&token=f153d320-4078-4be0-985c-b86e6ae91dcd",
                                                                 "Product Image Square": "https://firebasestorage.googleapis.com/v0/b/honcho-app.appspot.com/o/Generic-product-square.png?alt=media&token=c99367b7-230b-4435-9a70-2838660ea84f",
                                                                 "Quantity":  "1 Pack",
                                                                 "Size": productSize.text!,
                                                                 "Suggested Price": productPrice.text!,
                                                                 "Supplier ID": barcodeLabel.text!,
                                                                 "Unit Price": "n/a",
                                                                 "Unit SKU": barcodeLabel.text!
            // "image": products[indexPath.row].image!
    
        ]) { err in
            if let err = err {
                
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docRef!.documentID)")
            }
        }
        //////////////////////

    }*/
    
    // Animation function
    func tickTockTickTock(){
        let tick = AnimationView(name: "Accepted")
        //animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tick.contentMode = .scaleAspectFit
        tick.frame = successAnimation.bounds
        
        successAnimation.addSubview(tick)
        tick.play()
    }
    
    
    // Design parameters function
    func theyreTakingTheHobbitsToIzengard(){
        popUp.layer.cornerRadius = 15
        popUpImage.layer.cornerRadius = 15
        saveProductButton.backgroundColor = UIColor.actionBlue
        successAnimation.isHidden = true
        blurredBackground.isHidden = true
        productAdded.isHidden = true
        popUp.isHidden = true
        popUpImage.isHidden = true
        
        // Text fields borders
        productName.aroundTheCornerIsThePub()
        productSize.aroundTheCornerIsThePub()
        productPrice.aroundTheCornerIsThePub()
        productCategory.aroundTheCornerIsThePub()
        
        // Text fields padding
        productName.setLeftPaddingPoints(15)
        productCategory.setLeftPaddingPoints(15)
        productSize.setLeftPaddingPoints(15)
        productPrice.setLeftPaddingPoints(15)
        productCategory.setLeftPaddingPoints(15)
        productName.addBottomBorder()
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton)), animated: true)
        
    }
    
    
    // Save button function
    @objc func saveButton(){
        let picture: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        
        if (productName.text != nil) && productPrice.text != "" {
            if constantProducts.saveObject(name: productName.text!, price: Int(productPrice.text!)!, category: productCategory.text!, size: productSize.text!, inventory: Int(inventoryAmount)!, barcode: barcodeProduct, image: picture as NSData ) {

                // Animation shenanigans
                blurredBackground.frame = self.view.bounds
                blurredBackground.blurImageDark()
                self.view.addSubview(self.blurredBackground)
                blurredBackground.isHidden = false
                
                self.view.addSubview(self.popUp)
                popUp.isHidden = false
                productAdded.isHidden = false
                popUpImage.isHidden = false
                
                self.view.addSubview(self.successAnimation)
                successAnimation.isHidden = false
                tickTockTickTock()
                
                let timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
            }
            
            popUpImage.image = UIImage(data: picture as Data)
            productAdded.text = "\(productName.text!) has been added to your products"
        }
    }
    
    
    // Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    
    // UI Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        productCategory.text = categories[row]
    }
    
    
    // Dissmiss viewController
    @objc func youAreDismissed() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // Image Picker 2 funciton
    @objc func openImagePicker(_ sender:Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Image Picker 3
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.productImage.image = pickedImage
            
        } else{
            
        }
        
        picker.dismiss(animated: true)
        
        
    }
    
}

