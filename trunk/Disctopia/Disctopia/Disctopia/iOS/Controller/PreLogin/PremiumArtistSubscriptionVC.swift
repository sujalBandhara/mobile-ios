//
//  PremiumArtistSubscriptionVC.swift
//  Disctopia
//
//  Created by abc on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PremiumArtistSubscriptionVC: BaseVC , UITextFieldDelegate
{
    var presenting  = false
    var originFrame = CGRect()
    
    var param = Dictionary<String, String>()
    
    @IBOutlet var btnExpDate: UIButton!
    var expiryDatePicker = MonthYearPickerView()
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtExpDate: IQDropDownTextField!
    @IBOutlet weak var txtCVC: UITextField!
    
    @IBOutlet var btnPayNow: UIButton!
    
    override func viewDidLoad()
    {
        self.dynamicFontNeeded = false
        super.viewDidLoad()
        
        txtCardNumber.delegate = self
        txtCVC.delegate = self
        self.btnExpDate.hidden = true
        self.txtExpDate.setCustomDoneTarget(self, action:#selector(PremiumArtistSubscriptionVC.doneAction(_:)))

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear PremiumArtistSubscriptionVC")
        
        self.originFrame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 50, 50)
        self.setDropdown()
    }
    
    func setDropdown()
    {
        self.txtExpDate?.setDropDownTypePicker(3)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear PremiumArtistSubscriptionVC")
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear PremiumArtistSubscriptionVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear PremiumArtistSubscriptionVC")
    }
    
    
    //MARK: - PrivacyTermsSecurity  -
    
    @IBAction func privacyTermsSecurity(sender: AnyObject)
    {
        let url = NSURL(string: "https://www.disctopia.com/privacy-terms")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func closeClicked(sender: AnyObject) {
        
        let createAccountVC = storyboard!.instantiateViewControllerWithIdentifier("CreateNewArtistAccountSubscriptionVC") as! CreateNewArtistAccountSubscriptionVC
        createAccountVC.view.translatesAutoresizingMaskIntoConstraints = false;
        createAccountVC.param = self.param

        self.cycleFromViewController(self, toViewController: createAccountVC)
    }
    
    
    @IBAction func doneAction(txt: UITextField)
    {
        var str = self.txtExpDate.text
        str = self.convertDateFormater(str!, inputDateFormate: "MMM,yyyy", outputDateFormate: "MM/yyyy")
        self.txtExpDate.text = str
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.expiryDatePicker.tag = 100
        if let viewWithTag = self.view.viewWithTag(100)
        {
            BaseVC.sharedInstance.DLog("Tag 100")
            viewWithTag.removeFromSuperview()
        }
        else
        {
            BaseVC.sharedInstance.DLog("tag not found")
        }
    }
    
    @IBAction func btnMonthAndYear(sender: AnyObject)
    {
//        self.view.endEditing(true)
//        self.expiryDatePicker = MonthYearPickerView()
//        self.expiryDatePicker.frame = CGRectMake(0, self.view.frame.size.height - self.expiryDatePicker.frame.size.height ,self.view.frame.size.width ,self.expiryDatePicker.frame.size.height)
//        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
//            let expMonth = "\(month)"
//            let expYear = "\(year)"
//            self.txtExpDate.becomeFirstResponder()
//            self.txtExpDate.text = "\(expMonth) / \(expYear)"
//        }
//        self.expiryDatePicker.backgroundColor = UIColor.lightGrayColor()
//        self.txtExpDate.resignFirstResponder()
//        self.view.addSubview(self.expiryDatePicker)
    }
    
    @IBAction func txtMonthAndYearClick(sender: UITextField)
    {
//        let datePickerView:UIDatePicker = UIDatePicker()
//        datePickerView.datePickerMode = UIDatePickerMode.Date
//        datePickerView.minimumDate = NSDate()
//        sender.inputView = datePickerView
//        datePickerView.addTarget(self, action: #selector(PremiumArtistSubscriptionVC.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    /*
     @IBAction func txtDateOfBirthEdit(sender: UITextField)
     {
     let datePickerView:UIDatePicker = UIDatePicker()
     datePickerView.datePickerMode = UIDatePickerMode.Date
     datePickerView.maximumDate = NSDate()
     sender.inputView = datePickerView
     datePickerView.addTarget(self, action: #selector(CreateNewFanAccountVC.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
     }*/
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM-yyyy"
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        txtExpDate.text = self.convertGivenDateToString(sender.date, dateformat: "dd/YYYY") //dateFormatter.stringFromDate(sender.date)
    }
    @IBAction func btnPayNow(sender: AnyObject)
    {
        if  txtFirstName.text!.isEmpty
        {
            DAlert("Disctopia", message: "Enter first name", action: ALERT_OK, sender: self)
        }
        else if txtLastName.text!.isEmpty
        {
            DAlert("Disctopia", message: "Enter last name", action: ALERT_OK, sender: self)
        }
        else if txtCardNumber.text!.isEmpty
        {
            DAlert("Disctopia", message: "Enter card number", action: ALERT_OK, sender: self)
        }
        else if txtCardNumber.text!.length < 16
        {
            DAlert("Disctopia", message: "Invalid card number", action: ALERT_OK, sender: self)
        }
        else if txtExpDate.text!.isEmpty
        {
            DAlert("Disctopia", message: "Enter expiry date", action: ALERT_OK, sender: self)
        }
        else if txtCVC.text!.isEmpty
        {
            DAlert("Disctopia", message: "Enter CVC", action: ALERT_OK, sender: self)
        }
        else if txtCVC.text!.length < 3
        {
            DAlert("Disctopia", message: "Enter valid CVC", action: ALERT_OK, sender: self)
        }
        else
        {
            //success
            callCreateArtistApi()
        }
    }
    
    // Card number with space after 4 digit
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        let numbersAllow = NSCharacterSet(charactersInString: "0123456789").invertedSet
        let onlyNumbers = string.rangeOfCharacterFromSet(numbersAllow) == nil
        
        if textField == self.txtCardNumber
        {
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "0123456789").invertedSet) == nil
            
            if !replacementStringIsLegal
            {
                return false
            }
            
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789").invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 16 && !hasLeadingOne) || length > 19
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 16) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            let formatStrChar = "%@ "
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if length - index > 4
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 4))
                formattedString.appendFormat(formatStrChar, prefix)
                index += 4
            }
            
            if length - index > 4
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 4))
                formattedString.appendFormat(formatStrChar, prefix)
                index += 4
            }
            if length - index > 4
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 4))
                formattedString.appendFormat(formatStrChar, prefix)
                index += 4
            }
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        if textField == self.txtCVC
        {
            return (newLength <= 3) && onlyNumbers
        }
        return true
    }
    
    
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
        
        ["CardNumber": "4242 4242 4242 4242",
         "ExpiryYear": " 2017",
         "subscriptionplan": "Premium Artist",
         "username": "testest",
         "country": "Australia",
         "agreedtoterms": "true",
         "artistname": "testartist",
         "CVC": "123",
         "email": "testest@gmail.com",
         "firstname": "test",
         "lastname": "test",
         "dateofbirth": "01-Jul-2012",
         "device_token": "DeviceTokenNotAvailable",
         "NameOnCard": "test first name test last name",
         "password": "111111",
         "ExpiryMonth": "8 "]
        
        //        param["email"] = "sujal.bandhara@bypt.in"
        //        param["username"] = "sujal"
        //        param["password"] = "111111"
        //        param["firstname"] = "sujal"
        //        param["lastname"] = "bandhara"
        //        param["dateofbirth"] = txtDateOfBirth.text //"02-03-2011"
        //        param["country"] = txtCountry.text! //"India"
        //        param["agreedtoterms"] = "true"
        //        param["artistname"] = txtArtistName.text //"sukajal"
        //        param["subscriptionplan"] = txtPremium.text //"Testplan1"
        
        param["NameOnCard"] = "\(txtFirstName.text!) \(txtLastName.text!)"
        param["CardNumber"] = txtCardNumber.text //"4242424242424242"
        param["CVC"] = txtCVC.text //"121"
        
        let dateStr = txtExpDate.text
        let dateArray = dateStr?.componentsSeparatedByString("/")
        if ( dateArray?.count > 1 )
        {
            let monthStr = dateArray![0]
            param["ExpiryMonth"] = monthStr.stringByReplacingOccurrencesOfString(" ", withString: "") as String//"11"
            
            let yearStr = dateArray![1]
            param["ExpiryYear"] = yearStr.stringByReplacingOccurrencesOfString(" ", withString: "") as String//"11"
            
            param[kAPIDeviceToken] = appDelegate.deviceToken
            
            DLog("Parameter = \(param)")
            API.createArtist(param, aViewController:self) { (result: JSON) in
                
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
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String,sender: AnyObject?) -> Bool
    {
        if (identifier == "" )
        {
            return false
        }
        else
        {
            return false
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
