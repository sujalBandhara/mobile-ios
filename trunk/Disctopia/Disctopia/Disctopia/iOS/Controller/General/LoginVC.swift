//
//  ClubOwnerLoginViewController.swift
//  Aamer
//
//  Created by imac04 on 12/10/15.
//  Copyright © 2015 byPeople Technologies. All rights reserved.
//

import UIKit
import Social
import Accounts
import KFSwiftImageLoader

class LoginVC: BaseVC,APIConnectionDelegate,UITextFieldDelegate
{
    @IBOutlet var txtFieldEmail: UITextField!
    @IBOutlet var txtFieldPassword: UITextField!
    @IBOutlet var lblAPIStatus: UILabel!
    @IBOutlet var btnCreateAccount: UIButton!
    
    @IBOutlet weak var passwordBg: UIView!
    @IBOutlet weak var emailBg: UIView!
    /*
    *   get API Token from login API and set API Token in MyAccount API for get login user's detail
    */
    var strAPIAuthToken : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.txtFieldEmail.delegate = self
        self.txtFieldPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.emailBg.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.passwordBg.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        
        if (!IS_TESTING)
        {
            self.txtFieldEmail.text = ""
            self.txtFieldPassword.text = ""
        }
        else
        {
            //self.txtFieldEmail.text = "vaishali+1@soms.in"// Club Owner
            //self.txtFieldEmail.text = "vaishali+111@soms.in" // Owners
            //self.txtFieldEmail.text = "vaishali+226@soms.in" // Owners Test
            self.txtFieldEmail.text = "nawedita+6@soms.in"// Customer
            //self.txtFieldEmail.text = "nidhi@soms.in"
            self.txtFieldPassword.text = "123456"
        }
        
        setLoginButton()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginClick(sender: AnyObject)
    {
        if (!isLocalData)
        {
            appDelegate.aamerUserType = AamerUserType.Owner
            super.pushToViewControllerIfNotExistWithClassName(HomeScreenViewController(),identifier : "HomeScreenViewController",animated: true, animationType : AnimationType.ScrollView)
        }
        else
        {
           self.DLog("\(appDelegate.locationStatus)")
            //check validation for login
            let strMessage = validateData()
            
            //validation ok then go for login api
            if  strMessage == "Ok"
            {
                //call login api
                if self.txtFieldEmail.text != nil && self.txtFieldPassword.text != nil
                {
                    var param = Dictionary<String, String>()
                    param[kAPIUsername] = self.txtFieldEmail.text
                    param[kAPIPassword] = self.txtFieldPassword.text
                    param[kAPIDeviceToken] = appDelegate.deviceToken
                    param[kAPIDeviceType] = deviceType_IOS
                    
                    //call login api
                    let object =  APIConnection().POST(APIName.Login.rawValue, withAPIName: "login", withMessage: "", withParam: param, withProgresshudShow: true, isShowNoInternetView: true) as! APIConnection
                    object.delegate = self
                }
            }
            else
            {
                //not fulfil validation
                DAlert(ALERT_TITLE, message: strMessage, action: ALERT_OK, sender: self)
            }

        }
    }
    
    @IBAction func onForgotPasswordClick(sender: AnyObject)
    {
        super.pushToViewControllerIfNotExistWithClassName(ForgotPasswordVC(),identifier : "ForgotPasswordVC",animated: true, animationType : AnimationType.ScrollView)
        
        //DAlert(ALERT_TITLE, message: "Sorry ! Functionality is under implementation.", action: ALERT_OK, sender: self)
        return;
    }
    
    @IBAction func onRegistrationClick(sender: AnyObject)
    {
        super.pushToViewControllerIfNotExistWithClassName(RegistrationViewController(),identifier : "RegistrationViewController",animated: true, animationType : AnimationType.ScrollView)
        
        //DAlert(ALERT_TITLE, message: "Sorry ! Functionality is under implementation.", action: ALERT_OK, sender: self)
        return;
    }
    
    @IBAction func onDiscoverNightClick(sender: AnyObject)
    {
        appDelegate.aamerUserType = AamerUserType.Owner
       // super.pushToViewControllerIfNotExistWithClassName(RequestViewController(),identifier : "RequestViewController",animated: true, animationType : AnimationType.ScrollView)
    }
    
    //MARK: - APIConnection Delegate -
    func connectionFailedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    {
        switch action
        {
            //login API
        case APIName.Login.rawValue:
            //get login user's detail
            DAlert(ALERT_TITLE, message: "ALERT_NO_INTERNET".localized, action: ALERT_OK, sender: self)
            
        default:
           self.DLog("Nothing")
        }
    }
    
    func connectionDidUpdateAPIProgress(action: Int,bytesWritten: Int64, totalBytesWritten: Int64 ,totalBytesExpectedToWrite: Int64)
    {
        
    }
    
    func connectionDidFinishedErrorResponceForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    {
        switch action
        {
        case APIName.Login.rawValue:
            //get login user's detail
            if ( result != nil)
            {
                if  result!.isKindOfClass(NSDictionary)
                {
                    if (result[kAPIResponseErrorCode] != nil)
                    {
                        if (result[kAPIResponseErrorCode]!.isEqualToString("ValidationError_EmailAddressAlreadyExists") )
                        {
                            DAlert(ALERT_TITLE, message: ALERT_EMAILADRESS_ALREADY_USED, action: ALERT_OK, sender: self)
                        }
                        else if (result[kAPIResponseErrorCode]!.isEqualToString("ValidationError_PhoneNumberAlreadyExists") )
                        {
                            DAlert(ALERT_TITLE, message: ALERT_MOBILE_ALREADY_USED, action: ALERT_OK, sender: self)
                        }
                        else
                        {
                            if result[kAPIResponseErrorCode] != nil
                            {
                                DAlert(ALERT_TITLE, message: "\(result[kAPIResponseErrorCode]!)", action: ALERT_OK, sender: self)
                            }
                        }
                    }
                    else
                    {
                        //DAlert(ALERT_TITLE, message: ALERT_UNEXPECTED, action: ALERT_OK, sender: self)
                    }
                }
            }
            
        default:
           self.DLog("Nothing")
        }
        
    }
    
    func connectionDidFinishedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    {
        switch action
        {
            
        case APIName.Login.rawValue:
            //get login user's detail
            if ( result != nil)
            {
                if (result.isKindOfClass(NSDictionary))
                {
                    if(result[kAPIResponseStatus]?.intValue == 1)
                    {
                        var dic: NSMutableDictionary = NSMutableDictionary()
                        dic  = result.mutableCopy() as! NSMutableDictionary
                        dic.setObject(self.txtFieldPassword.text!, forKey: kAPIPassword)
                        dic.setObject( self.strAPIAuthToken, forKey: kAPIAuthToken)
                    
                        /*
                        USER_LEVEL_CUSTOMER=>1,
                        USER_LEVEL_MANAGER=>2,
                        USER_LEVEL_PROMOTER=>3,
                        USER_LEVEL_CLUBOWNER=>4
                        */
                        if (result[kAPIResponsedata]?["userType"]!!.intValue == 1)
                        {
                            appDelegate.aamerUserType = AamerUserType.Provider
                        }
                        else if (result[kAPIResponsedata]?["userType"]!!.intValue == 2)
                        {
                            appDelegate.aamerUserType = AamerUserType.Owner
                        }
                        
                        appDelegate.aamerUserType = AamerUserType.Owner
                        
                        super.setUserDefaultDataFromKey(USER_DEFAULT_LOGIN_USER_DATA, dic: dic )
                        super.setUserDefaultStringFromKey(USER_DEFAULT_ACCOUNT_SETUP_FROM_LOGIN, value: "1")
                        
                        //appDelegate.getUserProfile()
                       self.DLog("Login info \(super.getUserDefaultDataFromKey(USER_DEFAULT_LOGIN_USER_DATA))")
                        
                        if(appDelegate.aamerUserType == AamerUserType.Owner)
                        {
                            //super.pushToViewControllerIfNotExistWithClassName(RequestViewController(),identifier : "RequestViewController",animated: true, animationType : AnimationType.ScrollView)
                        }
                        else
                        {
                            DAlert(ALERT_TITLE, message: "\(result[kAPIResponseErrorDesc]!) \n Module Under Construction", action: ALERT_OK, sender: self)
                        }
                        
                        //Start Push Notification and Loation Manager
                    }
                    else
                    {
                         DAlert(ALERT_TITLE, message: "\(result[kAPIResponseErrorDesc]!)", action: ALERT_OK, sender: self)
                    }
                }
            }
            
           self.DLog("MyAccount")
            
        default:
           self.DLog("Nothing")
        }
    }
    
    //MARK: - Validation Method -
    func validateData() -> String
    {
        var strMessage = "Ok"
        
        if validate(self.txtFieldEmail.text)
        {
            strMessage = ALERT_BLANK_MOBILE_EMAIL
        }
        else if validate(self.txtFieldPassword.text)
        {
            strMessage = ALERT_BLANK_PASSWORD
        }
            // else if validateNumber(self.txtFieldEmail.text)
            // {
            //     if !validatePhoneNumber(self.txtFieldEmail.text!)
            //     {
            //         strMessage = ALERT_VALID_MOBILE_NUMBER
            //     }
            // }
        else if !self.txtFieldEmail.text!.isEmail()
        {
            strMessage = ALERT_VALID_EMAIL_ADDRESS
        }
        return strMessage
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if (textField == self.txtFieldEmail)
        {
            self.emailBg.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            self.passwordBg.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        }
        else if (textField == self.txtFieldPassword)
        {
            self.emailBg.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            self.passwordBg.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        }

        setLoginButton()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        setLoginButton()
        return true
    }
    
    func setLoginButton()
    {
        if (self.txtFieldEmail.text!.characters.count > 0 && self.txtFieldPassword.text!.characters.count > 0)
        {
            self.btnCreateAccount.hidden = false
        }
        else
        {
            self.btnCreateAccount.hidden = true
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
        {
            // your function here
            self.setLoginButton()
        })
        
//        if (textField == self.txtFieldEmail)
//        {
//            self.emailBg.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
//            self.passwordBg.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
//        }
//        else
//        {
//            self.emailBg.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
//            self.passwordBg.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
//        }
        return true
   }
    
    /*
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}