//
//  adsManagerViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 18/6/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import CoreData
import FirebaseStorage



// Advert collectionView class
class advertCell: UICollectionViewCell {
    @IBOutlet weak var advertImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        advertImage.layer.cornerRadius = 12
    }
    
}


class adsManagerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newAddButton: UIButton!
    @IBOutlet weak var adText: UITextField!
    
    var advertisments: [advertImages] = []
    var ads: AdvertImages?
    var adSave = [AdvertImages]()
    var adverts: [AdvertImages] = []
    var filetedData: [AdvertImages] = []
    var cartDocumentID: String = ""
    var selectedIndex: Int!
    var imagePicker:UIImagePickerController!
    var newLogo: UIImage?
    var imageWeb: String = ""
    @IBOutlet weak var adsView: UIView!
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var listenerTwo: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.dataSource = self
        collectionView.delegate = self
        runningOutOfTime()
        imagePickerOne()
        fetchData()
        collectionView.reloadData()
   
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
 
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    
    // Image Picker one function
    func imagePickerOne() {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    
    // Get adverts data function
    // Get products data function
    func fetchData() {
        do {
            adverts = try context.fetch(AdvertImages.fetchRequest())
            filetedData = adverts
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            print("Couldn't Fetch Data")
        }
    }
    


    @IBAction func assNewAd(_ sender: Any) {
        let alert = UIAlertController(title: "Where is your ad stored?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
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
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.navigationBar.tintColor = UIColor(red:0.11, green:0.68, blue:0.83, alpha:1.0)
        imagePicker.navigationBar.barTintColor = UIColor.white
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // Image Picker 3
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImageOne = info[UIImagePickerControllerEditedImage] as? UIImage
 
        var strURL = ""
        var realURL = ""
        func uploading( img : UIImage, completion: @escaping ((String) -> Void)) {
            
            let imageName = NSUUID().uuidString
            let storeImage = Storage.storage().reference().child(imageName)
            let pickedImageOne = info[UIImagePickerControllerEditedImage] as? UIImage
            let picture: NSData = UIImagePNGRepresentation(pickedImageOne!)! as NSData
            
            if let uploadImageData = UIImagePNGRepresentation((pickedImageOne)!){
                storeImage.putData(uploadImageData, metadata: nil, completion: { (metaData, error) in
                    storeImage.downloadURL(completion: { (url, error) in
                        if let urlText = url?.absoluteString {
                            
                            strURL = urlText
                            print("/////////////////// \(strURL)   ////////")
                            realURL = strURL
                         
                            let newMetadata = StorageMetadata()
                            newMetadata.cacheControl = "public,max-age=300";
                            newMetadata.contentType = "image/jpeg";
                            storeImage.updateMetadata(newMetadata) { metadata, error in
                                if let error = error {
                                    
                                } else {
                                   
                                }
                            }
                            
                            // Add firebase
                            let db = Firestore.firestore()
                            var docRef: DocumentReference? = nil
                            docRef = db.collection("advertImages").addDocument (data: ["AdvertImage": strURL, "PromotionalLabel":  "Platypus"]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                    
                                } else {
                                    
                                    print("Document added with ID: \(docRef!.documentID)")
                                    self.cartDocumentID = docRef!.documentID
                                }
                            }
 
                            if (self.adText.text != nil) /*&& productDescription.text != ""*/ {
                                if constantAdverts.saveObject(promotionalLabel: "Test", advertImage: picture as NSData, documentID: docRef!.documentID) {
                                    self.fetchData()
                                    self.collectionView.reloadData()
                                }
                            }
                            if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                                let picture: NSData = UIImagePNGRepresentation(pickedImage)! as NSData
     
                                } else{
                            }
                                picker.dismiss(animated: true)
                            }
                    })
                })
            }
        }
        
        let str = uploading(img: pickedImageOne!) { (url) in
            realURL = (url)
            print(url)
        }
    }
    
    // Design parameters
    func runningOutOfTime() {
        newAddButton.layer.cornerRadius = 10
    }
    
    // Haptic feel
    func shakingBunny() {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
    }
    
    // Delete functions
    func deleteEverything() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AdvertImages")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("the squirrels are ready")
        } catch {
            // Error Handling
        }
    
        if constantCart.fetchObject() != nil {
            adverts = constantAdverts.fetchObject()!
        }
    }
}
    

extension adsManagerViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if adverts.isEmpty {
            adsView.isHidden = true
        } else {
            adsView.isHidden = false
        }
        return adverts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advertCell", for: indexPath) as! advertCell
        let data = adverts[indexPath.row].advertImage as Data?
        cell.advertImage.image = UIImage(data: data!)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Would you like to delete your ad?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
     
            let db = Firestore.firestore()
            db.collection("advertImages").document("\(self.adverts[indexPath.row].documentID!)").delete() { err in
                if let err = err {
                    print ("ooops")
                } else {
                    print("yaaay")
                }
            }
            
            let item = self.adverts[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.adverts.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
            
            // delete item at indexPath
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
           // self.adverts.remove(at: indexPath.row)
            
             }))
     
        shakingBunny()
     
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break }
        self.present(alert, animated: true, completion: nil)
 
    }

}
