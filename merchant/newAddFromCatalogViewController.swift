//
//  newAddFromCatalogViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 15/5/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import Lottie

class newAddFromCatalogViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {

    // Variables
    var product: productsCatalogAll?
    var savedPrice: String = ""
    var inventoryAmount: String = ""
    var SKU: String = ""
    var nameProduct: String = ""
    var size: String = ""
    var cat: String = ""
    
    // UI Picker
    var categories = ["Coffee","Drinks","Food","Household Items","Stationary"]
    
    
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
    @IBOutlet weak var addProductsButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide keyboard
        hideKeyboardOrangutan()
        
        // Design parameters
        self.title = product?.name
        ohNohTheAmericansAreHere()
        
        // Image picker function
        imagePickerOne()
        
        // Load data
        whatYaSellingUz()
        inventoryAmount = "1"
        
    }
    
    // Image Picker one function
    func imagePickerOne() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        //productCategory.inputView = pickerView
        pickerView.backgroundColor = .white
        pickerView.setValue(UIColor(red:0.19, green:0.24, blue:0.32, alpha:1.0), forKeyPath: "textColor")
    }
    
    
    // Data transfer function (receiving)
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> newAddFromCatalogViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "newAddFromCatalogViewController") as! newAddFromCatalogViewController
        return controller
    }
    
    
    // Show data function
    func whatYaSellingUz() {
        let url = URL(string: (product?.productImageRectangle)!)
        let price = product!.suggestedPrice
        let pricePrice = "IDR \(String(describing: price))"
        
        let sku = product!.unitSKU
        SKU = sku
        
        productName.text = product?.name
        productPrice.text = pricePrice
        productBarcode.text = product?.unitSKU
        productDescription.text = product?.size
        productImage?.kf.setImage(with: url)
        
        nameProduct = product?.name ?? "Product"
        cat = product?.category ?? "Category"
        size = product?.size ?? "Size"
    
        //productCategoryAndSize.text = "\(size) | \(cat)"
        productCategory?.text = cat
        
        savedPrice = String(describing: price)
        popUpImage?.kf.setImage(with: url)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    // Inventory slider function
    @IBAction func inventorySlider(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        //addProductsButton.setTitle("Add \(currentValue) to my products", for: .normal)
        inventoryAmount = String(describing: currentValue)
        inventoryLabel.text = "\(String(describing: currentValue)) items"
    }
    
    @IBAction func sliderValueChange(_ sender: Any) {
        
    }
    
    
    // Add to myProducts function
    @IBAction func addProductButton(_ sender: Any) {
        let picture: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        var price: String = ""
        
        price = productPrice.text!
        let cleanPrice = price.dropFirst(4)
        
        if (productName.text != nil) /*&& productDescription.text != ""*/ {
            if constantProducts.saveObject(name: productName.text!, price: Int(cleanPrice)!, category: productCategory?.text ?? "uncategorized" , size: productDescription.text ?? "", inventory: Int(inventoryAmount)! , barcode: SKU, image: picture as NSData ) {
                
            }
            
            // Animation shenanigans
            blurredBackground.frame = self.view.bounds
            //blurredBackground.blurImageDark()
            self.view.addSubview(self.blurredBackground)
            blurredBackground.isHidden = false
            
            self.view.addSubview(self.popUp)
            popUp.isHidden = false
            successAnimation.isHidden = false
            productAdded.isHidden = false
            popUpImage.isHidden = false
            
            self.view.addSubview(self.successAnimation)
            successAnimation.isHidden = false
            tickTockTickTock()
            
            _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
        }
        
        productAdded.text = "\(nameProduct) has been added to your products"
        print("it works")
    }
    
    
    // Save button function
    @objc func saveButton(){
        let picture: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        var price: String = ""
        
        price = productPrice.text!
        let cleanPrice = price.dropFirst(4)
        
        if (productName.text != nil) /*&& productDescription.text != ""*/ {
            if constantProducts.saveObject(name: productName.text!, price: Int(cleanPrice)!, category: productCategory?.text ?? "uncategorized" , size: size, inventory: Int(inventoryAmount)! , barcode: SKU, image: picture as NSData ) {
        
            }
            
            // Animation shenanigans
            blurredBackground.frame = self.view.bounds
            blurredBackground.blurImageDark()
            self.view.addSubview(self.blurredBackground)
            blurredBackground.isHidden = false
            
            self.view.addSubview(self.popUp)
            popUp.isHidden = false
            successAnimation.isHidden = false
            productAdded.isHidden = false
            popUpImage.isHidden = false
            
            self.view.addSubview(self.successAnimation)
            successAnimation.isHidden = false
            tickTockTickTock()
            
            _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
        }
        
        productAdded.text = "\(nameProduct) has been added to your products"
        print("it works")
    }
    
    
    // Design Parameters function
    func ohNohTheAmericansAreHere() {
        popUp.layer.cornerRadius = 15
        popUpImage.layer.cornerRadius = 15
        addProductsButton.layer.cornerRadius = 10
        successAnimation.isHidden = true
        blurredBackground.isHidden = true
        popUp.isHidden = true
        successAnimation.isHidden = true
        popUpImage.isHidden = true
        sliderValueChange(self)
        productImage.backgroundColor = UIColor.white
        fullView.dropShadowLight()
        fullView.cards()
        
        // Text fields borders
        productName.addBottomBorder()
        productDescription.addBottomBorder()
        productCategory.addBottomBorder()
        productPrice.addBottomBorder()
        productBarcode.addBottomBorder()

        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
    //    self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton)), animated: true)
    }
    
    // Animation function
    func tickTockTickTock(){
        let tick = AnimationView(name: "Accepted")
        tick.contentMode = .scaleAspectFit
        tick.frame = successAnimation.bounds
        
        successAnimation.addSubview(tick)
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
    
    
    // UI Picker 2 function
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
  

}
