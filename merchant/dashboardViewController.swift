//
//  dashboardViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 16/5/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import GoogleSignIn
import Kingfisher
import CoreData
import Charts

// Dashboard tableView cell class
class dashboardCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

class dashboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellProductName: UILabel!
    @IBOutlet weak var cellProductImage: UIImageView!
    @IBOutlet weak var cellNumberView: UIView!
    @IBOutlet weak var cellProductInventory: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellNumberView.threeCornersSmall()
        self.contentView.threeCorners()
        self.threeCorners()
        //self.dropShadow()
        }
}


class dashboardViewController: UITableViewController {

    @IBOutlet weak var availableBalance: UILabel!
    @IBOutlet weak var revenueView: UIView!
    @IBOutlet weak var revenueRightView: UIView!
    @IBOutlet weak var insightsView: PieChartView!
    @IBOutlet weak var pruductsRunningLowLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var embededView: UIView!
    @IBOutlet weak var todaySalesLabel: UILabel!
    @IBOutlet weak var totalSalesLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    // Pie Chart Variables
    var firstDataEntry = PieChartDataEntry(value: 0)
    var secondDataEntry = PieChartDataEntry(value: 0)
    var thirdDataEntry = PieChartDataEntry(value: 0)
    
    var totalDataEntry = [PieChartDataEntry]()
    
    let global = appCurrencies()
    var currency: String = ""
    
    // Date and Time variables
    let formatter = DateFormatter()
    let formatterMonth = DateFormatter()
    let date = Date()
    
    // Data arrays
    var products = [Products1]()
    var filteredData2: [Products1] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndex: Int!
    
    var numberOfItems: String = ""
    
    // Text variables
    var totalAmount: String = ""
    var transferredAmount: String = ""
    var skinnyPete = NSMutableAttributedString()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        globalCurrencies()
        
