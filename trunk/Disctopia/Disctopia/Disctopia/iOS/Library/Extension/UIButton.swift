//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import Foundation

extension UIButton {
    
    func addUnderLine()
    {
        let attrs = [NSUnderlineStyleAttributeName : 1]
        let attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:(self.titleLabel?.text)!, attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        self.setAttributedTitle(attributedString, forState: .Normal)

    }
    
}