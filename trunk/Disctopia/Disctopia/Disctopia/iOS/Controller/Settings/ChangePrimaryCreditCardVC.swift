//
//  ChangePrimaryCreditCardVC.swift
//  Disctopia
//
//  Created by Trainee02 on 29/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePrimaryCreditCardVC: BaseVC {

    //Change Primary Credit Card View
    @IBOutlet var scrollChangeCreditCard: UIScrollView!
    @IBOutlet var viewChangeCreditCard: UIView!
    
    @IBOutlet var btnViewPrimaryCard: UIButton!
    @IBOutlet var btnSavePrimaryCard: UIButton!
    @IBOutlet var btnAddNewPrimaryCard: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var txtSelectCreditCard: IQDropDownTextField!
    
    var last4ToDelete : String = ""
    var customPicker = customPickerView()
    var creditCardArray: [JSON] = []
    var mergerdArr:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtSelectCreditCard.layer.cornerRadius = 5
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        btnSavePrimaryCard.layer.borderColor = UIColor.whiteColor().CGColor
        btnViewPrimaryCard.layer.borderColor = UIColor.whiteColor().CGColor
        btnAddNewPrimaryCard.layer.borderColor = UIColor.whiteColor().CGColor
        btnCancel.layer.borderWidth = 1
        btnViewPrimaryCard.layer.borderWidth = 1
        btnAddNewPrimaryCard.layer.borderWidth = 1
        btnSavePrimaryCard.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        
        getCreditCardList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        //self.scrollViewBankAcInfo.contentSize = CGSizeMake(subScrollView.frame.size.width,912)
        self.scrollChangeCreditCard.contentOffset = CGPointMake(0, 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.DLog("DidAppear changePrimaryCard VC")
        
//        setUserProfileData()
        getCreditCardList()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //Change Primary Credit Card Actions
    @IBAction func onSaveChangeCardClick(sender: AnyObject) {
        if txtSelectCreditCard.text?.isEmpty == true {
            self.DAlert(ALERT_TITLE, message: "Please select primary credit card", action: ALERT_OK, sender: self)
        }
        else {
            changeDefaultCard()
            //self.DAlert(ALERT_TITLE, message: "Under Construction", action: ALERT_OK, sender: self)
        }
    }
    
    @IBAction func onViewCardClick(sender: AnyObject) {
        if(self.creditCardArray.count > 1)
        {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ViewCreditCardViewController = storyboard.instantiateViewControllerWithIdentifier("ViewCreditCardViewController") as! ViewCreditCardViewController
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(navigationController, animated: true, completion: nil)
        }
        else
        {
            DAlert(ALERT_TITLE, message: "Credit card not available", action: ALERT_OK, sender: self)
        }
    }
    
    @IBAction func onAddCardClick(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : AddNewCreditCardSettingsVC = storyboard.instantiateViewControllerWithIdentifier("AddNewCreditCardSettingsVC") as! AddNewCreditCardSettingsVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func onCancelClick(sender: AnyObject) {
        //self.viewChangeCreditCard.removeFromSuperview()
        let presentingViewController: UIViewController! = self.presentingViewController
        self.dismissViewControllerAnimated(false)
        {
            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }

    @IBAction func onSelectCreditCardClick(sender: AnyObject) {
//        self.customPicker = customPickerView()
//        self.customPicker.customArray = [["id":"1","name":"Credit Card 1"],["id":"2","name":"Credit Card 2"],["id":"3","name":"Credit Card 3"],["id":"4","name":"Credit Card 4"]]
        self.customPicker.customArray = self.mergerdArr
        self.customPicker.customekey = "cardName"
        self.customPicker.center = CGPointMake(self.view.center.x, self.view.center.y)
        
        self.customPicker.onDateSelected = { (card: [String:String]) in
            let  card = "\(card["cardName"]!)"
            self.txtSelectCreditCard.text = card
            self.DLog("card = \(card)")
            
            let trimmedStr = card.stringByReplacingOccurrencesOfString(" ", withString: "")
            let cardArr = trimmedStr.characters.split{$0 == "-"}.map(String.init)
            
            self.last4ToDelete = cardArr[1]
            
            self.customPicker.removeFromSuperview()
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.customPicker.reloadAllComponents()
        if ( self.customPicker.superview == nil)
        {
            self.view.addSubview(self.customPicker)
        }
    }
    
    func setUserProfileData()
    {
        let profile : JSON =  self.loadJSON(Constants.userDefault.userProfileInfo)
        BaseVC.sharedInstance.DLog("Saved userProfile: \(profile)")
        if (profile.count > 0) {
            
//            self.txtSelectCreditCard.text = profile[0]["defaultcard"].stringValue
            
//            print("default card: \(self.mergerdArr[0])")
//            self.txtSelectCreditCard.text = mergerdArr[0]["cardName"]?!.stringValue
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
                    self.creditCardArray.removeAll()
                    self.creditCardArray = result.arrayValue

                    for dicCardList in result.arrayValue
                    {
                        let last4 = dicCardList["last4"].stringValue
                        let name = dicCardList["name"].stringValue
                        //
                        self.mergerdArr.addObject(name+" - "+last4)
//                        let dict:NSMutableDictionary = NSMutableDictionary()
//                        let dict1:NSMutableDictionary = NSMutableDictionary()
//                        
//                        dict.setObject(last4, forKey: "last4")
//                        dict.setObject(name, forKey: "name")
//                        dict1.setObject(name+" - "+last4, forKey: "cardName")
//                        
//                        self.creditCardArray.addObject(dict)
//                        self.mergerdArr.addObject(dict1)
                    }
                    self.txtSelectCreditCard.setDropDownTypePicker(0)
                    self.txtSelectCreditCard.itemList = self.mergerdArr as [AnyObject]

                    
                    if self.mergerdArr.count > 0
                    {
                       // let dict:NSMutableDictionary = self.mergerdArr[0] as! NSMutableDictionary

                        //let str : String = "\(dict["cardName"]!)"
                        self.txtSelectCreditCard.text = self.mergerdArr[0] as! String
                    }
                    
                    self.DLog("self.creditCardList : \(self.creditCardArray)")
                    self.DLog("self.mergerdArr : \(self.mergerdArr )")
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
            param["CardLast4"] = self.last4ToDelete
            
            API.changeDefaultCard(param, aViewController: self) {
                (result: JSON) in
                
                if (result != nil) {
                    self.DLog("defaultCreditCard API Response: \(result)")
                    
                    let savechangesVCObj: SaveChangesVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("SaveChangesVC") as! SaveChangesVC
                    let navigationController = UINavigationController(rootViewController: savechangesVCObj)
                    navigationController.modalPresentationStyle = .OverCurrentContext
                    navigationController.navigationBarHidden = true
                    self.presentViewController(navigationController, animated: true, completion: nil)
                    
                   // self.DAlert(ALERT_TITLE, message: "Default credit card set successful", action: ALERT_OK, sender: self)
                    
                    self.getCreditCardList()
                    
                    //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                }
            }
        }
    }
}
