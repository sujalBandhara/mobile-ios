//
//  ForgotPasswordVC.swift
//  
//
//  Created by Trainee02 on 25/06/16.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgotPasswordVC: BaseVC {

    /////////////
    var presenting  = false
    var originFrame = CGRect()
    var newFrame = CGRect()
    var oldFrame = CGRect()
    var createAccount = true
    @IBOutlet weak var forgotImgView: UIImageView!
    @IBOutlet weak var lblForgot: UILabel!
    ////////////
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var btnForgotPassword: UIButton!
    
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
        BaseVC.sharedInstance.DLog("WillAppear ForgotPasswordVC")
        
        self.originFrame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 50, 50)

        self.oldFrame = self.forgotImgView.frame
        
        newFrame = CGRectMake(self.forgotImgView.frame.origin.x, self.lblForgot.frame.origin.y, self.forgotImgView.frame.size.width, self.forgotImgView.frame.size.height)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear ForgotPasswordVC")
        
        if createAccount {
            NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier3", object: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear ForgotPasswordVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear ForgotPasswordVC")
    }
    

    @IBAction func btnForgotPasswordClicked(sender: AnyObject)
    {
        if txtEmail.text?.isEmpty == true
        {
            self.DAlert(ALERT_TITLE, message: "Please enter email address", action: ALERT_OK, sender: self)
        }
        else if txtEmail.text!.isEmail() == false
        {
            self.DAlert(ALERT_TITLE, message: "Invalid email address", action: ALERT_OK, sender: self)
        }
        else
        {
            //self.DAlert(ALERT_TITLE, message: "Under construction", action: ALERT_OK, sender: self)
            // API : forgotPassword
            API.forgotPassword(txtEmail.text!, aViewController:self) { (result: JSON) in
                
                if ( result != nil )
                {
                    let forgotpasswordResponse = result["message"].stringValue
                    if forgotpasswordResponse.characters.count > 0
                    {
                        self.DAlert(ALERT_TITLE, message: "\(forgotpasswordResponse)", action: ALERT_OK, sender: self)
                    }
                    BaseVC.sharedInstance.DLog("forgotPassword API Response: \(result)")
                }
            }
        }
    }

    @IBAction func btnCreateNewAccountClicked(sender: AnyObject)
    {
        //self.performSelector(#selector(trackViewFrame), withObject: self.forgotImgView, afterDelay: 0.1)
        
        createAccount = true
        
        self.willMoveToParentViewController(parentViewController!)
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .TransitionCrossDissolve, animations: { 
            self.view.alpha = 0
            },
        completion: { (true) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
        
        
        
        //self.presenting = true
        //let chooseVC = storyboard!.instantiateViewControllerWithIdentifier("RegisterationChoiceVC") as! RegisterationChoiceVC
        //chooseVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        //chooseVC.beginAppearanceTransition(true, animated: true)
        //self.cycleFromViewController1(self, toViewController: chooseVC)
        //chooseVC.endAppearanceTransition()
    }
    
    func trackViewFrame(view:UIView)
    {
        view.alpha = 1
        
        UIView.animateWithDuration(0.5) {
            
            view.frame = self.newFrame
        }
    }
    
    @IBAction func closeClicked(sender: AnyObject) {
        self.presenting = false
        createAccount = false
        if self.parentViewController != nil
        {
            self.cycleFromViewController(self, toViewController: self.parentViewController!)
        }
    }
    
    // MARK: - Animation
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
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
        
        finalFrame  = self.presenting ? herbView.frame : self.originFrame//CGRectMake(288, 35, 126, 84)
        myTimeInterval = 0.0
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        UIView.animateKeyframesWithDuration(0.2, delay: myTimeInterval, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            herbView.clipsToBounds = true
            
            },
                                            
                                            completion: { finished in
                                                
                                                //self.willMoveToParentViewController(nil)
                                                
                                                self.view.removeFromSuperview()
                                                self.removeFromParentViewController()
                                                
        })
    }
    
    func cycleFromViewController1(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
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
                                                
                                                oldViewController.view.removeFromSuperview()
                                                oldViewController.removeFromParentViewController()
                                                newViewController.didMoveToParentViewController(self)
        })
    }
}
