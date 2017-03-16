
//
//  OptionMenuVC.swift
//  Disctopia
//
//  Created by Dhaval on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class OptionMenuVC: BaseVC
{
    
    // MARK: - Functions

    @IBOutlet weak var frameButton: UIButton!

    @IBOutlet weak var viewAnimation: UIImageView!
    
    @IBOutlet weak var hideView: UIView!
    
    @IBOutlet weak var btnSearchOutlet: UIButton!
    
    @IBOutlet weak var btnShoppingCartOutlet: UIButton!
    
    @IBOutlet weak var btnSettings: UIButton!
    
    @IBOutlet weak var btnHelpOutlet: UIButton!

    @IBOutlet weak var btnCancelOutlet: UIButton!
   
    let duration    = 1.0
    
    var presenting  = false
    
    var isFromSearchBtn = Bool()
    
    var originFrame = CGRect.zero//CGRectMake(288, 35, 126, 84)
    
    var originFrame1 = CGRect.zero//CGRectMake(114, 196, 186, 70)
    
    
    // MARK: - Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        appDelegate.isLoderRequired = false
        BaseVC.sharedInstance.hideLoader()
        appDelegate.isLoderRequired = false
        btnCancelOutlet.exclusiveTouch = true
        btnSettings.exclusiveTouch = true
        btnHelpOutlet.exclusiveTouch = true
        btnSearchOutlet.exclusiveTouch = true
        originFrame1 = self.hideView.frame
        originFrame = CGRectMake(self.frameButton.frame.origin.x, self.frameButton.frame.origin.y, self.frameButton.frame.width, self.frameButton.frame.height)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
        btnCancelOutlet.layer.borderWidth = 1.0
        btnCancelOutlet.layer.borderColor = UIColor(white: 1.0, alpha: 1).CGColor
    }
    
    
    // MARK: - Actions
    
    @IBAction func btnSearch(sender: AnyObject)
    {
        /*
        if self.btnSearchOutlet.frame.origin.y == self.viewAnimation.frame.origin.y
        {
            NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier1", object: nil)
            self.isFromSearchBtn = true
            if self.parentViewController != nil
            {
                self.cycleFromViewController(self, toViewController: self.parentViewController!)
            }
        }
        else
        {
            UIView.animateWithDuration(0.36)
            {
                self.viewAnimation.frame = CGRectMake(self.btnSearchOutlet.frame.origin.x, self.btnSearchOutlet.frame.origin.y, self.btnSearchOutlet.frame.size.width, self.btnSearchOutlet.frame.size.height)
            }
        }
        
        */
        UIView.animateWithDuration(0.15, animations: {() -> Void in
            self.viewAnimation.frame = CGRectMake(self.btnSearchOutlet.frame.origin.x, self.btnSearchOutlet.frame.origin.y, self.btnSearchOutlet.frame.size.width, self.btnSearchOutlet.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier1", object: nil)
                self.isFromSearchBtn = true
                if self.parentViewController != nil
                {
                    self.cycleFromViewController(self, toViewController: self.parentViewController!)
                }
        })
        
        
        
    }
    
    @IBAction func btnShoppingCart(sender: AnyObject)
    {/*
        if self.btnShoppingCartOutlet.frame.origin.y == self.viewAnimation.frame.origin.y
        {
            //btnSearchOutlet.selected = false
            //btnSettings.selected = false
            //btnHelpOutlet.selected = true
//            let btnShoppingCartOutlet = UIAlertView()
//            btnShoppingCartOutlet.title = "Under Construction"
//            btnShoppingCartOutlet.addButtonWithTitle("OK")
//            btnShoppingCartOutlet.show()
//            self.isFromSearchBtn = false
//            self.presenting = true
//            self.pushToViewControllerIfNotExistWithClassName("HelpVC", animated: true)
//            self.cycleFromViewController(self, toViewController: parentViewController!)
            
              self.pushToViewControllerIfNotExistWithClassName("CartSummaryVC", animated: true)
            if self.parentViewController != nil
            {
                self.cycleFromViewController(self, toViewController: self.parentViewController!)
            }
            
        }
        else
        {
            UIView.animateWithDuration(0.36)
            {
                self.viewAnimation.frame = CGRectMake(self.btnShoppingCartOutlet.frame.origin.x, self.btnShoppingCartOutlet.frame.origin.y, self.btnShoppingCartOutlet.frame.size.width, self.btnShoppingCartOutlet.frame.size.height)
            }
        }
        */
        self.btnShoppingCartOutlet.enabled = false
        UIView.animateWithDuration(0.36, animations: {() -> Void in
            self.viewAnimation.frame = CGRectMake(self.btnShoppingCartOutlet.frame.origin.x, self.btnShoppingCartOutlet.frame.origin.y, self.btnShoppingCartOutlet.frame.size.width, self.btnShoppingCartOutlet.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                    self.btnShoppingCartOutlet.enabled = true
                self.pushToViewControllerIfNotExistWithClassName("CartSummaryVC", animated: true)
                if self.parentViewController != nil
                {
                    self.cycleFromViewController(self, toViewController: self.parentViewController!)
                }
                
        })
    }
    
    @IBAction func btnSettings(sender: AnyObject)
    {
        /*
        if self.btnSettings.frame.origin.y == self.viewAnimation.frame.origin.y
        {
//            self.dismissViewControllerAnimated(true, completion:
//            {
//                self.pushToViewControllerIfNotExistWithClassName("SettingsMenuVC", animated: true)
//            })
            self.isFromSearchBtn = false
            self.presenting = true
            self.pushToViewControllerIfNotExistWithClassName("SettingsMenuVC", animated: true)
            if self.parentViewController != nil
            {
                self.cycleFromViewController(self, toViewController: self.parentViewController!)
            }
        }
        else
        {
            UIView.animateWithDuration(0.36)
            {
                self.viewAnimation.frame = CGRectMake(self.btnSettings.frame.origin.x, self.btnSettings.frame.origin.y, self.btnSettings.frame.size.width, self.btnSettings.frame.size.height)
            }
        } 
 */
        self.btnSettings.enabled = false
        UIView.animateWithDuration(0.15, animations: {() -> Void in
            self.viewAnimation.frame = CGRectMake(self.btnSettings.frame.origin.x, self.btnSettings.frame.origin.y, self.btnSettings.frame.size.width, self.btnSettings.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.btnSettings.enabled = true
                self.isFromSearchBtn = false
                self.presenting = true

                if self.parentViewController != nil
                {
                    self.cycleFromViewController(self, toViewController: self.parentViewController!)
                }
                if let topViewController = appDelegate.navigationController?.topViewController
                {
                    if ((topViewController.isKindOfClass(SettingsMenuVC)))
                    {}
                    else
                    {
                        self.pushToViewControllerIfNotExistWithClassName("SettingsMenuVC", animated: true)
                    }
                }
        })
    }
    
    @IBAction func btnHelp(sender: AnyObject)
    {/*
        if self.btnHelpOutlet.frame.origin.y == self.viewAnimation.frame.origin.y
        {
            /*
            let btnShoppingCartOutlet = UIAlertView()
            btnShoppingCartOutlet.title = "Under Construction"
            btnShoppingCartOutlet.addButtonWithTitle("OK")
            btnShoppingCartOutlet.show()
             */
         
           //btnSearchOutlet.selected = false
           //btnSettings.selected = false
           //btnHelpOutlet.selected = true
           self.isFromSearchBtn = false
           self.presenting = true
           self.pushToViewControllerIfNotExistWithClassName("HelpVC", animated: true)
            if self.parentViewController != nil
            {
                self.cycleFromViewController(self, toViewController: self.parentViewController!)
            }
        }
        else
        {
            UIView.animateWithDuration(0.36)
            {
                self.viewAnimation.frame = CGRectMake(self.btnHelpOutlet.frame.origin.x, self.btnHelpOutlet.frame.origin.y, self.btnHelpOutlet.frame.size.width, self.btnHelpOutlet.frame.size.height)
            }
        }
 */
        self.btnHelpOutlet.enabled = false

        UIView.animateWithDuration(0.15, animations: {() -> Void in
            
            self.viewAnimation.frame = CGRectMake(self.btnHelpOutlet.frame.origin.x, self.btnHelpOutlet.frame.origin.y, self.btnHelpOutlet.frame.size.width, self.btnHelpOutlet.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.btnHelpOutlet.enabled = true
                self.isFromSearchBtn = false
                self.presenting = true
                if self.parentViewController != nil
                {
                    self.cycleFromViewController(self, toViewController: self.parentViewController!)
                }
                if let topViewController = appDelegate.navigationController?.topViewController
                {
                    if ((topViewController.isKindOfClass(HelpViewController)))
                    {}
                    else
                    {
                        self.pushToViewControllerIfNotExistWithClassName("HelpViewController", animated: true)
                    }
                }
              
        })
    }
    
    @IBAction func btnCancel(sender: AnyObject)
    {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        let presentingViewController: UIViewController! = self.presentingViewController
//        self.dismissViewControllerAnimated(false)
//        {
//            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
//        }
        self.isFromSearchBtn = false
        self.presenting = false
        self.hideLoader()
        if self.parentViewController != nil
        {
            self.cycleFromViewController(self, toViewController: self.parentViewController!)
        }
    }
    
    
    // MARK: - Functions

    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController)
    {
        oldViewController.willMoveToParentViewController(nil)
        newViewController.view.alpha = 1
        oldViewController.view.alpha = 1
        newViewController.view.layoutIfNeeded()
        //let thisView = oldViewController.view
        //let toView = newViewController.view
        let herbView = oldViewController.view
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        var finalFrame = CGRectMake(0, 0, 0, 0)
        var myTimeInterval = NSTimeInterval()
        if !self.isFromSearchBtn
        {
            finalFrame  = self.presenting ? herbView.frame : self.originFrame//CGRectMake(288, 35, 126, 84)
            myTimeInterval = 0.0
        }
        else
        {
            finalFrame  = self.presenting ? herbView.frame : self.originFrame1
            myTimeInterval = 0.3
        }
        
        let xScaleFactor = self.presenting ?
        initialFrame.width / finalFrame.width :
        finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
        initialFrame.height / finalFrame.height :
        finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        UIView.animateKeyframesWithDuration(0.15, delay: myTimeInterval, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations:
        {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            herbView.clipsToBounds = true
        },
        completion:
        {
            finished in
            //self.willMoveToParentViewController(nil)

            self.view.removeFromSuperview()
            self.removeFromParentViewController()

        })
    }
}
