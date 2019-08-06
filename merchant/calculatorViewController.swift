//
//  calculatorViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 6/09/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum Operation:String {
    case Add = "+"
    case Minus = "-"
    case Divide = "/"
    case Multiply = "*"
    case NULL = "Null"
}

class calculatorViewController: UIViewController, IndicatorInfoProvider,UITextFieldDelegate {

    // Variables
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var operationDescription = ""
    var multiplyNumber = ""
    var currentOperation: Operation = .NULL
    
    @IBOutlet weak var amountText: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Design parameters
        yawahoo()
        
        // Hide Keyboard
        hideKeyboardOrangutan()
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    // Button function
    func notActiveMyBruh() {
        
    }
    
    
    // Calculator functions start ---- >
    @IBAction func numberPressed(_ sender: UIButton) {
        shakingBunny()
        
        if runningNumber.count <= 8 {
            runningNumber += "\(sender.tag)"
            amountText.text = runningNumber
            amountButton.text = "IDR \(result)"
            multiplyNumber = "\(sender.tag)"
        }
        
        if runningNumber.count <= 1 {
            amountButton.text =  "IDR \(result)"
            multiplyNumber = "\(sender.tag)"
        }
        
        if operationDescription.count <= 4 {
          operationDescription += "\(sender.tag)"
          descriptionLabel.text = operationDescription
            multiplyNumber = "\(sender.tag)"
        }
    }
    
    @IBAction func zeroPressed(_ sender: UIButton) {
        shakingBunny()
        
        let integrerText = amountText.text
        let integrerTextChange = Int(integrerText!)
        let zeroNumbers = integrerTextChange! * 100
        
        if runningNumber.count <= 8 {
            runningNumber = "\(zeroNumbers)"
            amountText.text = runningNumber
            amountButton.text = "IDR \(result)"
        }
        
        if runningNumber.count <= 1 {
            amountButton.text =  "IDR \(result)"
        }
        
        if operationDescription.count <= 4 {
            operationDescription = "\(zeroNumbers)"
            descriptionLabel.text = operationDescription
        }
    }
    
    @IBAction func zerosPressed(_ sender: UIButton) {
        shakingBunny()
        
        let integrerText = amountText.text
        let integrerTextChange = Int(integrerText!)
        let zeroNumbers = integrerTextChange! * 1000
        
        if runningNumber.count <= 8 {
            
            runningNumber = "\(zeroNumbers)"
            amountText.text = runningNumber
            amountButton.text = "IDR \(result)"
        }
        
        if runningNumber.count <= 1 {
            amountButton.text =  "IDR \(result)"
        }
        
        if operationDescription.count <= 4 {
            operationDescription = "\(zeroNumbers)"
            descriptionLabel.text = operationDescription
        }
    }
    
    @IBAction func allClearPressed(_ sender: Any) {
        runningNumber = ""
        operationDescription = ""
        leftValue = ""
        rightValue = ""
        result = ""
        currentOperation = .NULL
        amountText.text = "0"
        descriptionLabel.text = "Enter amount to take payment"
        amountButton.text = "IDR 0"
        
        shakingBunny()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        operation(operation: .Add)
        descriptionLabel.text = "+"
        operationDescription = ""
        
        shakingBunny()
    }
    
    @IBAction func minus(_ sender: Any) {
        operation(operation: .Minus)
        descriptionLabel.text = "-"
        operationDescription = ""
        
        shakingBunny()
    }
    
    @IBAction func equal(_ sender: Any) {
        operation(operation: currentOperation)
        descriptionLabel.text = "="
        
        shakingBunny()
    }
    
    func operation(operation: Operation) {
        if currentOperation != .NULL {
            if runningNumber != "" {
                rightValue = runningNumber
                runningNumber = ""
                
                if currentOperation == .Add {
                    result = "\(Double(leftValue)! + Double(rightValue)!)"
                }
                
                else if currentOperation == .Minus {
                        result = "\(Double(leftValue)! - Double(rightValue)!)"
                    
                }
                
                leftValue = result
                    
                if (Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
                    result = "\(Int(Double(result)!))"
                }
                
                amountText.text = result
               amountButton.text = "IDR \(result)"
                
            }
            
            currentOperation = operation
            
        }else {
                
            leftValue = runningNumber
            runningNumber = ""
            currentOperation = operation
            
        }
    }
        
    // < --- Calculator functions finish
    
    // Heptic feel
    func shakingBunny() {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
    }
    
    // Pay button action
    @IBAction func payButton(_ sender: Any) {
        self.performSegue(withIdentifier: "paySegue", sender: self)
        
    }
    
    // Data transfer (send)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is smallChangeViewController
        {
            
            let vc = segue.destination as? smallChangeViewController
            vc?.amount = "IDR \(amountText.text!)"
            vc?.type = "Product Payment"
            
        }
        
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
    
    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "TILL")
        
    }
    
    // Design parameters funciton
    func yawahoo(){
        amountText.text = "0"
        descriptionLabel.text = "Enter amount to take payment"
        payButton.contentEdgeInsets.left = 45
        payButton.buttonCornersFour()
        
    }
    
  

}
