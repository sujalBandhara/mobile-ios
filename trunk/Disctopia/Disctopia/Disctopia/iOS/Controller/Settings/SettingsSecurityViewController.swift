//
//  SettingsSecurityViewController.swift
//  Disctopia
//
//  Created by Dhaval on 27/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsSecurityViewController: BaseVC,UITextFieldDelegate
{
    
    class func instantiateFromStoryboard() -> SettingsSecurityViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SettingsSecurityViewController
    }
    
    
    // MARK: - Outlets

    @IBOutlet weak var txtCurrentPassword: UITextField!
    
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBOutlet weak var txtReTypeNewPassword: UITextField!

    
    // MARK: - Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtCurrentPassword.delegate = self
        txtNewPassword.delegate = self
        txtReTypeNewPassword.delegate = self
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.hidePicker), name: "SettingsGeneralVCresignFirstResponder2", object: nil)
    }
    func hidePicker()
    {
        self.txtCurrentPassword.resignFirstResponder()
        self.txtNewPassword.resignFirstResponder()
        self.txtReTypeNewPassword.resignFirstResponder()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
       
    }
    // MARK: - Action
    
    @IBAction func onSaveChanges(sender: AnyObject)
    {
        if txtCurrentPassword.text?.isEmpty == true
        {
            txtCurrentPassword.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please enter current Password", action: ALERT_OK, sender: self)
        }
        else if txtNewPassword.text?.isEmpty == true
        {
            txtNewPassword.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please enter new password", action: ALERT_OK, sender: self)
        }
        else if txtReTypeNewPassword.text?.isEmpty == true
        {
            txtReTypeNewPassword.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please enter re-new password", action: ALERT_OK, sender: self)
        }
        else if(txtReTypeNewPassword.text != txtNewPassword.text)
        {
            txtReTypeNewPassword.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Your passwords do not match. Please type more carefully.", action: ALERT_OK, sender: self)
        }
            
        else
        {
            changePassword()
        }
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        appDelegate.selectedTextField = textField
        return true
    }
    // MARK: - API

    func changePassword()
    {
        var param = Dictionary<String, String>()
        let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
        if saveResult != nil
        {
            param["email"] =  saveResult[kAPIUsername].stringValue
        }
        //param["email"] = "1@2.com"
        param["oldpassword"] = txtCurrentPassword.text
        param["newpassword"] = txtNewPassword.text
        
        API.changePassword(param, aViewController:self)
        {
            (result: JSON) in
            if ( result != nil )
            {
                //print("success: \(result["message"])")
                
                BaseVC.sharedInstance.DAlert("", message: "\(result["message"])", action: "", sender: self)
                
                //("Change password success: \(result["message"])")
                
                self.txtCurrentPassword.text = ""
                self.txtNewPassword.text = ""
                self.txtReTypeNewPassword.text = ""
            }
            else
            {
                //print(" not success")

                BaseVC.sharedInstance.DLog("not Change password success")
            }
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

}
