//
//  shopSettingsTableViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 6/8/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Kingfisher
import PDFKit


class shopSettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var mainCurrency: UITextField!
    @IBOutlet weak var mainCurrencyFlag: UIImageView!
    @IBOutlet weak var socondaryCurrencyFlag: UIImageView!
    @IBOutlet weak var secondaryCurrency: UITextField!
    @IBOutlet weak var secondaryCurrencyName: UITextField!
    @IBOutlet weak var currencyValue: UITextField!
    @IBOutlet weak var multiCurrencySwitch: UISwitch!
    @IBOutlet weak var secondaryCurrencyCell: UITableViewCell!
    @IBOutlet weak var touristFee: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        standardKnowledgeAndGeneralCultureYouUneducatedPrick()
        pickMepickMe()
        newStyle()
        multiCurrencySwitch.addTarget(self, action: #selector(multiCurrencySwitchAction), for: .valueChanged)
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        standardKnowledgeAndGeneralCultureYouUneducatedPrick()
    }
    
    // Variables
    var imagePicker:UIImagePickerController!
    var newLogo: UIImage?
    var logo: UIImage?
    let global = appCurrencies()
    var currency: String = ""
    var globalURL: String = ""
    
    
    // Logo button function
    @IBAction func dontTickleMyWillyAndCallMeSilly(_ sender: Any) {
        let alert = UIAlertController(title: "Select a logo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take a photo of your logo", style: .default, handler: { _ in self.openCamera() }))
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
    
    
    // Image picker function
    func pickMepickMe (){
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        logoImage.isUserInteractionEnabled = true
        logoImage.addGestureRecognizer(imageTap)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
    }
    
    
    // Image picker function 2
    @objc func openImagePicker(_ sender:Any) {
        let alert = UIAlertController(title: "Select a logo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take a photo of your logo", style: .default, handler: { _ in self.openCamera() }))
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
            
            let alert  = UIAlertController(title: "Warning", message: "You don't have a camera", preferredStyle: .alert)
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
            self.logoImage.image = pickedImage
            let imageData = UIImagePNGRepresentation(pickedImage)
            UserDefaults.standard.set(imageData, forKey: "logo")
            
        } else{
            let logo = newLogo!
            self.logoImage.image = newLogo
            let imageData = UIImagePNGRepresentation(logo)
             UserDefaults.standard.set(imageData, forKey: "logo")
        }
        picker.dismiss(animated: true)
    }
    
    
    // Switch actions
    @objc func multiCurrencySwitchAction() {
        if multiCurrencySwitch.isOn {
           secondaryCurrencyCell.isHidden = false
        } else {
            
            secondaryCurrencyCell.isHidden = true
        }
    }
    
    
    // User defaults
    func standardKnowledgeAndGeneralCultureYouUneducatedPrick(){
         currency = global.appMainCurrency ?? "NZD"
        let flag = global.appMainCurrencyFlag ?? "https://www.countryflags.io/nz/flat/16.png"
        let twoFlag = global.appTwoCurrencyFlag ?? "https://www.countryflags.io/au/flat/16.png"
        let oneCurrency = global.appMainCurrency ?? "NZD"
        let twoCurrency = global.appTwoCurrency ?? "AUD"
        let twoCurrencyValue = global.appTwoCurrencyValue ?? "0.92"
        let twoCurrencyName = global.appTwoCurrencyName ?? "Australian Dollar"
        let url = URL(string: flag)
        let twoUrl = URL(string: twoFlag)
        let tFee = global.touristFee ?? "0"

        mainCurrency.text = currency
        secondaryCurrency.text = "(\(twoCurrency))"
        mainCurrencyFlag?.kf.setImage(with: url)
        socondaryCurrencyFlag?.kf.setImage(with: twoUrl)
        currencyValue?.text = "\(twoCurrencyValue) \(twoCurrency) per \(oneCurrency)"
        touristFee?.text = "\(tFee) \(oneCurrency)"
        secondaryCurrencyName?.text = twoCurrencyName
        
        logoImage.cards()
        makeMyShopLookPrettyYouUglyBastard()
    }

    
    // Merchant logo function
    func makeMyShopLookPrettyYouUglyBastard() {
        let merchantLogo = global.merchantLogo as? Data
        let logoPlaceholder = UIImagePNGRepresentation(#imageLiteral(resourceName: "logo-placeholder.png"))!
        let merchantLogoPNG = UIImage(data: merchantLogo ?? logoPlaceholder )
        logoImage.image = merchantLogoPNG
       /* if merchantLogo.isEmpty {
            
        } else {
        
        let merchantLogoPNG = UIImage(data: merchantLogo )
        logoImage.image = merchantLogoPNG
        }
        */
    }
    
    
    // Print QR code function
    @IBAction func printButton(_ sender: Any) {
        let controller = exportedQRcodeViewController.fromStoryboard()
        let qrCode = controller.view
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            qrCode!.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
   
    }
    
    
    func dataFromContainer(containerData : UIView){
        let jimmy = containerData
    }
    
    
    // Navbar style
    func newStyle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
       
    }
}



