//
//  myQRCodeViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 26/7/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GoogleSignIn
import Kingfisher

class myQRCodeViewController: UIViewController, IndicatorInfoProvider {
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var merchantID: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var whiteView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTheQtoTheCode()
        happyAsLarry()
        heresAllMyDataBigBrother()
    }
    
    
    // QR code funciton
    func generateTheQtoTheCode() {
        let amountForCode = "250000"
        let amountNoDecimals = amountForCode.dropLast(2)
        let count = amountForCode.count
        let countString = String(describing: count)
        let code = "00020101021226710019ID.CO.TELKOMSEL.WWW011893600911002162700102151802110116270010303UME30660016ID.CO.YOUTAP.WWW0118936099990000001002021362811801033000303UME51450015ID.OR.GPNQR.WWW02151802110116270010303UME520411115802ID5913WARUNG MAHUHU6015Jakarta Selatan61051219062840119670667528393791941807166F7D1AB79228EAFF98370016ID.CO.YOUTAP.WWW021362811801033005303360540\(countString)\(amountForCode)047BF1"
        
        let image = generateQRCode(from: code)
        qrImage.image = image
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "QR CODE")
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
    
    
    // Profile information function
    func heresAllMyDataBigBrother(){
        profileName?.text = GIDSignIn.sharedInstance()?.currentUser.profile.name
        merchantID?.text = GIDSignIn.sharedInstance().currentUser.profile.email
        
        let profilePhoto = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 76)
        profilePicture.kf.setImage(with: profilePhoto)
        profilePicture.roundMyCircle()
    }
    
    
    // Design parameters
    func happyAsLarry() {
        whiteView.cards()
        
    }
    
    

}
