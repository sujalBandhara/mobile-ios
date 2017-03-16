//
//  WWAlertVC.swift
//  Disctopia
//
//  Created by Mitesh on 13/12/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.

import UIKit


class WWAlertVC: UIViewController {
    
    var container:UIView!
    var messageLbl:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()//.colorWithAlphaComponent(0.8)
        self.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
         NSTimer.scheduledTimerWithTimeInterval(3.7, target: self, selector: #selector(WWAlertVC.onClose(_:)), userInfo: nil, repeats: false)
    }
    
    
    // MARK:- Methods
    
    func displayMessage(message:String)
    {
        if self.container == nil{
            
            self.container = UIView(frame: CGRectMake(0, -45, UIScreen.mainScreen().bounds.width, 45))
            self.container.backgroundColor = UIColor(red: 254 / 255, green: 56.0 / 255, blue: 36.0 / 255, alpha: 1.0)
            self.view.addSubview(self.container)
        }
        
        if self.messageLbl == nil
        {
            self.messageLbl = UILabel(frame: CGRectMake(10, 10, self.container.frame.width-10, 30))
            self.messageLbl.center = self.container.center
            self.messageLbl.text = message
            self.messageLbl.textAlignment = NSTextAlignment.Center
            self.messageLbl.numberOfLines = 0
            self.messageLbl.font =  UIFont.boldSystemFontOfSize(10)
            self.messageLbl.font = UIFont(name: "OpenSans-Regular", size: self.messageLbl.font.pointSize)
            self.messageLbl.adjustsFontSizeToFitWidth = true
            self.messageLbl.textColor = UIColor.whiteColor()
            self.container.addSubview(self.messageLbl)
        }
       
        
        self.view.alpha = 0
        
        let delegate:UIApplicationDelegate = UIApplication.sharedApplication().delegate!
        let window:UIWindow! = delegate.window!
        window.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        window.rootViewController!.presentViewController(self, animated: false, completion: nil)
        
        self.performSelector(#selector(self.displayView), withObject: nil, afterDelay: 0.2)
    }
    
    func displayView() {
        
        UIView.transitionWithView(self.container, duration: 0.3, options: .CurveLinear, animations: { 
            self.view.alpha = 1
            self.container.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 45)
            self.messageLbl.frame = CGRectMake(10, 10, self.container.width-20, 30)
            }) { (finished) in
                
        }

    }
    
    // MARK:- Handlers
    
    func onClose(sender: UIButton)
    {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.container.center = CGPointMake(self.view.center.x,  -50)
            self.view.alpha = 0
        }) { (Bool) -> Void in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
}

