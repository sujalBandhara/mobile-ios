//
//  CardPaymentSettingsVC.swift
//  Disctopia
//
//  Created by Trainee02 on 25/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CardPaymentSettingsVC: BaseVC,UITextFieldDelegate {
    
    //Banking Account Information View
    @IBOutlet var scrollViewBankAcInfo: UIScrollView!
    
    @IBOutlet var subScrollView: UIView!


    @IBOutlet var txtRoutingNumber: UITextField!
    @IBOutlet var txtAccountNumber: UITextField!
    @IBOutlet var txtSSNNumber: UITextField!
    @IBOutlet var txtCreditCards: IQDropDownTextField!
 //   @IBOutlet var txtBasicArtist: IQDropDownTextField!
    
    @IBOutlet var btnChangePrimaryCard: UIButton!
    @IBOutlet var btnDeletePrimaryCard: UIButton!
    @IBOutlet var btnAddNewCard: UIButton!
    @IBOutlet var btnNeedMoreInfo: UIButton!
    @IBOutlet var btnSaveChanges: UIButton!
    
  //  @IBOutlet var btnSelectBasicArtist: UIButton!
    
    var customPicker = customPickerView()
    
    var creditCardArray:NSMutableArray = NSMutableArray()
    var mergerdArr : NSMutableArray = NSMutableArray()
    
    var manageSubcriptionArray : NSMutableArray = NSMutableArray()
    
    var last4toDelete:String = ""
    
    class func instantiateFromStoryboard() -> CardPaymentSettingsVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! CardPaymentSettingsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtRoutingNumber.delegate = self
        txtAccountNumber.delegate = self
        txtSSNNumber.delegate = self
        
        
        txtRoutingNumber.layer.cornerRadius = 5
        txtRoutingNumber.layer.borderWidth = 0.5
        txtAccountNumber.layer.cornerRadius = 5
        txtAccountNumber.layer.borderWidth = 0.5
        txtSSNNumber.layer.cornerRadius = 5
        txtSSNNumber.layer.borderWidth = 0.5
        txtCreditCards.layer.cornerRadius = 5
        txtCreditCards.layer.borderWidth = 0.5
   //     txtBasicArtist.layer.cornerRadius = 5
   //     txtBasicArtist.layer.borderWidth = 0.5
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.hidePicker), name: "CardPaymentSettingsVCresignFirstResponder", object: nil)
        getCreditCardList()
        //getSubscriptionPlan()
    }
    
    func hidePicker()
    {
        self.txtRoutingNumber.resignFirstResponder()
        self.txtAccountNumber.resignFirstResponder()
        self.txtSSNNumber.resignFirstResponder()
        self.txtCreditCards.resignFirstResponder()
        
        if ( self.customPicker.superview != nil )
        {
            self.customPicker.removeFromSuperview()
        }
    }
    
    //MARK: - View Cycle -    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.DLog("WillAppear CardPaymentSettingsVC")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CardPaymentSettingsVC.reloadCards(_:)), name: "reloadCards", object: nil)//to delete single track while editind a playlist from AddNewPlaylistTableViewCell button click
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.DLog("WillDisappear CardPaymentSettingsVC")
        
          self.txtRoutingNumber.resignFirstResponder()
          self.txtAccountNumber.resignFirstResponder()
          self.txtSSNNumber.resignFirstResponder()
          self.txtCreditCards.resignFirstResponder()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)

        if ( self.customPicker.superview != nil )
        {
            self.customPicker.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.DLog("DidAppear CardPaymentSettingsVC")
        
        getPaymentInfo()
        
        //getCreditCardList()
        //setUserProfileData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.DLog("DidDisappear CardPaymentSettingsVC")
    }

    override func viewDidLayoutSubviews() {
        //self.scrollViewBankAcInfo.contentSize = CGSizeMake(subScrollView.frame.size.width,912)
        self.scrollViewBankAcInfo.contentOffset = CGPointMake(0, 0)
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
    //MARK: - Action -
    
    //Banking Account Information Actions
    @IBAction func onChangePrimaryCardClick(sender: AnyObject) {
        //self.view.addSubview(viewChangeCreditCard)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ChangePrimaryCreditCardVC = storyboard.instantiateViewControllerWithIdentifier("ChangePrimaryCreditCardVC") as! ChangePrimaryCreditCardVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverFullScreen
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    @IBAction func onDeleteCardClick(sender: AnyObject) {
        //self.view.addSubview(viewAddCreditCard)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : DeletePrimaryCreditCardVC = storyboard.instantiateViewControllerWithIdentifier("DeletePrimaryCreditCardVC") as! DeletePrimaryCreditCardVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    @IBAction func onAddNewCardClick(sender: AnyObject) {
        //self.view.addSubview(viewAddCreditCard)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : AddNewCreditCardSettingsVC = storyboard.instantiateViewControllerWithIdentifier("AddNewCreditCardSettingsVC") as! AddNewCreditCardSettingsVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(navigationController, animated: true, completion: nil)

    }
    
    @IBAction func onNeedMoreInfoClick(sender: AnyObject) {
        
        //self.DAlert(ALERT_TITLE, message: "Under Construction", action: ALERT_OK, sender: self)
        /*
        let url = NSURL(string: "https://www.disctopia.com/#signUpAnchor")!
        UIApplication.sharedApplication().openURL(url)
         */
    }
    
    @IBAction func onSaveChangesClick(sender: AnyObject) {
        
        if txtRoutingNumber.text?.isEmpty == true || txtAccountNumber.text?.isEmpty == true || txtSSNNumber.text?.isEmpty == true    {
            self.DAlert(ALERT_TITLE, message: "All fields are required", action: ALERT_OK, sender: self)
        }
        else if txtRoutingNumber.text?.length != 9 {
            self.DAlert(ALERT_TITLE, message: "Routing Number should have 9 digit", action: ALERT_OK, sender: self)
        }
        else if txtAccountNumber.text?.length != 12 {
            self.DAlert(ALERT_TITLE, message: "Account number should have 12 digit", action: ALERT_OK, sender: self)
        }
        else if txtSSNNumber.text?.length != 4 {
            self.DAlert(ALERT_TITLE, message: "SSN must have 4 digit", action: ALERT_OK, sender: self)
        }
        else if txtCreditCards.text?.isEmpty == true {
            self.DAlert(ALERT_TITLE, message: "Please select credit card", action: ALERT_OK, sender: self)
        }
//        else if txtBasicArtist.text?.isEmpty == true {
//            self.DAlert(ALERT_TITLE, message: "Please select basic artist", action: ALERT_OK, sender: self)
//        }
        else
        {
            updatePaymentInfo()
            changeDefaultCard()
           // updateSubscription()
        }
    }
    
    @IBAction func onSelectCreditCardClick(sender: AnyObject) {
        //self.customPicker = customPickerView()
    
        self.customPicker.customArray = self.mergerdArr
        
        self.DLog("self.customPicker.customArray : \(self.customPicker.customArray)")
        
        self.customPicker.customekey = "cardName"
        self.customPicker.center = CGPointMake(scrollViewBankAcInfo.center.x, (self.txtCreditCards.superview?.center.y)!)
        
        self.customPicker.onDateSelected = { (creditcard: [String:String]) in
            let  creditCard = "\(creditcard["cardName"]!)"
            self.txtCreditCards.text = creditCard
            self.DLog("CreditCard = \(creditCard)")
            
            let trimmedStr = creditCard.stringByReplacingOccurrencesOfString(" ", withString: "")
            let cardArr = trimmedStr.characters.split{$0 == "-"}.map(String.init)
            
            self.last4toDelete = cardArr[1]
            
            self.customPicker.removeFromSuperview()
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.customPicker.tag = 100
        self.customPicker.reloadAllComponents()
        if ( self.customPicker.superview == nil)
        {
            self.scrollViewBankAcInfo.addSubview(self.customPicker)
        }
    }
    
//    @IBAction func onSelectBasicArtist(sender: AnyObject) {
//        //self.customPicker = customPickerView()
//        //self.customPicker.customArray = [["id":"1","name":"   Basic Artist (Active1)"],["id":"2","name":"   Basic Artist (Active2)"],["id":"3","name":"   Basic Artist (Active3)"],["id":"4","name":"   Basic Artist (Active4)"],["id":"5","name":"   Basic Artist (Active5)"]]
//        self.customPicker.customArray = self.manageSubcriptionArray
//        self.customPicker.customekey = "name"
//        self.customPicker.center = CGPointMake(scrollViewBankAcInfo.center.x, (self.txtBasicArtist.superview?.center.y)!)
//        self.customPicker.onDateSelected = { (subscription: [String:String]) in
//            let  sub = "\(subscription["name"]!)"
//            self.txtBasicArtist.text = sub
//            self.DLog("subscription = \(sub)")
//            self.customPicker.removeFromSuperview()
//        }
//        self.customPicker.backgroundColor = UIColor.lightGrayColor()
//        self.customPicker.tag = 200
//        self.customPicker.reloadAllComponents()
//        if ( self.customPicker.superview == nil)
//        {
//            self.scrollViewBankAcInfo.addSubview(self.customPicker)
//        }
//    }
    
    func reloadCards(notification:NSNotification)
    {
        getCreditCardList()
    }
    
    //MARK: - API -
    
    func updatePaymentInfo()
    {
        let  saveResult : JSON = self.loadJSON(Constants.userDefault.loginInfo)
        
        if (saveResult != nil)
        {
            var param = Dictionary<String, String>()
             param[kAPISessionToken] = saveResult[kAPIToken].stringValue
            
            param["accountnumber"] = txtAccountNumber.text
            param["routingnumber"] = txtRoutingNumber.text
            param["ssn"] = txtSSNNumber.text
            
            API.updatePaymentInformation(param, aViewController:self)
            { (result: JSON) in
                
                if ( result != nil )
                {
                    self.DLog("updatePayment API Response: \(result)")
                    self.DAlert(ALERT_TITLE, message: "Payment information saved successful", action: ALERT_OK, sender: self)
                    //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                    self.getUserProfile()
                }   
            }
        }
        
    }
    
    func updateSubscription()
    {
       
       
        let saveResult: JSON = self.loadJSON(Constants.userDefault.loginInfo)
        if (saveResult != nil) {
            var param = Dictionary<String,String>()
            param[kAPISessionToken] = saveResult[kAPIToken].stringValue
            
         //   param["SubscripePlan"] = self.txtBasicArtist.text
            
            API.updateSubscription(param,aViewController:self) {
                (result: JSON) in
                
                if (result != nil) {
                    self.DLog("UpdateSubscription plan API response \(result)")
                    print("\(result.dictionaryValue["subscriptionId"]!)")
                    self.DAlert(ALERT_TITLE, message: "UpdateSubscription saved successful", action: ALERT_OK, sender: self)
                    //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                    self.getUserProfile()
                }
            }
        }
    }
   
    func getCreditCardList()
    {
        let saveResult : JSON =  self.loadJSON(Constants.userDefault.loginInfo)

        if saveResult != nil
        {
            var param = Dictionary<String, String>()
            param[kAPISessionToken] =  saveResult[kAPIToken].stringValue
            
            API.getCreditCardList(param,aViewController: self) { (result:JSON) in
                
                if ( result != nil )
                {
                    self.mergerdArr.removeAllObjects()
                    for dicCardList in result.arrayValue
                    {
                        let last4 = dicCardList["last4"].stringValue
                        let name = dicCardList["name"].stringValue
                        
//                        let dict:NSMutableDictionary = NSMutableDictionary()
//                        let dict1:NSMutableDictionary = NSMutableDictionary()
//                        
//                        dict.setObject(last4, forKey: "last4")
//                        dict.setObject(name, forKey: "name")
//                        dict1.setObject(name+" - "+last4, forKey: "cardName")
//                        
                     //   self.creditCardArray.addObject(dict)
                        self.mergerdArr.addObject(name+" - "+last4)
                        
                    }
                   // self.DLog("self.creditCardList : \(self.creditCardArray)")
                    self.DLog("self.mergerdArr : \(self.mergerdArr )")
                    
                    self.txtCreditCards.setDropDownTypePicker(0)
                    self.txtCreditCards.itemList = self.mergerdArr as [AnyObject]
                    
                    if result.count > 0 {
                        
                        if self.mergerdArr.count > 0
                        {
//                            let dic:NSMutableDictionary = self.mergerdArr[0] as! NSMutableDictionary
//                            self.txtCreditCards.text! = dic["cardName"] as! String
                            self.txtCreditCards.text! = self.mergerdArr[0] as! String
                        }
                        else
                        {
                            self.txtCreditCards.text = "Not Added"
                        }
                    }
                }
            }
        }
    }
    
//    func getSubscriptionPlan()
//    {
//        API.getSubscriptionPlanList("",aViewController: self) { (result: JSON) in
//            
//            if (result != nil) {
//                self.manageSubcriptionArray.removeAllObjects()
//                for dicSubcription in result.arrayValue
//                {
//                    let name = dicSubcription["name"].stringValue
//                    
//                    self.manageSubcriptionArray.addObject(name)
////                    let id = dicSubcription["id"].stringValue
////                    let name = dicSubcription["name"].stringValue
////                    
////                    let subcriptionArray : NSMutableDictionary = NSMutableDictionary()
////                    
////                    subcriptionArray.setObject(id, forKey: "id")
////                    subcriptionArray.setObject(name, forKey: "name")
////                    
////                    self.manageSubcriptionArray.addObject(subcriptionArray)
//                }
//                self.txtBasicArtist?.setDropDownTypePicker(0)
//                self.txtBasicArtist?.itemList = self.manageSubcriptionArray as [AnyObject]
//                self.DLog("self.manageSubscription Array: \(self.manageSubcriptionArray)")
//            }
//        }
//    }
    
    func getPaymentInfo()
    {
        let saveResult : JSON =  self.loadJSON(Constants.userDefault.loginInfo)
        
        if saveResult != nil
        {
            var param = Dictionary<String, String>()
            param[kAPISessionToken] =  saveResult[kAPIToken].stringValue
            
            API.getPaymentInfo(param,aViewController: self) { (result:JSON) in
                
                if ( result != nil )
                {
                    if (result.dictionaryValue["routingno"] != nil)
                    {
                        self.txtRoutingNumber.text = result.dictionaryValue["routingno"]!.stringValue
                        self.txtAccountNumber.text = result.dictionaryValue["bankaccountno"]!.stringValue
                        self.txtSSNNumber.text = "0000"//result.dictionaryValue["ssn"]!.stringValue
                        //                    if (result.dictionaryValue["ssn"]! == true) {
                        //                        self.txtSSNNumber.text = "****"
                        //                    }
                    }
                }
            }
            API.getGetArtistProfile(param, aViewController: self) {
                (result: JSON) in
                
                if result != nil {
                  //  self.txtBasicArtist.text = result.arrayValue[0]["stripeplan"].stringValue
                }
            }
        }
    }
    
    func changeDefaultCard()
    {
        let saveResult: JSON = self.loadJSON(Constants.userDefault.loginInfo)
        
        if saveResult != nil {
            var param = Dictionary<String,String>()
            param[kAPISessionToken] = saveResult[kAPIToken].stringValue
            param["CardLast4"] = self.last4toDelete
            
            API.changeDefaultCard(param, aViewController: self) {
                (result: JSON) in
                
                if (result != nil) {
                    self.DLog("defaultCreditCard API Response: \(result)")
                    self.DAlert(ALERT_TITLE, message: "Default credit card set successful", action: ALERT_OK, sender: self)
                    
                    self.getCreditCardList()
                    
                    //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                }
            }
        }
    }
}
