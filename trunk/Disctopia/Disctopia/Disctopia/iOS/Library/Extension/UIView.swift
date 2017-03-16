//
//  UIView.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/5/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib<T: UIView>(viewType: T.Type) -> T {
        let className = String.className(viewType)
        return NSBundle(forClass: viewType).loadNibNamed(className, owner: nil, options: nil).first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    func enumerateSubviews(block: (view: UIView) -> ())
    {
        for view in self.subviews
        {
            // ignore _UILayoutGuide
            if (!view.conformsToProtocol(UILayoutSupport))
            {
                view.enumerateSubviews(block)
                block(view: view)
            }
        }
    }
    
    func removePrototypingConstraints()
    {
        for constraint in self.constraints
        {
            let name = NSStringFromClass(constraint.dynamicType)
            
            if (name.hasPrefix("NSIBPrototyping"))
            {
                self.removeConstraint(constraint)
            }
        }
    }
    
    func addProportionalSizeConstraints()
    {
        // need to disable autoresizing masks, they might interfere
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // there must be a superview
        let superview = self.superview!
        
        // get dimensions
        let bounds = superview.bounds;
        let frame = self.frame
        
        // calculate percentages relative to bounds
        let percent_width = frame.size.width / bounds.width;
        let percent_height = frame.size.height / bounds.height;
        
        // constrain width as percent of superview
        let widthConstraint = NSLayoutConstraint(item: self,
                                                 attribute: .Width,
                                                 relatedBy: .Equal,
                                                 toItem: superview,
                                                 attribute: .Width,
                                                 multiplier: percent_width,
                                                 constant: 0);
        superview.addConstraint(widthConstraint);
        
        // constrain height as percent of superview
        let heightConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .Height,
                                                  relatedBy: .Equal,
                                                  toItem: superview,
                                                  attribute: .Height,
                                                  multiplier: percent_height,
                                                  constant: 0);
        superview.addConstraint(heightConstraint);
    }
    
    func addProportionalOriginConstraints()
    {
        // need to disable autoresizing masks, they might interfere
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // there must be a superview
        let superview = self.superview!
        
        // get dimensions
        let bounds = superview.bounds;
        let frame = self.frame
        
        // calculate percentages relative to bounds
        let percent_x = frame.origin.x / bounds.width;
        let percent_y = frame.origin.y / bounds.height;
        
        // constrain left as percent of superview
        if (percent_x > 0)
        {
            let leftMargin = NSLayoutConstraint(item: self,
                                                attribute: .Left,
                                                relatedBy: .Equal,
                                                toItem: superview,
                                                attribute: .Right,
                                                multiplier: percent_x,
                                                constant: 0);
            superview.addConstraint(leftMargin);
        }
        else
        {
            // since a multipler of 0 is illegal for .Right instead make .Left equal
            let leftMargin = NSLayoutConstraint(item: self,
                                                attribute: .Left,
                                                relatedBy: .Equal,
                                                toItem: superview,
                                                attribute: .Left,
                                                multiplier: 1,
                                                constant: 0);
            superview.addConstraint(leftMargin);
        }
        
        // constrain top as percent of superview
        if (percent_y > 0 )
        {
            let topMargin = NSLayoutConstraint(item: self,
                                               attribute: .Top,
                                               relatedBy: .Equal,
                                               toItem: superview,
                                               attribute: .Bottom,
                                               multiplier: percent_y,
                                               constant: 0);
            superview .addConstraint(topMargin);
        }
        else
        {
            // since a multipler of 0 is illegal for .Bottom we instead make .Top equal
            let topMargin = NSLayoutConstraint(item: self,
                                               attribute: .Top,
                                               relatedBy: .Equal,
                                               toItem: superview,
                                               attribute: .Top,
                                               multiplier: 1,
                                               constant: 0);
            superview .addConstraint(topMargin);
        }
    }

}
