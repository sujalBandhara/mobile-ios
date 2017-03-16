//
//  LogoutSeetingViewController.swift
//  Disctopia
//
//  Created by Dhaval on 30/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class ConfirmShoppingViewController: BaseVC
{

    // MARK: - Outlets
    @IBOutlet weak var lblConfirmPrice: UILabel!
    @IBOutlet weak var frameButton: UIButton!
    
    @IBOutlet weak var animationView: UIImageView!
    
    @IBOutlet weak var btnYes: UIButton!
    
    @IBOutlet weak var btnNo: UIButton!
    
    @IBOutlet weak var viewLogout: UIView!

    let duration    = 1.0
    
    var presenting  = true
    
    var isFromSearchBtn = Bool()
    
    var originFrame = CGRectMake(288, 35, 126, 84)

    var originFrame1 = CGRectMake(114, 196, 186, 70)
    

    // MARK: - Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        originFrame1 = CGRectMake(self.frameButton.frame.origin.x, self.frameButton.frame.origin.y, self.frameButton.frame.width, self.frameButton.frame.height)
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear ConfirmShoppingViewController")
    }

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear ConfirmShoppingViewController")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear ConfirmShoppingViewController")
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear ConfirmShoppingViewController")
    }
    
    
    // MARK: - Actions
    
//    @IBAction func onCancelLogoutClick(sender: AnyObject)
//    {
//        self.isFromSearchBtn = false
//        self.presenting = false
//        self.cycleFromViewController(self, toViewController: parentViewController!)
//    }
    
    @IBAction func onYesClick(button: UIButton)
    {
        
        /*
        if self.btnYes.frame.origin.y == self.animationView.frame.origin.y
        {
            self.paymentNow()
           
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnYes.frame.origin.x, self.btnYes.frame.origin.y, self.btnYes.frame.size.width, self.btnYes.frame.size.height)
            }
        }
 */
        UIView.animateWithDuration(0.5, animations: {() -> Void in
             self.animationView.frame = CGRectMake(self.btnYes.frame.origin.x, self.btnYes.frame.origin.y, self.btnYes.frame.size.width, self.btnYes.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
               // self.paymentNow()
                
                //self.inAppPayment()
        })

    }
    
   
    
    
//    
//    func paymentNow()
//    {
//        /*
//        self.loadThankyouScreen()
//        */
//        API.createPayment(nil, aViewController: self) { (result: JSON) in
//            if ( result != nil )
//            {
//                BaseVC.sharedInstance.DLog("#### createPayment API Response: \(result)")
//                self.DAlert(ALERT_TITLE, message: "Payment done succeessfully", action: ALERT_OK, sender: self)
//                self.loadThankyouScreen()
//            }
//        }
//    }

    func loadThankyouScreen()
    {
        self.view.removeFromSuperview()
        let vc : ThankYouPurchasingVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ThankYouPurchasingVC") as! ThankYouPurchasingVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        navigationController.navigationBarHidden = true
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func onNoClick(sender: AnyObject)
    {
        /*
        if self.btnNo.frame.origin.y == self.animationView.frame.origin.y
        {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.isFromSearchBtn = false
            self.presenting = false
            
            if self.parentViewController != nil
            {
                self.cycleFromViewController(self, toViewController: self.parentViewController!)
            }
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnNo.frame.origin.x, self.btnNo.frame.origin.y, self.btnNo.frame.size.width, self.btnNo.frame.size.height)
            }
        }
 */
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnNo.frame.origin.x, self.btnNo.frame.origin.y, self.btnNo.frame.size.width, self.btnNo.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.isFromSearchBtn = false
                self.presenting = false
                
                if self.parentViewController != nil
                {
                    self.cycleFromViewController(self, toViewController: self.parentViewController!)
                }
        })

    }
    
    // MARK: - Animation Function
    
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
        
        var finalFrame = self.originFrame   //CGRectMake(139, 290, 80, 100)
        var myTimeInterval = NSTimeInterval()
        
        if !self.isFromSearchBtn
        {
            finalFrame  = self.presenting ? herbView.frame : self.originFrame1
            myTimeInterval = 0.3
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
        UIView.animateKeyframesWithDuration(0.3, delay: myTimeInterval, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations:
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
            
           // self.pushToViewControllerIfNotExistWithClassName("ThankYouPurchasingVC", animated: true)

        })
    }
}
