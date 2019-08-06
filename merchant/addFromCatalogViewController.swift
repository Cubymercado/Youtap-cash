//
//  addFromCatalogViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 30/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import Lottie

class addFromCatalogViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCategoryAndSize: UILabel!
    @IBOutlet weak var productBarcode: UITextField!
    @IBOutlet weak var newProductPrice: UITextField!
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var successAnimation: UIView!
    @IBOutlet weak var blurredBackground: UIImageView!
    @IBOutlet weak var productInventory: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var productAddedLabel: UILabel!
    @IBOutlet weak var popUpBg: UIView!
    @IBOutlet weak var productSuccess: UILabel!
    @IBOutlet weak var popUpImage: UIImageView!
    
    // Variables
    var categories =  ["Biscuits","Chocolate","Coffee","Cooking","Crackers","Chips","Drinks","Food","Household","Milk","Noodles", "Personal Care", "Seasonings", "Stationary"]

    var product: productsCatalogAll?
    var savedPrice: String = ""
    var inventoryAmount: String = ""
    var SKU: String = ""
    var nameProduct: String = ""
    var size: String = ""
    var cat: String = ""
    
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
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
     
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
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> addFromCatalogViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "addFromCatalogViewController") as! addFromCatalogViewController
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
        productDescription.text = product?.description
        productImage?.kf.setImage(with: url)
        
        nameProduct = product?.name ?? "Product"
        cat = product?.category ?? "Category"
        size = product?.size ?? "Size"
        
        productCategoryAndSize.text = "\(size) | \(cat)"
        
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
        
        addProductButton.setTitle("Add \(currentValue) to my products", for: .normal)
        inventoryAmount = String(describing: currentValue)
        productInventory.text = "\(String(describing: currentValue)) items"
    }
    
    @IBAction func sliderValueChange(_ sender: Any) {
        
    }
    
    
    // Add to myProducts function
    @IBAction func addProductButton(_ sender: Any) {
        let picture: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        var price: String = ""
    
        if newProductPrice.text!.isEmpty {
        price = savedPrice
            
        } else {
            price = newProductPrice.text!
            
        }
        
        if (productName.text != nil) /*&& productDescription.text != ""*/ {
            if constantProducts.saveObject(name: productName.text!, price: Int(price)!, category: cat, size: size, inventory: Int(inventoryAmount)! , barcode: SKU, image: picture as NSData ) {
    
                }
            
            // Animation shenanigans
            blurredBackground.frame = self.view.bounds
            blurredBackground.blurImageDark()
            self.view.addSubview(self.blurredBackground)
            blurredBackground.isHidden = false
            
            self.view.addSubview(self.popUpBg)
            popUpBg.isHidden = false
            productSuccess.isHidden = false
            productAddedLabel.isHidden = false
            popUpImage.isHidden = false
            
            self.view.addSubview(self.successAnimation)
            successAnimation.isHidden = false
            tickTockTickTock()
            
            _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
        }
        
        productSuccess.text = "\(nameProduct) has been added to your products"
        print("it works")
    }
    
    
    // Design Parameters function
    func ohNohTheAmericansAreHere() {
        popUpBg.layer.cornerRadius = 15
        popUpImage.layer.cornerRadius = 15
        newProductPrice.layer.cornerRadius = 10
        addProductButton.layer.cornerRadius = 10
        successAnimation.isHidden = true
        blurredBackground.isHidden = true
        productAddedLabel.isHidden = true
        popUpBg.isHidden = true
        productSuccess.isHidden = true
        popUpImage.isHidden = true
        sliderValueChange(self)
        productImage.backgroundColor = UIColor.white
        
        // Text field style
        newProductPrice.aroundTheCornerIsThePub()
        productBarcode.aroundTheCornerIsThePub()
        
        newProductPrice.setLeftPaddingPoints(15)
        productBarcode.setLeftPaddingPoints(15)
        
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
        productCategoryAndSize.text = categories[row]
    }
    
}
    
    





