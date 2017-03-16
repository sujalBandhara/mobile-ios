//
//  CustomLabel.swift
//  Disctopia
//
//  Created by Mitesh on 22/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

@IBDesignable
public class CustomLabel: UILabel {
    
    @IBInspectable var myLineSpacing: CGFloat = 0
        {
        didSet
        {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSKernAttributeName, value: self.myLineSpacing, range: NSMakeRange(0, text!.characters.count))
            self.attributedText = attributedString
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureLabel()
    }
    
    func configureLabel()
    {
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSKernAttributeName, value: self.myLineSpacing, range: NSMakeRange(0, text!.characters.count))
        self.attributedText = attributedString
    }
}

//    func setText(text: String) {
//        var paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
//        
//        paragraphStyle.lineSpacing = myLineSpacing
//        paragraphStyle.alignment = self.textAlignment
//        var attributes: [NSObject : AnyObject] = [NSParagraphStyleAttributeName: paragraphStyle]
//        var attributedText: NSAttributedString = NSAttributedString(string: text, attributes: attributes)
//        self.attributedText = attributedText
//    }