//
//  ProfileSettingVC.swift
//  Disctopia
//
//  Created by Dhaval Vaghasiya on 25/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

let amazonUrl = ""//"https://s3-us-west-2.amazonaws.com/devdisctopia-audio/"

class ProfileSettingVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate,UITextFieldDelegate
{
    // MARK: - Outlets

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewBGScroll: UIView!
    
    @IBOutlet weak var viewSaveChange: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtPrimary: IQDropDownTextField!
    
    @IBOutlet weak var txtSecondary: IQDropDownTextField!
    
    @IBOutlet weak var btnPrimary: UIButton!
    
    @IBOutlet weak var btnSecondary: UIButton!
    
    @IBOutlet weak var txtArtistName: UITextField!
    
    @IBOutlet weak var txtTextView: UITextView!
    
    var customPicker = customPickerView()
    
    var imagePicker = UIImagePickerController()
    
    var arrPrimary: NSMutableArray = NSMutableArray()
    
    var arrSecondary: NSMutableArray = NSMutableArray()

    class func instantiateFromStoryboard() -> ProfileSettingVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! ProfileSettingVC
    }
    
    // MARK: - Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        txtArtistName.delegate = self
        
        txtTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtTextView.layer.borderWidth = 0.5
        txtTextView.layer.cornerRadius = 5
        
        txtPrimary.layer.cornerRadius = 5
        txtPrimary.layer.borderWidth = 0.5
        btnPrimary.layer.borderWidth = 0.5
        btnPrimary.layer.cornerRadius = 5
        
        txtSecondary.layer.cornerRadius = 5
        txtSecondary.layer.borderWidth = 0.5
        btnSecondary.layer.borderWidth = 0.5
        btnSecondary.layer.cornerRadius = 5
        
        btnSecondary.hidden = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setUserProfileData), name: "setProfileData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.hidePicker), name: "ProfileSettingVCresignFirstResponder", object: nil)

         let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // your function here
            self.primaryStyle()
            self.secondaryStyle()
            self.setUserProfileData()
            
        })
    }
    func hidePicker()
    {
        self.txtArtistName.resignFirstResponder()
        self.txtTextView.resignFirstResponder()
        self.txtPrimary.resignFirstResponder()
        self.txtSecondary.resignFirstResponder()
        if ( self.customPicker.superview != nil )
        {
            self.customPicker.removeFromSuperview()
        }
    }
    override func viewWillAppear(animated: Bool)
    {
        self.viewSaveChange.hidden = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        txtTextView.delegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews()
    {
        //self.scrollView.contentOffset = CGPointMake(0, 0)
        //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, viewBGScroll.frame.size.height + 100.0)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        appDelegate.selectedTextField = textField
        return true
    }

    // MARK: - Functions

    func setScrollViewConentSize(scrollView : UIScrollView)
    {
        var contentRect: CGRect = CGRectZero
        for view: UIView in self.scrollView.subviews
        {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, viewBGScroll.frame.size.height + 100.0)
        //self.scrollView.contentOffset = CGPointMake(0, 0)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            if (appDelegate.window?.viewWithTag(666) as? PlayerBaseVC) != nil
            {
                appDelegate.window?.viewWithTag(666)!.hidden = true
            }
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK")
            alertWarning.show()
        }
    }
    
    func openGallary()
    {
        if (appDelegate.window?.viewWithTag(666) as? PlayerBaseVC) != nil
        {
            appDelegate.window?.viewWithTag(666)!.hidden = true
        }
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!)
    {
        
        if (appDelegate.window?.viewWithTag(666) as? PlayerBaseVC) != nil
        {
            appDelegate.window?.viewWithTag(666)!.hidden = false
        }
        
        let selectedImage : UIImage = image
        imgProfile.contentMode = .ScaleAspectFit
        imgProfile.image = selectedImage


       
        
        
//        let URL = NSURL(string:"")!
//        let placeholderImage = selectedImage
//        
//        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
//            size: imgProfile.frame.size,
//            radius: 0//imgProfile.frame.size.width/2
//        )
//        
//        imgProfile.af_setImageWithURL(
//            URL,
//            placeholderImage: placeholderImage,
//            filter: filter,
//            imageTransition: .CrossDissolve(0.2),
//            completion: { response in
//                //self.DLog(response.result.value!) //# UIImage
//                //self.DLog(response.result.error!) //# NSError
//            }
//        )
//        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if txtTextView.text.isEmpty
        {
            txtTextView.text = "My Story"
            txtTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if txtTextView.textColor == UIColor.lightGrayColor()
        {
            txtTextView.text = nil
            txtTextView.textColor = UIColor.lightGrayColor()
        }
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
    
    // MARK: - Actions
    @IBAction func onButtonClick(sender: AnyObject)
    {
        
        if (appDelegate.minimizePlayerView != nil)
        {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                
                }, completion: { (finished) -> Void in
                    if finished {
                        appDelegate.minimizePlayerView!.hidden = true
                    }
            })
        }
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
//        let rect = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - 100, width:  alert.view.frame.width, height:  alert.view.frame.height)
//        alert.view.frame = rect
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
       
        self.presentViewController(alert, animated: true, completion: nil)
        
       //  alert.view.tintColor = UIColor.grayColor()
        alert.view.tintColor = UIColor(colorLiteralRed: 0, green: 0.478431, blue: 1, alpha: 1.0)
        
        //UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
    }
    
    @IBAction func onSaveClick(sender: UIButton)
    {
        if txtArtistName.text?.isEmpty == true
        {
            txtArtistName.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please enter artist name", action: ALERT_OK, sender: self)
        }
        else if txtTextView.text?.isEmpty == true
        {
            txtTextView.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please enter story", action: ALERT_OK, sender: self)
        }
        else if txtPrimary.text?.isEmpty == true
        {
            txtPrimary.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "please select primary", action: ALERT_OK, sender: self)
        }
        else if txtSecondary.text?.isEmpty == true
        {
            txtSecondary.becomeFirstResponder()
            self.DAlert(ALERT_TITLE, message: "Please select secondary", action: ALERT_OK, sender: self)
        }
        else
        {
            updateArtistProfile()
            
            self.viewSaveChange.hidden = false
            NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ProfileSettingVC.onCloseSaveChangeView(_:)), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func onCloseSaveChangeView(sender: UIButton)
    {
        self.viewSaveChange.hidden = true
    }
  
    @IBAction func onBtnClickPrimary(sender: AnyObject)
    {
        /*
        self.customPicker.customArray =  self.arrPrimary

        //self.customPicker.customArray = [["id":"1","name":"   Primary 1"],["id":"2","name":"   Primary 2"],["id":"3","name":"   Primary 3"],["id":"4","name":"   Primary 4"],["id":"5","name":"   Primary 5"]]
        
        self.customPicker.customekey = "name"
        self.customPicker.center = CGPointMake(scrollView.center.x, (self.txtPrimary.superview?.superview?.center.y)!)
        self.customPicker.onDateSelected =
        {
            (country: [String:String]) in
            let  country = "\(country["name"]!)"
            self.txtPrimary.text = country
            BaseVC.sharedInstance.DLog("expMonth = \(country)")
            self.customPicker.removeFromSuperview()
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        
        self.customPicker.tag = 100

        self.customPicker.reloadAllComponents()
        if ( self.customPicker.superview == nil)
        {
            self.scrollView.addSubview(self.customPicker)
        }
 */
        
        if self.arrPrimary.count > 0
        {
            self.txtPrimary.becomeFirstResponder()
        }
    }
   
    @IBAction func onBtnClickSecondary(sender: AnyObject)
    {
        /*
        self.customPicker.customArray =  self.arrSecondary

        //self.customPicker.customArray = [["id":"1","name":"   Secondary 1"],["id":"2","name":"   Secondary 2"],["id":"3","name":"   Secondary 3"],["id":"4","name":"   Secondary 4"],["id":"5","name":"   Secondary 5"]]
        self.customPicker.customekey = "name"
        self.customPicker.center = CGPointMake(scrollView.center.x, (self.txtSecondary.superview?.superview?.center.y)!)
        self.customPicker.onDateSelected =
        {
            (country: [String:String]) in
            let  country = "\(country["name"]!)"
            self.txtSecondary.text = country
            BaseVC.sharedInstance.DLog("expMonth = \(country)")
            self.customPicker.removeFromSuperview()
        }
        self.customPicker.backgroundColor = UIColor.lightGrayColor()
        self.customPicker.tag = 200

        self.customPicker.reloadAllComponents()
        if ( self.customPicker.superview == nil)
        {
            self.scrollView.addSubview(self.customPicker)
        }
 */
        if self.arrSecondary.count > 0
        {
            self.txtSecondary.becomeFirstResponder()
        }
    }
    
    
    // MARK: - API
    
    func primaryStyle()
    {
        //let saveResult : JSON =  self.loadJSON(Constants.userDefault.loginInfo)
        
        //var param = Dictionary<String, String>()
        
        API.primaryStyle("", aViewController: self) { (result: JSON) in
            
            if ( result != nil )
            {
                for dictTrackDetails in result.arrayValue
                {
//                    let id = dictTrackDetails["id"].stringValue
//                    
                    let name = dictTrackDetails["name"].stringValue
//
//                    let dict : NSMutableDictionary = NSMutableDictionary()
//                    
//                    dict.setObject(id, forKey: "id")
//                    dict.setObject(name, forKey: "name")
                    
                    self.arrPrimary.addObject(name)
                }
                self.txtPrimary.setDropDownTypePicker(0)
                self.txtPrimary.itemList = self.arrPrimary as [AnyObject]
                
                self.DLog("self.arrPrimaryStyle: \(self.arrPrimary)")
            }
        }
    }
    
    func secondaryStyle()
    {
        //let saveResult : JSON =  self.loadJSON(Constants.userDefault.loginInfo)
        //var param = Dictionary<String, String>()
        
        API.secondaryStyle("", aViewController: self) { (result: JSON) in
            
            if ( result != nil )
            {
                for dictTrackDetails in result.arrayValue
                {
                    //let id = dictTrackDetails["id"].stringValue
                    
                    let name = dictTrackDetails["name"].stringValue
                    
//                    let dict : NSMutableDictionary = NSMutableDictionary()
//                    
//                    dict.setObject(id, forKey: "id")
//                    dict.setObject(name, forKey: "name")
                    
                    self.arrSecondary.addObject(name)
                }
                self.txtSecondary.setDropDownTypePicker(0)
                self.txtSecondary.itemList = self.arrSecondary as [AnyObject]
                
                self.DLog("self.arrSecondaryStyle: \(self.arrSecondary)")
            }
        }
    }
    
    
    func setUserProfileData()
    {
        let profile : JSON =  self.loadJSON(Constants.userDefault.userProfileInfo)
        BaseVC.sharedInstance.DLog("Saved userProfile: \(profile)")
        
        txtPrimary.text = profile[0]["primaryMusicGenre"].stringValue
        txtSecondary.text = profile[0]["secondaryMusicGenre"].stringValue
        txtArtistName.text = profile[0]["artistName"].stringValue
        txtTextView.text = profile[0]["aboutMe"].stringValue
        
//        let string = profile[0]["profileUrl"].stringValue
//        let imageUrl2 = amazonUrl.stringByAppendingString(string)
//        
//        //https://s3-us-west-2.amazonaws.com/devdisctopia-audio/email's artist/email's artist_14735113589367454.jpg
//        // "profileUrl" : "email's artist\email's artist_14734924161956643.jpg",
//        
//        let imageUrl = imageUrl2.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//        let img = imageUrl.stringByReplacingOccurrencesOfString("'", withString: "%27")
//        //let imageUrl = amazonUrl.stringByAppendingString(string)
        
        let string = profile[0]["profileUrl"].stringValue
        let imageUrl2 = amazonUrl.stringByAppendingString(string)
        
        //https://s3-us-west-2.amazonaws.com/devdisctopia-audio/email's artist/email's artist_14735113589367454.jpg
        // "profileUrl" : "email's artist\email's artist_14734924161956643.jpg",
        
        let imageUrl = imageUrl2.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let img2 = imageUrl.stringByReplacingOccurrencesOfString("\\", withString: "%5C")
        let img = img2.stringByReplacingOccurrencesOfString("'", withString: "%27")
        
        if img.characters.count > 0
        {
            self.getAlbumImage(img,imageView: self.imgProfile)
        }
        else
        {
            self.imgProfile.image = UIImage(named: "user_icon")
        }
        
        if txtTextView.text.isEmpty
        {
            txtTextView.text = "My Story"
            txtTextView.textColor = UIColor.lightGrayColor()
        }
    }
    func UpdateSuccessProfile(notification:NSNotification)
    {
        let dic = notification.userInfo
        
        if(dic!["isSuccess"] as! Bool == true)
        {
            self.getUserProfile()
        }
    }
    
    // Update Artist Profile
    func updateArtistProfile()
    {
        
        let saveResult: JSON = self.loadJSON(Constants.userDefault.loginInfo)
        if (saveResult != nil) {
            
            NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(ProfileSettingVC.UpdateSuccessProfile),name: "UpdateSuccessProfile",object: nil)
            
            var param = Dictionary<String,String>()
            param[kAPISessionToken] = saveResult[kAPIToken].stringValue
        
            param["primaryMusicGenre"] = txtPrimary.text    //self.txtEmail.text
            param["secondaryMusicGenre"] = txtSecondary.text    //self.txtEmail.text
            param["artistName"] = txtArtistName.text
            param["aboutMe"] = txtTextView.text
            
            //let image = UIImage(named: "177143.jpg")
            //let imageData = UIImagePNGRepresentation(imgProfile.image!)
            //param["ProfileUrl"] = imageData
            
            param["artistname"] = "testr3"
            API.updateArtistProfile(param,profileImage:self.imgProfile.image, aViewController:self)
            {
                (result: JSON) in
                if ( result != nil )
                {
                    BaseVC.sharedInstance.DLog("updateArtistProfile API Response: \(result)")
                    //appDelegate.getUserProfileData()
                  //  self.getUserProfile()
                   // self.DAlert(ALERT_TITLE, message: "Profile Update Successfully", action: ALERT_OK, sender: self)

                    //self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                }
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
