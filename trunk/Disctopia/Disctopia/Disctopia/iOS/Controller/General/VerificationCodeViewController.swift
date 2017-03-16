//
//  VerificationCodeViewController.swift
//  Aamer
//
//  Created by Damini on 06/05/16.
//  Copyright © 2016 Damini. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

var otpCode = ""
var phone_num = ""

class VerificationCodeViewController: BaseVC {
    
    @IBOutlet var txtVerificationCode: UITextField!
       override func viewDidLoad()
       {
        super.viewDidLoad()
        txtVerificationCode.text = otpCode

        // Do any additional setup after loading the view.
    }

    class func instantiateFromStoryboard() -> VerificationCodeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! VerificationCodeViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Button Click

    
    @IBAction func btnVerificationCodeTapped(sender: AnyObject)
    {
        
        self.verifyOTPCode()
        
    }
    // MARK: - API Call function

    func verifyOTPCode()
    {}

    
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
