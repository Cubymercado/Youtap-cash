//
//  settingsTableViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 13/6/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import GoogleSignIn
import Kingfisher
import Firebase


class settingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var advertisments: [advertImages] = []
    var cartDocumentID: String = ""
    var selectedIndex: Int!
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profilePhone: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var colorThemeSwitch: UISwitch!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var advertCollectionView: UICollectionView!
  
    
    
    // Variables
    var imagePicker:UIImagePickerController!
    var newLogo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design function
        boogieboobieboo()
        heresAllMyDataBigBrother()
        pickMepickMe()
       
    }

   
    // Profile information function
    func heresAllMyDataBigBrother(){
        profileName?.text = GIDSignIn.sharedInstance()?.currentUser.profile.name
        profileEmail?.text = GIDSignIn.sharedInstance().currentUser.profile.email
        
        let profilePhoto = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 76)
        profilePicture.kf.setImage(with: profilePhoto)
        profilePicture.roundMyCircle()
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
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("playpusAttack"))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tap)
        
    }
    
    
    // Objc functions & segues
    @objc func playpusAttack() {
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            self.logoImage.image = pickedImage
            //self.rectangularImage.image = pickedImage
            
        } else{
            self.logoImage.image = newLogo
        }
        picker.dismiss(animated: true)
    }
    
    
    // Logout button action
    @IBAction func logOutButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        self.performSegue(withIdentifier: "unwindToViewController", sender: self)

    }
    

    // Section header and BG colours
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.groupTableViewBackground
        let header = view as! UITableViewHeaderFooterView
        
    }

    
   // Design parameters
    func boogieboobieboo() {
        logOutButton.layer.cornerRadius = 10
        logoImage.layer.cornerRadius = 14
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
    }
    

 
}


