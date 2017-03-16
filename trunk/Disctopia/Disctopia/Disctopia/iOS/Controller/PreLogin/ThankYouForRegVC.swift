//
//  ThankYouForRegVC.swift
//  Disctopia
//
//  Created by abc on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class ThankYouForRegVC: BaseVC {

    var presenting  = false
    var originFrame = CGRect()
    var emailID : String!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet var btnSignIn: UIButton!
    override func viewDidLoad() {
        self.dynamicFontNeeded = false
        super.viewDidLoad()
         
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear ThankYouForRegVC")
        
        self.view.bringSubviewToFront(self.view1)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear ThankYouForRegVC")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear ThankYouForRegVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear ThankYouForRegVC")
    }
    
    @IBAction func signInClicked(sender: AnyObject) {
        
        let loginVC = storyboard!.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        loginVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        appDelegate.isToLogin = "YES"
        
        //self.cycleFromViewController1(self, toViewController: loginVC)
        
        self.addChildViewController(loginVC)
        self.addSubview(loginVC.view, toView: self.view)
        
        loginVC.view.alpha = 1
        //loginVC.view.frame = CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        
        loginVC.isFromThankYou = "YES"
        
        NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier4", object: nil)
        
        UIView.animateWithDuration(0.5, animations: {
            
            loginVC.view.alpha = 1
            //fanAccountVC.lblfree.alpha = 1
            //fanAccountVC.lblFan.alpha = 1
            //fanAccountVC.fanImgView.alpha = 1
            
            //loginVC.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)
            
            
            },completion:  { (true) in
                //self.imgView.image = UIImage(named: "artist_logo.png")
                //view.alpha = 0
                loginVC.didMoveToParentViewController(self)
                //fanAccountVC.view.removeFromSuperview()
                
                //self.removeFromParentViewController()
                
                //self.navigationController?.pushViewController(fanAccountVC, animated: false)
                
        })
    }

    @IBAction func resendEmailClicked (sender : AnyObject)
    {
        API.resendEmail(appDelegate.emailID, aViewController: self, completionHandler: { (result: JSON) in
            
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("resendEmail API Response: \(result)")
                
                self.DAlert("", message: "Mail sent successfully", action: "", sender: self)
                //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
            }
        })
    }
    
    // MARK: - Animation -
    
    func cycleFromViewController1(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        //oldViewController.willMoveToParentViewController(nil)
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
        newViewController.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.x, self.view.frame.size.width, self.view.frame.size.height)
        
        UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
            
            /*herbView.transform = self.presenting ?
             CGAffineTransformIdentity : scaleTransform
             
             herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
             y: CGRectGetMidY(finalFrame))*/
            
            newViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)
            
            },
                                            completion: { finished in
                                                
                                                newViewController.didMoveToParentViewController(self)
        })
    }
    
}