        cardDesigns()
        newStyle()
        insightsView.chartDescription?.text = "Payments"
        getMeSomeData()
   
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        globalCurrencies()
        getMeSomeData()
        countWithAttribute()
        updateChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        globalCurrencies()
    }
    
    // App global currencies functions
    func globalCurrencies() {
        currency = global.appMainCurrency ?? "NZD"
        
    }
    
    // Data transfer from transactions   <-----
    func dataFromContainer(containerData : String){
        transferredAmount = containerData
        totalSalesLabel.text = "\(currency) \(containerData)"
        skinnyAndFat()
        yourFatBalance()
    }

    
    // Get data from products function
    func getMeSomeData(){
        collectionView.dataSource = self
        if constantProducts.fetchObject() != nil {
            products = constantProducts.fetchObject()!
            collectionView.reloadData()
        }
    }
    
    
    // Count from Core Data
    func countWithAttribute() {
        firstDataEntry.value = 20//Double(nfcCount)
        firstDataEntry.label = "NFC"
        secondDataEntry.value = 15//Double(qrCount)
        secondDataEntry.label = "QRC"
        thirdDataEntry.value = 80//Double(cashCount)
        thirdDataEntry.label = "Cash"
        totalDataEntry = [firstDataEntry, secondDataEntry, thirdDataEntry]
    }
    
    
    // Update Pie Chart function
    func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: totalDataEntry, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0), UIColor(red:0.82, green:0.00, blue:0.28, alpha:1.0), UIColor(red: 0.4941, green: 0.8275, blue: 0.1294, alpha: 1.0)]
        
        chartDataSet.colors = colors
        insightsView.data = chartData
    }

    
    // Text parameters
    func skinnyAndFat() {
        let moneyTotal = "\(currency) \(transferredAmount)"
        skinnyPete = NSMutableAttributedString(string: moneyTotal, attributes: [NSAttributedStringKey.font: UIFont (name: "Ubuntu", size: 21)!])
        skinnyPete.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Ubuntu-Light", size: 13.0)!, range: NSRange(location:0, length:3))
        todaySalesLabel.attributedText = skinnyPete
        todaySalesLabel.text = moneyTotal
        
    }
    
    func yourFatBalance() {
        let moneyTotal = "\(currency) 4,545,400"
        skinnyPete = NSMutableAttributedString(string: moneyTotal, attributes: [NSAttributedStringKey.font: UIFont (name: "Ubuntu", size: 21)!])
        skinnyPete.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Ubuntu-Light", size: 13.0)!, range: NSRange(location:0, length:3))
        availableBalance.attributedText = skinnyPete
        availableBalance.text = moneyTotal
        
    }
    
    
    
    // Scan button function
    @IBAction func scannerButton(_ sender: Any) {
        self.performSegue(withIdentifier: "scanSegue", sender: self)
    }

    
    // Design parameters
    func cardDesigns(){
        collectionView.cards()
        embededView.cards()
        revenueView.bottomLeftie()
        revenueRightView.bottomRightie()

        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
        self.tableView.addGestureRecognizer(longpress)
    }
    

    // App style and navigation
    func newStyle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.11, green:0.68, blue:0.83, alpha:1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        navigationController?.isNavigationBarHidden = true
        
        let profileNameGoogle = GIDSignIn.sharedInstance().currentUser.profile.givenName
        let profileEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email
        let profilePhoto = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 76)
        self.title = "Hi \(profileNameGoogle!)"
        
        profilePicture.kf.setImage(with: profilePhoto)
        profilePicture.roundMyCircle()
        username.text = "Hi \(profileNameGoogle!)"
        details.text = profileEmail
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("abrakadabra"))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tap)
    }

    
    // Objc functions
    @objc func abrakadabra() {
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
        let longpress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longpress.state
        let locationInView = longpress.location(in: self.tableView)
        var indexPath = self.tableView.indexPathForRow(at: locationInView)
        
        switch state {
        case .began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = self.tableView.cellForRow(at: indexPath!) as! dashboardCell
                My.cellSnapShot = snapshopOfCell(inputView: cell)
                var center = cell.center
                My.cellSnapShot?.center = center
                My.cellSnapShot?.alpha = 0.0
                self.tableView.addSubview(My.cellSnapShot!)
                
                UIView.animate(withDuration: 0.25, animations: {
                    center.y = locationInView.y
                    My.cellSnapShot?.center = center
                    My.cellSnapShot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapShot?.alpha = 0.98
                    cell.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        cell.isHidden = true
                    }
                })
            }
            
        case .changed:
            var center = My.cellSnapShot?.center
            center?.y = locationInView.y
            My.cellSnapShot?.center = center!
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                self.tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
            }
            
        default:
            let cell = self.tableView.cellForRow(at: Path.initialIndexPath!) as! dashboardCell
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                My.cellSnapShot?.center = cell.center
                My.cellSnapShot?.transform = .identity
                My.cellSnapShot?.alpha = 0.0
                cell.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    Path.initialIndexPath = nil
                    My.cellSnapShot?.removeFromSuperview()
                    My.cellSnapShot = nil
                }
            })
        }
    }
    
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
        struct My {
            static var cellSnapShot: UIView? = nil
            
    }
        struct Path {
            static var initialIndexPath: IndexPath? = nil
            
    }
   
    // Table View functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
}


// Collection view fetch Data functions
extension dashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! dashboardCollectionViewCell
    
        cell.cellProductName.text = products[indexPath.row].name
        
        let inventory = products[indexPath.row].inventory
        let inventoryNumber = inventory as NSNumber
        cell.cellProductInventory.text = inventoryNumber.stringValue
        
        if let data = products[indexPath.row].image as Data? {
            cell.cellProductImage.image = UIImage(data:data)
            
            let items = collectionView.numberOfItems(inSection: 0)
            let itemsNumber = items as NSNumber
            numberOfItems = itemsNumber.stringValue
            
        } else {
            cell.cellProductImage.image = UIImage(named: "features")
        }
        
        return cell

        }
}

    

