//
//  smallChangeViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 13/5/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Lottie
import Stripe

class smallChangeViewController: UIViewController {

    // Variables
    var imageName: String!
    var amountTransfer: String = ""
    var transactionType: String! = ""
    var amountStripe: String = ""
    
    var amount:String = ""
    var type: String = ""
    var companyName: String = ""
    var companyID: String = ""
    
    var skinnyPete = NSMutableAttributedString()
    
    // Date & Time variables
    let date = Date()
    let formatter = DateFormatter()
    let formatterTime = DateFormatter()
    
    // Calculator Variables
    var number  = 0
    var change = 0
    var cunt: String = "0"
    var hider = ""
    
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var calculateChangeView: UIView!
    @IBOutlet weak var amountDueLabel: UILabel!
    @IBOutlet weak var changeDueLabel: UILabel!
    @IBOutlet weak var amountReceivedLabel: UILabel!
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var newPrice: UITextField!
    @IBOutlet weak var blueView: UIView!

    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var blurredButton: UIButton!
   
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var barcodeTextField: UITextField!
    
    @IBOutlet weak var sameAmountButton: UIButton!
    @IBOutlet weak var roundAmountButton: UIButton!
    @IBOutlet weak var qrCodeView: UIImageView!
    
    // Checkout buttons
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var tabButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide keyboard
        hideKeyboardOrangutan()
        
        // Design
        cheapAsLou()
        generateTheQtoTheCode()
        
