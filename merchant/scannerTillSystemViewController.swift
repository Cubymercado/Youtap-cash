//
//  scannerTillSystemViewController.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 28/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import Firebase

class scannerTillCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
}


class scannerTillSystemViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {
    @IBOutlet weak var cameraScannerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Camera variables
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var barCodeFrameView: UIView? // for Extra credit section 3
    var initialized = false
    let barCodeTypes = [AVMetadataObject.ObjectType.upce,
                        AVMetadataObject.ObjectType.code39,
                        AVMetadataObject.ObjectType.code39Mod43,
                        AVMetadataObject.ObjectType.code93,
                        AVMetadataObject.ObjectType.code128,
                        AVMetadataObject.ObjectType.ean8,
                        AVMetadataObject.ObjectType.ean13,
                        AVMetadataObject.ObjectType.aztec,
                        AVMetadataObject.ObjectType.pdf417,
                        AVMetadataObject.ObjectType.itf14,
                        AVMetadataObject.ObjectType.dataMatrix,
                        AVMetadataObject.ObjectType.interleaved2of5]
    
    var crosshairView: CrosshairView? = nil
    var lastCapturedCode: String?
    var laserNumber = readLine()
    
    // Search variables
    var dataProduct = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var products = [String]()
    
    // Cart variables
    var myCart = [Cart]()
    var myCartUz: [Cart] = []
    var cart: Cart?
    var selectedIndex: Int!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var productPicture: UIImage!
    var cartDocumentID: String = ""
    var currency: String = ""
    let global = appCurrencies()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        peterPanIsNotPeterPunk()
        killTheVietCongs()
        
