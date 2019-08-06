//
//  productQuantityViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 11/09/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit

// Collection View Class
class percentagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
       
        
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.contentView.backgroundColor = UIColor(red:0.97, green:0.33, blue:0.20, alpha:1.0)
                self.amountLabel?.textColor = UIColor.white
                
                
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = UIColor(red:0.91, green:0.94, blue:0.97, alpha:1.0)
                self.amountLabel?.textColor = UIColor(red:0.19, green:0.24, blue:0.32, alpha:1.0)
                
            }
        }
    }
    
}

class productQuantityViewController: UIViewController, UITextFieldDelegate {

    // Data Arrays
    var myCart: Cart!
    var percentageAmounts = [".10",".15",".20","0.25",".30",".40",".50"]
    
    var priceItem: String = ""
    var amount: String = ""
    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productAmountLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newPriceText: UITextField!
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var blueBG: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var whiteAmount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Keyboard
        hideKeyboardOrangutan()
        
        // Design parameters
        theFoxIsDomesticated()
        popUpView.isHidden = true
        
        // Touches functions
        hideItAll()
        
        showMeTheGoodiesTwo(entry: myCart)
        
    }

    
    // Tap gesture recognizer
    func hideItAll() {
        let mightyFinger = UITapGestureRecognizer(target: self, action: #selector(hideThemBottles))
        mightyFinger.numberOfTapsRequired = 1
        self.popUpView.addGestureRecognizer(mightyFinger)
        
    }
    
    @objc func hideThemBottles(recognizer: UITapGestureRecognizer) {
        popUpView.isHidden = true
        
    }
    
    
    // Display product details function
    func showMeTheGoodiesTwo(entry: Cart) {
        
        let name = entry.product
        let quantity = entry.inventory
        let description = entry.productDescription
        let price = entry.price
        
        let image = entry.productImage as Data?
        let xNSNumber = quantity as NSNumber
        let xNSNumberP = price as NSNumber
        let money = "IDR \(xNSNumberP.stringValue)"
        
        productNameLabel!.text = name
        productDescriptionLabel!.text = description
        productAmountLabel!.text = money
        productQuantityLabel!.text = xNSNumber.stringValue
        productImage!.image = UIImage(data:image!)
        
        amount = xNSNumberP.stringValue
       
    }
    
    
    // Live text function
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let money = "IDR \(newPriceText.text!)"
        whiteAmount.text = money
        
        return true
    }
    
    
    // Stepper function
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        productQuantityLabel.text = Int(sender.value).description
        
    }
    
    
    // Cancel Button function
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    
    // Show pop up function
    @IBAction func showPopUpButton(_ sender: Any) {
        popUpView.isHidden = false
        
    }
    
    
    // Update product details
    @IBAction func updateButton(_ sender: Any) {
        
        let amountForCode = productAmountLabel.text
        let dropped = amountForCode!.dropFirst(4)
        
        let newPrice = Int(dropped)!
        let newQuantity = Int(productQuantityLabel.text!)!
        
        myCart?.price = Int32(newPrice )
        myCart?.inventory = Int16(newQuantity )
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController?.popViewController(animated: false)
     self.dismiss(animated: false, completion: nil)
    }

    
    // Ok button function
    @IBAction func okButton(_ sender: Any) {
        
        popUpView.isHidden = true
        
        let money = "IDR \(newPriceText.text!)"
        productAmountLabel.text = money
        
    }
    
    
    // Design parameters function
    func theFoxIsDomesticated(){
        addProductButton.backgroundColor = UIColor.actionBlue
        blueBG.layer.cornerRadius = 10
        okButton.backgroundColor = UIColor.actionBlue
        okButton.layer.cornerRadius = 10
        addProductButton.layer.cornerRadius = 10
        newPriceText.layer.masksToBounds = true
        newPriceText.layer.cornerRadius = 7
        newPriceText.setLeftPaddingPoints(15)
    }
    

    // Keyboard hiding functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -210, up: true)
    
    }


    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -210, up: false)
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


// Collection view delegate
extension productQuantityViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let amountForCode = amount
        
        let priceInt = Double(amountForCode)!
        let percentageInt = Double(percentageAmounts[indexPath.row])!
        let result = priceInt * percentageInt
        let possumMoney = priceInt - Double(result )
        
        let resultString = possumMoney as NSNumber
        
        productAmountLabel.text = "IDR \(resultString.stringValue)"
        
    }
    
    
}

// Collection view dataSource
extension productQuantityViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return percentageAmounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: percentageAmounts[indexPath.item], for: indexPath)
        
    }
}
