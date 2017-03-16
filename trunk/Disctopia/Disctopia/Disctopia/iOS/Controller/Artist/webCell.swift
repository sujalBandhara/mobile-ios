//
//  webCell.swift
//  Disctopia
//
//  Created by iMac03 on 03/10/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class webCell: UITableViewCell {
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var helpLabel: UILabel!
    @IBOutlet var lblButton: UIButton!
    @IBOutlet var arrowImg: UIImageView!
    @IBOutlet var arrowlbl: UILabel!
    
    @IBOutlet var secondView: UIView!
    @IBOutlet var helpDetailView: UIWebView!
    @IBOutlet var lblHelp: UILabel!
    
    @IBOutlet weak var secondHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.helpDetailView.dataDetectorTypes = .All
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var showDetails = false {
        didSet {
            secondHeightConstraint.priority = showDetails ? 250 : 999
        }
    }
    
    func setCollapsed(selected: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
        arrowlbl.rotate(selected ? 0.0 : CGFloat(M_PI_2))
    }
}

extension UIView {
    
    func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.addAnimation(animation, forKey: nil)
    }
    
}