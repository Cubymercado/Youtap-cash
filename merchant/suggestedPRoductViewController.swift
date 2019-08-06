//
//  suggestedPRoductViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 15/5/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Lottie

class suggestedPRoductViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDescription: UITextField!
    @IBOutlet weak var productCategory: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productBarcode: UITextField!
    @IBOutlet weak var inventorySlider: UISlider!
    @IBOutlet weak var inventoryLabel: UILabel!
    @IBOutlet weak var blurredBackground: UIImageView!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var productAdded: UILabel!
    @IBOutlet weak var photoButton: UIImageView!
    @IBOutlet weak var successAnimation: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var addProduct: UIButton!
    
    
    // Data Arrays
    var product: Products1!
    var suggestedProduct: Suggested1!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var newImage: UIImage?
    var imagePicker:UIImagePickerController!
    var inventoryAmount: String = ""
    
    // UI Picker
    var categories = ["Coffee","Drinks","Food","Household Items","Stationary"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide Keyboard
        hideKeyboardOrangutan()
        
        // Design parameters
        nezahualcoyotl()
        
        // Image picker function
        imagePickerOne()
        
        // Load data
        configureEntryData(entry: suggestedProduct)
        inventoryAmount = "1"
        
    }
    
    // Image Picker one function
    func imagePickerOne() {
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        print("The mighty salmon of knowledge is on his way upstream, beware of him bears")
        photoButton.isUserInteractionEnabled = true
        photoButton.addGestureRecognizer(imageTap)
        
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
    func configureEntryData(entry: Suggested1) {
        
        let name = entry.productName
        let description = entry.productDescription
        let category = entry.productCategory
        let image = UIImagePNGRepresentation(#imageLiteral(resourceName: "Add-product-photo"))! as NSData
        let price = entry.price
        let barcode = entry.barcode
        let xNSNumberPrice = price as NSNumber
        
        productName!.text = name
        productPrice!.text = xNSNumberPrice.stringValue
        productDescription!.text = description
        productCategory!.text = category
        productBarcode!.text = barcode
        productImage!.image = UIImage(data:image as Data)
        
        
        productAdded.text = "\(name) has been added to your products"
        
    }
    
    
    // Inventory slider function
    @IBAction func inventorySlider(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        //addToMyProducts.setTitle("Add \(currentValue) to my products", for: .normal)
        inventoryAmount = String(describing: currentValue)
        inventoryLabel.text = "\(String(describing: currentValue)) items"
    }
    
    @IBAction func sliderValueChange(_ sender: Any) {
        let inventoryNumbers = Float(2)
        
    }
    
    
    // Save product details
    @IBAction func updateButton(_ sender: Any) {
        var barcode: String = ""
        if productBarcode.text!.isEmpty {
            barcode = "000000"
            
        }else {
            barcode = productBarcode.text!
        }
        let yummy: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        popUpImage!.image = UIImage(data:yummy as Data)
        
        if (productName.text != nil) && productDescription.text != "" {
            if constantProducts.saveObject(name: productName.text!, price: Int(productPrice.text!)!, category: productCategory.text!, size: productDescription.text!, inventory: Int(inventoryAmount)!, barcode: barcode, image: yummy as NSData) {
            }
            
            // Animation shenanigans
            blurredBackground.frame = self.view.bounds
           // blurredBackground.blurImageDark()
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
        
        let item = self.suggestedProduct
        self.context.delete(item!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    // Design parameters function
    func nezahualcoyotl() {
        popUp.layer.cornerRadius = 15
        popUpImage.layer.cornerRadius = 15
        addProduct.layer.cornerRadius = 10
        successAnimation.isHidden = true
        blurredBackground.isHidden = true
        popUp.isHidden = true
        fullView.layer.cornerRadius = 10
        fullView.dropShadowLight()
        fullView.cards()
        
        sliderValueChange(self)
        
        // Text fields borders
        productName.addBottomBorder()
        productDescription.addBottomBorder()
        productCategory.addBottomBorder()
        productPrice.addBottomBorder()
        productBarcode.addBottomBorder()
        
         self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        
    //    self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton)), animated: true)
    }
    
    
    // Save button function
    @objc func saveButton(){
        var barcode: String = ""
        if productBarcode.text!.isEmpty {
            barcode = "000000"
        }else {
            barcode = productBarcode.text!
        }
        
        let yummy: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        popUpImage!.image = UIImage(data:yummy as Data)
        
        if (productName.text != nil) && productDescription.text != "" {
            if constantProducts.saveObject(name: productName.text!, price: Int(productPrice.text!)!, category: productCategory.text!, size: productDescription.text!, inventory: Int(inventoryAmount)!, barcode: barcode, image: yummy as NSData) {
            }
            
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
        
        let item = self.suggestedProduct
        self.context.delete(item!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
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
    
    
    // Dissmiss viewController
    @objc func youAreDismissed() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // UI Picker 2 function
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
    
    
    // UI Picker 3 function
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
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // Alert functions
    func alert() {
        let alert = UIAlertController(title: "Possums!", message: "Your product has been updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Radical", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // Animation function
    func tickTockTickTock(){
        let tick = AnimationView(name: "Accepted")
        //animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tick.contentMode = .scaleAspectFit
        tick.frame = successAnimation.bounds
        
        successAnimation.addSubview(tick)
        tick.play()
    }


}
