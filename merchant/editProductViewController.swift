//
//  editProductViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 19/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import Lottie


class editProductViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
  
    // Data Arrays
    var product: Products1!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var newImage: UIImage?
    var imagePicker:UIImagePickerController!
    var inventoryAmount: String = ""
    var nameProduct: String = ""
    
    // UI Picker
    var categories = ["Biscuits","Chocolate","Coffee","Cooking","Crackers","Chips","Drinks","Food","Household","Milk","Noodles", "Personal Care", "Seasonings", "Stationary"]
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var barcodeNumber: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productSize: UITextField!
    @IBOutlet weak var amountLabel: UITextField!
    @IBOutlet weak var productCategory: UITextField!
    @IBOutlet weak var inventoryLabel: UILabel!
    @IBOutlet weak var addToMyProducts: UIButton! 
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var successProduct: UILabel!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var blurredBackground: UIImageView!
    @IBOutlet weak var popUpImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
     
        // Hide Keyboard
        hideKeyboardOrangutan()
        
        // Design parameters
        nezahualcoyotl()
        
        // Image picker function
        imagePickerOne()
        
        // Load data
        configureEntryData(entry: product)
    
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    
    // Image Picker one function
    func imagePickerOne() {
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        print("The mighty salmon of knowledge is on his way upstream, beware of him bears")
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
    
    
    // Display product details
    func configureEntryData(entry: Products1) {
        
        let name = entry.name
        let size = entry.size
        let barcode = entry.barcode
        let category = entry.category
    
        productName!.text = name
        barcodeNumber!.text = barcode
        productSize!.text = size
        productCategory!.text = category
        
        let price = entry.price
        let xNSNumberPrice = price as NSNumber
        amountLabel!.text = xNSNumberPrice.stringValue
        
        let image = entry.image as Data?
        productImage!.image = UIImage(data:image!)
        
        let inventory = entry.inventory
        let xNSNumber = inventory as NSNumber //as!
        inventoryLabel!.text = "\(xNSNumber.stringValue) items"
        
        let maxValue = inventory + 20
        slider.value = Float(inventory)
        slider.maximumValue = Float(maxValue)
        
        nameProduct = name!
        popUpImage!.image = UIImage(data:image!)
        //popUpImage!.image = newImage
    }
    
    
    // Inventory slider function
    @IBAction func inventorySlider(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        //addToMyProducts.setTitle("Add \(currentValue) to cart", for: .normal)
        
        inventoryAmount = String(describing: currentValue)
        inventoryLabel.text = "\(String(describing: currentValue)) items"
    }
    
    @IBAction func sliderValueChange(_ sender: Any) {
      
    }
    
    
    // Update product details
    @IBAction func updateButton(_ sender: UIButton) {
        
        let newName = productName.text
        let newCategory = productCategory.text
        let newSize = productSize.text
        
        let inventoryNumbers = inventoryLabel.text!
        let newInventory = Int(inventoryNumbers.dropLast(6))!
        let newPrice = Int(amountLabel.text!)!
        
        let newImage: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        
        popUpImage!.image = productImage.image!
        
        product.price = Int32(newPrice )
        product.name = newName
        product.category = newCategory
        product.size = newSize
        product.inventory = Int16(newInventory )
        product.image = newImage as NSData as Data
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Animation shenanigans
        blurredBackground.frame = self.view.bounds
        blurredBackground.blurImageDark()
        self.view.addSubview(self.blurredBackground)
        blurredBackground.isHidden = false
        
        self.view.addSubview(self.popUp)
        popUp.isHidden = false
        successLabel.isHidden = false
        successProduct.isHidden = false
        popUpImage.isHidden = false
        
        self.view.addSubview(self.animationView)
        animationView.isHidden = false
        tickTockTickTock()
        
        successProduct.text = "\(nameProduct) has been updated"
        
        let timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
    }
 
    
    // Design parameters function
    func nezahualcoyotl() {
        popUp.layer.cornerRadius = 15
        popUpImage.layer.cornerRadius = 15
        popUp.isHidden = true
        successLabel.isHidden = true
        successProduct.isHidden = true
        animationView.isHidden = true
        blurredBackground.isHidden = true
        popUpImage.isHidden = true
        
        addToMyProducts.backgroundColor = UIColor.actionBlue
        sliderValueChange(self)
        
        // Text fields borders
        productName.aroundTheCornerIsThePub()
        productSize.aroundTheCornerIsThePub()
        amountLabel.aroundTheCornerIsThePub()
        barcodeNumber.aroundTheCornerIsThePub()
        productCategory.aroundTheCornerIsThePub()
        
        // Text fields padding
        productName.setLeftPaddingPoints(15)
        productCategory.setLeftPaddingPoints(15)
        productSize.setLeftPaddingPoints(15)
        amountLabel.setLeftPaddingPoints(15)
        productCategory.setLeftPaddingPoints(15)
        barcodeNumber.setLeftPaddingPoints(15)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton)), animated: true)
    }
    
    // Save button function
    @objc func saveButton(){
        let newName = productName.text
        let newCategory = productCategory.text
        let newSize = productSize.text
        
        let inventoryNumbers = inventoryLabel.text!
        let newInventory = Int(inventoryNumbers.dropLast(6))!
        let newPrice = Int(amountLabel.text!)!
        
        let newImage: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        
        popUpImage!.image = productImage.image!
        
        product.price = Int32(newPrice )
        product.name = newName
        product.category = newCategory
        product.size = newSize
        product.inventory = Int16(newInventory )
        product.image = newImage as NSData as Data
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Animation shenanigans
        blurredBackground.frame = self.view.bounds
        blurredBackground.blurImageDark()
        self.view.addSubview(self.blurredBackground)
        blurredBackground.isHidden = false
        
        self.view.addSubview(self.popUp)
        popUp.isHidden = false
        successLabel.isHidden = false
        successProduct.isHidden = false
        popUpImage.isHidden = false
        
        self.view.addSubview(self.animationView)
        animationView.isHidden = false
        tickTockTickTock()
        
        successProduct.text = "\(nameProduct) has been updated"
        
        let timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
    }
    
    
    // Animation function
    func tickTockTickTock(){
        let tick = AnimationView(name: "Accepted")
        tick.contentMode = .scaleAspectFit
        tick.frame = animationView.bounds
        
        animationView.addSubview(tick)
        tick.play()
    }
    
    // Dissmiss viewController
    @objc func youAreDismissed() {
        navigationController?.popViewController(animated: false)
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
    
    // Image Picker 2
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
    
    
    // Open camera
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
            
            self.productImage.image = newImage
        }
        
        picker.dismiss(animated: true)
    }
    
    
    // UI Picker 2
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
    
    
    // Back button function
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // Alert functions
    func alert() {
        let alert = UIAlertController(title: "Possums!", message: "Your product has been updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Radical", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}


