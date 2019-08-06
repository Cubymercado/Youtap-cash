//
//  changeViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 28/01/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Lottie

class changeViewController: UIViewController {

    // Variables
    var companyName: String = ""
    var companyID: String = ""
    var imageName: String!
    var amountTransfer: String = ""
    var transactionType: String! = ""

    
    // Calculator Variables
    var number  = 0
    var change = 0
    var cunt: String = "0"
    var hider = ""
    
    
    @IBOutlet weak var amountDueLabel: UILabel!
    @IBOutlet weak var changeDueLabel: UILabel!
    @IBOutlet weak var sameAmountButton: UIButton!
    @IBOutlet weak var roundedAmountButton: UIButton!
    @IBOutlet weak var imageAnimation: UIImageView!
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var newPrice: UITextField!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var newWhiteAmount: UILabel!
    @IBOutlet weak var changeDueTextl: UILabel!
    @IBOutlet weak var amountReceivedLabel: UILabel!
    @IBOutlet weak var amountReceivedText: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide Keyboard
        hideKeyboardOrangutan()
        
        // Data
        slidingSidewaysJimmy()
         labelButtons()
        
        // Design
        cheapAsLou()
        
        // Animation
        iLikeToMoveItMoveIt()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
     
    // Data across tabBar function
    func slidingSidewaysJimmy() {
        let tabbar = tabBarController as! SelectViewController
        let nextAmount = String(describing: tabbar.amount) 
        amountTransfer = String(describing: tabbar.amount)
        amountDueLabel.text = nextAmount
        transactionType = String(describing: tabbar.type)
        companyName = String(describing: tabbar.companyName)
        companyID = String(describing: tabbar.companyID)
        
    }

    
    // Button labels text
    func labelButtons (){
        // Same variables
        let  amount = amountDueLabel.text
        let amountNoC = amount?.dropFirst(4)
        let doubleConvert = Double(amountNoC!)
        let amountNoCC = String(amountNoC!)
        
        // Rounded variables
        let roundedNumber = doubleConvert?.rounded(.awayFromZero)
        let pooPeePoo = roundedNumber! + 1000
        let roundedString = String(pooPeePoo)
        let droppedString = roundedString.dropLast(2)
        let fuckingShitCunt = String( droppedString)
        
        changeDueLabel.text = amountDueLabel.text
        sameAmountButton.setTitle("\(amountNoCC)K", for: UIControlState.normal)
        roundedAmountButton.setTitle("\(fuckingShitCunt)K", for:UIControlState.normal)
        sameAmountButton.tag = Int(doubleConvert!)
        roundedAmountButton.tag = Int(pooPeePoo)
        amountTransfer = amountDueLabel.text!
   
    }
    
 
    // Live text function
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let money = "IDR \(newPrice.text!)"
        newWhiteAmount.text = money
        
        return true
    }
    
    
    // Deactivated Button function
    func buttonDeactivated(){
        [newPrice].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        okButton.isEnabled = false
        okButton.backgroundColor = UIColor.lightGray
        
    }
    
    
    // Activate Confirm Button function
    @objc func editingChanged(_ textField: UITextField) {
        if newPrice.text?.characters.count == 3 {
            if newPrice.text?.characters.first == " " {
                newPrice.text = ""
                
                return
            }
        }
        guard
            let confirm = newPrice.text, !confirm.isEmpty
            
            else {
                self.okButton.isEnabled = false
                return
        }
        okButton.isEnabled = true
        okButton.backgroundColor = UIColor.electricGreen
    }
 
    
    // Calculator functions start ---- >
    @IBAction func numberPressed(_ sender: UIButton) {
        number = Int( cunt)!
        cunt = String(number + sender.tag)
        self.amountReceivedLabel.text = "IDR \(cunt)"
        
       calculameEstaPuto()
        
        changeDueLabel.isHidden = false
        amountReceivedLabel.isHidden = false
        amountReceivedText.isHidden = false
        changeDueTextl.isHidden = false

    }

    
    // Calculator Buttons functions
    func calculameEstaPuto() {
        let changeNo = amountDueLabel.text
        let changeNoSymbol = changeNo?.dropFirst(4)
        let changeCunt = Int(cunt)
        let result = (Int(changeNoSymbol!)! - changeCunt!)*(-1)
        
        changeDueLabel.text = "IDR \(String(result))"
        
    }
    
    
    // Pay button action
    @IBAction func payButton(_ sender: Any) {
        self.performSegue(withIdentifier: "paySegue", sender: self)
        
    }
    

    // Data Transfer (send)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is confirmedPaymentViewController
        {
            let vc = segue.destination as! confirmedPaymentViewController
            vc.amount = amountTransfer
            vc.transaction = "Cash Payment"
            vc.type = transactionType
            vc.companyName = companyName
            vc.companyID = companyID
        }
    }
    
    
    // Other button action
    @IBAction func otherButton(_ sender: Any) {
        blurredView.isHidden = false
        newPrice.text = ""
        letsAllDisappear()
        buttonDeactivated()
    }
    
    
    // OK New Amount button action
    @IBAction func okButton(_ sender: Any) {
        blurredView.isHidden = true
        cunt = newPrice.text!
        self.amountReceivedLabel.text = "IDR \(cunt)"
        
        let changeNo = amountDueLabel.text
        let changeNoSymbol = changeNo?.dropFirst(4)
        let result = (Int(changeNoSymbol!)! - number)
        
        changeDueLabel.text = "IDR \(String(result))"
        
        calculameEstaPuto()
    }
    
    
    // Back Button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    // Blurred View dissapear
    func letsAllDisappear() {
        let hideView = UITapGestureRecognizer(target: self, action: #selector(hideIt))
        blurredView.isUserInteractionEnabled = true
        blurredView.addGestureRecognizer(hideView)
    }
    
            @objc func hideIt() {
                    blurredView.isHidden = true
            }
    
    
    // Animation function
    func iLikeToMoveItMoveIt(){
        let dollarMoneys = AnimationView(name: "coins")
        
        dollarMoneys.contentMode = .scaleAspectFit
        dollarMoneys.frame = imageAnimation.bounds
        
        imageAnimation.addSubview(dollarMoneys)
        //dollarMoneys.play()
        dollarMoneys.play(fromProgress: 0,
                                        toProgress: 1,
                                        loopMode: LottieLoopMode.loop,
                                        completion: { (finished) in
                                            if finished {
                                                print("Animation Complete")
                                            } else {
                                                print("Animation cancelled")
                                            }
        })
        
       // dollarMoneys.loopAnimation = true
        
        
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
    
    
    // Design Parameters
    func cheapAsLou() {
        blurredView.isHidden = true
        changeDueLabel.isHidden = true
        amountReceivedLabel.isHidden = true
        amountReceivedText.isHidden = true
        changeDueTextl.isHidden = true
        
        newPrice.layer.cornerRadius = 8
        blueView.layer.cornerRadius = 10
       newPrice.setLeftPaddingPoints(15)
        
    }
    
    
    

}