        // Data
        skinnyAndFat()
        labelButtons()
         whatsTheDate()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        ahoi()
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.barcodeTextField.becomeFirstResponder()
        }
    }

    
    // QR code funciton
    func generateTheQtoTheCode() {
        let amountForCode = amountDueLabel.text!.dropFirst(4)
        let amountNoDecimals = amountForCode.dropLast(2)
        let count = amountForCode.count
        let countString = String(describing: count)
        
        let code = "00020101021226710019ID.CO.TELKOMSEL.WWW011893600911002162700102151802110116270010303UME30660016ID.CO.YOUTAP.WWW0118936099990000001002021362811801033000303UME51450015ID.OR.GPNQR.WWW02151802110116270010303UME520411115802ID5913WARUNG MAHUHU6015Jakarta Selatan61051219062840119670667528393791941807166F7D1AB79228EAFF98370016ID.CO.YOUTAP.WWW021362811801033005303360540\(countString)\(amountForCode)047BF1"

        let image = generateQRCode(from: code)
        qrCodeView.image = image
    }
    
    
    // QR code generator function
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
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
        
        //changeDueLabel.text = amountDueLabel.text
        sameAmountButton.setTitle("\(amountNoCC)", for: UIControlState.normal)
        roundAmountButton.setTitle("\(fuckingShitCunt)K", for:UIControlState.normal)
        sameAmountButton.tag = Int(doubleConvert!)
        roundAmountButton.tag = Int(pooPeePoo)
        amountTransfer = amountDueLabel.text!
    }
    
    
    // Text design parameters and data transfer
    func skinnyAndFat() {
        let nextAmount = amount
        skinnyPete = NSMutableAttributedString(string: nextAmount, attributes: [NSAttributedStringKey.font: UIFont (name: "Ubuntu-Bold", size: 40)!])
        skinnyPete.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Ubuntu-Light", size: 20.0)!, range: NSRange(location:0, length:3))
        
        amountDueLabel.attributedText = skinnyPete
        amountDueLabel.text = nextAmount
        amountTransfer = amount
        transactionType = type
        
        let stripeAmount = String(nextAmount.dropFirst(4))
        amountStripe = stripeAmount
        print(amountStripe)
        
      //  self.navigationController?.navigationBar.tintColor = UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0)
     //   self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    
    // Live text function
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let money = "IDR \(newPrice.text!)"
        newPrice.text = money
        
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
        calculateChangeView.isHidden = false
        
    }
    
    
    // Calculator Buttons functions
    func calculameEstaPuto() {
        let changeNo = amountDueLabel.text
        let changeNoSymbol = changeNo?.dropFirst(4)
        let changeCunt = Int(cunt)
        let result = (Int(changeNoSymbol!)! - changeCunt!)*(-1)
        
        changeDueLabel.text = "IDR \(String(result))"
    }
    
    // Calculate change button
    @IBAction func calculateButton(_ sender: Any) {
        calculateChangeView.isHidden = !calculateChangeView.isHidden
    }
    
    
    // Pay button
    @IBAction func payButton(_ sender: Any) {
        self.performSegue(withIdentifier: "paySegue", sender: self)
        
    }
    
    // Tab button
    @IBAction func tabButton(_ sender: Any) {
        self.performSegue(withIdentifier: "tabSegue", sender: self)
    }
    
    
    // Card button
    @IBAction func cardButton(_ sender: Any) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        //navigationController?.pushViewController(addCardViewController, animated: false)
   
       let navigationControllers = UINavigationController(rootViewController: addCardViewController)
        present(navigationControllers, animated: true, completion: nil)
        
        
    }
    
    
    // Other button action
    @IBAction func otherButton(_ sender: Any) {
        blurredView.isHidden = false
        newPrice.text = ""
        letsAllDisappear()
        buttonDeactivated()
    }
    
    
    // Back button
    @IBAction func backButton(_ sender: Any) {
         dismiss(animated: false, completion: nil)
    }
    
    
    // Cash button
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
  

    // Scan button
    @IBAction func scanButton(_ sender: Any) {
        self.performSegue(withIdentifier: "scanSegue", sender: self)
        
    }
    
    
    // Data transfer segue functions ----->
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is confirmedPaymentViewController {
            let vc = segue.destination as! confirmedPaymentViewController
            vc.amount = amountTransfer
            vc.transaction = "Cash Payment"
            vc.type = transactionType
            vc.companyName = companyName
            vc.companyID = companyID
        }
        
        if segue.destination is scannToPayViewController {
            let vc = segue.destination as! scannToPayViewController
            vc.amountToPay = amount
        }
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
    
    // Date & time function
    func whatsTheDate(){
        formatter.dateFormat = "dd.MM.yyyy"
        formatterTime.timeStyle = .medium
        
        let result = formatter.string(from: date)
        let resultTime = formatterTime.string(from: date)
        
        currentDate.text = result
        currentTime.text = resultTime
        
    }
    
    
     // QR code handheld scanner
    func ahoi() {
        barcodeTextField.addTarget(self, action: #selector(testText(textField:)), for: .editingChanged)
        
        tickTockTickTock()
    }
    
    @objc func testText(textField: UITextField) {
       animationView.isHidden = false
        qrCodeView.isHidden = true
        let cuntNumbers = barcodeTextField.text?.count
        
        if cuntNumbers == 343 {
            self.performSegue(withIdentifier: "paySegue", sender: self)
          
            barcodeTextField.text  = ""
        } else {
            
        }
    }
 
    
    // Animation function
    func tickTockTickTock(){
        let tick = AnimationView(name: "loading")
        //animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tick.contentMode = .scaleAspectFit
        tick.frame = animationView.bounds
        
        animationView.addSubview(tick)
        tick.play(fromProgress: 0,
                  toProgress: 1,
                  loopMode: LottieLoopMode.loop,
                  completion: { (finished) in
                    if finished {
                        print("Animation Complete")
                    } else {
                        print("Animation cancelled")
                    }
        })
        
    }
    
    
    // Design Parameters
    func cheapAsLou() {
        blurredView.isHidden = true
        calculateChangeView.isHidden = true
        newPrice.layer.cornerRadius = 8
        blueView.layer.cornerRadius = 10
        newPrice.setLeftPaddingPoints(15)
        okButton.layer.cornerRadius = 10
        blurredButton.layer.cornerRadius = 10
        animationView.isHidden = true
            self.navigationController?.navigationBar.tintColor = UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0)
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        
    }
   

}



extension smallChangeViewController: STPAddCardViewControllerDelegate {
   
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        StripeClient.shared.completeCharge(with: token, amount: Int(amountStripe)! / 100) { result in
            
            switch result {
            
            case .success:
                completion(nil)
                
                self.performSegue(withIdentifier: "paySegue", sender: self)
                
                let alertController = UIAlertController(title: "Congrats", message: "You've been scammed by Honcho!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    //self.performSegue(withIdentifier: "receiptSegue", sender: self)
                    //self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
           
            case .failure(let error):
                completion(error)
              
            }
        }
    }
    
    
}

