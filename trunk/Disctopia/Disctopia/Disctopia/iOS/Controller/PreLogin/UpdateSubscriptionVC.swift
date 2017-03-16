//
//  UpdateSubscriptionVC.swift
//  Disctopia
//
//  Created by Mitesh on 19/11/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class UpdateSubscriptionVC: BaseVC
{

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
        self.navigationController?.navigationBarHidden = true
        super.viewDidLoad()
        
        deactivateAccountBtn.layer.borderColor = UIColor.redColor().CGColor
        deactivateAccountBtn.layer.borderWidth = 1
        
        txtBasicArtist.layer.cornerRadius = 5
        txtBasicArtist.layer.borderWidth = 0.5
        txtBasicArtist.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 200.0)
        
        self.lblAttribute.attributedText = self.SetAttributePrivacyLabel("Please be aware that if you deactivate your\n", second: "account you will ", third: "not ", forth: "be able to recover it.")
      
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        getInAppList()
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
           
            if self.planJSONArray.count > self.txtBasicArtist.selectedRow && self.txtBasicArtist.selectedRow > -1
            {
                let planId = self.planJSONArray[self.txtBasicArtist.selectedRow]["id"].stringValue
                appDelegate.planId = planId
                let productId = self.planJSONArray[self.txtBasicArtist.selectedRow]["productId"].stringValue
                if productId.characters.count > 0
                {
                    appDelegate.isFromUpdateSubsription = true
                    purchase(productId)
                }
                else
                {
                    updateSubscriptionAPI()
                }
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - API
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
                    self.txtBasicArtist?.setDropDownTypePicker(0)
                    self.txtBasicArtist?.itemList = self.manageSubcriptionArray as [AnyObject]
                    self.DLog("self.manageSubscription Array: \(self.manageSubcriptionArray)")
                }
                self.getArtistProfile()
            }
        }
    }
    func getArtistProfile()
    {
        var param = Dictionary<String, String>()
        param[kAPISessionToken] = appDelegate.appToken
        param[kAPIUserId] = appDelegate.userId
        param[kAPIDeviceToken] = appDelegate.deviceToken
        API.getGetArtistProfile(param, aViewController: self)
        {
            (result: JSON) in
            
            if result != nil
            {
                if result.arrayValue.count > 0
                {
                   self.txtBasicArtist.text = result.arrayValue[0]["stripeplan"].stringValue
                }
            }
        }
        
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

}