        currency = global.appMainCurrency ?? "NZD"
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.payButton)
       
        self.view.bringSubview(toFront: self.tableView!)
        self.view.bringSubview(toFront: self.payButton!)
        self.view.addSubview(self.cancelButton)
        self.view.bringSubview(toFront: self.cancelButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
        super.viewDidAppear(animated)
        if crosshairView == nil {
            crosshairView = CrosshairView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            crosshairView?.backgroundColor = UIColor.clear
            self.view.addSubview(crosshairView!)
            
        }
        setupCapture()
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.payButton)
        self.view.bringSubview(toFront: self.tableView!)
        self.view.bringSubview(toFront: self.payButton!)
        self.view.addSubview(self.totalAmountLabel)
        
    }
    
    // Camera capture function
    func setupCapture() {
        
        // Section 3
        if let barCodeFrameView = cameraScannerView {
            barCodeFrameView.removeFromSuperview()
            self.barCodeFrameView = nil
        }
        var success = false
        var accessDenied = false
        var accessRequested = false
        if let barCodeFrameView = cameraScannerView {
            barCodeFrameView.removeFromSuperview()
            self.barCodeFrameView = nil
        }
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorizationStatus == .notDetermined {
            // permission dialog not yet presented, request authorization
            accessRequested = true
            AVCaptureDevice.requestAccess(for: .video,
                                          completionHandler: { (granted:Bool) -> Void in
                                            self.setupCapture();
            })
            return
        }
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            accessDenied = true
        }
        
        if initialized {
            success = true
        }
        else {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            if let captureDevice = deviceDiscoverySession.devices.first {
                do {
                    let videoInput = try AVCaptureDeviceInput(device: captureDevice)
                    captureSession.addInput(videoInput)
                    success = true
                } catch {
                    NSLog("Cannot construct capture device input")
                }
            }
            else {
                NSLog("Cannot get capture device")
            }
            
            if success {
                // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                // Set delegate and use the default dispatch queue to execute the call back
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = self.barCodeTypes
                
                // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = cameraScannerView.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                initialized = true
            }
        }
        if success {
            captureSession.startRunning()
            view.bringSubview(toFront: crosshairView!)
        }
   
        if !success {
          
            if !accessRequested {
                
                var message = "Cannot access camera to scan bar codes"
                #if (arch(i386) || arch(x86_64)) && (!os(macOS))
                message = "You are a bit stupid as the simulator does not have a camera device.  Try this on a real iOS device."
                #endif
                if accessDenied {
                    message = "Jeeez mate!. You have denied this app permission to access the camera"
                }
                let alertPrompt = UIAlertController(title: "Cannot access camera", message: message, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                alertPrompt.addAction(confirmAction)
                self.present(alertPrompt, animated: true, completion: {
                })
            }
        }
    }
    
    // Swift 3.x callback
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        processBarCodeData(metadataObjects: metadataObjects as! [AVMetadataObject])
    }
    
    // Swift 4 callback
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        processBarCodeData(metadataObjects: metadataObjects)
    }
    
    func processBarCodeData(metadataObjects: [AVMetadataObject]) {
        if metadataObjects.count == 0 {
            cameraScannerView?.frame = CGRect.zero // Extra credit section 3
            return
        }
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if barCodeTypes.contains(metadataObject.type) {
                
                // If the found metadata is equal to the barcode then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject)
                
                // Initialize Frame to highlight the Bar Code
                DispatchQueue.main.async {
                    if self.cameraScannerView == nil {
                        self.cameraScannerView = UIView()
                        if let barCodeFrameView = self.cameraScannerView {
                            barCodeFrameView.layer.borderColor = UIColor.green.cgColor
                            barCodeFrameView.layer.borderWidth = 1
                            self.view.addSubview(barCodeFrameView)
                            self.view.bringSubview(toFront: barCodeFrameView)
                            self.view.bringSubview(toFront: self.payButton!)
                        }
                    }
                    self.cameraScannerView?.frame = barCodeObject!.bounds
                }
                
                if metadataObject.stringValue != nil {
                    lastCapturedCode = metadataObject.stringValue
                    captureSession.stopRunning()
                    letsCookSomeNoodles()
                    
                    return
                }
            }
        }
    }
    
   
    // Get values from CODE
    func letsCookSomeNoodles() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Products1")
        let searchString = self.lastCapturedCode
            request.predicate = NSPredicate(format: "barcode == %@", searchString!)
    
        do {
            let result = try dataProduct.fetch(request)
            if result.count > 0{
                let name = (result[0] as AnyObject).value(forKey: "name") as! String
                let price = (result[0] as AnyObject).value(forKey: "price") as! NSNumber
                let picture: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Random-product"))! as NSData
                let kfPicture = (result[0] as AnyObject).value(forKey: "image") as! NSData
                products.append(lastCapturedCode!)
                self.tableView.reloadData()

        // Add firebase
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("tillProducts").addDocument (data: ["product": name, "description":  "scanned", "price": "\(currency) \(price.stringValue)",
            // "image": products[indexPath.row].image!
                ]) { err in
                    if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docRef!.documentID)")
            }
        }

                
    // Save data to table view till
    if (name != nil) && price.stringValue != "" {
        if constantCart.saveObject(product: name, price: Int(truncating: price), inventory: 1, productImage: kfPicture, productDescription: "scanned", documentID: docRef!.documentID) {
    }
            if constantCart.fetchObject() != nil {
            myCartUz = constantCart.fetchObject()!
            self.tableView.reloadData()
        }
    }
    
    // Restart scanner
        self.captureSession.startRunning()
    
        } else {
                weDontKnowDaProduct()
        print("There's not enough rocks in the cave mr. Honey badger") }
        } catch {
    }
    
    // Haptic feedback
    shakingBunny()
}

    // Scanner value search
    func laserTagIsLaserLife() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Products1")
        let searchString = laserNumber
        request.predicate = NSPredicate(format: "barcode == %@", searchString!)
        do {
            let result = try dataProduct.fetch(request)
            if result.count > 0{
                let name = (result[0] as AnyObject).value(forKey: "name") as! String
                let price = (result[0] as AnyObject).value(forKey: "price") as! NSNumber
                let picture: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Random-product"))! as NSData
                let kfPicture = (result[0] as AnyObject).value(forKey: "image") as! NSData
                
                products.append(laserNumber!)
                self.tableView.reloadData()
                
                // Add firebase
                let db = Firestore.firestore()
                var docRef: DocumentReference? = nil
                docRef = db.collection("tillProducts").addDocument (data: ["product": name, "description":  "scanned", "price": "\(currency) \(price.stringValue)",
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(docRef!.documentID)")
                    }
                }
                
                // Save data to table view till
                if (name != nil) && price.stringValue != "" {
                    if constantCart.saveObject(product: name, price: Int(truncating: price), inventory: 1, productImage: kfPicture, productDescription: "scanned", documentID: docRef!.documentID) {
                    }
                    if constantCart.fetchObject() != nil {
                        myCartUz = constantCart.fetchObject()!
                        self.tableView.reloadData()
                    }
                }
   
            } else {
                thaLasaIsCraza()
                print("There's not enough rocks in the cave mr. Honey badger") }
        } catch {
        }

    }
    
    
    // Add amount function
    func thaLasaIsCraza() {
        let alertController = UIAlertController(title: "Unknown Product", message: "Enter the product and a price", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Product name"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField

            secondTextField.keyboardType = .numberPad
            
            let product = firstTextField.text
            let price = Int(secondTextField.text!)
            let picture: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Random-product"))! as NSData
            let image: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Random-product"))! as NSData
            
            // Save project to my cart
            if constantCart.saveObject(product: product!, price: price!, inventory: 1, productImage: picture, productDescription: "manual entry", documentID: self.cartDocumentID) {
            }
            
            // Save product to suggested products
            if constantSuggestedProducts.saveObject(name: product!, price: price!, description: "Manual entry", category: "Manual entry", barcode: self.lastCapturedCode!, image: image) {
            }
            print("the kiwi bird is browsing")
            
            if constantCart.fetchObject() != nil {
                self.myCartUz = constantCart.fetchObject()!
                self.tableView.reloadData()
                self.captureSession.startRunning()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Product price"
            textField.keyboardType = .decimalPad
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    // Draw crosshair on camera view
    class CrosshairView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func draw(_ rect: CGRect) {
            let fWidth = self.frame.size.width
            let fHeight = 400 as CGFloat
            let squareWidth = fWidth/2
            let topLeft = CGPoint(x: fWidth/2-squareWidth/2, y: fHeight/2-squareWidth/2)
            let topRight = CGPoint(x: fWidth/2+squareWidth/2, y: fHeight/2-squareWidth/2)
            let bottomLeft = CGPoint(x: fWidth/2-squareWidth/2, y: fHeight/2+squareWidth/2)
            let bottomRight = CGPoint(x: fWidth/2+squareWidth/2, y: fHeight/2+squareWidth/2)
            let cornerWidth = squareWidth/4
            
            if let context = UIGraphicsGetCurrentContext() {
                context.setLineWidth(2.0)
                context.setStrokeColor(UIColor.green.cgColor)
                
                // top left corner
                context.move(to: topLeft)
                context.addLine(to: CGPoint(x: fWidth/2-squareWidth/2+cornerWidth, y: fHeight/2-squareWidth/2))
                context.strokePath()
                
                context.move(to: topLeft)
                context.addLine(to: CGPoint(x: fWidth/2-squareWidth/2, y: fHeight/2-squareWidth/2+cornerWidth))
                context.strokePath()
                
                // top right corner
                context.move(to: topRight)
                context.addLine(to: CGPoint(x: fWidth/2+squareWidth/2, y: fHeight/2-squareWidth/2+cornerWidth))
                context.strokePath()
                
                context.move(to: topRight)
                context.addLine(to: CGPoint(x: fWidth/2+squareWidth/2-cornerWidth, y: fHeight/2-squareWidth/2))
                context.strokePath()
                
                // bottom right corner
                context.move(to: bottomRight)
                context.addLine(to: CGPoint(x: fWidth/2+squareWidth/2-cornerWidth, y: fHeight/2+squareWidth/2))
                context.strokePath()
                
                context.move(to: bottomRight)
                context.addLine(to: CGPoint(x: fWidth/2+squareWidth/2, y: fHeight/2+squareWidth/2-cornerWidth))
                context.strokePath()
                
                // bottom left corner
                context.move(to: bottomLeft)
                context.addLine(to: CGPoint(x: fWidth/2-squareWidth/2+cornerWidth, y: fHeight/2+squareWidth/2))
                context.strokePath()
            
                context.move(to: bottomLeft)
                context.addLine(to: CGPoint(x: fWidth/2-squareWidth/2, y: fHeight/2+squareWidth/2-cornerWidth))
                context.strokePath()
    
            }
        }
    }
    
    
    // Add amount function
    func weDontKnowDaProduct() {
        let alertController = UIAlertController(title: "Unknown Product", message: "Enter the product and a price", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Product name"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            secondTextField.keyboardType = .numberPad
            let product = firstTextField.text
            let price = Int(secondTextField.text!)
            let picture: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Random-product"))! as NSData
            let image: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Random-product"))! as NSData
            
            
            // Save project to my cart
            if constantCart.saveObject(product: product!, price: price!, inventory: 1, productImage: picture, productDescription: "manual entry", documentID: self.cartDocumentID) {
            }
            
            // Save product to suggested products
            if constantSuggestedProducts.saveObject(name: product!, price: price!, description: "Manual entry", category: "Manual entry", barcode: self.lastCapturedCode!, image: image) {
                
            }
            print("the kiwi bird it's browsing")
            
            if constantCart.fetchObject() != nil {
                self.myCartUz = constantCart.fetchObject()!
                self.tableView.reloadData()
                self.captureSession.startRunning()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Product price"
            textField.keyboardType = .decimalPad
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // Back Button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // Cancel button
    @IBAction func cancelButton(_ sender: Any) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            
        } catch {
            
        }
    }
    
    
    // Ok button action
    @IBAction func okButton(_ sender: Any) {
        self.performSegue(withIdentifier: "paySegue", sender: self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            print("the squirrels are ready")
        } catch {
            
        }
        if constantCart.fetchObject() != nil {
            myCartUz = constantCart.fetchObject()!
        }
    }
    
    
    // Delete everything when starting up
    func killTheVietCongs(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("the squirrels are ready")
            
        } catch {
        }
    }
    
    
    // Data transfer to payments (send)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is discountViewController {
            let vc = segue.destination as? discountViewController
            vc?.amount = totalAmountLabel.text!
            //vc?.type = "Product Payment"
        } else {
            if segue.identifier == "quantitySegue" {
                let editVC = segue.destination as! productQuantityViewController
                editVC.myCart = cart
                
                print("here's the product the cat will steal from the cupboard ")
            }
        }
    }
    
    
    // Haptic feel
    func shakingBunny() {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
    }
    
    
    // Design parameters function
    func peterPanIsNotPeterPunk(){
        payButton.contentEdgeInsets.left = 20
        payButton.buttonCornersFour()
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.11, green:0.68, blue:0.83, alpha:1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
}


extension scannerTillSystemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! scannerTillCell
        cell.productName?.text = myCartUz[indexPath.row].product
        let price = myCartUz[indexPath.row].price
        let xNSNumber = price as NSNumber
        cell.productPrice?.text = "\(currency) \(xNSNumber.stringValue)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myCartUz.isEmpty {
            return myCartUz.count
            
        } else {
            
            // Totals calculator
            var sum = 0.0
            for item in myCartUz {
                sum += Double(item.price)
            }
            totalAmountLabel.text = "\(currency) \(sum)"
            
            return myCartUz.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            let db = Firestore.firestore()
            db.collection("tillProducts").document("\(self.myCartUz[indexPath.row].documentID!)").delete() { err in
                if let err = err {
                    print ("ooops")
                } else {
                    print("yaaay")
                }
            }
            
            // delete item at indexPath
            let item = self.myCartUz[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.myCartUz.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        delete.backgroundColor = UIColor(red: 246/255, green: 104/255, blue: 37/255, alpha: 1.0)
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cart = myCartUz[indexPath.row]
        self.performSegue(withIdentifier: "quantitySegue", sender: self)
        
    }
    
}
