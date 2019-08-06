//
//  orderProductViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 23/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class orderProductViewController: UIViewController, UITextFieldDelegate {

    // Variables
    var product: suppliersProducts?
    var inventoryAmount: String = ""
    var calculationPrice: String = ""
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var singleItemPrice: UILabel!
    @IBOutlet weak var suggestedPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide keyboard
        hideKeyboardOrangutan()
        
        // Load data
        whatYaSellingUz()
        
        // Design parameters
        ohNohTheAmericansAreHere()
        pricePricePricePrice()
       
        
    }
    
    
    // Show data function
    func whatYaSellingUz() { 
        let url = URL(string: (product?.productImageRectangle)!)
        
        let price = product!.unitPrice
        let pricePrice = "IDR \(String(describing: price))"
        
        let suggestedPrices = product!.suggestedPrice
        let suggested = "IDR \(String(describing: suggestedPrices))"
        
        productName.text = product?.name
        productPrice.text = pricePrice
        productSize.text = product?.size
        singleItemPrice.text = pricePrice
        suggestedPrice.text = suggested
        productDescription.text = product?.description

        productImage?.kf.setImage(with: url)
        
        calculationPrice = String(describing: price)
        
    }
    
    // Data transfer function (receiving)
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> orderProductViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "orderProductViewController") as! orderProductViewController
        return controller
    }
    
    
    // Add to products button
    @IBAction func addToProducts(_ sender: Any) {
   
       let picture: NSData = UIImagePNGRepresentation(productImage.image!)! as NSData
        let price = product!.unitPrice
        let pricePrice = "IDR \(String(describing: price))"
        
        if (product?.name != nil) && pricePrice != "" {
            if constantCart.saveObject(product: (product?.name)!, price: (product?.unitPrice)!, inventory: Int(inventoryAmount)!, productImage: picture as NSData, productDescription: (product?.size)!, documentID: "testProducts" ) {
                
            }
            
        }
        
       navigationController?.popViewController(animated: false)
    }
    
    
    // Slider function and maths
    @IBAction func inventorySlider(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        addToCartButton.setTitle("Add \(currentValue) to cart", for: .normal)
        
        let price = calculationPrice
        let moneys = Int(price)!
        let total = moneys * currentValue
        
        totalPrice.text = "IDR \(String(describing: total))"
        inventoryAmount = String(describing: currentValue)
    }
    
    
    // Design Parameters function
    func ohNohTheAmericansAreHere() {
        addToCartButton.backgroundColor = UIColor.actionBlue
        addToCartButton.contentEdgeInsets.left = 20
       // successAnimation.isHidden = true
       // blurredBackground.isHidden = true
        
    }

    // Start price
    func pricePricePricePrice(){
        inventoryAmount = "1"
        totalPrice.text = "IDR \(calculationPrice)"
        
    }
   

}
