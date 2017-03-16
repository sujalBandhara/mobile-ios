//
//  CreateNewFanAccountVC.swift
//  Disctopia
//
//  Created by abc on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Accounts
import Social

class CreateNewFanAccountVC: BaseVC {

    var selectedCounrtyCode : String!
    
    var param = Dictionary<String, String>()

    var customPicker = customPickerView()
    
    var accountStore = ACAccountStore()

    var facebookAccount = ACAccount()
    let arrCountry:NSMutableArray = NSMutableArray()
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtCountry: IQDropDownTextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet var btnCreateNewAccount: UIButton!
    
    @IBOutlet var registrationView: UIView!
    
    ///////////////////
    let duration    = 1.0
    var presenting  = false
    var originFrame = CGRect()
    var isCreateAccount  = false
    ////////////////////
    
    //MARK: - View Life Cycle -
    
    override func viewDidLoad()
    {
        self.dynamicFontNeeded = false
        super.viewDidLoad()
        self.txtCountry.setCustomDoneTarget(self, action:#selector(ViewCreditCardViewController.doneAction(_:)))
 
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.DLog("WillAppear CreateNewAccountViewController")
        self.getCountries()
        self.arrCountry.removeAllObjects()
        
        for i in 0...self.countryListArray.count - 1
        {
            arrCountry.addObject(countryListArray[i]["name"] as! String)
        }
        self.txtCountry?.setDropDownTypePicker(0)
        self.txtCountry?.itemList = arrCountry as [AnyObject]
        
        self.originFrame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 50, 50)
        
        //self.countryArray = [["code": "US","name":"United States"],["code": "AU","name":"Australia"],["code": "CA","name":"Canada"],["code": "DK","name":"Denmark"],["code": "FI","name":"Finland"],["code": "IE","name":"Ireland"],["code": "NO","name":"Norway"],["code": "SE","name":"Sweden"],["code": "GB","name":"United Kingdom"]]
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.DLog("WillDisappear CreateNewAccountViewController")
        
        if isCreateAccount {
            NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier2", object: nil)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.DLog("DidAppear CreateNewAccountViewController")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.DLog("DidDisappear CreateNewAccountViewController")
    }
    @IBAction func doneAction(txt: UITextField)
    {
      //  let countryArray:NSArray = [["code": "US","name":"United States"],["code": "AU","name":"Australia"],["code": "CA","name":"Canada"],["code": "DK","name":"Denmark"],["code": "FI","name":"Finland"],["code": "IE","name":"Ireland"],["code": "NO","name":"Norway"],["code": "SE","name":"Sweden"],["code": "GB","name":"United Kingdom"]]
        
        if txt.text!.characters.count > 0
        {
            let arr = self.countryListArray.filteredArrayUsingPredicate(NSPredicate(format: "name = %@", txt.text!))
            if arr.count > 0
            {
                self.selectedCounrtyCode = "\(arr[0]["code"] as! String)"
            }
        }
    }
    //MARK: - Button Action -

//    @IBAction func btnCountry(sender: AnyObject)
//    {
//        self.customPicker = customPickerView()
//        self.customPicker.customArray = self.countryListArray as NSArray
//        self.customPicker.customekey = "name"
//        self.customPicker.center = CGPointMake(self.view.center.x, self.view.center.y)
//        
//        self.customPicker.onDateSelected = { (country: [String:String]) in
//            
//            //let  country = "\(country["code"]!)"
//            self.txtCountry.becomeFirstResponder()
//            self.txtCountry.text = country["name"]
//            self.txtCountry.resignFirstResponder()
//            self.selectedCounrtyCode = country["code"]
//            
//            self.DLog("expMonth = \(self.selectedCounrtyCode)")
//            
//            self.customPicker.removeFromSuperview()
//            
//        }
//        // self.customPicker.backgroundColor = UIColor(red: 207/255, green: 208/255, blue: 209/255, alpha: 0.5)
//        self.customPicker.backgroundColor = UIColor.lightGrayColor()
//        self.customPicker.tag = 200
//        self.view.addSubview(self.customPicker)
//    }
    
    @IBAction func txtDateOfBirthEdit(sender: UITextField)
    {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.maximumDate = NSDate()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(CreateNewFanAccountVC.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        txtDateOfBirth.text = self.convertGivenDateToString(sender.date, dateformat: "MM-dd-YYYY") //dateFormatter.stringFromDate(sender.date)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let viewWithTag = self.view.viewWithTag(200)
        {
            self.DLog("Tag 200")
            viewWithTag.removeFromSuperview()
        }
    }
    
    
    @IBAction func closeClicked(sender: AnyObject) {
        
        if self.parentViewController != nil
        {
            self.cycleFromViewController(self, toViewController: self.parentViewController!)
        }
        isCreateAccount = false
    }
    
    //MARK: - Register New Account -
    
    @IBAction func btnCreateNewAccount(sender: AnyObject)
    {
        isValidFan()
    }
    
    func isValidFan()
    {
        if txtUserName.text?.isEmpty == true || txtEmail.text?.isEmpty == true  || txtPassword.text?.isEmpty == true || txtFirstName.text?.isEmpty == true  || txtLastName.text?.isEmpty == true || txtCountry.text?.isEmpty == true || txtDateOfBirth.text?.isEmpty == true
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
            // self.DAlert(ALERT_TITLE, message: "Go on Home under construction", action: ALERT_OK, sender: self)
            //self.performSegueWithIdentifier("syncMusic", sender: sender)
            callCreateUserApi()
        }
    }
    
    func callCreateUserApi()
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
        param["email"] = txtEmail.text! //"vyomasweet27@gmail.com"
        print(param["email"]!)
        param["username"] = txtUserName.text! //"vims21"
        print(param["username"]!)
        param["password"] = txtPassword.text! //"Bypt_2012"
        print(param["password"]!)
        param["firstname"] = txtFirstName.text! //"vyoma"
        print(param["firstname"]!)
        param["lastname"] = txtLastName.text! //"patel"
        print(param["lastname"]!)
        param["DateOfBirth"] = txtDateOfBirth.text! //new change
        print(param["DateOfBirth"]!)
        param["country"] = self.selectedCounrtyCode //"India"
        print(param["country"]!)
        param["agreedtoterms"] = "\("true")"
        print(param["agreedtoterms"]!)
        //param["usertype"] = "user"
        //param["artistname"] = "testr3"
        param[kAPIDeviceToken] = appDelegate.deviceToken
        API.createUser(param, aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                self.DLog("createUser API Response: \(result)")
                //self.pushToViewControllerIfNotExistWithClassName("ThankYouForRegVC", animated: true)
                
                let thankYouVC = self.storyboard!.instantiateViewControllerWithIdentifier("ThankYouForRegVC") as! ThankYouForRegVC
                thankYouVC.view.translatesAutoresizingMaskIntoConstraints = false;
                appDelegate.emailID = self.txtEmail.text!
                
                self.cycleFromViewController(self, toViewController: thankYouVC)
                self.isCreateAccount = true
            }
        }
    }
    
    
    //MARK: - PrivacyTermsSecurity  -

    @IBAction func privacyTermsSecurity(sender: AnyObject)
    {
        let url = NSURL(string: "https://www.disctopia.com/privacy-terms")!
        UIApplication.sharedApplication().openURL(url)
    }
  
    
    //MARK: - Facebook Login -
    
    @IBAction func btnFacebook(sender: AnyObject)
    {
        self.facebookLogin()
    }
    func facebookLogin()
    {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
        {
            let accountType = self.accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
            
            let postingOptions = [ACFacebookAppIdKey: FB_APP_ID , ACFacebookPermissionsKey: ["email","public_profile","user_friends"]]
            
            accountStore.requestAccessToAccountsWithType(accountType, options: postingOptions as [NSObject : AnyObject], completion: { (granted : Bool, error : NSError?) -> Void in
                
                if granted
                {
                    let accounts : NSArray = self.accountStore.accountsWithAccountType(accountType)
                    
                    if accounts.count > 0
                    {
                        if let account = accounts.objectAtIndex(0) as? ACAccount
                        {
                            self.facebookAccount = account
                        }
                        let accessToken : String? = self.facebookAccount.credential.oauthToken
                        
                        if let token = accessToken
                        {
                            let url = NSURL(string: "https://graph.facebook.com/me")
                            
                            let parameters : NSDictionary = ["access_token" : token,
                                "fields": "id,name,email,first_name,last_name,gender,birthday,picture.type(large),location"]
                            
                            let fbRequest : SLRequest = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.GET, URL: url, parameters: parameters as [NSObject : AnyObject])
                            fbRequest.account = self.facebookAccount
                            
                            fbRequest.performRequestWithHandler({ (responseData : NSData?, urlResponse : NSHTTPURLResponse?, error : NSError?) -> Void in
                                
                                if let error = error
                                {
                                    self.DAlert(ALERT_TITLE, message: error.localizedDescription, action: ALERT_OK, sender: self)
                                }
                                else if let responseData = responseData
                                {
                                    var userInfo : NSMutableDictionary?
                                    do
                                    {
                                        userInfo = try! NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as? NSMutableDictionary
                                    }
                                    if let userInfo = userInfo
                                    {
                                        self.DLog("facebook userInfo : \(userInfo)")
                                        
                                        self.callSocialUserAPI(userInfo)
                                    }
                                }
                            })
                        }
                    }
                }
                else
                {
                    if let error = error
                    {
                        self.DLog("Error : \(error)")
                        
                        if error.code == 6
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.DAlertForSettings("No Facebbok Account", message: "There are no Facebook accounts configured. You can add or create Facebook account in Settings", action: ALERT_OK, sender: self)
                            })
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.view.userInteractionEnabled = true
                                
                                self.DAlert(ALERT_TITLE, message: "\(error.localizedDescription)", action: ALERT_OK, sender: self)
                            })
                        }
                    }
                }
            })
        }
        else
        {
            self.DAlertForSettings("No Facebbok Account", message: "There are no Facebook accounts configured. You can add or create Facebook account in Settings", action: ALERT_OK, sender: self)
        }
    }
    func callSocialUserAPI(socialUserInfo : NSMutableDictionary)
    {
        var param = Dictionary<String, String>()
        if let email = socialUserInfo.valueForKey("email") as? String
        {
            param["email"] = email
        }
        param["username"] = "user1234"
        param["password"] = "123456"
        if let firstName = socialUserInfo.valueForKey("first_name") as? String
        {
            param["firstname"] = firstName
        }
        if let lastName = socialUserInfo.valueForKey("last_name") as? String
        {
            param["lastname"] = lastName
        }
        param["dateofbirth"] = "01-01-2001"  // Need to remove this field
        param["country"] = txtCountry.text //"India"
        param["agreedtoterms"] = "true"
        //param["usertype"] = "user"
        //param["artistname"] = "testr3"
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        API.createUser(param, aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                self.DLog("createUser API Response: \(result)")
                //self.pushToViewControllerIfNotExistWithClassName("ThankYouForRegVC", animated: true)
                
                let thankYouVC = self.storyboard!.instantiateViewControllerWithIdentifier("ThankYouForRegVC") as! ThankYouForRegVC
                thankYouVC.view.translatesAutoresizingMaskIntoConstraints = false;
                
                self.cycleFromViewController(self, toViewController: thankYouVC)
                self.isCreateAccount = true
            }
        }
    }
    func DAlertForSettings(title: String, message: String, action: String, sender: UIViewController)
    {
        if objc_getClass("UIAlertController") != nil
        {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: .Default) { (action : UIAlertAction) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=FACEBOOK")!)
                })
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            sender.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertView(title: title, message: message, delegate: sender, cancelButtonTitle:action)
            alert.show()
        }
    }
    
    //MARK: -
    
    override func shouldPerformSegueWithIdentifier(identifier: String,sender: AnyObject?) -> Bool
    {
        if (identifier == "" )
        {
            return false
        }
        else
        {
            return true
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//    {
//        if segue.identifier != nil
//        {
//            if (segue.identifier! == "")
//            {
//                // Get destination view
//                if let aSyncMusicVC = segue.destinationViewController as? SyncMusicVC
//                {
//                    // Get button tag number (or do whatever you need to do here, based on your object
//                    let tagIndex: Int = (sender as! UIButton).tag
//                    // Pass the information to your destination view
//                    aSyncMusicVC.view.tag = tagIndex
//                }
//            }
//        }
//    }

    
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

}
