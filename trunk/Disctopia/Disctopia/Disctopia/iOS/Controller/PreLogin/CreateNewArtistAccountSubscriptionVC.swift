//
//  CreateNewArtistAccountSubscriptionVC.swift
//  Disctopia
//
//  Created by abc on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateNewArtistAccountSubscriptionVC: BaseVC,UITextFieldDelegate
{
    var selectedCounrtyCode : String!
    
    var presenting  = false
    var originFrame = CGRect()
    
    var customPicker = customPickerView()
    var manageSubcriptionArray : NSMutableArray = NSMutableArray()
    var manageSubcriptionJSONArray : [JSON] = []
    let arrCountry:NSMutableArray = NSMutableArray()

    
    var param = Dictionary<String, String>()
    
    @IBOutlet weak var txtArtistName:  HoshiTextFieldNew!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtCountry: IQDropDownTextField!
    @IBOutlet weak var txtPremium: IQDropDownTextField!
    @IBOutlet var btnCreateNewAccount: UIButton!
    
    
    override func viewDidLoad()
    {
        self.getCountries()

        self.dynamicFontNeeded = false
        super.viewDidLoad()
    
        //getSubscriptionPlan()
        
        getInAppList()
        
        self.txtCountry.setCustomDoneTarget(self, action:#selector(ViewCreditCardViewController.doneAction(_:)))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateNewArtistAccountSubscriptionVC.callCreateArtistRegisterIOS), name:"callCreateArtistRegisterIOS", object: nil)

        //C R E A T E   N E W   A R T I S T  A C C O U N T
        
        //CREATE NEW ARTIST ACCOUNT
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.getCountries()

        self.DLog("WillAppear CreateNewArtistAccountSubscriptionVC")
        
        self.originFrame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 50, 50)
        self.arrCountry.removeAllObjects()
        
        for i in 0...self.countryListArray.count - 1
        {
            arrCountry.addObject(countryListArray[i]["name"] as! String)
        }
        
        self.txtCountry?.setDropDownTypePicker(0)
        self.txtCountry?.itemList = arrCountry as [AnyObject]

        
        
        //self.countryArray = [["code": "US","name":"United States"],["code": "AU","name":"Australia"],["code": "CA","name":"Canada"],["code": "DK","name":"Denmark"],["code": "FI","name":"Finland"],["code": "IE","name":"Ireland"],["code": "NO","name":"Norway"],["code": "SE","name":"Sweden"],["code": "GB","name":"United Kingdom"]]
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.DLog("WillDisappear CreateNewArtistAccountSubscriptionVC")
       
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        self.DLog("DidAppear CreateNewArtistAccountSubscriptionVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.DLog("DidDisappear CreateNewArtistAccountSubscriptionVC")
    }
    
    
    @IBAction func doneAction(txt: UITextField)
    {
        if txt.text!.characters.count > 0
        {
            let arr = self.countryListArray.filteredArrayUsingPredicate(NSPredicate(format: "name = %@", txt.text!))
            if arr.count > 0
            {
                self.selectedCounrtyCode = "\(arr[0]["code"] as! String)"
            }
        }
    }
    
    @IBAction func closeClicked(sender: AnyObject)
    {
        
        let createAccountVC = storyboard!.instantiateViewControllerWithIdentifier("CreateNewArtistAccountSubscriptionVC") as! CreateNewArtistAccountSubscriptionVC
        createAccountVC.view.translatesAutoresizingMaskIntoConstraints = false;
        createAccountVC.param = self.param

        self.cycleFromViewController(self, toViewController: createAccountVC)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
        if let viewWithTag = self.view.viewWithTag(100)
        {
            self.DLog("Tag 100")
            viewWithTag.removeFromSuperview()
        }
        
        if let viewWithTag = self.view.viewWithTag(200)
        {
            self.DLog("Tag 200")
            viewWithTag.removeFromSuperview()
        }
    }
    
    @IBAction func txtDateOfBirthEdit(sender: UITextField)
    {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.maximumDate = NSDate()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(CreateNewArtistAccountSubscriptionVC.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        txtDateOfBirth.text = self.convertGivenDateToString(sender.date, dateformat: "dd-MMM-yyyy") //dateFormatter.stringFromDate(sender.date)
    }
    /*
    @IBAction func btnSelectCountry(sender: AnyObject)
    {
        self.customPicker = customPickerView()
         self.customPicker.customArray = self.countryListArray as NSArray
        self.customPicker.customekey = "name"
        self.customPicker.center = CGPointMake(self.view.center.x, self.view.center.y)
        
        self.customPicker.onDateSelected = { (country: [String:String]) in
            
        self.selectedCounrtyCode = country["code"]
            
        self.txtCountry.isActiveState = true
        self.txtCountry.becomeFirstResponder()
        self.txtCountry.text = country["name"]
        self.txtCountry.resignFirstResponder()
        self.txtCountry.animateViewsForTextEntry()
    
        self.DLog("expMonth = \(self.selectedCounrtyCode)")
            
        self.customPicker.removeFromSuperview()
       
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.customPicker.tag = 100
        self.view.addSubview(self.customPicker)
    }
    */
    /*
    @IBAction func btnSelectPremium(sender: AnyObject)
    {
        self.customPicker = customPickerView()
        self.customPicker.customArray = self.manageSubcriptionArray//[["id":"1","name":"Premium Artist"]]
        self.customPicker.customekey = "name"
        self.customPicker.center = CGPointMake(self.view.center.x, self.view.center.y)
        
        self.customPicker.onDateSelected = { (premium: [String:String]) in
            let  premium = "\(premium["name"]!)"
            self.txtPremium.becomeFirstResponder()
            self.txtPremium.text = premium
            self.txtPremium.resignFirstResponder()
            self.DLog("txtPremium = \(premium)")
            self.customPicker.removeFromSuperview()
            
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.customPicker.tag = 200
        self.view.addSubview(self.customPicker)
    }*/
    
    //MARK: - PrivacyTermsSecurity  -

    @IBAction func privacyTermsSecurity(sender: AnyObject)
    {
        let url = NSURL(string: "https://www.disctopia.com/privacy-terms")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func btnCreateNewAccountAction(sender: AnyObject)
    {
        isValidArtist()
    }
    
    func isValidArtist()
    {
        if  txtArtistName.text!.isEmpty
        {
            DAlert("Disctopia", message: "Enter your name", action: ALERT_OK, sender: self)
        }
        else if txtCountry.text!.isEmpty
        {
            DAlert("Disctopia", message: "Select country", action: ALERT_OK, sender: self)
        }
        else if txtDateOfBirth.text!.isEmpty
        {
            DAlert("Disctopia", message: "Enter date of birth", action: ALERT_OK, sender: self)
        }
        else if txtPremium.text!.isEmpty
        {
            DAlert("Disctopia", message: "Select premium ", action: ALERT_OK, sender: self)
        }
        else
        {
            //Success
           
            if self.manageSubcriptionJSONArray.count > self.txtPremium.selectedRow
            {
                let productIdStr = self.manageSubcriptionJSONArray[self.txtPremium.selectedRow]["productId"].stringValue
                let idStr = self.manageSubcriptionJSONArray[self.txtPremium.selectedRow]["id"].stringValue
                if productIdStr.characters.count > 0
                {
                    //getInfo(productIdStr)
                    
                    purchase(productIdStr)
                    
                    param["InAppPlanId"] = idStr
                }
            }
            
           

            //            let thankYouVC = self.storyboard!.instantiateViewControllerWithIdentifier("ThankYouForRegVC") as! ThankYouForRegVC
//            thankYouVC.view.translatesAutoresizingMaskIntoConstraints = false;
//            
//            self.cycleFromViewController1(self, toViewController: thankYouVC)
            
            
//callCreateArtistApi()
//            let createAccountVC = storyboard!.instantiateViewControllerWithIdentifier("PremiumArtistSubscriptionVC") as! PremiumArtistSubscriptionVC
//            createAccountVC.param = param
//            createAccountVC.view.translatesAutoresizingMaskIntoConstraints = false;
//            
//            self.cycleFromViewController1(self, toViewController: createAccountVC)
        }
    }
    
    func callCreateArtistRegisterIOS()
    {
        //    email:tester4@yopmail.com
        //    username:tester4
        //    password:111111
        //    firstname:tester4
        //    lastname:patel
        //    //middleinitial:d
        //    dateofbirth:02-03-2011
        //    country:US
        //    agreedtoterms:true
        //    artistname:tester4
        //    InAppPlanId:1
        
                /* // param add previous screen
         param["email"] = ""
         param["username"] = ""
         param["password"] = ""
         param["firstname"] = ""
         param["lastname"] = "" */
        
        
        param["dateofbirth"] =  self.convertDateFormater(txtDateOfBirth.text!, inputDateFormate: "dd-MMM-yyyy", outputDateFormate: "MM-dd-yyyy")
        param["country"] = self.selectedCounrtyCode
        param["agreedtoterms"] = "true"
        param["artistname"] = txtArtistName.text
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        API.createArtistRegisterIOS(param, aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("createArtist API Response: \(result)")
                
                let thankYouVC = self.storyboard!.instantiateViewControllerWithIdentifier("ThankYouForRegVC") as! ThankYouForRegVC
                thankYouVC.view.translatesAutoresizingMaskIntoConstraints = false;
                
                // self.cycleFromViewController(self, toViewController: thankYouVC)
                self.cycleFromViewController1(self, toViewController: thankYouVC)
            }
        }
        
    }

    func getSubscriptionPlan()
    {
        API.getSubscriptionPlanList("",aViewController: self) { (result: JSON) in
            
            if (result != nil) {
                self.manageSubcriptionArray.removeAllObjects()
                
                self.manageSubcriptionJSONArray = result.arrayValue
                for dicSubcription in result.arrayValue
                {
                   // let id = dicSubcription["id"].stringValue
                    let name = dicSubcription["name"].stringValue
                    
                  self.manageSubcriptionArray.addObject(name)
                    
                   // subcriptionArray.setObject(id, forKey: "id")
                    //subcriptionArray.setObject(name, forKey: "name")
                    //self.manageSubcriptionArray.addObject(subcriptionArray)
                }
                self.DLog("self.manageSubscription Array: \(self.manageSubcriptionArray)")
                self.txtPremium?.setDropDownTypePicker(0)
                self.txtPremium?.itemList = self.manageSubcriptionArray as [AnyObject]
            }
        }
    }
    func getInAppList()
    {
        API.getInAppList("",aViewController: self) { (result: JSON) in
            
            if (result != nil) {
                self.manageSubcriptionArray.removeAllObjects()
                
                self.manageSubcriptionJSONArray = result.arrayValue
                for dicSubcription in result.arrayValue
                {
                    // let id = dicSubcription["id"].stringValue
                    let name = dicSubcription["plan"].stringValue
                    
                    self.manageSubcriptionArray.addObject(name)
                    
                    // subcriptionArray.setObject(id, forKey: "id")
                    //subcriptionArray.setObject(name, forKey: "name")
                    //self.manageSubcriptionArray.addObject(subcriptionArray)
                }
                self.DLog("self.manageSubscription Array: \(self.manageSubcriptionArray)")
                self.txtPremium?.setDropDownTypePicker(0)
                self.txtPremium?.itemList = self.manageSubcriptionArray as [AnyObject]
            }
        }
        //getInAppList2()
    }
    

    func callCreateArtistApi()
    {
        /* email:sujal.bandharatest@bypt.in
         username:sujaltest
         password:111111
         firstname:sujal
         lastname:bandhara
         //middleinitial:d
         dateofbirth:02-03-2011
         country:India
         agreedtoterms:true
         //usertype:user
         artistname:sukajal
         subscriptionplan:Testplan1
         NameOnCard:sujal bandhara
         CardNumber:4242424242424242
         CVC:121
         ExpiryMonth:11
         ExpiryYear:2020
         //City:Ahmedabad
         //State:Gujarat
         //Address:Navarngpura
         //PostalCode:380050
         */
        
        
//        param["email"] = "sujal.bandhara@bypt.in"
//        param["username"] = "sujal"
//        param["password"] = "111111"
//        param["firstname"] = "sujal"
///       param["lastname"] = "bandhara"
        
        param["dateofbirth"] = self.convertDateFormater(txtDateOfBirth.text!, inputDateFormate: "dd-MMM-yyyy", outputDateFormate: "MM-dd-yyyy")
 //"02-03-2011"
        param["country"] = self.selectedCounrtyCode //txtCountry.text! //"India"
        param["agreedtoterms"] = "true"
        param["artistname"] = txtArtistName.text //"sukajal"
         param["subscriptionplan"] = ""
       
        if self.manageSubcriptionJSONArray.count > self.txtPremium.selectedRow
        {
            let planId = self.manageSubcriptionJSONArray[self.txtPremium.selectedRow]["id"].stringValue
            if planId.characters.count > 0
            {
                param["subscriptionplan"] = planId
            }
        }
        
//        param["subscriptionplan"] = "Testplan1" //txtPremium.text //"Testplan1"
//        param["NameOnCard"] = "sujal bandhara"
//        param["CardNumber"] = "4242424242424242"
//        param["CVC"] = "121"
//        param["ExpiryMonth"] = "11"
//        param["ExpiryYear"] = "2020"
        param[kAPIDeviceToken] = appDelegate.deviceToken
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String,sender: AnyObject?) -> Bool
    {
        if (identifier == "PremiumArtistSubscriptionVC" )
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
            if (segue.identifier! == "PremiumArtistSubscriptionVC")
            {
                // Get destination view
                if let aSyncMusicVC = segue.destinationViewController as? PremiumArtistSubscriptionVC
                {
                    
                    aSyncMusicVC.param = param
                }
            }
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

