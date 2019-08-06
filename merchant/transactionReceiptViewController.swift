//
//  transactionReceiptViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 29/08/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import MapKit
import SpriteKit
import Printer

private extension TextBlock {
    
    static func plainText(_ content: String) -> TextBlock {
        return TextBlock(content: content, predefined: .light)
    }
}

class transactionReceiptViewController: UIViewController {

    // Data Arrays
    var transaction: Transactions3!
    let formatter = DateFormatter()
    let formatterTime = DateFormatter()
    
    var imageName: String!
    var imageNameTwo: String!
    
    var totalDough: String = ""
    
    var skinnyPete = NSMutableAttributedString()
    let pm = PrinterManager()
    
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var printer: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Design parameters
        roundCorners()
        transactionType!.becomeFirstResponder()
        configureEntryData(entry: transaction)

        print("you see what the cayote found in Texas? Not much I tell ya partner...")
        
        topOfTheMotherFuckingWorld()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // Printer button
    @IBAction func printNow(_ sender: UIButton) {
  
        guard let image = UIImage(named: "honcho-face-blue") else {
            return
        }
        
        if pm.canPrint {
            var receipt = Receipt(
                .title("Mr Jones"),
                .blank,
                .text(.init("You wanted a QR code right?")),
                .text(.init("Well, here it is")),
                .blank,
                .text(.init(content: Date().description, predefined: .alignment(.center))),
                .blank,
                .kv(key: "Merchant ID:", value: "iceu1390"),
                .kv(key: "Terminal ID:", value: "29383"),
                .blank,
                .kv(key: "Transaction ID:", value: "0x000321"),
                .text(.plainText("PURCHASE")),
                
                .blank,
                .kv(key: "Sub Total", value: totalDough),
                .kv(key: "Tip", value: "3.78"),
                .dividing,
                .kv(key: "Total", value: totalDough),
                .blank,
                .blank,
                .blank,
                .text(.init(content: "Thanks for supporting", predefined: .alignment(.center))),
                .text(.init(content: "local bussiness!", predefined: .alignment(.center))),
                .blank,
                .text(.init(content: "JOIN US NOW", predefined: .bold, .alignment(.center))),
                .blank,
                .blank,
                .blank,
                .qr("https://www.youtap.com"),
                .blank,
                .blank
            )
            receipt.feedLinesOnTail = 2
            receipt.feedPointsPerLine = 60
            pm.print(receipt)
            
        } else {
            
            performSegue(withIdentifier: "ShowSelectPrintVC", sender: nil)
            print("thisis working")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PrinterTableViewController {
            vc.sectionTitle = "Choose Printer"
            vc.printerManager = pm
        }
    }
    
    
    // Top image selector function
    func topOfTheMotherFuckingWorld(){
        switch transactionType.text {
            
        case "Product Payment":
            imageName = "Receipt-payment.png"
            
        case "Teleco":
            imageName = "Receipt-teleco.png"
            
        case "Water Bill":
            imageName = "Receipt-water-bill.png"
            
        case "Electricity Bill":
            imageName = "Receipt-lelectricity.png"
            
        case "Insurance":
            imageName = "Receipt-insurance.png"
            
        case "Cash Out":
            imageName = "Receipt-cash-out.png"
            
        case "Cash In":
            imageName = "Receipt-cash-in.png"
            
        case "Transfer":
            imageName = "Receipt-transfers.png"
            
        case "ATM Withdrawal":
            imageName = "atm-receipt-icon.png"
            
        default: break
        }
        
        transactionImage!.image = UIImage(named: imageName)
    }
    
    
    // Back button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    func configureEntryData(entry: Transactions3) {
        formatter.dateFormat = "dd.MM.yyyy"
        formatterTime.timeStyle = .medium
        
        let ttype = entry.type
        let tdate = entry.date
        let ptype = entry.payment
        let tamount = entry.amount
        
        transactionType!.text = ttype
        dateLabel!.text = formatter.string(from: tdate!)
        timeLabel!.text = formatterTime.string(from: tdate!)
        //amountLabel!.text = tamount
        totalDough = tamount!
        
        // Image selector depending on payment
        switch ptype {
            
        case "NFC Payment":
            imageNameTwo = "Payment-letters-NFC.png"
            
        case "QR Payment":
            imageNameTwo = "Payment-letters-QR.png"
            
        case "Cash Payment":
            imageNameTwo = "Payment-letters-Cash.png"
            
        case "Manual Payment":
            imageNameTwo = "Payment-letters-Manual.png"
            
        case "Transfer":
            imageNameTwo = "Payment-letters-transfer.png"
            
        default: break
        }
        
        paymentImage!.image = UIImage(named: imageNameTwo)
        skinnyAndFat()
        
        // Map view location
        let doubleLatitude = NumberFormatter().number(from: entry.latitude!)?.doubleValue
        let doubleLongitude = NumberFormatter().number(from: entry.longitude!)?.doubleValue
        let initialLocation = CLLocation(latitude: doubleLatitude!, longitude: doubleLongitude! )
        
        centerMapOnLocation(location: initialLocation)
        
        // show artwork on map
        let artwork = Artwork(title: "\(ttype ?? "possum")",
            locationName: "\(ptype ?? "possum")",
            discipline: "\(ptype ?? "possum")",
            coordinate: CLLocationCoordinate2D(latitude: doubleLatitude!, longitude: doubleLongitude!))
        mapView.addAnnotation(artwork)
    }

    
    // Text design parameters
    func skinnyAndFat() {
        skinnyPete = NSMutableAttributedString(string: totalDough, attributes: [NSAttributedStringKey.font: UIFont (name: "Ubuntu-Regular", size: 24)!])
        skinnyPete.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Ubuntu-Light", size: 15.0)!, range: NSRange(location:0, length:3))
        
        amountLabel.attributedText = skinnyPete
        amountLabel.text = totalDough
        
    }
    
    
    // Save to PDF
    @IBAction func shareButton(_ sender: Any) {
        let bounds = self.scrollView!.bounds
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = scrollView.screenshot()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    // Map function
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // Map pin function
    class Artwork: NSObject, MKAnnotation {
        let title: String?
        let locationName: String
        let discipline: String
        let coordinate: CLLocationCoordinate2D
        
        init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.locationName = locationName
            self.discipline = discipline
            self.coordinate = coordinate
            
            super.init()
        }
        
        var subtitle: String? {
            return locationName
        }
    }
    
    
    // Design Parameters functions
    func roundCorners () {
        firstView.whiteTopCorners()
        mapView.layer.cornerRadius = 10
    }
}


fileprivate extension UIScrollView {
    func screenshot() -> UIImage? {
        // begin image context
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
        // save the orginal offset & frame
        let savedContentOffset = contentOffset
        let savedFrame = frame
        // end ctx, restore offset & frame before returning
        defer {
            UIGraphicsEndImageContext()
            contentOffset = savedContentOffset
            frame = savedFrame
        }
        // change the offset & frame so as to include all content
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
}
