//
//  CreateNewArtistAccountVC.swift
//  Disctopia
//
//  Created by abc on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateNewArtistAccountVC: BaseVC {
    
    //MARK: - Outlets -
    
    @IBOutlet var txtFirstName: CustomTextField!
    @IBOutlet var txtLastName: CustomTextField!
    @IBOutlet var txtUserName: CustomTextField!
    @IBOutlet var txtEmail: CustomTextField!
    @IBOutlet var txtPassword: CustomTextField!
    
    ///////////////////
    //MARK: - Variables -
    
    let duration    = 1.0
    var presenting  = false
    var originFrame = CGRect()
    var isCreateAccount  = false
    var param = Dictionary<String, String>()
    
    ////////////////////
    
    //MARK: - View LifeCycle -
    
    
    override func viewDidLoad() {
        
        self.dynamicFontNeeded = false
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.DLog("WillAppear CreateNewArtistAccountVC")
        
        self.originFrame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 50, 50)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.DLog("WillDisappear CreateNewArtistAccountVC")
        
        if isCreateAccount {
            NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier2", object: nil)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.DLog("DidAppear CreateNewArtistAccountVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.DLog("DidDisappear CreateNewArtistAccountVC")
    }
    
    
    //MARK: - Button Actions -
    
    @IBAction func closeClicked(sender: AnyObject) {
        
        let createAccountVC = storyboard!.instantiateViewControllerWithIdentifier("CreateNewArtistAccountSubscriptionVC") as! CreateNewArtistAccountSubscriptionVC
        createAccountVC.view.translatesAutoresizingMaskIntoConstraints = false;
        createAccountVC.param = self.param

        self.cycleFromViewController(self, toViewController: createAccountVC)
    }
    
    @IBAction func btnNextClicked(sender: AnyObject) {
        
        if ( txtFirstName.text?.isEmpty == true || txtLastName.text?.isEmpty == true || txtUserName.text?.isEmpty == true || txtEmail.text?.isEmpty == true || txtPassword.text?.isEmpty == true )
        {
            self.DAlert(ALERT_TITLE, message: "All fields are required", action: ALERT_OK, sender: self)
            
        }
        else if txtEmail.text!.isEmail() == false
        {
            self.DAlert(ALERT_TITLE, message: "Invalid email address", action: ALERT_OK, sender: self)
        }
        else if validatePassword(txtPassword.text!) == false
        {
            self.DAlert(ALERT_TITLE, message: "Password should have 6 digits", action: ALERT_OK, sender: self)
        }
        else
        {
            callCreateArtistApi()
            
            //            let createAccountVC = storyboard!.instantiateViewControllerWithIdentifier("CreateNewArtistAccountSubscriptionVC") as! CreateNewArtistAccountSubscriptionVC
            //            createAccountVC.param = param
            //            createAccountVC.view.translatesAutoresizingMaskIntoConstraints = false;
            //
            //            self.cycleFromViewController1(self, toViewController: createAccountVC)
            
        }
    }
    
    //MARK: - API -
    
    
    func callCreateArtistApi()
    {
        /* API : createArtist
         email :sujal.bandhara@bypt.in
         username :sujal
         password :111111
         firstname :sujal
         lastname :bandhara
         dateofbirth:02-03-2011
         country :India
         agreedtoterms :true
         artistname :sukajal
         subscriptionplan :Testplan1
         NameOnCard :sujal bandhara
         CardNumber :4242424242424242
         CVC :121
         ExpiryMonth :11
         ExpiryYear :2020
         //City :Ahmedabad
         //State :Gujarat
         //Address :Navarngpura
         //PostalCode :380050
         */
        var param1 = Dictionary<String, String>()
        param1["username"] = self.txtUserName.text
        
        API.CheckForEmailExist(param1,aViewController: self) { (result: JSON) in
            
            if (result != nil) {
                if(result["message"].stringValue == "Success")
                {
                    self.checkEmailApi()
                }
                else
                {
                    self.DAlert(ALERT_TITLE, message: result["message"].stringValue, action: ALERT_OK, sender: self)
                }
            }
        }
        //        param["email"] = txtEmail.text //"sujal.bandhara@bypt.in"
        //        param["username"] = txtUserName.text //"sujal"
        //        param["password"] = txtPassword.text //"111111"
        //        param["firstname"] = txtFirstName.text // "sujal"
        //        param["lastname"] = txtLastName.text //"bandhara"
        
        
        //        param["dateofbirth"] = txtDateOfBirth.text //"02-03-2011"
        //        param["country"] = txtCountry.text! //"India"
        //        param["agreedtoterms"] = "true"
        //        param["artistname"] = txtArtistName.text //"sukajal"
        //
        //        param["subscriptionplan"] = txtPremium.text //"Testplan1"
        //        param["NameOnCard"] = "sujal bandhara"
        //        param["CardNumber"] = "4242424242424242"
        //        param["CVC"] = "121"
        //        param["ExpiryMonth"] = "11"
        //        param["ExpiryYear"] = "2020"
        // param[kAPIDeviceToken] = appDelegate.deviceToken
        
    }
    
    
    func checkEmailApi()
    {
        var param1 = Dictionary<String, String>()
        param1["email"] = self.txtEmail.text
        
        API.CheckForEmailExist(param1,aViewController: self) { (result: JSON) in
            
            if (result != nil) {
                if(result["message"].stringValue == "Success")
                {
                    self.param["email"] = self.txtEmail.text //"sujal.bandhara@bypt.in"
                    self.param["username"] = self.txtUserName.text //"sujal"
                    self.param["password"] = self.txtPassword.text //"111111"
                    self.param["firstname"] = self.txtFirstName.text // "sujal"
                    self.param["lastname"] = self.txtLastName.text //"bandhara"
                    self.param[kAPIDeviceToken] = appDelegate.deviceToken
                    
                    
                    let createAccountVC = STORY_BOARD_PRELOGIN.instantiateViewControllerWithIdentifier("CreateNewArtistAccountSubscriptionVC") as! CreateNewArtistAccountSubscriptionVC
                    createAccountVC.param = self.param
                    createAccountVC.view.translatesAutoresizingMaskIntoConstraints = false;
                    
                    self.cycleFromViewController1(self, toViewController: createAccountVC)
                }
                else
                {
                    self.DAlert(ALERT_TITLE, message: result["message"].stringValue, action: ALERT_OK, sender: self)
                }
            }
        }
    }
    //MARK: - Segue Delegates  -
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String,sender: AnyObject?) -> Bool
    {
        if (identifier == "CreateNewArtistAccountSubscriptionVC" )
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier != nil
        {
            if (segue.identifier! == "CreateNewArtistAccountSubscriptionVC")
            {
                // Get destination view
                if let aSyncMusicVC = segue.destinationViewController as? CreateNewArtistAccountSubscriptionVC
                {
                    
                    aSyncMusicVC.param = self.param
                }
            }
        }
    }
    
    
    
    // MARK: - Animation
    
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
