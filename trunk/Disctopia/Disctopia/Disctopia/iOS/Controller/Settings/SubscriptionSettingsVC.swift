//
//  SubscriptionSettingsVC.swift
//  Disctopia
//
//  Created by Dhaval on 23/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubscriptionSettingsVC: BaseVC
{
    
    class func instantiateFromStoryboard() -> SubscriptionSettingsVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SubscriptionSettingsVC
    }
    
    
    // MARK: - Outlets

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var deactivateAccountBtn: UIButton!
    
    @IBOutlet weak var lblAttribute: UILabel!
    
    @IBOutlet weak var lblCurrentPlanExp: UILabel!
    
    @IBOutlet weak var txtBasicArtist: IQDropDownTextField!
    
    var planJSONArray : [JSON] = []
    
    var customPicker = customPickerView()

    var arrSub: NSMutableArray = NSMutableArray()
    
    var manageSubcriptionArray : NSMutableArray = NSMutableArray()
    // MARK: - Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        deactivateAccountBtn.layer.borderColor = UIColor.redColor().CGColor
        deactivateAccountBtn.layer.borderWidth = 1
       
        txtBasicArtist.layer.cornerRadius = 5
        txtBasicArtist.layer.borderWidth = 0.5
       
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 200.0)
        
        self.lblAttribute.attributedText = self.SetAttributePrivacyLabel("Please be aware that if you deactivate your\n", second: "account you will ", third: "not ", forth: "be able to recover it.")
       
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateSubscription", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.hidePicker), name: "SubscriptionSettingsVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateSubscription), name: "updateSubscription", object: nil)
        
    }
    func hidePicker()
    {
        if ( self.customPicker.superview != nil )
        {
            self.customPicker.removeFromSuperview()
        }
        self.txtBasicArtist.resignFirstResponder()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
       // getSubscriptionPlan()
        getInAppList()
        setSubscriptionPlan()
//        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC)))
//        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
//            // your function here
//            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 200.0)
//        })
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        if ( self.customPicker.superview != nil )
        {
            self.customPicker.removeFromSuperview()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let viewWithTag = self.view.viewWithTag(100)
        {
            self.DLog("Tag 100")
            viewWithTag.removeFromSuperview()
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        self.scrollView.contentOffset = CGPointMake(0, 0)
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 200.0)
        
    }
    
    // MARK: - Action
    
    @IBAction func onBtnClick(sender: AnyObject)
    {
        if self.manageSubcriptionArray.count > 0
        {
            self.txtBasicArtist.becomeFirstResponder()
        }
/*        self.customPicker.customArray =  self.manageSubcriptionArray
        self.customPicker.customekey = "name"
        self.customPicker.center = CGPointMake(scrollView.center.x, self.txtBasicArtist.frame.origin.y)
        
        self.customPicker.onDateSelected =
        {
            (plan: [String:String]) in
            let  plan = "\(plan["name"]!)"
            self.txtBasicArtist.text = plan
            BaseVC.sharedInstance.DLog("plan = \(plan)")
            self.customPicker.removeFromSuperview()
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.customPicker.tag = 100
        self.customPicker.reloadAllComponents()
        if ( self.customPicker.superview == nil)
        {
            self.view.addSubview(self.customPicker)
        }*/
        
        
        
    }
    
    @IBAction func btnDeactivateAccount(sender: AnyObject)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let aExpandedPlayerVC : DeactivateAccountReasonViewController = storyboard.instantiateViewControllerWithIdentifier("DeactivateAccountReasonViewController") as! DeactivateAccountReasonViewController
        
        let navigationController = UINavigationController(rootViewController: aExpandedPlayerVC)
        
        navigationController.modalPresentationStyle = .OverCurrentContext
        
        self.presentViewController(navigationController, animated: true, completion: nil)
        self.pushToViewControllerIfNotExistWithClassName("DeactivateAccountReasonViewController", animated: true)
    }
    
    @IBAction func onNeedMoreClick(sender: AnyObject)
    {
        /*
        let url = NSURL(string: "https://www.disctopia.com/#signUpAnchor")!
        UIApplication.sharedApplication().openURL(url)
         */
    }
    
    @IBAction func onSaveChanges(sender: AnyObject)
    {
        if txtBasicArtist.text?.isEmpty == true
        {
            txtBasicArtist.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please select basic artist", action: ALERT_OK, sender: self)
        }
        else
        {
            let saveResult: JSON = self.loadJSON( Constants.userDefault.userProfileInfo)
            if (saveResult != nil)
            {
                let usertype = saveResult[0]["userType"].intValue
                if usertype == 1
                {
                    if self.planJSONArray.count > self.txtBasicArtist.selectedRow && self.txtBasicArtist.selectedRow > -1
                    {
                        let planId = self.planJSONArray[self.txtBasicArtist.selectedRow]["id"].stringValue
                        appDelegate.planId = planId
                        let productId = self.planJSONArray[self.txtBasicArtist.selectedRow]["productId"].stringValue
                        if productId.characters.count > 0
                        {
                            appDelegate.isFromSubsription = true
                            purchase(productId)
                        }
                        else
                        {
                            updateSubscription()
                        }
                    }
                }
                else
                {
                    let isSubscriptionExpired = saveResult[0]["isSubscriptionExpired"].stringValue
                    
                    if isSubscriptionExpired == "0"
                    {
                        print("self.planJSONArray.count \(self.planJSONArray.count)")
                        print("self.txtBasicArtist.selectedRow : \(self.txtBasicArtist.selectedRow)")
                        if self.planJSONArray.count > self.txtBasicArtist.selectedRow && self.txtBasicArtist.selectedRow > -1
                        {
                            let planId = self.planJSONArray[self.txtBasicArtist.selectedRow]["id"].stringValue
                            appDelegate.planId = planId
                        }
                        updateSubscription()
                    }
                    else
                    {
                        if self.planJSONArray.count > self.txtBasicArtist.selectedRow && self.txtBasicArtist.selectedRow > -1
                        {
                            let planId = self.planJSONArray[self.txtBasicArtist.selectedRow]["id"].stringValue
                            appDelegate.planId = planId
                            let productId = self.planJSONArray[self.txtBasicArtist.selectedRow]["productId"].stringValue
                            if productId.characters.count > 0
                            {
                                appDelegate.isFromSubsription = true
                                purchase(productId)
                            }
                            else
                            {
                                updateSubscription()
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    // MARK: - API
    
    func getSubscriptionPlan()
    {
        API.getSubscriptionPlanList("",aViewController: self) { (result: JSON) in
            
            if (result != nil)
            {
                self.manageSubcriptionArray.removeAllObjects()
                //self.manageSubcriptionArray.addObject("Free")
                
                self.planJSONArray = result.arrayValue
                
                for dicSubcription in result.arrayValue
                {
                    let name = dicSubcription["name"].stringValue
                    
                    self.manageSubcriptionArray.addObject(name)
                    //    let id = dicSubcription["id"].stringValue
                    //    let name = dicSubcription["name"].stringValue
                    //
                    //    let subcriptionArray : NSMutableDictionary = NSMutableDictionary()
                    //
                    //    subcriptionArray.setObject(id, forKey: "id")
                    //    subcriptionArray.setObject(name, forKey: "name")
                    //
                    //    self.manageSubcriptionArray.addObject(subcriptionArray)
                }
                
                if self.txtBasicArtist != nil
                {
                    if self.manageSubcriptionArray.count > 0
                    {
                        self.txtBasicArtist?.setDropDownTypePicker(0)
                        self.txtBasicArtist?.itemList = self.manageSubcriptionArray as [AnyObject]
                        self.DLog("self.manageSubscription Array: \(self.manageSubcriptionArray)")
                    }
                }
                
                self.setSubscriptionPlan()
            }
        }
    }
    
    func getInAppList()
    {
        API.getInAppList("",aViewController: self) { (result: JSON) in
            
            if (result != nil) {
                self.manageSubcriptionArray.removeAllObjects()
                self.planJSONArray = result.arrayValue
                for dicSubcription in result.arrayValue
                {
                    let name = dicSubcription["plan"].stringValue
                    self.manageSubcriptionArray.addObject(name)
                }
                
                if self.txtBasicArtist != nil
                {
                    if self.manageSubcriptionArray.count > 0
                    {
                    self.txtBasicArtist?.setDropDownTypePicker(0)
                    self.txtBasicArtist?.itemList = self.manageSubcriptionArray as [AnyObject]
                    self.DLog("self.manageSubscription Array: \(self.manageSubcriptionArray)")
                    }
                }
                 self.setSubscriptionPlan()
            }
        }
    }

    func setSubscriptionPlan()
    {
        Constants.userDefault.userProfileInfo
        let saveResult : JSON =  self.loadJSON(Constants.userDefault.loginInfo)
        let saveResult1 : JSON =  self.loadJSON(Constants.userDefault.userProfileInfo)

        if saveResult != nil && saveResult1 != nil
        {
            var param = Dictionary<String, String>()
            param[kAPISessionToken] =  saveResult[kAPIToken].stringValue
            
            let usertype = saveResult1[0]["userType"].intValue
            if usertype == 1
            {
                 self.lblCurrentPlanExp.text = "FAN"//Fan(Active)
            }
            else
            {
                API.getGetArtistProfile(param, aViewController: self) {
                    (result: JSON) in
                    
                    if result != nil
                    {
                        if result.arrayValue.count > 0
                        {
                            // self.manageSubcriptionArray.removeAllObjects()
                            
                            let userTypeStr = saveResult1.arrayValue[0][kAPIUserType].stringValue
                            if userTypeStr == "2" // Artist User
                            {
                                // TODO : Patrick is getting 
                                self.txtBasicArtist.text = result.arrayValue[0]["stripeplan"].stringValue
                                //self.txtBasicArtist.text = self.findPlanName(result.arrayValue[0]["stripeplan"].stringValue)
                                
                                self.lblCurrentPlanExp.text = "\(self.findPlanName(result.arrayValue[0]["stripeplan"].stringValue)) renews on"
                                
                                
                                if let expDate:String = result.arrayValue[0]["activeUntil"].stringValue
                                {
                                    
                                    if expDate.characters.count > 0
                                    {
                                        //"2026-10-31T14:22:27.64"
                                        var eDate = expDate.componentsSeparatedByString(".")
                                        
                                        if let aExpDate = eDate[0] as? String
                                        {
                                            let strNewDate = self.convertDateFromOneFormatToOtherFormat(aExpDate, oldDateFormat: "yyyy-MM-dd'T'HH:mm:ss", newDateFormat: "MM/dd/yyyy")
                                            self.lblCurrentPlanExp.text = "\(self.findPlanName(result.arrayValue[0]["stripeplan"].stringValue)) renews on \(strNewDate)"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func updateSubscription()
    {
        var param = Dictionary<String,String>()
        param["inappplan"] = appDelegate.planId
        API.UpdateSubscriptionIOS(param,aViewController:self) {
            (result: JSON) in
            
            if (result != nil)
            {
                self.DAlert(ALERT_TITLE, message: "Update Subscription successfully", action: ALERT_OK, sender: self)
                BaseVC.sharedInstance.getUserProfile()
                print("UpdateSubscriptionIOS result\(result)")
            }
        }
    }
    func updateSubscriptionOld()
    {
        let saveResult: JSON = self.loadJSON(Constants.userDefault.loginInfo)
        if (saveResult != nil) {
            var param = Dictionary<String,String>()
            param[kAPISessionToken] = saveResult[kAPIToken].stringValue
            
            //param["SubscripePlan"] = self.txtBasicArtist.text
            
            param["SubscripePlan"] = ""
            
            if self.txtBasicArtist.text == "Free"
            {
                param["SubscripePlan"] = "Free"
            }
            else
            {
                if self.planJSONArray.count > self.txtBasicArtist.selectedRow-1 && self.txtBasicArtist.selectedRow > 0
                {
                    let planId = self.planJSONArray[self.txtBasicArtist.selectedRow-1]["id"].stringValue
                    if planId.characters.count > 0
                    {
                        param["SubscripePlan"] = planId
                    }
                }
            }
            
            API.updateSubscription(param,aViewController:self) {
                (result: JSON) in
                
                if (result != nil) {
                    let savechangesVCObj: SaveChangesVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("SaveChangesVC") as! SaveChangesVC
                    let navigationController = UINavigationController(rootViewController: savechangesVCObj)
                    navigationController.modalPresentationStyle = .OverCurrentContext
                    navigationController.navigationBarHidden = true
                    appDelegate.navigationController?.presentViewController(navigationController, animated: true, completion: {
                        print("Save changesVC Presented")
                    })
                    
                                        //self.DLog("UpdateSubscription plan API response \(result)")
                    //print("\(result.dictionaryValue["subscriptionId"]!)")
                  //  self.DAlert(ALERT_TITLE, message: "UpdateSubscription saved successful", action: ALERT_OK, sender: self)
                    //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                    self.getUserProfileAfterSubscriptionUpdate()

                }
                else
                {
                    self.getUserProfileAfterSubscriptionUpdate()

                }
                
            }
        }
    }
    
    func getUserProfileAfterSubscriptionUpdate()
    {
        API.getUserProfile(nil, aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("getUserProfile API Response: \(result)")
                self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                self.setSubscriptionPlan()
            }
        }
    }
    
    func findPlanName(planId : String) -> String {
        
        //let predicate: NSPredicate = NSPredicate(format: "name contains[c] %@", planId)
        
        var planName : String = ""
        
        DLog("self.planJSONArray.count \(self.planJSONArray.count)")
        
        for i in 0..<self.planJSONArray.count
        {
            DLog("self.planJSONArray[i] \(self.planJSONArray[i]["id"].stringValue)")
            if self.planJSONArray[i]["id"].stringValue == planId
            {
                planName = self.planJSONArray[i]["plan"].stringValue
            }
        }
        return planName
    }
    
    // MARK: - Functions

    func SetAttributePrivacyLabel(first: String, second: String, third: String, forth: String) -> NSAttributedString
    {
        let multipleAttributes = [NSForegroundColorAttributeName: UIColor.redColor(),
                                  NSFontAttributeName: UIFont(name: "Avenir Medium", size: 16.0)!]
        
        let myAttrString1 = NSAttributedString(string: first, attributes:nil)
        let myAttrString2 = NSAttributedString(string: second, attributes: nil)
        let myAttrString3 = NSAttributedString(string: third, attributes: multipleAttributes)
        let myAttrString4 = NSAttributedString(string: forth, attributes: nil)
        
        let result = NSMutableAttributedString()
        
        result.appendAttributedString(myAttrString1)
        result.appendAttributedString(myAttrString2)
        result.appendAttributedString(myAttrString3)
        result.appendAttributedString(myAttrString4)

        return result
    }
    
    func SetAttributePrivacyLabelForPlan(first: String, second: String, third: String, forth: String) -> NSAttributedString
    {
      //  let multipleAttributes = [NSForegroundColorAttributeName: UIColor.redColor(),
                             //     NSFontAttributeName: UIFont(name: "Avenir Medium", size: 16.0)!]
        
        let textSize = self.lblCurrentPlanExp.font.pointSize

        let multipleAttributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(textSize)]
        
        let myAttrString1 = NSAttributedString(string: first, attributes:multipleAttributes)
        let myAttrString2 = NSAttributedString(string: second, attributes: nil)
        let myAttrString3 = NSAttributedString(string: third, attributes: nil)
        let myAttrString4 = NSAttributedString(string: forth, attributes: nil)
        
        let result = NSMutableAttributedString()
        
        result.appendAttributedString(myAttrString1)
        result.appendAttributedString(myAttrString2)
        result.appendAttributedString(myAttrString3)
        result.appendAttributedString(myAttrString4)
        
        return result
    }
    
    
    
}
