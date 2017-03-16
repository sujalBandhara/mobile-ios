//
//  FanAccountInfoVC.swift
//  Disctopia
//
//  Created by abc on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class FanAccountInfoVC: BaseVC
{

    var param = Dictionary<String, String>()
    
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect()
    var imgFrame = CGRect()
    var leftnewFrame = CGRect()
    var leftoldFrame = CGRect()
    var rightnewFrame = CGRect()
    var rightoldFrame = CGRect()
    var newFanFrame = CGRect()
    var oldFanFrame = CGRect()
    var newFreeFrame = CGRect()
    var oldFreeFrame = CGRect()
    
    /////
    var newDescriptionFrame = CGRect()
    var oldDescriptionFrame = CGRect()
    var newRegisterFrame = CGRect()
    var oldRegisterFrame = CGRect()
    var newCancelFrame = CGRect()
    var oldCancelFrame = CGRect()
    /////
    
    @IBOutlet weak var fanImgView: UIImageView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var lblFan: UILabel!
    @IBOutlet weak var lblfree: UILabel!
    
    ////
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var registerBtnView: UIView!
    @IBOutlet weak var cancelBtnView: UIView!
    ////
    
    override func viewDidLoad()
    {
        self.dynamicFontNeeded = false
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear FanAccountViewController")
        
        self.fanImgView.layoutIfNeeded()
        self.leftView.layoutIfNeeded()
        self.rightView.layoutIfNeeded()
        self.lblFan.layoutIfNeeded()
        self.lblfree.layoutIfNeeded()
        self.descriptionView.layoutIfNeeded()
        self.registerBtnView.layoutIfNeeded()
        
        self.originFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        
        self.imgFrame = self.fanImgView.frame
        
        self.leftoldFrame = self.leftView.frame
        self.leftnewFrame = CGRectMake(self.leftView.frame.origin.x, self.descriptionView.frame.size.height, self.leftView.frame.size.width, self.leftView.frame.size.height)
        
        self.rightoldFrame = self.rightView.frame
        self.rightnewFrame = CGRectMake(self.rightView.frame.origin.x, self.descriptionView.frame.size.height, self.rightView.frame.size.width, self.rightView.frame.size.height)
        
        self.oldFanFrame = self.lblFan.frame
        self.newFanFrame = CGRectMake(self.lblFan.frame.origin.x, self.descriptionView.frame.origin.y, self.lblFan.frame.size.width, self.lblFan.frame.size.height)
        
        self.oldFreeFrame = self.lblfree.frame
        self.newFreeFrame = CGRectMake(self.lblfree.frame.origin.x, self.descriptionView.frame.origin.y, self.lblfree.frame.size.width, self.lblfree.frame.size.height)
        
        
        self.descriptionView.alpha = 0
        self.registerBtnView.alpha = 0
        /////
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear FanAccountViewController")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear FanAccountViewController")
        
        self.fanImgView.frame = CGRectMake(self.fanImgView.frame.origin.x, self.descriptionView.frame.size.height, self.fanImgView.frame.size.width, self.fanImgView.frame.size.height)
        
        self.fanImgView.alpha = 1
        self.leftView.frame = self.leftnewFrame
        
        self.leftView.alpha = 1
        self.rightView.frame = self.rightnewFrame
        
        self.rightView.alpha = 1
        
        self.lblFan.frame = self.newFanFrame
        self.lblFan.alpha = 1
        
        self.lblfree.frame = self.newFreeFrame
        self.lblfree.alpha = 1
        
        ///////////
        self.oldDescriptionFrame = self.descriptionView.frame
        self.newDescriptionFrame = CGRectMake(self.descriptionView.frame.origin.x, self.view.frame.size.height, self.descriptionView.frame.size.width, self.descriptionView.frame.size.height)
        
        self.descriptionView.frame = self.newDescriptionFrame
        
        self.oldRegisterFrame = self.registerBtnView.frame
        self.newRegisterFrame = CGRectMake(self.registerBtnView.frame.origin.x, self.view.frame.size.height+self.view.frame.size.height, self.registerBtnView.frame.size.width, self.registerBtnView.frame.size.height)
        
        self.registerBtnView.frame = self.newRegisterFrame
        ////////////////
        
        self.performSelector(#selector(trackViewFrame1), withObject:nil, afterDelay: 0.3)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear FanAccountViewController")
    }
        
    @IBAction func cancelClicked(sender: AnyObject)
    {
        self.performSelector(#selector(trackViewFrame2), withObject:nil, afterDelay: 0.0)
        
        NSNotificationCenter.defaultCenter().postNotificationName("trackViewFrame3", object: nil)
        
        self.beginAppearanceTransition(false, animated: true)
        self.willMoveToParentViewController(parentViewController!)
        self.endAppearanceTransition()
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.alpha = 0
            self.view.frame = CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
            },completion:  { (true) in
                //self.imgView.image = UIImage(named: "artist_logo.png")
                //view.alpha = 0
                //self.didMoveToParentViewController(self)
                self.removeFromParentViewController()
                self.navigationController?.popViewControllerAnimated(false)
                
        })
        
    }
    
    func trackViewFrame1()
    {
        UIView.animateWithDuration(0.5, animations: {
            
            self.fanImgView.frame = self.imgFrame
            self.fanImgView.alpha = 1
            
            self.leftView.frame = self.leftoldFrame
            self.leftView.alpha = 1
            
            self.rightView.frame = self.rightoldFrame
            self.rightView.alpha = 1
            
            self.lblFan.frame = self.oldFanFrame
            self.lblFan.alpha = 1
            
            self.lblfree.frame = self.oldFreeFrame
            self.lblfree.alpha = 1
            
            //self.descriptionView.frame = self.oldDescriptionFrame
            //self.descriptionView.alpha = 1
            
            
            
            },completion:  { (true) in
                //self.imgView.image = UIImage(named: "artist_logo.png")
                //view.alpha = 0
                
        })
        UIView.animateWithDuration(0.5, animations: {
            self.descriptionView.frame = self.oldDescriptionFrame
            self.descriptionView.alpha = 1
            
            self.registerBtnView.frame = self.oldRegisterFrame
            self.registerBtnView.alpha = 1
            
            },completion:  { (true) in
                //self.imgView.image = UIImage(named: "artist_logo.png")
                //view.alpha = 0
                
        })
        
    }
    
    func trackViewFrame2()
    {
        
        UIView.animateWithDuration(0.5, animations: {
            self.fanImgView.frame = CGRectMake(self.fanImgView.frame.origin.x, self.view.frame.size.height/2, self.fanImgView.frame.size.width, self.fanImgView.frame.size.height)
            
            self.fanImgView.alpha = 0
            self.leftView.frame = self.leftnewFrame
            
            self.leftView.alpha = 0
            self.rightView.frame = self.rightnewFrame//CGRectMake(self.rightView.frame.origin.x, self.leftView.frame.origin.y, self.rightView.frame.size.width, self.right View.frame.size.height)
            
            self.rightView.alpha = 0
            self.lblFan.frame = self.newFanFrame//CGRectMake(self.lblFan.frame.origin.x, -10, self.lblFan.frame.size.width, self.lblFan.frame.size.height)
            self.lblFan.alpha = 0
            
            self.lblfree.frame = self.newFreeFrame
            self.lblfree.alpha = 0
            
            self.lblDescription.frame = self.newDescriptionFrame
            self.lblDescription.alpha = 0
            
            self.registerBtnView.frame = self.newRegisterFrame
            self.registerBtnView.alpha = 0
            
            },completion:  { (true) in
                //self.imgView.image = UIImage(named: "artist_logo.png")
                //view.alpha = 0
        })
    }
    
    
    @IBAction func registerClicked(sender: AnyObject) {
        
        let createAccountVC = storyboard!.instantiateViewControllerWithIdentifier("CreateNewFanAccountVC") as! CreateNewFanAccountVC
        createAccountVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.cycleFromViewController(self, toViewController: createAccountVC)
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.view!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        //let thisView = oldViewController.view
        let toView = newViewController.view
        
        let herbView = newViewController.view
        
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : self.originFrame
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if self.presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            herbView.clipsToBounds = true
            
            self.view.addSubview(toView)
            self.view.bringSubviewToFront(herbView)
        }
        
        
        UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                y: CGRectGetMidY(finalFrame))
            
            },
                                            completion: { finished in
                                                
                                                newViewController.didMoveToParentViewController(self)
        })
    }

}
