//
//  scannToPayViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 26/7/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation
import CoreImage

class scannToPayViewController: UIViewController,  AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var whiteBgView: UIView!
    @IBOutlet weak var amountText: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var customerIDLabel: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var controlVurrency: UIView!
    
    // Date & Time variables
    let date = Date()
    let formatter = DateFormatter()
    let formatterTime = DateFormatter()
    
    var amountBeingPaid: String = ""
    var customerQRID: String = ""
    var amountToPay: String = ""
    var skinnyPete = NSMutableAttributedString()
    
    // Scanner variables
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var captureDevice:AVCaptureDevice?
    var barCodeFrameView: UIView? // for Extra credit section 3
    var lastCapturedCode:String?
    public var barcodeScanned:((String) -> ())?
    
    private var allowedTypes = [AVMetadataObject.ObjectType.upce,
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOrangutan()
        startTheDonkey()
        whatsTheTimeMrWolf()
        heyPiPiLangstrumpf()
        skinnyAndFat()
    }
    
    
    // Text parameters
    func skinnyAndFat() {
        skinnyPete = NSMutableAttributedString(string: amountToPay, attributes: [NSAttributedStringKey.font: UIFont (name: "Ubuntu-Bold", size: 40)!])
        skinnyPete.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Ubuntu-Light", size: 20.0)!, range: NSRange(location:0, length:3))
        
        amountText.attributedText = skinnyPete
        amountText.text = amountToPay
    }
    
    
    public override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewLayer?.frame = self.videoView.layer.bounds
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        switch(orientation) {
        case UIInterfaceOrientation.landscapeLeft:
            videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            
        case UIInterfaceOrientation.landscapeRight:
            videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            
        case UIInterfaceOrientation.portrait:
            videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            
        case UIInterfaceOrientation.portraitUpsideDown:
            videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
            
        default:
            print("Unknown orientation state")
        }
    }
    
    public override func viewDidLayoutSubviews() {
        
    }
    
    public override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        videoPreviewLayer?.frame = videoView.layer.bounds
    }
    
    
    // Metadata scanner capture function
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        processBarCodeData(metadataObjects: metadataObjects)
    }
    
    
    func processBarCodeData(metadataObjects: [AVMetadataObject]) {
        if metadataObjects.count == 0 {
            barCodeFrameView?.frame = CGRect.zero
            return
        }
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if allowedTypes.contains(metadataObject.type) {
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
                    //  self.barCodeFrameView?.frame = barCodeObject!.bounds
                }
                
                if metadataObject.stringValue != nil {
                    captureSession?.stopRunning()
                    displayBarCodeResult(code: metadataObject.stringValue!)
                    customerQRID = metadataObject.stringValue!
                    let customerSummaryID = customerQRID.prefix(5)
                    customerIDLabel.text = String(customerSummaryID)
                    
                    return
                }
            }
        }
    }
    
    
    // Pop Up function
    func displayBarCodeResult(code: String) {
        
        let systemSoundId: SystemSoundID = 1016
        
        // System sound and vibrations
        AudioServicesAddSystemSoundCompletion(systemSoundId, nil, nil, { (customSoundId, _) -> Void in
            AudioServicesDisposeSystemSoundID(customSoundId)
        }, nil)
        
        AudioServicesPlayAlertSound(systemSoundId)
        
        self.whiteBgView.isHidden = false
        controlVurrency.isHidden = true
        self.captureSession?.stopRunning()
    }
    
    // Start the camera function
    func startTheDonkey(){
        
        // Retrieve the default capturing device for using the camera
        self.captureDevice = AVCaptureDevice.default(for: .video)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput(device:captureDevice!)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(String(describing: error?.localizedDescription))")
            return
        }
        
        // Initialize the captureSession object and set the input device on the capture session.
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = self.allowedTypes
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resize
        videoPreviewLayer?.frame = videoView.layer.bounds
        videoView.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        //view.bringSubview(toFront: messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.red.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        qrCodeFrameView?.autoresizingMask = [UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin, UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin]
        
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
        
    }
    
    // Date & Time function
    func whatsTheTimeMrWolf() {
        formatter.dateFormat = "dd.MM.yyyy"
        formatterTime.timeStyle = .medium
        
        let whatsTheDate = formatter.string(from: date)
        let whatsTheTime = formatterTime.string(from: date)
        
        dateLabel.text = whatsTheDate
        timeLabel.text = whatsTheTime
        
    }
    
    
    // Button function
    @IBAction func okButton(_ sender: Any) {
        self.performSegue(withIdentifier: "paySegue", sender: self)
        self.captureSession?.stopRunning()
        
    }
    
    // Data transfer function ----->
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is confirmedPaymentViewController {
            let vc = segue.destination as! confirmedPaymentViewController
            vc.amount = amountToPay
            vc.transaction = "QR Payment"
            vc.type = "Product Payment"
            vc.companyName = customerName.text!
            vc.companyID = customerIDLabel.text!
        }
    }

    
    // Design parameters
    func heyPiPiLangstrumpf(){
        whiteBgView.layer.cornerRadius = 25
        self.whiteBgView.isHidden = true
        okButton.layer.cornerRadius = 10
        controlVurrency.layer.cornerRadius = 10
    }
    
}
