//
//  paymentsViewController.swift
//  merchant
//
//  Created by Eugenio Mercado on 17/06/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit

class mainScreenViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var customerText: UITextField!
    @IBOutlet weak var adButton: UIButton!
    
    
    @IBAction func button(_ sender: Any) {
        self.adButton.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        amountText.delegate = self
        customerText.delegate = self
        
        tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
       cell.transform = CGAffineTransform(rotationAngle: (-.pi))
        
        // Do any additional setup after loading the view.
    }

    
    
 override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
