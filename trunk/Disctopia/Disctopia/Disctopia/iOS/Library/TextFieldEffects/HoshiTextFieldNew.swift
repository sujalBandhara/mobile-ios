//
//  HoshiTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

let commonColor = UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1.0)
/**
 An HoshiTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the lower edge of the control.
 */
@IBDesignable public class HoshiTextFieldNew: TextFieldEffects {
    
    /**
     The color of the border when it has no content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic public var borderInactiveColor: UIColor = commonColor {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the border when it has content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic public var borderActiveColor: UIColor = commonColor {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the placeholder text.

     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic public var placeholderColor: UIColor = commonColor {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
    */
    @IBInspectable dynamic public var placeholderFontScale: CGFloat = 0.5 {
        didSet {
            updatePlaceholder()
        }
    }


    override public var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    var isActiveState = false
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 1, inactive: 1)
    private let placeholderInsets = CGPoint(x: 0, y: 6)
    private let textFieldInsets = CGPoint(x: 5, y: 9)
    private let activeBorderLayer = CALayer()
    private let inactiveBorderLayer = CALayer()
    private var activePlaceholderPoint: CGPoint = CGPointZero
    
    // MARK: - TextFieldsEffects
    
    override public func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        loadDefaultValues()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
    }
    
    func loadDefaultValues()
    {   //self.tintColor = UIColor.redColor()
        self.textColor = commonColor
        self.placeholderColor = commonColor
        self.borderActiveColor = commonColor
        self.borderInactiveColor =  commonColor
        self.borderColor = commonColor
        self.borderWidth = 0
    }
    
    override public func animateViewsForTextEntry()
    {
        if text!.isEmpty {
            UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .BeginFromCurrentState, animations: ({
                
                self.isActiveState = true
//                let translate = CGAffineTransformMakeTranslation(-self.placeholderInsets.x, self.placeholderLabel.bounds.height + (self.placeholderInsets.y * 2))
//                let scale = CGAffineTransformMakeScale(0.5, 0.5)
//                self.placeholderLabel.transform = CGAffineTransformConcat(translate, scale)
//                
                self.placeholderLabel.frame.origin = CGPoint(x: 0, y: self.placeholderLabel.frame.origin.y)
                self.placeholderLabel.alpha = 0
                
                self.placeholderLabel.font = self.placeholderFontFromFont(self.font!)

            }), completion: { _ in
                self.animationCompletionHandler?(type: .TextEntry)
            })
        }
    
        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin = activePlaceholderPoint
        
        UIView.animateWithDuration(0.2, animations: {
            self.placeholderLabel.alpha = 0.9
        })
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
    }
    
    override public func animateViewsForTextDisplay()
    {
        if text!.isEmpty {
            UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({
                
               // self.placeholderLabel.transform = CGAffineTransformIdentity
                self.isActiveState = false
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
                self.placeholderLabel.font = self.placeholderFontFromFont(self.font!)

                }), completion: { _ in
                self.animationCompletionHandler?(type: .TextDisplay)

            })
            
            self.activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
        }
    }
    
    // MARK: - Private
    
    private func updateBorder()
    {
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: false)
        activeBorderLayer.backgroundColor = borderActiveColor.CGColor

        
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: true)
        inactiveBorderLayer.backgroundColor = borderInactiveColor.CGColor
        //inactiveBorderLayer.borderColor = UIColor.grayColor().CGColor
        
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder() || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
       
        if (isActiveState)
        {
            let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
            return smallerFont
        }
        else
        {
            let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale * (1/placeholderFontScale))
            return smallerFont
        }
    }

    private func rectForBorder(thickness: CGFloat, isFilled: Bool) -> CGRect {
        
        if isFilled {
            self.placeholderLabel.textColor = commonColor
            return CGRect(origin: CGPoint(x: 0, y: CGRectGetHeight(frame)-thickness), size: CGSize(width: CGRectGetWidth(frame), height: thickness))
        } else {
            self.placeholderLabel.textColor = commonColor
            return CGRect(origin: CGPoint(x: 0, y: CGRectGetHeight(frame)-thickness + 4), size: CGSize(width: CGRectGetWidth(frame), height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        
       // placeholderLabel.transform = CGAffineTransformIdentity

        let textRect = textRectForBounds(bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .Center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .Right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        
        if DeviceType.IS_IPHONE_5 {
            placeholderLabel.frame = CGRect(x: originX, y: self.bounds.size.height/1,
                                        width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
            activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x , y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderLabel.bounds.height) //placeholderInsets.y)
        }
        else if DeviceType.IS_IPHONE_4_OR_LESS {
            placeholderLabel.frame = CGRect(x: originX, y: self.bounds.size.height/1.9,
                                            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
            activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x , y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height)// - placeholderLabel.bounds.height) //placeholderInsets.y)
        }
        else if DeviceType.IS_IPHONE_6 {
            placeholderLabel.frame = CGRect(x: originX, y: self.bounds.size.height/2.0,
                                            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
            activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x , y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height) //placeholderInsets.y)
        }
        else if DeviceType.IS_IPHONE_6P {
            placeholderLabel.frame = CGRect(x: originX, y: self.bounds.size.height/2.0,
                                            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
            activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x , y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height) //placeholderInsets.y)

        }
        else {
            placeholderLabel.frame = CGRect(x: originX, y: self.bounds.size.height/2.0,
                                            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
            activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x , y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height) //placeholderInsets.y)

        }
         placeholderLabel.frame = CGRect(x: originX, y: textRect.height - placeholderLabel.bounds.height - placeholderInsets.y,
         width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
         
        
        /*placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2,
            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)*/
        

    }
    
    // MARK: - Overrides
    
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect
    {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }
    
}

//extension UITextField {
//    
//    //    @IBInspectable var placeHolderColor: UIColor? {
//    //        get {
//    //            return self.placeHolderColor
//    //        }
//    //        set {
//    //            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
//    //        }
//    //    }
//    
//    
//    @IBInspectable var bottomBorderColor: UIColor? {
//        get {
//            return self.bottomBorderColor
//        }
//        set {
//            self.borderStyle = UITextBorderStyle.None;
//            let border = CALayer()
//            let width = CGFloat(0.5)
//            border.borderColor = newValue?.CGColor
//            border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
//            
//            border.borderWidth = width
//            self.layer.addSublayer(border)
//            self.layer.masksToBounds = true
//            
//        }
//    }
//}
//
