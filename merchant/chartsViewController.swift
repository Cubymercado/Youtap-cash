//
//  chartsViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 4/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import CoreData
import XLPagerTabStrip
import Charts
import AERecord

class chartsViewController: UIViewController, IndicatorInfoProvider{

    
    @IBOutlet weak var todaysView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var todaysAmountLabel: UILabel!
    
    @IBOutlet weak var pieChart: PieChartView!
    
    // Pie Chart Variables
    var firstDataEntry = PieChartDataEntry(value: 0)
    var secondDataEntry = PieChartDataEntry(value: 0)
    var thirdDataEntry = PieChartDataEntry(value: 0)
    
    var totalDataEntry = [PieChartDataEntry]()

    // Date and Time variables
    let formatter = DateFormatter()
    let formatterMonth = DateFormatter()
    let date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Parameters
        pieChart.chartDescription?.text = "Payments"
        coreDataModel()
        theCayoteIsHere()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        countWithAttribute()
        updateChartData()
    }
    

    func coreDataModel() {
        
        // Core Data model
        let myModel = AERecord.modelFromBundle(for: Transactions3.self)
        do {
            try AERecord.loadCoreDataStack(managedObjectModel: myModel, storeType: NSInMemoryStoreType)
           print (myModel)
        }
        catch {
            print(error)
        }
    }
    
    
    // Count from Core Data
    func countWithAttribute() {
     
        let nfcCount = Products1.count(with: "name", value: "Indomie Chicken" as AnyObject)
        let qrCount = Transactions3.count(with: "payment", value: "QR Payment" as AnyObject)
        let cashCount = Transactions3.count(with: "payment", value: "Cash Payment" as AnyObject)
        
        firstDataEntry.value = 20//Double(nfcCount)
        firstDataEntry.label = "NFC"
        
        secondDataEntry.value = 15//Double(qrCount)
        secondDataEntry.label = "QRC"
        
        thirdDataEntry.value = 80//Double(cashCount)
        thirdDataEntry.label = "Cash"
        
        
        totalDataEntry = [firstDataEntry, secondDataEntry, thirdDataEntry]
        
        
        
        print(nfcCount, qrCount, cashCount)
    }
    
    
    // Update Pie Chart function
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(entries: totalDataEntry, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0), UIColor(red:0.82, green:0.00, blue:0.28, alpha:1.0), UIColor(red: 0.4941, green: 0.8275, blue: 0.1294, alpha: 1.0)]
        
        chartDataSet.colors = colors
        
        pieChart.data = chartData
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    // Slider menu indicator
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "INSIGHTS")
        
    }
    
    func theCayoteIsHere(){
        // Get current date and time
        formatter.dateFormat = "dd"
        formatterMonth.dateFormat = "MMMM"
    
        let dayResult = formatter.string(from: date)
        let monthResult = formatterMonth.string(from: date)
        
        dayLabel!.text = dayResult
        monthLabel!.text = monthResult
        
        
    }
    
}
