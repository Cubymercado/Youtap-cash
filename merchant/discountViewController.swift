//
//  discountViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 25/09/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import Lottie
import GoogleSignIn

// Collection view cell class
class discountCollectionViewCell: UICollectionViewCell {
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
                self.contentView.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.89, alpha:1.0)
                self.amountLabel?.textColor = UIColor(red:0.97, green:0.33, blue:0.20, alpha:1.0)
                
            }
        }
    }
    
}


// Table view cell class
class discountTableViewCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
}


class discountViewController: UIViewController, UITextFieldDelegate {

    // Data Arrays
    var myCart = [Cart]()
    var myCartUz: [Cart] = []
    var percentageAmounts = [".10",".15",".20","0.25",".30",".40",".50", "0"]
    
    var selectedIndex: Int!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var priceItem: String = ""
    var amount: String = ""
    var realAmount: String = ""
    var skinnyPete = NSMutableAttributedString()
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var wgiteView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var newAmountText: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get data
        //amountLabel.text = amount
        skinnyAndFat()
        
        // Design parameters
        crazyCottonEyedJoe()
        iLikeToMoveItMoveIt()
        
        // Hide Keyboard
        hideKeyboardOrangutan()
        
        // Touches functions
        hideItAll()
        fetchData()
        
    }
  
    // Get data from Core Data for tableViewTwo
    func fetchData() {
        do {
            myCart = try context.fetch(Cart.fetchRequest())
            myCartUz = myCart
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Couldn't Fetch Data")
        }
        
        profileName?.text = GIDSignIn.sharedInstance().currentUser.profile.name
        profileEmail?.text = GIDSignIn.sharedInstance().currentUser.profile.email
        print("Jeronimoooo")
    }

    
    // Pay button
    @IBAction func payButton(_ sender: Any) {
        self.performSegue(withIdentifier: "paySegue", sender: self)
        print("hamana hamana hamana hamana, the hamanas come together?")
        
    }
    
    
    // Ok button function
    @IBAction func okButton(_ sender: Any) {
        popUpView.isHidden = true
        let money = "IDR \(newAmountText.text!)"
        amountLabel.text = money
    }
    
    
    // Data transfer to payments (send)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SelectViewController {
                    let vc = segue.destination as? SelectViewController
                    vc?.amount = amountLabel.text!
                    vc?.type = "Product Payment"
                }
    }
    
    
    // Text design parameters
    func skinnyAndFat() {
        skinnyPete = NSMutableAttributedString(string: amount, attributes: [NSAttributedStringKey.font: UIFont (name: "Ubuntu-Bold", size: 40)!])
        skinnyPete.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Ubuntu-Light", size: 20.0)!, range: NSRange(location:0, length:3))
        
        amountLabel.attributedText = skinnyPete
        amountLabel.text = amount
        
    }
    
    
    // Design parameters function
    func crazyCottonEyedJoe() {
        wgiteView.layer.cornerRadius = 20
        newAmountText.layer.masksToBounds = true
        newAmountText.layer.cornerRadius = 7
        newAmountText.setLeftPaddingPoints(15)
        okButton.backgroundColor = UIColor.actionBlue
        blueView.layer.cornerRadius = 20
        payButton.layer.cornerRadius = 10
     
        UINavigationBar.appearance().barStyle = .blackTranslucent
        
        // Circle parameters
        topView.layer.cornerRadius = topView.frame.size.width/2
        topView.clipsToBounds = true
        circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2
        circleImageView.clipsToBounds = true
        
        popUpView.isHidden = true
        navigationController?.isNavigationBarHidden = true
        
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
    
    // Pop up button
    @IBAction func popUpButton(_ sender: Any) {
        popUpView.isHidden = false
        
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
    
    // Unwind segue
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
    }
    
    // Animation function
    func iLikeToMoveItMoveIt(){
        let dollarMoneys = AnimationView(name: "coins")
        dollarMoneys.contentMode = .scaleAspectFit
        dollarMoneys.frame = circleImageView.bounds
        
        circleImageView.addSubview(dollarMoneys)
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
    }

}

// Collection view dataSource and delegates
extension discountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return percentageAmounts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: percentageAmounts[indexPath.item], for: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let amountForCode = amount.dropFirst(4)
        let priceInt = Double(amountForCode)!
        let percentageInt = Double(percentageAmounts[indexPath.row])!
        let result = priceInt * percentageInt
        let possumMoney = priceInt - Double(result )
        let resultString = possumMoney as NSNumber
        
        amountLabel.text = "IDR \(resultString.stringValue)"
    }
    
    
}


// Table view dataSource and delegates
extension discountViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCartUz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discountCell", for: indexPath) as! discountTableViewCell
        let price = myCartUz[indexPath.row].price
        let xNSNumber = price as NSNumber
        
        cell.productName?.text = myCartUz[indexPath.row].product
        cell.amountLabel?.text = "IDR \(xNSNumber.stringValue)"
        
        return cell
    }
    
}
