//
//  ViewCreditCardViewController.swift
//  Disctopia
//
//  Created by Dhaval on 09/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class ViewCreditCardViewController: BaseVC,IQDropDownTextFieldDelegate
{
    
    // MARK: - Outlets
    
    @IBOutlet var scrollAddCreditCard: UIScrollView!
    
    @IBOutlet var viewAddCreditCard: UIView!
    
    @IBOutlet var txtCardTitle: UITextField!
    
    @IBOutlet var btnCheckBox: UIButton!
    
    @IBOutlet var txtBillingAdd: UITextField!
    
    @IBOutlet var txtBillingAdd2: UITextField!
    
    @IBOutlet var txtState: IQDropDownTextField!
    
    @IBOutlet var txtCity: IQDropDownTextField!
    
    @IBOutlet var txtNameOnCard: UITextField!
    
    @IBOutlet var txtCreditCardNumber: UITextField!
    
    @IBOutlet var txtCountry: IQDropDownTextField!
    
    @IBOutlet var txtYear: IQDropDownTextField!
    
    @IBOutlet var txtMonth: IQDropDownTextField!
    
    @IBOutlet var txtCVC: UITextField!
    
    @IBOutlet var btnSaveChanges: UIButton!
    
    @IBOutlet var btnCancel: UIButton!
    
    let arrCountry:NSMutableArray = NSMutableArray()
    
    var customPicker = customPickerView()
    var selectedCountryCode : String!
    var stateArr: NSMutableArray = NSMutableArray()
    // MARK: - Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtCardTitle.layer.cornerRadius = 5
        txtBillingAdd.layer.cornerRadius = 5
        txtBillingAdd2.layer.cornerRadius = 5
        txtState.layer.cornerRadius = 5
        txtCity.layer.cornerRadius = 5
        txtNameOnCard.layer.cornerRadius = 5
        txtCreditCardNumber.layer.cornerRadius = 5
        txtCountry.layer.cornerRadius = 5
        txtYear.layer.cornerRadius = 5
        txtMonth.layer.cornerRadius = 5
        txtCVC.layer.cornerRadius = 5
        
        txtCardTitle.layer.borderWidth = 0.5
        txtCardTitle.layer.borderColor = UIColor.whiteColor().CGColor
        txtBillingAdd.layer.borderWidth = 0.5
        txtBillingAdd.layer.borderColor = UIColor.whiteColor().CGColor
        txtBillingAdd2.layer.borderWidth = 0.5
        txtBillingAdd2.layer.borderColor = UIColor.whiteColor().CGColor
        txtState.layer.borderWidth = 0.5
        txtState.layer.borderColor = UIColor.whiteColor().CGColor
        txtCity.layer.borderWidth = 0.5
        txtCity.layer.borderColor = UIColor.whiteColor().CGColor
        txtNameOnCard.layer.borderWidth = 0.5
        txtNameOnCard.layer.borderColor = UIColor.whiteColor().CGColor
        txtCreditCardNumber.layer.borderWidth = 0.5
        txtCreditCardNumber.layer.borderColor = UIColor.whiteColor().CGColor
        txtCountry.layer.borderWidth = 0.5
        txtCountry.layer.borderColor = UIColor.whiteColor().CGColor
        txtYear.layer.borderWidth = 0.5
        txtYear.layer.borderColor = UIColor.whiteColor().CGColor
        txtMonth.layer.borderWidth = 0.5
        txtMonth.layer.borderColor = UIColor.whiteColor().CGColor
        txtCVC.layer.borderWidth = 0.5
        txtCVC.layer.borderColor = UIColor.whiteColor().CGColor
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        btnSaveChanges.layer.borderWidth = 1
        btnSaveChanges.layer.borderColor = UIColor.whiteColor().CGColor
        self.txtMonth.hidden = false
        self.txtCountry.setCustomDoneTarget(self, action:#selector(ViewCreditCardViewController.doneAction(_:)))
    }
    @IBAction func doneAction(txt: UITextField) {
        
        if txt.text!.characters.count > 0
        {
            let arr = self.countryListArray.filteredArrayUsingPredicate(NSPredicate(format: "name = %@", txt.text!))
            var param = Dictionary<String, String>()
            if arr.count > 0
            {
                param["countryId"] = "\(arr[0]["id"] as! String)"
                API.getStateList(param, aViewController: self) {
                    (result: JSON) in
                    
                    if result != nil
                    {
                        self.getStateList(result)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews()
    {
        self.scrollAddCreditCard.contentSize = CGSizeMake(viewAddCreditCard.frame.size.width,1200)
        self.scrollAddCreditCard.contentOffset = CGPointMake(0, 0)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.DLog("DidAppear ViewCreditCardVC")
        self.getCountries()
        getCardDetails()
        self.arrCountry.removeAllObjects()
        for i in 0...self.countryListArray.count - 1
        {
            arrCountry.addObject(countryListArray[i]["name"] as! String)
        }
        self.txtCountry?.setDropDownTypePicker(0)
        self.txtCountry?.itemList = arrCountry as [AnyObject]
        self.setDropDown()
    }
    
    func setDropDown()
    {
        let arrMonth:NSArray = NSArray(objects: "1","2","3","4","5","6","7","8","9","10","11","12")
        self.txtMonth?.setDropDownTypePicker(0)
        self.txtMonth?.itemList =  arrMonth as [AnyObject]
        
        let arrYear:NSArray = NSArray(objects: "2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2090","2030")
        self.txtYear?.setDropDownTypePicker(0)
        self.txtYear?.itemList =  arrYear as [AnyObject]
    }
    
    
    // MARK: - Actions
    
    @IBAction func onCheckBoxClick(sender: UIButton)
    {
        if sender.selected == true{
            self.txtBillingAdd.text = nil
            self.txtBillingAdd2.text = nil
            self.txtState.text = nil
            self.txtCity.text = nil
            sender.selected = false
        } else {
            setUserAddress()
            sender.selected = true
            //self.txtBillingAdd2.text = self.txtBillingAdd.text
        }
    }
    /*
     @IBAction func countryBtnClicked(sender: AnyObject)
     {
     //        self.customPicker.customArray = self.countryListArray as NSArray
     //        self.customPicker.customekey = "name"
     //        self.customPicker.center = CGPointMake(self.view.center.x, self.view.center.y)
     //
     //        self.customPicker.onDateSelected = { (country: [String: String]) in
     //            self.txtCountry.text = country["name"]
     //            self.selectedCountryCode = country["code"]
     //            self.DLog("country : \(country)")
     //
     //            var param = Dictionary<String, String>()
     //            param["countryId"] = country["id"]
     //            API.getStateList(param, aViewController: self) {
     //                (result: JSON) in
     //                if result != nil {
     //                    self.getStateList(result)
     //                }
     //            }
     //            self.customPicker.removeFromSuperview()
     //        }
     //        self.customPicker.backgroundColor = UIColor.lightGrayColor()
     //        self.view.addSubview(self.customPicker)
     
     }
     
     
     @IBAction func onSelectStateClick(sender: AnyObject)
     {
     self.customPicker.customArray = self.stateArr
     self.customPicker.customekey = "name"
     self.customPicker.center = CGPointMake(self.view.center.x, self.view.center.y)
     
     self.customPicker.onDateSelected = { (state: [String:String]) in
     let  state = "\(state["name"]!)"
     self.txtState.text = state
     self.DLog("state = \(state)")
     self.customPicker.removeFromSuperview()
     }
     self.customPicker.backgroundColor = UIColor.lightGrayColor()
     self.customPicker.reloadAllComponents()
     if ( self.customPicker.superview == nil)
     {
     self.view.addSubview(self.customPicker)
     }
     
     }
     */
    @IBAction func onSaveChangesButtonClick(sender: AnyObject)
    {
        self.btnSaveChanges.enabled = false
        if txtCardTitle.text?.isEmpty == true || txtNameOnCard.text?.isEmpty == true || txtCreditCardNumber.text?.isEmpty == true || txtCountry.text?.isEmpty == true || txtYear.text?.isEmpty == true || txtMonth.text?.isEmpty == true || txtCVC.text?.isEmpty == true
        {
            self.DAlert(ALERT_TITLE, message: "All fields are required", action: ALERT_OK, sender: self)
        }
            //        else if txtState.text?.isEmpty == true
            //        {
            //            self.DAlert(ALERT_TITLE, message: "Please select state name", action: ALERT_OK, sender: self)
            //        }
        else if txtCreditCardNumber.text?.length != 16
        {
            self.DAlert(ALERT_TITLE, message: "Credit card number should have 16 digit", action: ALERT_OK, sender: self)
        }
        else if txtYear.text?.length != 4
        {
            self.DAlert(ALERT_TITLE, message: "Year should have 4 digit", action: ALERT_OK, sender: self)
        }
        else if txtCVC.text?.length != 3
        {
            self.DAlert(ALERT_TITLE, message: "CVC number should have 3 digit", action: ALERT_OK, sender: self)
        }
        else
        {
            self.btnSaveChanges.enabled = true
            saveChangesCreditCard()
        }
        self.btnSaveChanges.enabled = true
    }
    
    @IBAction func yearBtnClicked(sender: AnyObject)
    {
       /*
        self.customPicker = customPickerView()
        self.customPicker.customArray = [["id":"1","name":"2016"],["id":"2","name":"2017"],["id":"3","name":"2018"],["id":"4","name":"2019"],["id":"5","name":"2020"],["id":"6","name":"2021"],["id":"7","name":"2022"],["id":"8","name":"2023"],["id":"9","name":"2024"],["id":"10","name":"2025"],["id":"11","name":"2026"],["id":"12","name":"2027"],["id":"13","name":"2028"],["id":"14","name":"2029"],["id":"15","name":"2030"]]
        //self.customPicker.customArray = ["credit card 1","credit card 1","credit card 3"]
        self.customPicker.customekey = "name"
        self.customPicker.center = CGPointMake(self.view.center.x, self.view.center.y)
        self.customPicker.onDateSelected =
            {
                (country: [String:String]) in
                let  year = "\(country["name"]!)"
                self.txtYear.text = year
                BaseVC.sharedInstance.DLog("expMonth = \(country)")
                self.customPicker.removeFromSuperview()
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.customPicker)*/
    }
    
    
    @IBAction func monthBtnClicked(sender: AnyObject)
    {
       /* self.customPicker = customPickerView()
        self.customPicker.customArray = [["id":"1","name":"1"],["id":"2","name":"2"],["id":"3","name":"3"],["id":"4","name":"4"],["id":"5","name":"5"],["id":"6","name":"6"],["id":"7","name":"7"],["id":"8","name":"8"],["id":"9","name":"9"],["id":"10","name":"10"],["id":"11","name":"11"],["id":"12","name":"12"]]
        //self.customPicker.customArray = ["credit card 1","credit card 1","credit card 3"]
        self.customPicker.customekey = "name"
        self.customPicker.center = CGPointMake(self.view.center.x, self.view.center.y)
        self.customPicker.onDateSelected =
            {
                (country: [String:String]) in
                let  month = "\(country["name"]!)"
                self.txtMonth.text = month
                BaseVC.sharedInstance.DLog("expMonth = \(country)")
                self.customPicker.removeFromSuperview()
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.customPicker)*/
    }
    
    @IBAction func onCancelButtonClick(sender: AnyObject)
    {
        let presentingViewController: UIViewController! = self.presentingViewController
        self.dismissViewControllerAnimated(false)
        {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func setUserAddress(){
        let profile: JSON = self.loadJSON(Constants.userDefault.userProfileInfo)
        BaseVC.sharedInstance.DLog("user Profile: \(profile)")
        
        if profile.count > 0 {
            self.txtBillingAdd.text = profile[0]["address1"].stringValue
            self.txtBillingAdd2.text = profile[0]["address2"].stringValue
            self.txtState.text = profile[0]["state"].stringValue
            self.txtCity.text = profile[0]["city"].stringValue
        }
    }
    
    func getStateList(result:JSON)
    {
        var tempArray : [JSON] = []
        tempArray = result.arrayValue
        self.stateArr.removeAllObjects()
        for i in 0...tempArray.count - 1
        {
            stateArr.addObject(tempArray[i]["name"].stringValue)
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
    
    
    
    //MARK: - API -
    
    func getCardDetails()
    {
        let saveResult : JSON = self.loadJSON(Constants.userDefault.loginInfo)
        
        if saveResult != nil {
            
            var param = Dictionary<String,String>()
            param[kAPISessionToken] = saveResult[kAPIToken].stringValue
            
            API.getCreditCardList(param, aViewController:self)
            { (result: JSON) in
                
                if ( result != nil )
                {
                    if result.arrayValue.count > 0
                    {
                        self.txtCardTitle.text = result.arrayValue[0]["name"].stringValue
                        self.txtBillingAdd.text = result.arrayValue[0]["address_line1"].stringValue
                        self.txtBillingAdd2.text = result.arrayValue[0]["address_line2"].stringValue
                        self.txtState.text = result.arrayValue[0]["address_state"].stringValue
                        self.txtCity.text = result.arrayValue[0]["address_city"].stringValue
                        self.txtNameOnCard.text = result.arrayValue[0]["name"].stringValue
                        self.txtCreditCardNumber.text = "xxxx xxxx xxxx xxxx " + result.arrayValue[0]["last4"].stringValue
                        self.txtCountry.text = result.arrayValue[0]["country"].stringValue
                        self.txtMonth.text = result.arrayValue[0]["exp_month"].stringValue
                        self.txtYear.text = result.arrayValue[0]["exp_year"].stringValue
                        self.txtCVC.text = ""
                    }
                    
                }
            }
        }
    }
    
    func saveChangesCreditCard()
    {
        let saveResult : JSON = self.loadJSON(Constants.userDefault.loginInfo)
        
        if saveResult != nil {
            
           /* {
                "expYear": "2040",
                "expMonth": "2",
                "cvc": "777",
                "userId": "712d3a74-6ffe-40d9-a687-ed19bfd32fc8",
                "nameoncard": "Artist7",
                "address1": "A/91",
                "city": "faasff",
                "state": "fsjhdk",
                "country": "Jermani",
                "address2": "HongKong",
                "last4": "4242"
            }*/
            
            
            
            var param = Dictionary<String, String>()
            param["last4"] = txtCreditCardNumber.text
            param["expYear"] = txtYear.text
            param["expMonth"] = txtMonth.text
            param["cvc"] = txtCVC.text
            param[kAPIUserId] = saveResult[kAPIUserId].stringValue
            param["nameoncard"] = txtNameOnCard.text
            param["address1"] = txtBillingAdd.text
            param["city"] = txtCity.text
            param["state"] = txtState.text
            param["country"] = txtCountry.text
            param["address2"] = txtBillingAdd2.text
            
            API.EditCreditCard(param, aViewController:self) { (result: JSON) in
                
                if ( result != nil )
                {
                    self.DLog("Changes success: \(result)")
                    let savechangesVCObj: SaveChangesVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("SaveChangesVC") as! SaveChangesVC
                    let navigationController = UINavigationController(rootViewController: savechangesVCObj)
                    navigationController.modalPresentationStyle = .OverCurrentContext
                    navigationController.navigationBarHidden = true
                    appDelegate.navigationController?.presentViewController(navigationController, animated: true, completion: {
                        print("Save changesVC Presented")
                    })
                   // self.DAlert(ALERT_TITLE, message: "Credit card updated successful", action: ALERT_OK, sender: self)
                    //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                    self.getUserProfile()
                }
            }
        }
    }
    
    
}