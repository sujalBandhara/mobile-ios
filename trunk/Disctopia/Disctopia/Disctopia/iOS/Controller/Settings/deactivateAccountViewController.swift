//
//  deactivateAccountViewController.swift
//  Disctopia
//
//  Created by Dhaval on 02/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class deactivateAccountViewController: BaseVC
{
    
    class func instantiateFromStoryboard() -> deactivateAccountViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! deactivateAccountViewController
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad()
    {
        self.dynamicFontNeeded = false
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func deactivateAccount(sender: AnyObject)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let aExpandedPlayerVC : DeactivateAccountReasonViewController = storyboard.instantiateViewControllerWithIdentifier("DeactivateAccountReasonViewController") as! DeactivateAccountReasonViewController
        
        let navigationController = UINavigationController(rootViewController: aExpandedPlayerVC)
        
        navigationController.modalPresentationStyle = .OverCurrentContext
        
        self.presentViewController(navigationController, animated: true, completion: nil)
        self.pushToViewControllerIfNotExistWithClassName("DeactivateAccountReasonViewController", animated: true)
        
//        let alertController = UIAlertController(title: "Deactivate Account", message: "Please enter your reason:", preferredStyle: .Alert)
//        
//        let confirmAction = UIAlertAction(title: "Submit", style: .Default) { (_) in
//            if let textField = alertController.textFields![0] as? UITextField {
//                // store your data
//                BaseVC.sharedInstance.DLog("Text field: \(textField.text)")
//                self.callDeactivateAccountAPI(textField.text!)
//            } else
//            {
//                // user did not fill field
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
//        
//        alertController.addTextFieldWithConfigurationHandler { (textField) in
//            textField.placeholder = "enter reason"
//        }
//        
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - API

    func callDeactivateAccountAPI(reason:String)
    {
        var param = Dictionary<String, String>()
        //param["albumId"] = appDelegate.selectedAlbumId
        param["reason"] = reason
        DLog("param = \(param)")
        
//        API.reportAlbum(param, aViewController: self) { (result: JSON) in
//         if ( result != nil )
//         {
//         BaseVC.sharedInstance.DLog("#### reportAlbum API Response: \(result)")
//         
//         }
//         }
        
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
