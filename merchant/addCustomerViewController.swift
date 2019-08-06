//
//  addCustomerViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 7/02/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import Lottie

class addCustomerViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tabImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var photoButton: UIImageView!
    @IBOutlet weak var addTabButton: UIButton!
    @IBOutlet weak var blurredBackground: UIImageView!
    @IBOutlet weak var successAnimation: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var viewStack: UIView!
    
    
    // Variables
    var imagePicker:UIImagePickerController!
    var newImage: UIImage?
    
    // Date & Time variables
    let date = Date()
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide keyboard
        hideKeyboardOrangutan()
    
        // Design parameters
        jaquesCusteauTheFrench()
        pickMepickMe()
        
        // Date function
        tellMeTheTimeJimbo()
        
    }
    
    
    // Add button function / save data
    @IBAction func addButton(_ sender: Any) {
        var picture = NSData()
        let date = NSDate()
        var address: String = ""
        let uuid = NSUUID().uuidString.lowercased()
        
        if addressField.text!.isEmpty {
            address = "Address not provided"
            
        } else {
            
            address = addressField.text!
        }
        
        if stackView.isHidden {
            picture = UIImagePNGRepresentation(tabImage.image!)! as NSData
           
        } else {
             picture = UIImagePNGRepresentation(#imageLiteral(resourceName: "profile-profile"))! as NSData
            
        }
        
    
        let name = nameField.text
        let phone = phoneNumberField.text
        let email = emailField.text
        
        
     // Save to customers
        let customerSave = Customers(name: name, customerId: uuid, phone: phone, address: address, email: email, picture: picture as NSData, date: date)
        
        do {
            try customerSave?.managedObjectContext?.save()
           // self.navigationController?.popViewController(animated: true)
            
           // Animation shenanigans
           partyPartyJimboRee()
            
        }catch{
            print("Could not save category")
        }
    
    }
    
    // Dissmiss viewController
    @objc func youAreDismissed() {
        dismiss(animated: false, completion: nil)
    }
    
    
    // Back Button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    // Image picker function
    func pickMepickMe (){
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        photoButton.isUserInteractionEnabled = true
        photoButton.addGestureRecognizer(imageTap)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.imagePicker.allowsEditing = true
    }
    
    
    // Image picker function 2
    @objc func openImagePicker(_ sender:Any) {
        let alert = UIAlertController(title: "Select an image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { _ in self.openCamera() }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in self.openGallary() }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
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
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
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
            
            self.tabImage.image = pickedImage
            viewStack.isHidden = false
            
        } else{
            
            self.tabImage.image = newImage
            viewStack.isHidden = false
            
        }
        picker.dismiss(animated: true)
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
    
    
    // Date funciton
    func tellMeTheTimeJimbo() {
    formatter.dateFormat = "dd.MM.yyyy"
     let result = formatter.string(from: date)
    
    }
    
    
    // Design parameters function
    func jaquesCusteauTheFrench() {
        addTabButton.layer.cornerRadius = 10
        successAnimation.isHidden = true
        blurredBackground.isHidden = true
        viewStack.isHidden = true
        cardView.cards()
        stackView.dropShadowLight()
        
        // Text field borders
        nameField.addBottomBorder()
        phoneNumberField.addBottomBorder()
        emailField.addBottomBorder()
        addressField.addBottomBorder()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
    }
    
    // Animation and segue function
    func partyPartyJimboRee(){
    self.view.addSubview(self.blurredBackground)
    blurredBackground.isHidden = false
        
    self.view.addSubview(self.successAnimation)
    successAnimation.isHidden = false
    tickTockTickTock()
    
    let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(youAreDismissed), userInfo: nil, repeats: false)
    
    }
    
    // Animation funciton
    func tickTockTickTock(){
        let tick = AnimationView(name: "Accepted")
        tick.contentMode = .scaleAspectFit
        tick.frame = successAnimation.bounds
        successAnimation.addSubview(tick)
        tick.play()
    }

}
