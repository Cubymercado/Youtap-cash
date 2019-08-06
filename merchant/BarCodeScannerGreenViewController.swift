//
//  BarCodeScannerGreenViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 18/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import AVFoundation
import XLPagerTabStrip
import CoreData


class BarCodeScannerGreenViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, IndicatorInfoProvider {
    
    @IBOutlet weak var barCode: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
 
    var lastCapturedCode: String?
    var productName: String = ""
    
    // Search variables
    var dataProduct = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var products = [String]()
    
    // Products variables
    var myProduct = [Products1]()
    var myProductUz: [Products1] = []
    var product: Products1?
    var selectedIndex: Int!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var productPicture: UIImage!
    
    
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
                        AVMetadataObject.ObjectType.interleaved2of5,
                        AVMetadataObject.ObjectType.qr]
    
    var crosshairView: CrosshairView? = nil // For Extra credit section 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Big titles
        //navigationController?.navigationBar.prefersLargeTitles = false
       // navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if crosshairView == nil {
            crosshairView = CrosshairView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            crosshairView?.backgroundColor = UIColor.clear
            self.view.addSubview(crosshairView!)
        }
        setupCapture()
        
    }
    
    @objc func willEnterForeground() {
        setupCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    // Camera capture function
    func setupCapture() {
        
        // ESection 3
        if let barCodeFrameView = barCodeFrameView {
            barCodeFrameView.removeFromSuperview()
            self.barCodeFrameView = nil
        }
        
        var success = false
        var accessDenied = false
        var accessRequested = false
        if let barCodeFrameView = barCodeFrameView {
            barCodeFrameView.removeFromSuperview()
            self.barCodeFrameView = nil
        }
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorizationStatus == .notDetermined {
            // permission dialog not yet presented, request authorization
            accessRequested = true
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted:Bool) -> Void in self.setupCapture();
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
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                let newSerialQueue = DispatchQueue(label: "barCodeScannerQueue") // in iOS 11 you can use main queue
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: newSerialQueue)
                captureMetadataOutput.metadataObjectTypes = barCodeTypes
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
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
                message = "You are a bit stupid as the simulator does not hae a camera device.  Try this on a real iOS device."
                #endif
                if accessDenied {
                    message = "Jeeez mate!. You have denied this app permission to access to the camera"
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            barCodeFrameView?.frame = CGRect.zero // Extra credit section 3
            return
        }
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if barCodeTypes.contains(metadataObject.type) {
                // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject)
                // Initialize Frame to highlight the Bar Code
                DispatchQueue.main.async {
                    // Extra credit section 3
                    if self.barCodeFrameView == nil {
                        self.barCodeFrameView = UIView()
                        if let barCodeFrameView = self.barCodeFrameView {
                            barCodeFrameView.layer.borderColor = UIColor.yellow.cgColor
                            barCodeFrameView.layer.borderWidth = 2
                            self.view.addSubview(barCodeFrameView)
                            self.view.bringSubview(toFront: barCodeFrameView)
                        }
                    }
                    self.barCodeFrameView?.frame = barCodeObject!.bounds
                }
                
                if metadataObject.stringValue != nil {
                   // captureSession.stopRunning()
                  //  displayBarCodeResult(code: metadataObject.stringValue!)
                    lastCapturedCode = metadataObject.stringValue
                    captureSession.stopRunning()
                    letsCookSomeNoodles()
             
                    return
                }
            }
        }
    }
    
    // Back button function
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    // Manual button function
    @IBAction func manualButton(_ sender: Any) {
        self.performSegue(withIdentifier: "manualSegue1", sender: self)
    }
    
    
    // New barcode function
    func displayBarCodeResult(code: String) {
        self.barCode.text = code
        
        let systemSoundId: SystemSoundID = 1016
        
        // System sound and vibrations
        AudioServicesAddSystemSoundCompletion(systemSoundId, nil, nil, { (customSoundId, _) -> Void in
            AudioServicesDisposeSystemSoundID(customSoundId)}, nil)
        AudioServicesPlayAlertSound(systemSoundId)
        
        let alertPrompt = UIAlertController(title: "This product is not on your inventory, would you like to add it?", message: code, preferredStyle: .alert)
        if let barcode = URL(string: code) {
            let confirmAction = UIAlertAction(title: "Add product", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                self.performSegue(withIdentifier: "scanSegue", sender: self)
                
            })
            alertPrompt.addAction(confirmAction)
        }
        let cancelAction = UIAlertAction(title: "Scan another", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            self.setupCapture()
        })
        alertPrompt.addAction(cancelAction)
        present(alertPrompt, animated: true, completion: nil)
    }
    
    
    // Old barcode function
    func oldBarcode(code: String) {
       // self.barCode.text = code
        let systemSoundId: SystemSoundID = 1016
        
        
        // System sound and vibrations
        AudioServicesAddSystemSoundCompletion(systemSoundId, nil, nil, { (customSoundId, _) -> Void in
            AudioServicesDisposeSystemSoundID(customSoundId)}, nil)
        AudioServicesPlayAlertSound(systemSoundId)
        
        let alertPrompt = UIAlertController(title: "\(productName) is already in your products", message: code, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Scan another", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            self.setupCapture()
        })
        alertPrompt.addAction(cancelAction)
        present(alertPrompt, animated: true, completion: nil)
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
                productName = name
            
                products.append(lastCapturedCode!)
                oldBarcode(code: lastCapturedCode!)
                
            } else {
                
                 captureSession.stopRunning()
                 displayBarCodeResult(code: lastCapturedCode!)
                print("There's not enough rocks in the cave mr. Honey badger")
            }
        } catch {
            
        }
}
    
    // Data transfer function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is newScanProductAddViewController
        {
            let dvc = segue.destination as! newScanProductAddViewController
            dvc.barcodeProduct = barCode.text!
            
        }
    }
    
    // ----------------------
    // Extra credit section 2
    // Draw crosshairs over camera view
    // ----------------------
    class CrosshairView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func draw(_ rect: CGRect) {
            let fWidth = self.frame.size.width
            let fHeight = self.frame.size.height
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
    
    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BARCODE SCANNER")
        
    }
    
    
}
