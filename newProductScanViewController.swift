//
//  newProductScanViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 14/5/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import XLPagerTabStrip
import Lottie


class newProductScanViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, IndicatorInfoProvider  {

    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var productImage: UIStackView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDescription: UITextField!
    @IBOutlet weak var productCategory: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productBarcode: UITextField!
    @IBOutlet weak var inventorySlider: UISlider!
    @IBOutlet weak var inventoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurredBackground: UIImageView!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var successAnimation: UIView!
    @IBOutlet weak var productAddedText: UILabel!
    @IBOutlet weak var photoButton: UIImageView!
    @IBOutlet weak var viewStack: UIView!
    @IBOutlet weak var stachView: UIStackView!
    @IBOutlet weak var addProductButton: UIButton!
    
    // Variables
    var imagePicker:UIImagePickerController!
    var categories =  ["Coffee","Drinks","Food","Household Items","Stationary"]
    
    var newImage: UIImage?
    var productTitle: String = ""
    var priceTitle: String = ""
    var categoryTitle: String = ""
    var inventoryAmount: String = ""
    var nameProduct: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide keyboard
        hideKeyboardOrangutan()
        
        // Design parameters
        jackOlanternIsTheRealPumpkin()
        
        // Image picker
        pickMepickMe()
        
    }
    
    
    // Image picker function 1
    func pickMepickMe (){
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        photoButton.isUserInteractionEnabled = true
        photoButton.addGestureRecognizer(imageTap)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        productCategory.inputView = pickerView
        pickerView.backgroundColor = .white
        pickerView.setValue(UIColor(red:0.19, green:0.24, blue:0.32, alpha:1.0), forKeyPath: "textColor")
        
        self.imagePicker.allowsEditing = true
    }
    
    
    // Inventory slider function
    @IBAction func inventorySlider(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        inventoryAmount = String(describing: currentValue)
        inventoryLabel.text = String(describing: currentValue)
        
    }
    
    @IBAction func sliderValueChange(_ sender: Any) {
        
    }
    
    
    // Dissmiss viewController
    @objc func youAreDismissed() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // Save new product function
    @IBAction func saveProductButton(_ sender: Any) {
        let picture: NSData = UIImagePNGRepresentation(imageView.image!)! as NSData
        var barcode: String = ""
        
        if productBarcode.text!.isEmpty {
            barcode = "000000"
            
        } else {
            barcode = productBarcode.text!
        }
        
        if (productName.text != nil) && productPrice.text != "" {
            if constantProducts.saveObject(name: productName.text!, price: Int(productPrice.text!)!, category: productCategory.text!, size: productDescription.text!, inventory: Int(inventoryAmount)!, barcode: barcode, image: picture as NSData ) {
                
                for Products in constantProducts.fetchObject()! {
                }
                
                // Animation shenanigans
                blurredBackground.frame = self.view.bounds
               // blurredBackground.blurImageDark()
                self.view.addSubview(self.blurredBackground)
                blurredBackground.isHidden = false
                
                self.view.addSubview(self.popUp)
                popUp.isHidden = false
                popUpImage.isHidden = false
                
                self.view.addSubview(self.successAnimation)
                successAnimation.isHidden = false
                tickTockTickTock()
                
                let timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
            }
        }
        popUpImage.image = UIImage(data: picture as Data)
        productAddedText.text = "\(nameProduct) has been added to your products"
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
    
    
    // Design parameters function
    func jackOlanternIsTheRealPumpkin() {
        //addToMYProductsButton.backgroundColor = UIColor.actionBlue
        popUp.layer.cornerRadius = 15
        popUpImage.layer.cornerRadius = 15
        addProductButton.layer.cornerRadius = 10
        popUp.isHidden = true
        successAnimation.isHidden = true
        blurredBackground.isHidden = true
        viewStack.isHidden = true
        fullView.layer.cornerRadius = 10
        stachView.dropShadowLight()
        fullView.cards()
        
        sliderValueChange(self)
        
        // Text field borders
        productName.addBottomBorder()
        productDescription.addBottomBorder()
        productCategory.addBottomBorder()
        productPrice.addBottomBorder()
        productBarcode.addBottomBorder()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)

    }
    
    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "MANUAL ENTRY")
        
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
    
    
    // Image picker function 2
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
    
    
    // Image picker function 3
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.imageView.image = pickedImage
            viewStack.isHidden = false
            //photoButton.isHidden = true
        } else{
            
            self.imageView.image = newImage
            viewStack.isHidden = false
            //photoButton.isHidden = true
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

}
