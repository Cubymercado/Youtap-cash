//
//  appStyle.swift
//  merchant
//
//  Created by Eugenio Mercado on 11/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import UIKit 

// App colours
extension UIColor {
    static var darkBlue: UIColor {
        return UIColor(red:0.11, green:0.68, blue:0.83, alpha:1.0)
        //UIColor(red:0.11, green:0.68, blue:0.83, alpha:1.0)
    }
    static var actionBlue: UIColor {
        return UIColor(red:0.97, green:0.33, blue:0.20, alpha:1.0) // Orange
        // UIColor(red:0.97, green:0.33, blue:0.20, alpha:1.0)
    }
    static var electricGreen: UIColor {
        return UIColor(red:0.49, green:0.83, blue:0.13, alpha:1.0)
        // UIColor(red:0.07, green:0.67, blue:0.00, alpha:1.0)
    }
}

// App font
extension UIFont {
    static var titles: UIFont {
        return UIFont(name: "Ubuntu-Regular", size: 17)!
    }
    static var descriptions: UIFont {
        return UIFont(name: "Ubuntu-Light", size: 13)!
    }
}

// Card images
extension UIImageView {
    func card() {
        
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        
    }
}

// Card view
extension UIImageView {
    func cardView() {
    self.layer.cornerRadius = 20
        
    }
    
}

// Pay button right corners radius
extension UIButton {
    public func buttonCorners() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
    }
}

// Pay button right corners radius
extension UIButton {
    public func buttonCornersFour() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
}


// Text fiels left corners radius
extension UITextField {
    public func textFieldCorners() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        let padding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        self.leftView = padding
        self.leftViewMode = .always
        
    }
}

// Background colours
extension UIView {
    public func itsSalmonBitch(){
        self.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.89, alpha:1.0)
        
    }
}

extension UIView {
    public func whiteGirlsWated(){
        self.backgroundColor = UIColor.white
        
    }
}


// White Background top corners radius
extension UIView {
    public func whiteTopCorners (){
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 25
        self.layer.maskedCorners = [.layerMinXMinYCorner, . layerMaxXMinYCorner]
        
    }
    
}

// Top corners radius
extension UIView {
    public func roundTopCorners (){
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, . layerMaxXMinYCorner]
        
    }
    
}

extension UIView {
    public func cards (){
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    
}


// Bottom left corner
extension UIView {
    public func bottomLeftie () {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMaxYCorner]
        
    }
    
}

// Bottom left corner
extension UIView {
    public func bottomLeftieTwo () {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.maskedCorners = [.layerMinXMaxYCorner]
        
    }
    
}

// Bottom right
extension UIView {
    public func bottomRightie () {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
    }
    
}

// White Background top corners radius
extension UIView {
    public func bottomCorners (){
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 25
        self.layer.maskedCorners = [.layerMinXMaxYCorner, . layerMaxXMaxYCorner]
        
    }
    
}


// Till Buttons corner radius
extension UIView {
    public func threeCorners (){
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.maskedCorners = [.layerMinXMinYCorner, . layerMaxXMaxYCorner, . layerMinXMaxYCorner]
        
    }
    
}

// Till Buttons corner radius
extension UIView {
    public func threeCornersSmall (){
        self.clipsToBounds = true
        self.layer.cornerRadius = 3
        self.layer.maskedCorners = [.layerMinXMinYCorner, . layerMaxXMaxYCorner, . layerMinXMaxYCorner]
    }
    
}

// Till Buttons shadow
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.11).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 3)
        layer.shadowRadius = 3
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

// Till Buttons shadow
extension UIView {
    func dropShadowHard(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.11).cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize(width: 1, height: 3)
        layer.shadowRadius = 3
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

// Company Buttons shadow
extension UIView {
    func dropShadowLight(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.11).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowRadius = 3
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

extension UIView {
    func dropShadowSuperLight(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.1).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 3
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

// White image selection
extension UIImageView {
    func imageTint(color:UIColor) -> UIImage
    {
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
        tintColor = color
        return image!
        
    }
    
}

// Transparent image selection
extension UIImageView {
    func imageTintTrans() -> UIImage
    {
        let renderingMode: UIImage.RenderingMode = .alwaysOriginal
        self.image = self.image?.withRenderingMode(renderingMode)
        
        return image!
    }
    
}

// Circle images
extension UIImageView {
    func roundMyCircle() {
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        
    }
}

// Images
extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard 375 > 0 && 185 > 0 else { return bounds }
        
        let scale: CGFloat
        if 375 > 185 {
            scale = bounds.width / 375
        } else {
            scale = bounds.height / 185
        }
        
        let size = CGSize(width: 375 * scale, height: 185 * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

extension UIImageView{
    func blurImage()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

extension UIImageView{
    func blurImageRegular()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

extension UIImageView{
    func blurImageDark()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}


// Aspect fill resize
class ScaledHeightImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
}


// Text Field padding extension
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

// Text Field corners
extension UITextField {
    func aroundTheCornerIsThePub(){
        self.layer.cornerRadius = 10
        
    }
    
}

// Text Field bottom border
extension UITextField {
    
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.groupTableViewBackground.cgColor
        self.borderStyle = UITextBorderStyle.none
        self.layer.addSublayer(bottomLine)
        
    }
}

// Hide keyboard extension
extension UIViewController {
    func hideKeyboardOrangutan() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
