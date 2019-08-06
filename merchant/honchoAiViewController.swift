//
//  honchoAiViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 7/02/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class honchoAiViewController: UIViewController, UITextFieldDelegate {

    // Variables
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var honcho: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide keyboard
        hideKeyboardOrangutan()
        
    }
    
    // Button functiobn
    @IBAction func sendButton(_ sender: Any) {
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.messageTextField.text, text != "" {
            request?.query = text
            
        } else {
            
            return
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
                
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        messageTextField.text = ""

    }
    
    // Talking function
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.responseLabel.text = text
        }, completion: nil)
    }
    
    // Keyboard hiding functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -260, up: true)
        
    }
    
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -260, up: false)
    }
    
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
  

}
