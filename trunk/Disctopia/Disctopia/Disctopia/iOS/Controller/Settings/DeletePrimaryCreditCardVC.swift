//
//  ViewController.swift
//  Disctopia
//
//  Created by Trainee02 on 15/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DeletePrimaryCreditCardVC: BaseVC,IQDropDownTextFieldDelegate {

    @IBOutlet weak var txtCreditCard: IQDropDownTextField!
    @IBOutlet weak var btnCreditCard: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
    var customPicker = customPickerView()
    
    var creditCardArray:NSMutableArray = NSMutableArray()
    var mergerdArr : NSMutableArray = NSMutableArray()
    var last4ToDelete : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtCreditCard.layer.cornerRadius = 3
        txtCreditCard.delegate = self
        
        btnNo.layer.borderWidth = 0.90
        btnNo.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnYes.layer.borderWidth = 0.90
        btnYes.layer.borderColor = UIColor.whiteColor().CGColor
        
        getCreditCardList()
        
        // Do any additional setup after loading the view.
    }
    func textField(textField: IQDropDownTextField!, didSelectItem item: String!) {
        if(textField == self.txtCreditCard)
        {
            self.txtCreditCard.text = item
            self.DLog("card = \(item)")
            
            let trimmedStr = item.stringByReplacingOccurrencesOfString(" ", withString: "")
            let cardArr = trimmedStr.characters.split{$0 == "-"}.map(String.init)
            if(cardArr.count > 1)
            {
                self.last4ToDelete = cardArr[1]
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func onBtnCreditCardClick(sender: AnyObject) {
        
        self.customPicker.customArray = self.mergerdArr
        
        self.customPicker.customekey = "cardName"
        self.customPicker.center = CGPointMake(self.view.center.x, self.view.center.y)
        
        self.customPicker.onDateSelected = { (card: [String:String]) in
            let  card = "\(card["cardName"]!)"
            self.txtCreditCard.text = card
            self.DLog("card = \(card)")
            
            let trimmedStr = card.stringByReplacingOccurrencesOfString(" ", withString: "")
            let cardArr = trimmedStr.characters.split{$0 == "-"}.map(String.init)
        
            self.last4ToDelete = cardArr[1]
            
            self.customPicker.removeFromSuperview()
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.customPicker)
        
    }
    
    
    
    @IBAction func onBtnNoClick(sender: AnyObject) {
        let presentingViewController: UIViewController! = self.presentingViewController
        self.dismissViewControllerAnimated(false)
        {
            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
    
    @IBAction func onBtnYesClick(sender: AnyObject) {
        if (self.txtCreditCard.text != "" || self.txtCreditCard != nil) {
            deleteCreditCard()
        } else {
            self.DAlert(ALERT_TITLE, message: "Please select credit card", action: ALERT_OK, sender: self)

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
                    self.creditCardArray.removeAllObjects()

                    for dicCardList in result.arrayValue
                    {
                        let last4 = dicCardList["last4"].stringValue
                        let name = dicCardList["name"].stringValue
//
//                        let dict:NSMutableDictionary = NSMutableDictionary()
//                        let dict1:NSMutableDictionary = NSMutableDictionary()
//                        
//                        dict.setObject(last4, forKey: "last4")
//                        dict.setObject(name, forKey: "name")
//                        dict1.setObject(name+" - "+last4, forKey: "cardName")
//                        
//                        
                        
                       // self.creditCardArray.addObject(dict)
                        self.mergerdArr.addObject(name+" - "+last4)
                        
                    }
                    self.txtCreditCard.setDropDownTypePicker(0)
                    self.txtCreditCard.itemList = self.mergerdArr as [AnyObject]
               //     self.DLog("self.creditCardList : \(self.creditCardArray)")
                    self.DLog("self.mergerdArr : \(self.mergerdArr )")
                    
                    
                    if self.mergerdArr.count > 0
                    {
                      //  let dic:NSMutableDictionary = self.mergerdArr[0] as! NSMutableDictionary
                        
                        self.txtCreditCard.text! = self.mergerdArr[0] as! String
                    }
                }
                
                
            }
        }
    }
    
    func deleteCreditCard()
    {
        let saveResult : JSON =  self.loadJSON(Constants.userDefault.loginInfo)
        
        if saveResult != nil
        {
            var param = Dictionary<String, String>()
            param[kAPISessionToken] =  saveResult[kAPIToken].stringValue
            param["CardLast4"] = self.last4ToDelete
            
            API.deleteCreditCard(param, aViewController:self) { (result: JSON) in
                
                if ( result != nil )
                {
                    self.DLog("deleteCreditCard API Response: \(result)")
                    self.DAlert(ALERT_TITLE, message: "Credit card delete successful", action: ALERT_OK, sender: self)
                    //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                    self.getUserProfile()
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadCards", object: nil)
                    let presentingViewController: UIViewController! = self.presentingViewController
                    self.dismissViewControllerAnimated(false)
                    {
                        presentingViewController.dismissViewControllerAnimated(false, completion: nil)
                    }
                }
                else
                {
                    let presentingViewController: UIViewController! = self.presentingViewController
                    self.dismissViewControllerAnimated(false)
                    {
                        presentingViewController.dismissViewControllerAnimated(false, completion: nil)
                    }

                }
            }

        }
    }
}
