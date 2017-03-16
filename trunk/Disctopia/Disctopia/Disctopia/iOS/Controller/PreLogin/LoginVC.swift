//
//  LoginVC.swift
//  Disctopia
//
//  Created by abc on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: BaseVC,UITextFieldDelegate {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnSignin: UIButton!
    @IBOutlet var btnCreatenewaccount: UIButton!
    @IBOutlet var btnForgotpassword: UIButton!
    
    @IBOutlet var MainView: UIView!
    /**************ParthStart************/
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect()
    var splashFrame = CGRect()
    var newFrame = CGRect()
    var oldFrame = CGRect()
    
    var isFromThankYou:String! = "NO"
    
    @IBOutlet weak var loginImgView: UIImageView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    ////////////////forSplashEffect
    @IBOutlet weak var splashImgView: UIImageView!
    @IBOutlet weak var splashView: UIView!
    /**************ParthEnd************/
    
    override func viewDidLoad()
    {
        self.dynamicFontNeeded = false
        super.viewDidLoad()
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        btnSignin.hidden = true
        
        BaseVC.sharedInstance.loadCategory()
        //self.testAPI()
    }
    
    func loadTestData()
    {

        //self.txtEmail.text = "diddy"
        //self.txtPassword.text = "test1234"
        
        self.btnSigninClicked(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear LoginVC")
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.methodOfReceivedNotification1(_:)), name:"NotificationIdentifier111", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.methodOfReceivedNotification2(_:)), name:"NotificationIdentifier2", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.methodOfReceivedNotification3(_:)), name:"NotificationIdentifier3", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.methodOfReceivedNotification4(_:)), name:"NotificationIdentifier4", object: nil)//for ThankYouVC
        
        self.loginImgView.layoutIfNeeded()
        self.splashImgView.layoutIfNeeded()
        
        self.originFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        
        if appDelegate.isToLogin == "NO"
        {
            self.splashFrame = self.splashImgView.frame//CGRectMake(97, 274, 220, 188)
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //let attributedString = NSMutableAttributedString(string:textField.text!)
        /*
        let attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(17)]
        let boldString = NSMutableAttributedString(string:textField.text!, attributes:attrs)
        
        //attributedString.appendAttributedString(boldString)
      //  textField.attributedText = boldString
        */
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        if textField.text?.isEmpty == false {
//            textField.textColor = UIColor.lightGrayColor()
//        } else {
//            textField.textColor = UIColor.blackColor()
//        }
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear LoginVC")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear LoginVC")
        
        if appDelegate.isToLogin == "NO"
        {
            self.splashImgView.alpha = 0
            self.performSelector(#selector(splashEffect), withObject:self.loginImgView, afterDelay: 0.0)
        }
        //self.loadTestData()
        self.oldFrame = self.loginImgView.frame//CGRectMake(159, 120, 97, 81)//
        
        newFrame = CGRectMake(self.loginImgView.frame.origin.x, self.bottomView.frame.origin.y, self.loginImgView.frame.size.width, self.loginImgView.frame.size.height)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear LoginVC")
    }
    
    @IBAction func forgotPasswordClicked(sender: AnyObject) {
        
        let loginVC = storyboard!.instantiateViewControllerWithIdentifier("ForgotPasswordVC") as! ForgotPasswordVC
        loginVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.cycleFromViewController1(self, toViewController: loginVC)
        
    }
    // MARK: - Animation -
    /**************ParthStart************/
    
    func splashEffect(view:UIView)
    {
        view.alpha = 1
        view.layoutIfNeeded()
        //self.splashImgView.alpha = 1
        
        let toView = view
        let herbView = view
        
        let initialFrame = self.presenting ? self.splashFrame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : self.splashFrame
        
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
            self.view.bringSubviewToFront(toView)
        }
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .TransitionCrossDissolve, animations: {
            self.splashView.alpha = 0
        }) { (true) in
            
        }
        
        UIView.transitionWithView(view, duration: 0.3, options: .TransitionNone, animations: {
            
            self.splashImgView.alpha = 0
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                y: CGRectGetMidY(finalFrame))
            
            }, completion: { (true) in
                view.alpha = 1
        })
    }
    
    func trackViewFrame(view:UIView)
    {
        view.alpha = 1
        
        UIView.animateWithDuration(0.5) {
            
            view.frame = self.newFrame
        }
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

    func methodOfReceivedNotification1(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("LoginVC methodOfReceivedNotification1 called")
        
        self.loginImgView.frame = newFrame
        
        UIView.animateWithDuration(0.5) {
            
            self.loginImgView.frame = self.oldFrame
        }
        
    }
    
    func methodOfReceivedNotification2(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification2 called")
        
        let thankYouVC = storyboard!.instantiateViewControllerWithIdentifier("ThankYouForRegVC") as! ThankYouForRegVC
        thankYouVC.view.translatesAutoresizingMaskIntoConstraints = false;
        //herbDetails.beginAppearanceTransition(true, animated: true)
        //herbDetails.endAppearanceTransition()
        self.willMoveToParentViewController(self)
        self.addChildViewController(thankYouVC)
        self.addSubview(thankYouVC.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            thankYouVC.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    thankYouVC.didMoveToParentViewController(self)
        })
        
    }
    
    func methodOfReceivedNotification3(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification3 called")
        
        self.performSelector(#selector(trackViewFrame), withObject: self.loginImgView, afterDelay: 0.1)
        
        let chooseVC = storyboard!.instantiateViewControllerWithIdentifier("RegisterationChoiceVC") as! RegisterationChoiceVC
        chooseVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        //chooseVC.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: chooseVC)
        //chooseVC.endAppearanceTransition()
        
    }
    
    func methodOfReceivedNotification4(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification4 called")
        
        self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, -self.view.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height)
        
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveLinear, animations: {
            
            self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.topView.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height)
            
        },completion: { (true) in
                
        })
        
        
    }
    
    /**************ParthEnd************/
    
    func testAPI()
    {
        /* API : createUser
         email :vyomasweet27@gmail.com
         username :vims21
         password :Bypt_2012
         firstname :vyoma
         lastname :patel
         dateofbirth :02-03-2011
         country :India
         agreedtoterms :true
         usertype :user
         artistname :testr3
         AcceptsTerms :true
         */
        var param = Dictionary<String, String>()
        param["email"] = "vyomasweet27@gmail.com"
        param["username"] = "vims21"
        param["password"] = "Bypt_2012"
        param["firstname"] = "vyoma"
        param["lastname"] = "patel"
        param["dateofbirth"] = "02-03-2011"
        param["country"] = "India"
        param["agreedtoterms"] = "true"
        param["usertype"] = "user"
        param["artistname"] = "testr3"
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        API.createUser(param, aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("createUser API Response: \(result)")
            }
        }
        
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
        
        //var param1 = Dictionary<String, String>()
        param["email"] = "sujal.bandhara@bypt.in"
        param["username"] = "sujal"
        param["password"] = "111111"
        param["firstname"] = "sujal"
        param["lastname"] = "bandhara"
        param["dateofbirth"] = "02-03-2011"
        param["country"] = "India"
        param["agreedtoterms"] = "true"
        param["artistname"] = "sukajal"
        
        param["subscriptionplan"] = "Testplan1"
        param["NameOnCard"] = "sujal bandhara"
        param["CardNumber"] = "4242424242424242"
        param["CVC"] = "121"
        param["ExpiryMonth"] = "11"
        param["ExpiryYear"] = "2020"
        param[kAPIDeviceToken] = appDelegate.deviceToken
        API.createArtist(param, aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("createArtist API Response: \(result)")
            }
        }
        
        // API : forgotPassword
        API.forgotPassword("sujal.bandhara@bypt.in", aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("forgotPassword API Response: \(result)")
            }
        }
        
        // API : signIn
        API.signIn("diddy", password: "test1234", aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("SignIn API Response: \(result)")
                self.saveJSON(result,key:"loginInfo")
                
                let saveResult : JSON =  self.loadJSON(Constants.userDefault.loginInfo)
                if saveResult != nil
                {
                    appDelegate.appToken = saveResult[kAPIToken].stringValue
                    BaseVC.sharedInstance.DLog("Saved token: \(saveResult[kAPIToken].stringValue)")
                    BaseVC.sharedInstance.DLog("Saved userId: \(saveResult[kAPIUserId].stringValue)")
                }
                
                // API : songPurchaseHistory
                var param = Dictionary<String, String>()
                API.syncMusic(param, aViewController: self)  { (result: JSON) in
                    
                    if ( result != nil )
                    {
                        BaseVC.sharedInstance.DLog("#### songPurchaseHistory API Response: \(result)")
                    }
                }
                
                // API : GetArtistAlbumList
                param = Dictionary<String, String>()
                param["artistName"] = "Devartist"
                param["categories"] = "popular"
                API.getArtistAlbumList(param, aViewController: self) { (result: JSON) in
                    
                    if ( result != nil )
                    {
                        BaseVC.sharedInstance.DLog("#### GetArtistAlbumList API Response: \(result)")
                    }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldDidEndEditing(textField: UITextField) {
        if txtEmail.text?.isEmpty == true || txtPassword.text?.isEmpty == true {
            btnSignin.hidden = true
        } else if self.btnSignin.hidden == true {
            self.btnSignin.hidden = false
            //            btnSignin.transform = CGAffineTransformMakeScale(0.6, 0.6)
            UIView.animateWithDuration(0.1,
                                       animations: {
                                        self.btnSignin.layoutIfNeeded()
                                        self.btnSignin.transform = CGAffineTransformMakeScale(0, 1)
                },
                                       completion: { finish in
                                        UIView.animateWithDuration(0.4){
                                            self.btnSignin.transform = CGAffineTransformIdentity
                                        }
            })
        } else {
            self.btnSignin.hidden = false
        }
    }
    
    @IBAction func btnSigninClicked(sender: AnyObject)
    {
        btnSignin.exclusiveTouch = true
        //self.isValidLogin(sender)
        if txtEmail.text?.isEmpty == true {
            self.DAlert(ALERT_TITLE, message: "Please enter email address", action: ALERT_OK, sender: self)
        }
        else if txtPassword.text?.isEmpty == true {
            self.DAlert(ALERT_TITLE, message: "Please enter password", action: ALERT_OK, sender: self)
        }
        /*else if txtEmail.text!.isEmail() == false
        {
            self.DAlert(ALERT_TITLE, message: "Invalid email address", action: ALERT_OK, sender: self)
        }*/
        else if validatePassword(txtPassword.text!) == false
        {
            self.DAlert(ALERT_TITLE, message: "Password should have 6 digits", action: ALERT_OK, sender: self)
        }
        else
        {
            // self.DAlert(ALERT_TITLE, message: "Go on Home under construction", action: ALERT_OK, sender: self)
            //self.performSegueWithIdentifier("syncMusic", sender: sender)
            
            var temp:Bool = callLoginApi()
            
            if temp == true {
                UIView.animateWithDuration(0.1,
                                           animations:
                    {
                        self.btnSignin.layoutIfNeeded()
                        self.btnSignin.transform = CGAffineTransformMakeScale(0, 1)
                    },
                                           completion:{ finish in
                                            
                                            UIView.animateWithDuration(0.4, animations:
                                                {
                                                    self.MainView.frame = CGRectMake(self.MainView.frame.origin.x, -736, self.MainView.frame.size.width, self.MainView.frame.size.height)
                                                    
                                                }, completion: { (true) in
                                                    //self.MainView.hidden = true
                                                    //self.performSegueWithIdentifier("syncMusic", sender: sender)
                                                    
                                                    
                                                    //chooseVC.endAppearanceTransition()
                                            })
                })
            }
        }
    }
    
    //    func isValidLogin(sender: AnyObject)
    //    {
    //
    //    }

    func callLoginApi() -> Bool
    {
        // API : signIn
        var success = false
        API.signIn(txtEmail.text!, password: txtPassword.text!, aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("SignIn API Response: \(result)")
                if result["userType"].stringValue == "2" && result["isExpired"].stringValue == "1"
                {
                    appDelegate.appToken = result[kAPIToken].stringValue
                    appDelegate.userId = result[kAPIUserId].stringValue
                    BaseVC.sharedInstance.DLog(" appDelegate.appToken: \( appDelegate.appToken)")
                    
                    let vc : SubscriptionExpirePopUpVC = self.storyboard!.instantiateViewControllerWithIdentifier("SubscriptionExpirePopUpVC") as! SubscriptionExpirePopUpVC
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.modalPresentationStyle = .OverCurrentContext
                    appDelegate.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
                    
                }
                else
                {
                    self.saveJSON(result,key:Constants.userDefault.loginInfo)
                    let saveResult : JSON =  self.loadJSON(Constants.userDefault.loginInfo)
                    if saveResult != nil
                    {
                        appDelegate.appToken = saveResult[kAPIToken].stringValue
                        BaseVC.sharedInstance.DLog("Saved token: \(saveResult[kAPIToken].stringValue)")
                        BaseVC.sharedInstance.DLog("Saved userId: \(saveResult[kAPIUserId].stringValue)")
                        
                        
                        let chooseVC = self.storyboard!.instantiateViewControllerWithIdentifier("SyncMusicVC") as! SyncMusicVC
                        chooseVC.view.translatesAutoresizingMaskIntoConstraints = false;
                        self.addChildViewController(chooseVC)
                        self.addSubview(chooseVC.view, toView: self.view)
                        chooseVC.didMoveToParentViewController(self)
                        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
                        
                        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                            
                            // Do your task here
                            BaseVC.sharedInstance.getCountries()
                            BaseVC.sharedInstance.getUserProfile()
                            BaseVC.sharedInstance.getArtistAlbumListAPIForExplore()
                            appDelegate.playlistVC.reloadPlaylist()
                        })
                        
                        success = true
                    }
                    
                }
                
            }
            else
            {
                // Login Fail
                success = false
            }
        }
        return success
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String,sender: AnyObject?) -> Bool
    {
        if (identifier == "LoginVC" )
        {
            return false
        }
        else
        {
            return true
        }
        //return false
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier != nil
        {
            if (segue.identifier! == "syncMusic") {
                // Get destination view
                
                if let aSyncMusicVC = segue.destinationViewController as? SyncMusicVC
                {
                    // Get button tag number (or do whatever you need to do here, based on your object
                    let tagIndex: Int = (sender as! UIButton).tag
                    // Pass the information to your destination view
                    aSyncMusicVC.view.tag = tagIndex
                }
            }
        }
    }

    
    @IBAction func btnCreateNewAccountClicked(sender: AnyObject)
    {
        self.performSelector(#selector(trackViewFrame), withObject: self.loginImgView, afterDelay: 0.1)
        
        let chooseVC = storyboard!.instantiateViewControllerWithIdentifier("RegisterationChoiceVC") as! RegisterationChoiceVC
        chooseVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        //chooseVC.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: chooseVC)
        //chooseVC.endAppearanceTransition()
    }
    
    @IBAction func btnForgotPasswordClicked(sender: AnyObject)
    {
        
    }
    
}


