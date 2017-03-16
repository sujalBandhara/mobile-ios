//
//  SettingsGeneralViewController.swift
//  Disctopia
//
//  Created by Dhaval on 25/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsGeneralViewController: BaseVC,UITextFieldDelegate
{
    var stateArr: NSMutableArray = NSMutableArray()
    
    var selectedCountryCode : String!
    
    var initialState : String!
    
    var birthdate : String!

    var customPicker = customPickerView()
    
    let arrCountry:NSMutableArray = NSMutableArray()

   
    // MARK: - Outlets

    @IBOutlet weak var txtCountry: IQDropDownTextField!
    
    @IBOutlet weak var txtState: IQDropDownTextField!
    
    @IBOutlet weak var lblDisctopiaID: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtAddress2: UITextField!
    
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet var scrollViewGeneral: UIScrollView!
    // MARK: - Methods
    class func instantiateFromStoryboard() -> SettingsGeneralViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SettingsGeneralViewController
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.viewLogout.hidden = true
        //roundBtn.layer.borderColor = UIColor.whiteColor().CGColor
        //roundBtn.layer.borderWidth = 2
        self.scrollView.contentOffset = CGPointZero
        
        txtCountry.layer.borderWidth = 0.5
        txtCountry.layer.cornerRadius = 5
        
        txtState.layer.borderWidth = 0.5
        txtState.layer.cornerRadius = 5
        
      
        //txtCountry.delegate = self
        //txtState.delegate = self
        txtEmail.delegate = self
        txtAddress.delegate = self
         txtCity.delegate = self
        txtZipCode.delegate = self
        
        self.txtCountry.setCustomDoneTarget(self, action:#selector(SettingsGeneralViewController.doneAction(_:)))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setUserProfileData), name: "setProfileData", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.hidePicker), name: "SettingsGeneralVCresignFirstResponder", object: nil)
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.txtEmail.text = " "
        self.txtCity.text = " "
        self.txtAddress.text = " "
        self.txtZipCode.text = " "
        self.txtState.text = " "
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear SettingsGeneralViewController")
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        
        BaseVC.sharedInstance.DLog("WillDisappear SettingsGeneralViewController")
        if ( self.customPicker.superview != nil )
        {
            self.customPicker.removeFromSuperview()
        }
    }
    func hidePicker()
    {
        self.customPicker.removeFromSuperview()
       
        self.txtCity.resignFirstResponder()
        self.txtZipCode.resignFirstResponder()
        self.txtAddress.resignFirstResponder()
        self.txtCountry.resignFirstResponder()
        self.txtState.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
       // self.txtEmail.placeholder = " "
//        self.txtEmail.becomeFirstResponder()
//        self.txtEmail.text = " "
//        self.txtEmail.resignFirstResponder()
//        self.txtEmail.userInteractionEnabled = false
//        self.txtCity.becomeFirstResponder()
//        self.txtCity.text = " "
//        self.txtCity.resignFirstResponder()
//        self.txtZipCode.becomeFirstResponder()
//        self.txtZipCode.text = " "
//        self.txtZipCode.resignFirstResponder()
//        self.txtAddress.becomeFirstResponder()
//        self.txtAddress.text = " "
//        self.txtAddress.resignFirstResponder()
//        self.txtEmail.becomeFirstResponder()
        
         let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // your function here
            self.getCountries()
            self.arrCountry.removeAllObjects()
            for i in 0...self.countryListArray.count - 1
            {
                self.arrCountry.addObject(self.countryListArray[i]["name"] as! String)
            }
            self.txtCountry?.setDropDownTypePicker(0)
            self.txtCountry?.itemList = self.arrCountry as [AnyObject]
            self.setUserProfileData()
        })
       
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        
        
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear SettingsGeneralViewController")
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
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        appDelegate.selectedTextField = textField
        
        
        return true
    }
    
    
    // MARK: - Actions

    @IBAction func doneAction(txt: UITextField) {
        
        let arr = self.countryListArray.filteredArrayUsingPredicate(NSPredicate(format: "name = %@", txt.text!))
      
        var param = Dictionary<String, String>()
        if arr.count > 0
        {
            param["countryId"] = "\(arr[0]["id"] as! String)"
            self.selectedCountryCode = arr[0]["code"] as! String
            API.getStateList(param, aViewController: self) {
                (result: JSON) in
                
                if result != nil
                {
                    self.getStateList(result)
                }
            }
        }
      
    }

    @IBAction func onCountryClick(sender: AnyObject)
    {
        //self.customPicker = customPickerView()
        self.customPicker.customArray = self.countryListArray as NSArray
        self.customPicker.customekey = "name"
        self.customPicker.center = CGPointMake(scrollView.center.x, self.txtCountry.frame.origin.y)
        self.customPicker.onDateSelected =
        {
            (country: [String:String]) in
            self.txtCountry.text = country["name"]
            self.selectedCountryCode = country["code"]
            //get States of selected Country
            var param = Dictionary<String, String>()
            param["countryId"] = country["id"]
            API.getStateList(param, aViewController:self)
            {
                (result: JSON) in
                if ( result != nil )
                {
                    //BaseVC.sharedInstance.DLog("getStateList API Response: \(result)")
                    self.getStateList(result)
                }
            }
            self.customPicker.removeFromSuperview()
        }
        
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.customPicker.tag = 100

        self.customPicker.reloadAllComponents()
        if ( self.customPicker.superview == nil)
        {
            self.scrollView.addSubview(self.customPicker)
        }
    }
    
    @IBAction func onStateClick(sender: AnyObject)
    {
        
        // self.customPicker = customPickerView()
        self.customPicker.customArray = self.stateArr//[["id":"1","name":"  Gujarat"],["id":"2","name":"  Goa"],["id":"3","name":"  Kerala"],["id":"4","name":"  Punjab"],["id":"5","name":"  Haryana"]]
        self.customPicker.customekey = "name"
        self.customPicker.center = CGPointMake(scrollView.center.x, self.txtState.frame.origin.y)
        self.customPicker.onDateSelected =
        {
            (country: [String:String]) in
            let  country = "\(country["name"]!)"
            self.txtState.text = country
            BaseVC.sharedInstance.DLog("selectedState = \(country)")
            self.customPicker.removeFromSuperview()
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.customPicker.tag = 200

        self.customPicker.reloadAllComponents()
        if ( self.customPicker.superview == nil)
        {
            self.scrollView.addSubview(self.customPicker)
        }
    }
    
    @IBAction func onSaveChanges(sender: AnyObject)
    {
        //self.viewLogout.hidden = false
        if txtEmail.text?.isEmpty == true
        {
            txtEmail.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please enter email address", action: ALERT_OK, sender: self)
        }
        else if txtCountry.text?.isEmpty == true
        {
            txtCountry.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please select country", action: ALERT_OK, sender: self)
        }
        else if txtAddress.text?.isEmpty == true
        {
            txtAddress.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please enter address", action: ALERT_OK, sender: self)
        }
//        else if txtAddress2.text?.isEmpty == true
//        {
//            txtAddress2.becomeFirstResponder()
//            self.DAlert(ALERT_TITLE, message: "Please enter address line2", action: ALERT_OK, sender: self)
//        }
        else if txtCity.text?.isEmpty == true
        {
            txtCity.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please enter city", action: ALERT_OK, sender: self)
        }
        else if txtState.text?.isEmpty == true
        {
            txtState.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please select state", action: ALERT_OK, sender: self)
        }
        else if txtZipCode.text?.isEmpty == true
        {
            txtZipCode.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please enter zipcode", action: ALERT_OK, sender: self)
        }
        else
        {
            NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(SettingsGeneralViewController.UpdateSuccessProfile),name: "UpdateSuccessProfile",object: nil)
            self.updateArtistProfile()
        }
    }
    
    func UpdateSuccessProfile(notification:NSNotification)
    {
        let dic = notification.userInfo
        if(dic!["isSuccess"] as! Bool == true)
        {
            self.getUserProfile()
        }
    }
    
    // MARK: - API
    func setUserProfileData()
    {
        self.txtAddress.becomeFirstResponder()
        self.txtAddress.text = ""
        self.txtAddress.resignFirstResponder()
        
        let profile : JSON =  self.loadJSON(Constants.userDefault.userProfileInfo)
        BaseVC.sharedInstance.DLog("Saved userProfile: \(profile)")
        
        if (profile.count > 0)
        {
            self.scrollView.contentOffset = CGPointZero

            txtEmail.text = profile[0]["email"].stringValue
            lblDisctopiaID.text = profile[0]["disctopiaID"].stringValue
            //let dateFormatter = NSDateFormatter()
            //dateFormatter.dateFormat = "dd-MMM-yyyy"
            //dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            //dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            //self.birthdate = self.convertStringToFormatedDate(profile[0]["dateOfBirth"].stringValue, dateformatter: dateFormatter.dateFormat)
            
            // create dateFormatter with UTC time format
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let date = dateFormatter.dateFromString(profile[0]["dateOfBirth"].stringValue)// create   date from string
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "MM-dd-YYYY"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            if (date != nil)
            {
                self.birthdate = dateFormatter.stringFromDate(date!)
            }
            else
            {
                self.birthdate = ""
            }
            
            for i in 0..<countryListArray.count
            {
                if profile[0]["country"].stringValue == countryListArray[i]["code"] as! String
                {
                    let str : String!
                    str = countryListArray[i]["name"] as! String
                    txtCountry.text = str
                    self.selectedCountryCode = countryListArray[i]["code"] as! String
                    
                    // get States of selected Country
                    var param = Dictionary<String, String>()
                    param["countryId"] = countryListArray[i]["id"] as? String
                    
                    API.getStateList(param, aViewController:self)
                    {
                        (result: JSON) in
                        if ( result != nil )
                        {
                            //BaseVC.sharedInstance.DLog("getStateList API Response: \(result)")
                            self.getStateList(result)
                        }
                    }
                }
            }
            
            txtAddress.text = profile[0]["address1"].stringValue
            //txtAddress2.text = profile[0]["address2"].stringValue
            txtCity.text = profile[0]["city"].stringValue
            self.initialState =  profile[0]["state"].stringValue
            txtState.text = self.initialState
            txtZipCode.text =  profile[0]["zipCode"].stringValue
        }
        
    }
    
    func getStateList(result:JSON)
    {
        var tempArray : [JSON] = []
        tempArray = result.arrayValue
        let sortedResults = tempArray.sort { $0["name"].stringValue < $1["name"].stringValue }
        self.stateArr.removeAllObjects()
        for i in 0...tempArray.count - 1
        {
            stateArr.addObject(sortedResults[i]["name"].stringValue)
            self.txtState?.setDropDownTypePicker(0)
            self.txtState?.itemList = self.stateArr as [AnyObject]
        }
        //        for i in 0..<tempArray.count
        //        {
        //            let json : JSON = tempArray[i]
        //            let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
        //            dict.setObject(json["code"].stringValue, forKey: "code")
        //            dict.setObject(json["id"].stringValue, forKey: "id")
        //            dict.setObject(json["currency"].stringValue, forKey: "currency")
        //            dict.setObject(json["name"].stringValue, forKey: "name")
        //            self.stateArr.addObject(dict)
        //        }
    }
    
    func updateArtistProfile()
    {
        var param = Dictionary<String, String>()
        param["email"] = self.txtEmail.text
        //param["FirstName"] = "Par"//self.txtEmail.text
        //param["LastName"] = "Pr"//self.txtEmail.text
        param["dateofbirth"] = self.birthdate
        param["Country"] = self.selectedCountryCode
        param["Address1"] = self.txtAddress.text
        param["Address2"] = self.txtAddress2.text
        param["City"] = self.txtCity.text
        param["State"] = self.txtState.text//self.txtState.text
        param["ZipCode"] = self.txtZipCode.text
        
        
        //param["artistname"] = "testr3"
        
        
        API.updateArtistProfile(param,profileImage:nil, aViewController:self)
        {
            (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("updateArtistProfile API Response: \(result)")
                //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                
                self.DAlert(ALERT_TITLE, message: "Update artist profile successfully ", action: ALERT_OK, sender: self)

                self.getUserProfile()
            }
            else
            {
              //  self.DAlert(ALERT_TITLE, message: "Update artist profile Fail.", action: ALERT_OK, sender: self)
            }
        }
    }
   
    
    // MARK: - Functions

//    func getStateList(result:JSON)
//    {
//        var tempArray : [JSON] = []
//        tempArray = result.arrayValue
//        self.stateArr.removeAllObjects()
//        for i in 0..<tempArray.count
//        {
//            let json : JSON = tempArray[i]
//            let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
//            dict.setObject(json["code"].stringValue, forKey: "code")
//            dict.setObject(json["id"].stringValue, forKey: "id")
//            dict.setObject(json["currency"].stringValue, forKey: "currency")
//            dict.setObject(json["name"].stringValue, forKey: "name")
//            self.stateArr.addObject(dict)
//        }
//        if self.initialState == ""
//        {
//            self.txtState.text = self.stateArr.firstObject!["name"] as? String
//        }
//    }
    
}