//
//  newScanProductAddViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 15/5/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import Lottie
import Firebase

class newScanProductAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var viewStack: UIView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDescription: UITextField!
    @IBOutlet weak var productCategory: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productBarcode: UITextField!
    @IBOutlet weak var inventorySlider: UISlider!
    @IBOutlet weak var inventoryLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var photoButton: UIImageView!
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var blurredBackground: UIImageView!
    @IBOutlet weak var successAnimation: UIView!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var productAdded: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mainView: UIView!
    
    
    
    // Variables
    var imagePicker:UIImagePickerController!
    var barcodeProduct: String = ""
    var inventoryAmount: String = ""
    var categories =  ["Coffee","Drinks","Food","Household Items","Stationary"]
    var products:  [productsCatalogAll] = []
    
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
        productBarcode.text = barcodeProduct
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if productName.text!.isEmpty {
            
        } else {
            self.title = productName.text
        }
    }

    
    // Image Picker one function
    func imagePickerOne() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
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
        inventoryAmount = String(describing: currentValue)
        inventoryLabel.text = "\(String(describing: currentValue)) items"
        
    }
    
    @IBAction func sliderValueChange(_ sender: Any) {
        
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
    
    
    // Design parameters function
    func theyreTakingTheHobbitsToIzengard(){
        popUp.layer.cornerRadius = 15
        popUp.layer.cornerRadius = 15
        popUpImage.layer.cornerRadius = 15
        addProductButton.layer.cornerRadius = 10
        successAnimation.isHidden = true
        blurredBackground.isHidden = true
        popUp.isHidden = true
        viewStack.isHidden = true
        fullView.layer.cornerRadius = 10
        viewStack.dropShadowLight()
        mainView.cards()
        
        sliderValueChange(self)
        
        // Text fields bottom border
        productName.addBottomBorder()
        productDescription.addBottomBorder()
        productCategory.addBottomBorder()
        productPrice.addBottomBorder()
        productBarcode.addBottomBorder()
        
         self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
    
    }
    
    
    // Save button function
    @IBAction func saveButton(_ sender: Any) {
        let picture: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        
        if (productName.text != nil) && productPrice.text != "" {
            if constantProducts.saveObject(name: productName.text!, price: Int(productPrice.text!)!, category: productCategory.text!, size: productDescription.text!, inventory: Int(inventoryAmount)!, barcode: barcodeProduct, image: picture as NSData ) {
                
                // Animation shenanigans
                blurredBackground.frame = self.view.bounds
             //   blurredBackground.blurImageDark()
                self.view.addSubview(self.blurredBackground)
                blurredBackground.isHidden = false
                
                self.view.addSubview(self.popUp)
                popUp.isHidden = false
                popUp.isHidden = false
                
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
            viewStack.isHidden = false
            
            
        } else{
            
        }
        
        picker.dismiss(animated: true)
        
        
    }
   

}
