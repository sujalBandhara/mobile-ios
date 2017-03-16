//
//  ViewController.swift
//  Aamer
//
//  Created by Damini on 05/05/16.
//  Copyright © 2016 Damini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignInViewController: BaseVC ,UITextFieldDelegate {
    
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var btnNextLogin: UIButton!
    var options: PagingMenuControllerCustomizable!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.txtPhoneNo.delegate = self
        //txtPhoneNo.text = phone_num
        
        //self.loadPageMenu()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
       
    @IBAction func NextButtonTapped(sender: AnyObject)
    {
        self.isValidPhoneNumber(txtPhoneNo.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string.length == 0
        {
            return true
        }
        else if textField.text!.length >= 10
        {
            return false
        }
        
        return true
    }
    func isValidPhoneNumber(phoneNo : String)
    {
        let first2char = String(phoneNo.characters.prefix(2))
        
        
        if phoneNo.characters.count != 10
        {
            self.DAlert(ALERT_TITLE, message: "Phone number should be 10  digit.", action: ALERT_OK, sender: self)
        }
        else if first2char != "05"
        {
            self.DAlert(ALERT_TITLE, message: "Phone number should start with 05 digit.", action: ALERT_OK, sender: self)
        }
        else
        {
            //self.DAlert(ALERT_TITLE, message: "Success", action: ALERT_OK, sender: self)
            sendOTPCode(phoneNo)
        }
    }
    
    func sendOTPCode(phoneNo:String)
    {
        
        self.showLoader()
        var param = Dictionary<String, String>()
        
        param[kAPIUserType] = KAPIUserTypeValue
        param["phone_number"] = phoneNo
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        let url = Constants.Network.baseUrl +  "sendOTP"
        DLog("param \(param)")
        
        self.printAPIURL("sendOTP", param: param)
        // DLog("url = \(url)")
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                self.hideLoader()
                
                switch response.result {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        self.DLog("******JSON: \(json)")
                        if (json[kAPIResponseStatus].intValue == 1)
                        {
                            
                            if  json[kAPIResponsedata] != nil
                            {
                                if  json[kAPIResponsedata] != nil
                                {
                                    otpCode = json[kAPIResponsedata]["otp_code"].stringValue
                                    self.DLog("otp_code \(otpCode)")
                                    phone_num = phoneNo
                                    
                                    //super.pushToViewControllerIfNotExistWithClassName(VerificationCodeViewController(),identifier : "VerificationCodeViewController",animated: true, animationType : AnimationType.ScrollView)
                                }
                            }
                            
                        }
                        else if (json[kAPIResponseStatus].intValue == -2)
                        {
                            BaseVC.sharedInstance.logOut()
                        }
                        else
                        {
                            self.DAlert(ALERT_TITLE, message: "\(json[kAPIResponseErrorDesc].stringValue)", action: ALERT_OK, sender: self)
                        }
                        
                    }
                case .Failure(let error):
                    self.DLog(error)
                }
        }
    }
    
    func loadPageMenu()
    {
//        options =  PagingMenuOptionsSujal()
//        let pagingMenuController = PagingMenuController(options: options)
//        //let pagingMenuController = self.childViewControllers.first as! PagingMenuController
//        pagingMenuController.delegate = self
//        pagingMenuController.setup(options)
//        self.addChildViewController(pagingMenuController)
//        pagingMenuController.view.frame = CGRectMake(0, 100,pagingMenuController.view.frame.size.width, pagingMenuController.view.frame.size.height - 100)
//        self.view.addSubview(pagingMenuController.view)
//        //        pagingMenuController.didMoveToParentViewController(self)
    }
    
}


/*
 class func instantiateFromStoryboard() -> VerificationCodeViewController {
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! VerificationCodeViewController
 }
 
 */
