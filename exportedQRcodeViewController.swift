//
//  exportedQRcodeViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 22/8/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import GoogleSignIn
import Kingfisher

class exportedQRcodeViewController: UIViewController {

    @IBOutlet weak var qrCodeView: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var qrCodeWrapper: UIView!
    @IBOutlet weak var qrCodeWrapperWhite: UIView!
    
    
    let global = appCurrencies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTheQtoTheCode()
        heresAllMyDataBigBrother()
    }
    
    // Data transfer function (receiving)
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> exportedQRcodeViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "exportedQRcodeViewController") as! exportedQRcodeViewController
        return controller
    }
    
    // QR code funcitons
    func generateTheQtoTheCode() {
        let amountForCode = "250000"
        let count = amountForCode.count
        let countString = String(describing: count)
        let code = "00020101021226710019ID.CO.TELKOMSEL.WWW011893600911002162700102151802110116270010303UME30660016ID.CO.YOUTAP.WWW0118936099990000001002021362811801033000303UME51450015ID.OR.GPNQR.WWW02151802110116270010303UME520411115802ID5913WARUNG MAHUHU6015Jakarta Selatan61051219062840119670667528393791941807166F7D1AB79228EAFF98370016ID.CO.YOUTAP.WWW021362811801033005303360540\(countString)\(amountForCode)047BF1"
        
        let image = generateQRCode(from: code)
        qrCodeView.image = image
    }
    
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
    
    // Data trasnsfer to dashboard   ----->
    func sendDataToVc(myString : UIImage) {
        let Vc = parent as! shopSettingsTableViewController
        Vc.dataFromContainer(containerData: contentView)
    }
    
    
    // Profile information function
    func heresAllMyDataBigBrother(){
        profileName?.text = GIDSignIn.sharedInstance()?.currentUser.profile.name
        profileEmail?.text = GIDSignIn.sharedInstance().currentUser.profile.email
        
        let profilePhoto = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 76)
        profileImage.kf.setImage(with: profilePhoto)
        profileImage.roundMyCircle()
        let merchantLogo = global.merchantLogo as? Data
        let logoPlaceholder = UIImagePNGRepresentation(#imageLiteral(resourceName: "logo-placeholder.png"))!
        let merchantLogoPNG = UIImage(data: merchantLogo ?? logoPlaceholder )
        logoImage.image = merchantLogoPNG
        qrCodeWrapper.cards()
        qrCodeWrapperWhite.cards()
        logoImage.card()
    }
    
    
}
