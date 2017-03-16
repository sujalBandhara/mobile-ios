//
//  BaseVC.swift
//  Aamer
//
//  Created by Sujal Bandhara on 03/12/2015.
//  Copyright (c) 2015 byPeople Technologies Pvt Limited. All rights reserved.
//

import UIKit
import CoreLocation
import IQKeyboardManager
import AlamofireImage
import Alamofire
import SwiftyJSON
import AudioToolbox
import CRToast
import AVFoundation
import MediaPlayer
import StoreKit
import CoreTelephony
//import SwiftyStoreKit

let isTesting = false


let ANIMATION_SPEED = 0.3

class BaseVC: UIViewController
{
    var countryListArray : NSMutableArray = NSMutableArray(capacity: 0)
    var dynamicFontNeeded = true
    @IBOutlet var btnShoppingCartBadge: UIButton!
    static let sharedInstance = BaseVC()// instance  of baseVC class
    
    //var countryArray = [["id":"1","name":"United States"],["id":"2","name":"Australia"],["id":"3","name":"Canada"],["id":"4","name":"Denmark"],["id":"5","name":"Finland"],["id":"6","name":"Ireland"],["id":"7","name":"Norway"],["id":"8","name":"Sweden"],["id":"8","name":"United Kingdom"]]//static
    
    var myMatrixDic : NSMutableDictionary  = [
        "1":0.99,"2":1.99,"3":2.99,"4":3.99,"5":4.99,"6":5.99,"7":6.99,"8":7.99,"9":8.99,"10":9.99,"11":10.99,"12":11.99,"13":12.99,"14":13.99,"15":14.99,"16":15.99,"17":16.99,"18":17.99,"19":18.99,"20":19.99,"21":20.99,"22":21.99,"23":22.99,"24":23.99,"25":24.99,"26":25.99,"27":26.99,"28":27.99,"29":28.99,"30":29.99,"31":30.99,"32":31.99,"33":32.99,"34":33.99,"35":34.99,"36":35.99,        "37":36.99,        "38":37.99,        "39":38.99,        "40":39.99,        "41":40.99,        "42":41.99,        "43":42.99,        "44":43.99,        "45":44.99,        "46":45.99,        "47":46.99,        "48":47.99,        "49":48.99,        "50":49.99,        "51":54.99,        "52":59.99,        "53":64.99,        "54":69.99,        "55":74.99,        "56":79.99,        "57":84.99,        "58":89.99,        "59":94.99,        "60":99.99,        "61":109.99,        "62":119.99,        "63":124.99,        "64":129.99,        "65":139.99,        "66":149.99,        "67":159.99,        "68":169.99,        "69":174.99,        "70":179.99,        "71":189.99,        "72":199.99,        "73":209.99,        "74":219.99,        "75":229.99,        "76":239.99,        "77":249.99,        "78":299.99,        "79":349.99,        "80":399.99,        "81":449.99,        "82":499.99,        "83":599.99,        "84":699.99,        "85":799.99,        "86":899.99,        "87":999.99 ]
    
    
    var managePriceMatrxArray :  NSMutableArray = NSMutableArray()
    
    
    let defaultsAppLunchDate = NSUserDefaults.standardUserDefaults()
    private var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    var notificationsList : Array<JSON> = []
    var txtSearchStr : String = ""
    
    /*
     *    In Location method, after start/stop location we need to push to viewcontroller
     */
    var strPushToViewController : String = String()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    //MARK: - View Life Cycle -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //self.view.backgroundColor = AppBackground
        
        if ((appDelegate.navigationController?.respondsToSelector(Selector("interactivePopGestureRecognizer"))) != nil)
        {
            appDelegate.navigationController?.interactivePopGestureRecognizer!.enabled = false
        }
        
        //For IQKeyboardManager Next Button click event enable
        //returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
        //returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.Done
        //returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarManageBehaviour.ByPosition
        // Do any additional setup after loading the view.
        
        DLog("You are in \(self.dynamicType)")
        if (self.dynamicFontNeeded)
        {
            self.changeAllFontinView(self.view)
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateShoppingCart), name: "updateCart", object: nil)//
        self.updateShoppingCart()
        //appDelegate.getShoppingCartItemCount()
        //self.isMiniPlayerVisible()
        UIApplication.sharedApplication().resignFirstResponder()
        self.loadMusicPlayer()
        self.isMiniPlayerVisible()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        UIApplication.sharedApplication().resignFirstResponder()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateCart", object: nil)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    func updateShoppingCart()
    {
        if self.btnShoppingCartBadge != nil
        {
            if (appDelegate.shoppingCartItemCount-1) > 0
            {
                //self.btnShoppingCartBadge.hidden = false
                //self.btnShoppingCartBadge.setTitle("\(appDelegate.shoppingCartItemCount - 1)", forState: .Normal)
            }
            else
            {
                self.btnShoppingCartBadge.hidden = true
            }
             self.btnShoppingCartBadge.hidden = true
        }
    }
    
    func loadMusicPlayer()
    {
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
//    func getTier(newPrice2 : Float) -> String
//    {
//        for dicSubcription in appDelegate.managePriceMatrxJSONArray
//        {
//            let productId = dicSubcription["productId"].stringValue
//            let value = dicSubcription["price"].floatValue
//            
//            if newPrice2 == value
//            {
//                return productId
//            }
//        }
//        
//        //        var cnt = 1
//        //        for (_, _) in myMatrixDic
//        //        {
//        //
//        //            if let value = myMatrixDic["\(cnt)"] as? Float
//        //            {
//        //                if newPrice2 == value
//        //                {
//        //                    return cnt
//        //                }
//        //            }
//        //            cnt = cnt + 1
//        //        }
//        return "0"
//    }

    
    func checkForMinimizePlayerVisibility()
    {
        
        
        if (appDelegate.window?.viewWithTag(666) as? PlayerBaseVC) != nil
        {
            appDelegate.isMinimisePlayerVisible = true
        }
        else
        {
            appDelegate.isMinimisePlayerVisible = false
        }
    }
    // use for Minimize player show and remove.
    func isMiniPlayerVisible()
    {
        self.checkForMinimizePlayerVisibility()
        if (appDelegate.minimizePlayerView != nil)
        {
            if (appDelegate.isMinimisePlayerVisible)
            {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            appDelegate.minimizePlayerView!.hidden = false
                            
                            appDelegate.minimizePlayerView!.frame = CGRect(x: 0, y: ScreenSize.SCREEN_HEIGHT - MINIMIZE_PLAYER_HEIGHT, width: ScreenSize.SCREEN_WIDTH, height: MINIMIZE_PLAYER_HEIGHT)
                            appDelegate.minimizePlayerView!.translatesAutoresizingMaskIntoConstraints = true
                            appDelegate.minimizePlayerView?.layoutIfNeeded()
                            appDelegate.minimizePlayerView?.updateConstraintsIfNeeded()
                        }
                })
            }
            else
            {
                if (appDelegate.window?.viewWithTag(666) as? PlayerBaseVC) != nil
                {
                    UIView.animateWithDuration(1.0, animations: { () -> Void in
                        
                        }, completion: { (finished) -> Void in
                            if finished {
                                
                                appDelegate.minimizePlayerView!.hidden = true
                            }
                    })
                    
                    //minimizeView.removeFromSuperview()
                }
            }
        }
    }
    //Remote Control控制音乐的播放 Control the playback of music

    override func remoteControlReceivedWithEvent(event: UIEvent?)
    {
        BaseVC.sharedInstance.DLog("remoteControlReceivedWithEvent player.play()")
        if appDelegate.playerView != nil
        {
            switch event?.subtype {
            case UIEventSubtype.RemoteControlPlay?: // 音乐播放
                appDelegate.player.play()
                appDelegate.playerView.btnPlay.selected = true
                break
            case UIEventSubtype.RemoteControlPause?: // 音乐暂停
               
                appDelegate.playerView.btnPlay.selected = false
                appDelegate.player.pause()
                
                break
            case UIEventSubtype.RemoteControlPreviousTrack?: //上一首
                appDelegate.playerView.onPreviousTrackClick(nil)
                break;
            case UIEventSubtype.RemoteControlNextTrack?: //下一首
                appDelegate.playerView.onNextTrackClick(nil)
                // appDelegate.player.advanceToNextItem()
                // if (appDelegate.player.currentItem != nil)
                // {
                //    insertCurrentSongToLast()
                // }
                
                break;
            case UIEventSubtype.RemoteControlTogglePlayPause?: //use for hair phone
                
                if appDelegate.playerView != nil
                {
                    if appDelegate.playerView.btnPlay.selected
                    {
                        
                        appDelegate.player.pause()
                        
                    }
                    else
                    {
                        appDelegate.player.play()
                    }
                    
                    appDelegate.playerView.btnPlay.selected = !appDelegate.playerView.btnPlay.selected


                }
                break
            default:
                break
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("basePlayer", object: appDelegate.trackObjArray)
            
            let currentItemAsset = appDelegate.player.currentItem?.asset as? AVURLAsset
            if (currentItemAsset != nil)
            {
                appDelegate.playerView.configNowPlayingCenter(currentItemAsset!)
            }
        }
    }
    
    func priceWithTier(originalPrice : Float)
    {
        var priceMatrixDic = ["1":0.99,"2":1.99]
    }
    
    func logAllFonts()
    {
        /*
         Font Family Name = [Roboto]
         Font Names = [["Roboto-Bold", "Roboto-Regular", "Roboto-Medium"]]
         */
        for familyName in UIFont.familyNames()
        {
            BaseVC.sharedInstance.DLog("------------------------------")
            BaseVC.sharedInstance.DLog("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName)
            BaseVC.sharedInstance.DLog("Font Names = [\(names)]")
        }
    }
    
    func changeAllFontinView(inputView : UIView)
    {
        //return
        for subView in inputView.subviews
        {
            //self.DLog("dynamicType = \(subview.dynamicType)")
            if let subLable = subView as? UILabel
            {
                subLable.font = self.changeFont(subLable.font)
            }
            else if let subTextField = subView as? UITextField
            {
                subTextField.font = self.changeFont(subTextField.font!)
            }
            else if let subTextView = subView as? UITextView
            {
                subTextView.font = self.changeFont(subTextView.font!)
            }
            else if let subbutton = subView as? UIButton
            {
                if subbutton.tag < 1000000
                {
                    subbutton.titleLabel!.font = self.changeFont(subbutton.titleLabel!.font)
                }
            }
            else if let subsubView = subView as? UIView
            {
                self.changeAllFontinView(subsubView)
            }
            
            //          if subview.dynamicType = UILable.dynamicType
            //          {
            //
            //          }
        }
    }
    
    func changeFont(inputFont : UIFont) -> UIFont
    {
        //self.DLog("inputFont = \(inputFont)")
        let preferredDescriptor = appDelegate.appDynamicFont
        let outPutfont = UIFont(name: inputFont.fontName, size: preferredDescriptor.pointSize)
        //self.DLog("outPutfont = \(outPutfont)")
        return outPutfont!
    }
    
    func logToFile(msg: String)
    {
        
        let logFile = "DisctopiaLog.txt"
        let filePath = "\(self.getDocumentsDirectory())/\(logFile)"
        
        if !NSFileManager.defaultManager().fileExistsAtPath(filePath)
        {
            //Create the file
            do
            {
                try "Hello".writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
            }
            catch let error {
                DLog("error: to create file  \n \(error)")
            }
        }
        
        do {
            var contents = try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
            contents = "\(contents)\n\(msg)"
            try contents.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
            
        }
        catch let error {
            DLog("error: \n \(error)")
        }
    }
        //MARK: - explore category -
    func loadCategory()
    {
        if isExistUserDefaultKey("exploreCategoryList") == true
        {
            let saveExploreCategoryResult : JSON =  BaseVC.sharedInstance.loadJSON("exploreCategoryList")
            //self.DLog("saveExploreCategoryResult = \(saveExploreCategoryResult)")
            if saveExploreCategoryResult != nil
            {
                self.DLog("saveExploreCategoryResult.count = \(saveExploreCategoryResult.count)")
                if saveExploreCategoryResult.count > 0
                {
                    self.DLog("artistCategoryName = \(saveExploreCategoryResult[0]["artistCategoryName"].stringValue)")
                    self.DLog("artistCategoryId = \(saveExploreCategoryResult[0]["artistCategoryId"].stringValue)")
                }
            }
        }
        else
        {
            // API : GetArtistCategoryList
            //let param = Dictionary<String, String>()
            API.GetArtistCategoryList(nil, aViewController: self) { (result: JSON) in
                
                if ( result != nil )
                {
                    self.DLog("#### GetArtistCategoryList API Response: \(result)")
                    self.saveJSON(result,key:"exploreCategoryList")
                    BaseVC.sharedInstance.loadCategory()
                }
            }
        }
    }
    
    func getCategoryId(categoryName : String) -> String
    {
        if isExistUserDefaultKey("exploreCategoryList") == true
        {
            let saveExploreCategoryResult : JSON =  BaseVC.sharedInstance.loadJSON("exploreCategoryList")
            //self.DLog("saveExploreCategoryResult = \(saveExploreCategoryResult)")
            if saveExploreCategoryResult != nil
            {
                if saveExploreCategoryResult.count > 0
                {
                    for i in 0...saveExploreCategoryResult.count
                    {
                        if  saveExploreCategoryResult[i]["name"].stringValue == categoryName
                        {
                            DLog("saveExploreCategoryResult[i] = \(saveExploreCategoryResult[i]["artistCategoryName"].stringValue)")
                            DLog("categoryName = \(categoryName)")
                            
                            if saveExploreCategoryResult[i]["id"] != nil
                            {
                                DLog("category id = \(saveExploreCategoryResult[i]["id"].stringValue)")
                                return saveExploreCategoryResult[i]["id"].stringValue
                            }
                            
                            if saveExploreCategoryResult[i]["artistCategoryId"] != nil
                            {
                                DLog("artistCategoryId id = \(saveExploreCategoryResult[i]["artistCategoryId"].stringValue)")
                                return saveExploreCategoryResult[i]["artistCategoryId"].stringValue
                            }
                            
                            //return saveExploreCategoryResult[i]["artistCategoryId"].stringValue
                            return "0"
                        }
                    }
                }
            }
        }
        return "0"
    }
    
    // API : GetArtistAlbumList For Explore
    func getArtistAlbumListAPIForExplore()
    {
        if (appDelegate.exploreArray == nil)
        {
            var param = Dictionary<String, String>()
            
            param["artistcategoryId"] = "0" //self.getCategoryId(categoryName)
            DLog("param = \(param)")
            
            API.getArtistAlbumList(param, aViewController: self) { (result: JSON) in
                
                if ( result != nil )
                {
                    appDelegate.exploreArray = result.arrayObject
                    self.DLog("appDelegate.exploreArray = \(appDelegate.exploreArray!.count)")
                    self.DLog("#### GetArtistAlbumList API Response: \(result)")
                }
            }
        }
        else
        {
            //self.DLog(self.filterExpolreArrayWithCategory("1").count)
        }
    }
    
    /*
     func filterExpolreArrayWithCategory(categoryName : String) -> [JSON]
     {
     
     var param = Dictionary<String, String>()
     param["exploreid"] = self.getCategoryId(categoryName)
     //DLog("exploreid \(self.categoryName) param = \(param)")
     appDelegate.isFromPlaylist = false
     API.getExplorer(param, aViewController: self) { (result: JSON) in
     
     if ( result != nil )
     {
     //appDelegate.exploreArray = result.arrayObject
     self.DLog("appDelegate.exploreArray = \(categoryName) count\(appDelegate.exploreArray!.count)")
     self.DLog("#### GetArtistAlbumList API Response: \(result)")
     //self.layout.itemCount = Int32(self.exploreArray.count)
     //self.reloadCategory()
     return result.arrayValue
     }
     }
     
     /*
     if appDelegate.exploreArray != nil
     {
     let categoryId = self.getCategoryId(categoryName)
     let searchCategoryPredicate = NSPredicate(format: "albumChartStatusId = %@ OR (albumChartStatusId = 0)",  categoryId)
     //let searchCategoryPredicate = NSPredicate(format: "(albumChartStatusId = %@)",categoryId)
     let exploreCategoryArray =  JSON(NSArray(array: appDelegate.exploreArray!).filteredArrayUsingPredicate(searchCategoryPredicate))
     return exploreCategoryArray.arrayValue
     }
     else
     {
     return []
     }
     */
     }*/
    
    // Back button Methord - Will pop current View Controller
    @IBAction func popToSelf(sender: AnyObject)
    {
        if (appDelegate.navigationController != nil)
        {
            appDelegate.navigationController!.popViewControllerAnimated(true)
        }
        //self.popViewController(AnimationType.ScrollView)
        //appDelegate.lastSelectedMenuItems = 3
        //self.popViewController(AnimationType.ScrollView)
        // self.switchToViewController(self.getLoadedMenuViewControllerName(LeftMenu(rawValue: appDelegate.lastSelectedMenuItems)!))
    }
    
    //MARK: - Loader Hide/Show  -
    func showLoader()
    {
       // print("################ Show Loader \(superclass.dynamicType)")
       if (!isSVGNeeded)
        {
            //BaseVC.sharedInstance.DLog("Method called")
            let imgListArray :NSMutableArray = []
            
            //use for loop
            for position in 0...255
            {
                var strImageName : String = "svg_00"
            if position < 10
            {
                strImageName = "\(strImageName)00\(position).png"
            }
            else if position < 100
            {
                strImageName = "\(strImageName)0\(position).png"
            }
            else
            {
                strImageName = "\(strImageName)\(position).png"
            }
                //let strImageName : String = "\(position).png"
                let image  = UIImage(named:strImageName)
                imgListArray .addObject(image!)
            }
            let loaderHight = UIScreen.mainScreen().bounds.width / 2.0
            let imageView = UIImageView(frame: CGRectMake(0, 0, loaderHight, loaderHight));
            
            imageView.animationImages = NSArray(array: imgListArray) as? [UIImage]
            imageView.animationDuration = 3.0
            imageView.startAnimating()
            
            if (!JTProgressHUD.isVisible())
            {
                JTProgressHUD.showWithView(imageView)
            }
        }
        else
       {
        let loaderwidth = UIScreen.mainScreen().bounds.width / 2.0
        let loaderHight = UIScreen.mainScreen().bounds.height / 2.0
        //            let jeremyGif = UIImage.gifImageWithName("loderSVGtoGIF")
        //            let imageView = UIImageView(image: jeremyGif)
        //            imageView.frame = CGRectMake(0, 0, loaderHight, loaderHight)
        
        
        //            let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("loderSVGtoGIF", withExtension: "gif")!)
        //            let advTimeGif = UIImage.gifImageWithData(imageData!)
        //            let imageView2 = UIImageView(image: advTimeGif)
        //            imageView2.frame = CGRectMake(0, 0, loaderHight, loaderHight)
        //
        //            if (!JTProgressHUD.isVisible())
        //            {
        //                JTProgressHUD.showWithView(imageView2)
        //            }
        
        
            appDelegate.animatedLoaderWebView.frame = CGRectMake(loaderwidth - 60, loaderHight - 60, 60, 60)
            // appDelegate.animatedLoaderWebView.frame = CGRectMake(0, 0, loaderHight+20, loaderHight) //self.view.frame
            appDelegate.animatedLoaderWebView.opaque = false
            appDelegate.animatedLoaderWebView.backgroundColor = UIColor.clearColor()
            appDelegate.animatedLoaderWebView.center = self.view.center
            if (!JTProgressHUD.isVisible())
            {
                //appDelegate.animatedLoaderWebView.scrollView.scrollEnabled = false
                //appDelegate.animatedLoaderWebView.scalesPageToFit = false
                JTProgressHUD.showWithView(appDelegate.animatedLoaderWebView)
                //appDelegate.animatedLoaderWebView.scrollView.scrollEnabled = false
                //appDelegate.animatedLoaderWebView.scalesPageToFit = false
                //appDelegate.animatedLoaderWebView.frame = self.view.frame
            }
            appDelegate.animatedLoaderWebView.frame = CGRectMake(loaderwidth - 60, loaderHight - 60, 60, 60)
            appDelegate.animatedLoaderWebView.opaque = false
            appDelegate.animatedLoaderWebView.backgroundColor = UIColor.clearColor()
            appDelegate.animatedLoaderWebView.center = self.view.center
       
        }
 
    }
    
    func hideLoader()
    {
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.0 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // your function here
            JTProgressHUD.hide()
        })
    }
    
    //MARK: - Remove Null from Responce Dictionary
    
    //TO remove NULL from data
    func removeNullFromData(data: AnyObject) -> NSDictionary
    {
        var dict:NSMutableDictionary = NSMutableDictionary()
        
        if (data.isKindOfClass(NSArray))
        {
            dict["responceData"] = data;
            dict = self.removeNullFromDictionary(NSDictionary(dictionary: dict)).mutableCopy() as! NSMutableDictionary
        }
        else if (data.isKindOfClass(NSDictionary))
        {
            dict = self.removeNullFromDictionary(NSDictionary(dictionary: data as! NSDictionary)).mutableCopy() as! NSMutableDictionary
        }
        return NSDictionary(dictionary: dict)
    }
    
    func removeNullFromDictionary(dict: NSDictionary) -> NSDictionary
    {
        let dictUpdated = dict.mutableCopy() as! NSMutableDictionary
        
        for (key,value) in dictUpdated
        {
            if(value.isKindOfClass(NSNull))
            {
                dictUpdated.setValue("", forKey: key as! String)
            }
            else if(value.isKindOfClass(NSDictionary))
            {
                dictUpdated.setObject(self.removeNullFromDictionary(value as! NSDictionary), forKey: key as! String)
            }
            else if(value.isKindOfClass(NSArray))
            {
                dictUpdated.setObject(self.removeNullFromArray(value as! NSArray), forKey: key as! String)
            }
        }
        
        return NSDictionary(dictionary: dictUpdated)
    }
    
    func removeNullFromArray(arr: NSArray) -> NSArray
    {
        let arrayUpdate = arr.mutableCopy() as! NSMutableArray
        
        for index in 0...arrayUpdate.count-1
        {
            if (arrayUpdate[index].isKindOfClass(NSNull))
            {
                arrayUpdate[index] = "";
            }
            else if(arrayUpdate[index].isKindOfClass(NSDictionary))
            {
                arrayUpdate[index] = self.removeNullFromDictionary(arrayUpdate[index] as! NSDictionary)
            }
            else if(arrayUpdate[index].isKindOfClass(NSArray))
            {
                arrayUpdate[index] = self.removeNullFromArray(arrayUpdate[index] as! NSArray)
            }
        }
        return NSArray(array: arrayUpdate);
    }
    
    var CurrentTimestamp: String {
        
        //BaseVC.sharedInstance.DLog("\(NSDate().timeIntervalSince1970 * 1000)")
        
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    func getUUID() -> String
    {
        let uuid = NSUUID().UUIDString
        return uuid
    }
    
    
    //for printing API Url with parameters
    func printAPIURL(apiName: String, param: Dictionary<String,String>)
    {
        
        var urlStr = "\(Constants.Network.baseUrl)\(apiName)&"
        
        var paramList = ""
        for (key,value) in param
        {
            paramList = "\(paramList)\(key)=\(value)&"
        }
        
        if !paramList.isEmpty
        {
            //Remove last & from URL
            paramList.deleteCharactersInRange(NSMakeRange(paramList.length-1, 1))
        }
        
        urlStr = "\(urlStr)\(paramList)"
        
        DLog("\(urlStr)")
    }
    //MARK: - Current date and time function -
    
    
    /*
     customFormatedDate function return the date as per parameter and return date in string
     param : format taht accept format of date like "EEEE, MM-dd-yyyy"
     */
    func customFormatedDate(format: String) -> String {
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = format
        
        return dateFormatter.stringFromDate(date)
    }
    
    //MARK: - Round View -
    //for rounding view
    func roundView(View : UIView)
    {
        View.layer.cornerRadius = View.frame.size.width / 2
        View.clipsToBounds = true
    }
    
    //MARK: - Round ImageView -
    //for rounding image view
    func roundImage(imageView : UIImageView)
    {
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    //MARK: - make call-
    func callNumber(phoneNumber:String)
    {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)")
        {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL))
            {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    //MARK: - Async ImageView -
    // for
    func getUserImage(url:String , imageView:UIImageView)
    {
        let imageUrl = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        if let URL = NSURL(string:imageUrl)
        {
            //let URL = NSURL(string:url)!
            let placeholderImage = UIImage(named: DEFAULT_IMAGE)!
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: imageView.frame.size,
                radius: imageView.frame.size.width/2
            )
            
            
            imageView.af_setImageWithURL(
                URL,
                placeholderImage: placeholderImage,
                filter: filter,
                imageTransition: .CrossDissolve(0.2),
                completion: { response in
                    //self.DLog(response.result.value!) //# UIImage
                    //self.DLog(response.result.error!) //# NSError
                }
            )
        }
    }
    
    func getExploreImage(url:String , imageView:UIImageView)
    {
        let imageUrl = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        if let URL = NSURL(string:imageUrl)
        {
            let placeholderImage = UIImage(named:DEFAULT_IMAGE)!
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: imageView.frame.size,
                radius: 5.0
            )
            
            imageView.af_setImageWithURL(
                URL,
                placeholderImage: placeholderImage,
                filter: filter,
                imageTransition: .CrossDissolve(0.2),
                completion: { response in
                    
                    //                    if let downloadImage = response.result.value
                    //                    {
                    //                        //print("image downloaded: \(downloadImage)")
                    //                        let size = downloadImage.size.height
                    //
                    //                        let h = imageView.frame.size.height * 0.10
                    //                        let w = imageView.frame.size.width * 0.10
                    //
                    //
                    //                        imageView.image = self.cropToBounds(downloadImage, width: Double(w), height: Double(h))
                    //
                    //
                    //                    }
                    
                    //self.DLog(response.result.value!) //# UIImage
                    //self.DLog(response.result.error!) //# NSError
                }
            )}
    }
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage
    {
        
        print("cropToBounds \(width)")
        let contextImage: UIImage = UIImage(CGImage: image.CGImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func getAlbumImage(url:String , imageView:UIImageView)
    {
        let imageUrl = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        if let URL = NSURL(string:imageUrl)
        {
            //let URL:NSURL = NSURL(string:url)!
            let placeholderImage = UIImage(named: DEFAULT_IMAGE)!
            
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: imageView.frame.size,
                radius: 5.0
            )
            
            imageView.af_setImageWithURL(
                URL,
                placeholderImage: placeholderImage,
                filter: filter,
                imageTransition: .CrossDissolve(0.2),
                completion: { response in
                    //self.DLog(response.result.value!) //# UIImage
                    //self.DLog(response.result.error!) //# NSError
                }
            )
        }
    }
    
   
    //MARK: - DLog -
    func DLog(message: AnyObject = "",file: String = #file, line: UInt = #line , function: String = #function)
    {
        //for printing log
        
        /*  #if DEBUG : In comment then display log
         #if DEBUG : Not comment then stop log
         */
        if(isTesting)
        {
            print("fuction:\(function) line:\(line) file:\(file) \n=================================================================================================\n \(message) ")
        }
    }
    
    func Log(message: AnyObject = "",file: String = #file, line: UInt = #line , function: String = #function)
    {
        // for printing log
        
        /*  #if DEBUG : In comment then display log
         #if DEBUG : Not comment then stop log
         */
        if (isTesting)
        {
            self.DLog("\(message) ")
        }
    }
    
    //for display alert
    func DAlert(title: String, message: String, action: String, sender: UIViewController)
    {
        
        let alert:WWAlertVC = WWAlertVC()
       
        alert.displayMessage(message)
        
        
      /*  CRToastManager.dismissAllNotifications(false)
        let options: [NSObject : AnyObject] = [kCRToastTextKey: message, kCRToastTextAlignmentKey: NSTextAlignment.Center.rawValue,
                                               kCRToastNotificationTypeKey:CRToastType.Custom.rawValue,
                                               kCRToastNotificationPreferredHeightKey: 40,
                                               kCRToastBackgroundColorKey: UIColor(red: 254 / 255, green: 56.0 / 255, blue: 36.0 / 255, alpha: 1.0),
                                               kCRToastAnimationInTypeKey: "CRToastAnimationTypeGravity",
                                               kCRToastAnimationOutTypeKey: "CRToastAnimationTypeGravity",
                                               kCRToastAnimationInDirectionKey: "CRToastAnimationDirectionLeft",
                                               kCRToastAnimationOutDirectionKey: "CRToastAnimationDirectionRight"];
        
        CRToastManager.showNotificationWithOptions(options, completionBlock: {() -> Void in
            NSLog("Completed")
        })
        */
        
        
        //        if objc_getClass("UIAlertController") != nil
        //        {
        //            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        //            alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Default, handler:nil))
        //            sender.presentViewController(alert, animated: true, completion: nil)
        //        }
        //        else
        //        {
        //            let alert = UIAlertView(title: title, message: message, delegate: sender, cancelButtonTitle:action)
        //            alert.show()
        //        }
    }
    
    //MARK: - isNetworkReachable -
    
    func isNetworkReachable() -> CBool
    {
        return appDelegate.isNetworkReachable
    }
    
    //MARK: - PUSH POP -
    
    // for pop View Controller
    func popViewController(animationType :Int)
    {
        if(animationType == AnimationType.Default)
        {
            appDelegate.navigationController!.popViewControllerAnimated(true)
        }
        else
        {
            let object  = appDelegate.navigationController!.viewControllers[appDelegate.navigationController!.viewControllers.count-2]
            
            let fromViewController: UIViewController = appDelegate.navigationController!.topViewController!
            let toViewController: UIViewController = object
            
            let containerView: UIView? = fromViewController.view.superview
            let screenBounds: CGRect = UIScreen.mainScreen().bounds
            
            let finalToFrame: CGRect = screenBounds
            let finalFromFrame: CGRect = CGRectOffset(finalToFrame, screenBounds.size.width*2 , 0)
            
            toViewController.view.frame = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
            containerView?.addSubview(toViewController.view)
            
            UIView.animateWithDuration(ANIMATION_SPEED, animations: {
                toViewController.view.frame = CGRectOffset(finalToFrame, 0, 0)
                
                fromViewController.view.frame = finalFromFrame
                }, completion: { finished in
                    appDelegate.navigationController!.popViewControllerAnimated(false)
            })
        }
    }
    
    // for move to root view controller
    func popToRootViewController()
    {
        self.popToRootViewControllerAnimated(true)
    }
    
    //To pop a viewController Without Animation
    func popViewControllerWithoutAnimation()
    {
        self.popToRootViewControllerAnimated(false)
    }
    //To pop a viewController With Animation
    func popToRootViewControllerAnimated(animated: Bool)
    {
        appDelegate.navigationController!.popViewControllerAnimated(animated)
    }
    
    // for redirecting to the login page
    func popForcefullyLoginScreenWhenSessionTimeOutWithClassName(viewController: UIViewController, identifier: String, animated : Bool  ,animationType :Int)//
    {
        if(animationType == AnimationType.Default)
        {
            var stack = appDelegate.navigationController!.viewControllers as Array
            
            var isFoundVC : Bool = false
            
            for i in (0...stack.count-1).reverse()
            {
                let className = NSStringFromClass(stack[i].classForCoder)
                BaseVC.sharedInstance.Log("\(className)")
                
                if (className == ("Aamer.")+identifier)
                {
                    //If navigationController not have login View Controller
                    
                    BaseVC.sharedInstance.DLog("Found Login")
                    appDelegate.navigationController?.popToViewController((appDelegate.navigationController?.viewControllers[i])!, animated: animated)
                    isFoundVC = true
                    break;
                }
            }
            
            if !isFoundVC
            {
                //If navigationController not have login View Controller
                
                BaseVC.sharedInstance.DLog("Not Found Login")
                let storyBoard = appDelegate.AppStoryBoard()
                
                let objLoginVC   = storyBoard.instantiateViewControllerWithIdentifier(identifier)
                
                appDelegate.navigationController?.pushViewController(objLoginVC, animated: false)
                
                let object  = appDelegate.navigationController!.viewControllers[appDelegate.navigationController!.viewControllers.count-2]
                
                let fromViewController: UIViewController =  appDelegate.navigationController!.topViewController!
                let toViewController: UIViewController =  object
                
                let containerView: UIView? = fromViewController.view.superview
                let screenBounds: CGRect = UIScreen.mainScreen().bounds
                
                let finalToFrame: CGRect = screenBounds
                let finalFromFrame: CGRect = CGRectOffset(finalToFrame, screenBounds.size.width*2 , 0)
                
                toViewController.view.frame = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
                containerView?.addSubview(toViewController.view)
                
                UIView.animateWithDuration(ANIMATION_SPEED, animations: {
                    toViewController.view.frame = CGRectOffset(finalToFrame, 0, 0)
                    
                    fromViewController.view.frame = finalFromFrame
                    }, completion: { finished in
                        
                        //Remove all other viewController except Aamer.WelComeStep1aLoginVC and Aamer.LandingPageVC
                        
                        var arrayCount = -1
                        
                        for _ in 0  ..< appDelegate.navigationController!.viewControllers.count
                        {
                            arrayCount += 1
                        }
                        
                        for index in (arrayCount...0).reverse()
                        {
                            if appDelegate.navigationController?.viewControllers.count > 0
                            {
                                let className = NSStringFromClass( appDelegate.navigationController!.viewControllers[index].classForCoder)
                                
                                if (className != ("Aamer.WelComeStep1aLoginVC") && className != ("Aamer.LandingPageVC"))
                                {
                                    appDelegate.navigationController?.viewControllers .removeAtIndex(index)
                                }
                                
                            }
                            
                        }
                })
                
            }
            
        }
    }
    
    // for redirecting to the particular view controller
    func popToViewControllerWithClass(Class: AnyObject ,animated : Bool)
    {
        var index : Int = 0
        
        let array = appDelegate.navigationController!.viewControllers as NSArray
        
        for i in 0   ..< array.count
        {
            let object: UIViewController = array[i] as! UIViewController
            
            if object == Class as! UIViewController
            {
                index = i
                let object  = appDelegate.navigationController!.viewControllers[index]
                appDelegate.navigationController?.popToViewController(object as UIViewController, animated: animated)
                break;
            }
        }
    }
    
    // for dismiss View Animated
    func dismissViewAnimated(animated: Bool)
    {
        self.dismissViewControllerAnimated(animated, completion: nil)
    }
    
    // for push View Controller WithClass
    func pushViewControllerWithClass(Class : UIViewController, identifier: String , animated : Bool)
    {
        let object: AnyObject! = appDelegate.AppStoryBoard().instantiateViewControllerWithIdentifier(identifier)
        appDelegate.navigationController?.pushViewController(object as! UIViewController, animated: animated)
    }
    
    // for push View Controller
    func pushViewController(vc : UIViewController)
    {
        appDelegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    // for push View Controller WithOut Animation
    func pushViewControllerWithOutAnimation(vc : UIViewController)
    {
        appDelegate.navigationController?.pushViewController(vc, animated: false)
    }
    
    // for present View Controller WithAnimation
    func presentViewControllerWithAnimation(identifier: String , animated : Bool)
    {
        let object: AnyObject! = appDelegate.AppStoryBoard().instantiateViewControllerWithIdentifier(identifier)
        appDelegate.navigationController?.presentViewController(object  as! UIViewController, animated: true, completion: { () -> Void in
        })
    }
    
    //for push To ViewController If Not Exist With Class NameWithObj
    func pushToViewControllerIfNotExistWithClassObj(viewController: UIViewController, animated : Bool)//
    {
        if let navViewControllers = appDelegate.navigationController?.viewControllers
        {
            var newViewControllers : [UIViewController] = navViewControllers
            
            var popViewController : UIViewController?
            for aView in newViewControllers
            {
                if (aView.dynamicType == viewController.dynamicType)
                {
                    popViewController = aView
                    break
                }
            }
            if popViewController != nil
            {
                appDelegate.navigationController?.popToViewController(popViewController!, animated: animated)
            }
            else
            {
                newViewControllers.append(viewController)
                //newViewControllers[newViewControllers.indexOf(self)!] = viewController
                appDelegate.navigationController!.setViewControllers(newViewControllers, animated: animated)
            }
        }
        else
        {
            if appDelegate.navigationController == nil
            {
                appDelegate.navigationController = UINavigationController(rootViewController: viewController)
            }
            else
            {
                appDelegate.navigationController!.setViewControllers([viewController], animated: animated)
                
            }
        }
        //  appDelegate.loadMenuController()
    }
    
    //** for push To ViewController If Not Exist With Class Name
    func pushToViewControllerIfNotExistWithClassName(identifier: String, animated : Bool)//
    {
        
        let object   = appDelegate.AppStoryBoard().instantiateViewControllerWithIdentifier(identifier)
        if (appDelegate.navigationController!.viewControllers.contains(object))
        {
            // move it
            appDelegate.navigationController!.popToViewController(object, animated: animated)
        }
        else
        {
            // push it
            appDelegate.navigationController!.pushViewController(object, animated: animated)
        }
        
        // appDelegate.loadMenuController()
        return
        
    }
    // for switch To ViewController
    func switchToViewController(identifier: String)
    {
        let viewController = appDelegate.AppStoryBoard().instantiateViewControllerWithIdentifier(identifier)
        appDelegate.navigationController?.setViewControllers([viewController], animated: false)
    }
    
    //MARK: - Validation Swift -
    
    // for Is string has some characters
    func validate(value: String?) -> Bool
    {
        if value?.characters.count > 0
        {
            return false
        }
        return (value?.isEmpty)!
    }
    
    //for validating Number
    func validateNumber(value: String?) -> Bool
    {
        
        if value?.characters.count > 0
        {
            let num = Int(value!)
            if num != nil
            {
                //Valid Interger
                return true
            }
            else
            {
                //"Not Valid Integer"
                return false
            }
        }
        return false
    }
    
    //for validating Phone Number
    func validatePhoneNumber(value: String) -> Bool
    {
        
        let DEFAULT_LENGTH: Int = 5
        
        if value.characters.count > DEFAULT_LENGTH
        {
            return true
        }
        else
        {
            return false
        }
    }
    //for validating Password
    func validatePassword(value: String) -> Bool
    {
        
        let DEFAULT_LENGTH: Int = 6
        
        if value.characters.count >= DEFAULT_LENGTH
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    //MARK: - BASE64 To String & String To Base64 -
    func encodeStringToBase64(str : String) -> String
    {
        // UTF 8 str from original
        // NSData! type returned (optional)
        let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Base64 encode UTF 8 string
        // fromRaw(0) is equivalent to objc 'base64EncodedStringWithOptions:0'
        // Notice the unwrapping given the NSData! optional
        // NSString! returned (optional)
        let base64Encoded = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        // BaseVC.sharedInstance.DLog("Encoded:  \(base64Encoded)")
        
        /*
         // Base64 Decode (go back the other way)
         // Notice the unwrapping given the NSString! optional
         // NSData returned
         
         let data = NSData(base64EncodedString: base64Encoded, options: NSDataBase64DecodingOptions(rawValue: 0))
         
         // Convert back to a string
         let base64Decoded = NSString(data: data!, encoding: NSUTF8StringEncoding)
         BaseVC.sharedInstance.DLog("Decoded:  \(base64Decoded)")
         */
        return base64Encoded;
    }
    
    // for Resize Image
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage
    {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    //MARK: - UserDefault Operation -
    // for set User Default Data From Ke yWith Archive
    func setUserDefaultDataFromKeyWithArchive(key : String ,dic : NSMutableDictionary) {
        
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(dic)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: key)
        defaults.synchronize()
    }
    
    // for get User Default Data From Key With Archive
    func getUserDefaultDataFromKeyWithArchive(key : String) -> NSMutableDictionary? {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? NSMutableDictionary
        }
        return nil
    }
    func getUserDefaultDataFromKeyWithArchiveForArray(key : String) -> NSMutableArray? {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? NSMutableArray
        }
        return nil
    }
    func setUserDefaultDataFromKeyWithArchiveForArray(key : String ,array : NSMutableArray) {
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(array)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: key)
        defaults.synchronize()
    }
    
    // for checking user default is exist or not
    func isExistUserDefaultKey(key : String) -> Bool
    {
        if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
        {
            return true;
        }
        return false;
    }
    // for removing user default key
    func removeUserDefaultKey(key : String)
    {
        if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
        {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    // for clearing all user deafult key
    func clearUserDefaultAllKey()
    {
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
    }
    // for getting data from  key
    func getUserDefaultDataFromKey(key : String) -> NSMutableDictionary
    {
        if let dic = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)?.mutableCopy() as? NSMutableDictionary
        {
            return dic
        }
        
        
        let dic: NSMutableDictionary = NSMutableDictionary()
        return dic
    }
    
    // for getting UserDefault Integer data
    func getUserDefaultIntergerFromKey(key : String) -> Int
    {
        var value : Int = 0
        
        if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
        {
            value = NSUserDefaults.standardUserDefaults().valueForKey(key) as! Int
            return value
        }
        return value
    }
    
    //for getting UserDefault String data
    func getUserDefaultStringFromKey(key : String) -> String
    {
        var value : String = String()
        
        if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
        {
            value = NSUserDefaults.standardUserDefaults().valueForKey(key) as! String
            return value
        }
        return value
    }
    
    // for getting UserDefault dictionary data
    func getUserDefaultDictionaryFromKey(key : String) -> NSMutableDictionary
    {
        var dic: NSMutableDictionary = NSMutableDictionary()
        
        if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
        {
            dic = NSUserDefaults.standardUserDefaults().valueForKey(key)!.mutableCopy() as! NSMutableDictionary
            return dic
        }
        return dic
    }
    // for getting UserDefault bool data
    func getUserDefaultBoolFromKey(key : String) -> Bool
    {
        let value : Bool = false
        
        if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil)
        {
            let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
            
            if(dic.isKindOfClass(NSDictionary))
            {
                if (dic.valueForKey(key) != nil)
                {
                    return dic.valueForKey(key) as! Bool
                }
            }
        }
        return value
    }
    
    // for setting UserDefault data into key
    func setUserDefaultDataFromKey(key : String ,dic : NSMutableDictionary)
    {
        if dic.isKindOfClass(NSMutableDictionary)
        {
            NSUserDefaults.standardUserDefaults().setObject(dic, forKey:USER_DEFAULT_LOGIN_USER_DATA)
            NSUserDefaults.standardUserDefaults().synchronize()
            self.DLog("\(self.getUserDefaultDataFromKey(USER_DEFAULT_LOGIN_USER_DATA))")
        }
    }
    // for setting UserDefault  Integer data into key
    func setUserDefaultIntergerFromKey(key : String ,value : Int)
    {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // for setting UserDefault  Integer data into key
    func setUserDefaultBoolFromKey(key : String ,value : Bool)
    {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //for setting UserDefault String data into key
    func setUserDefaultStringFromKey(key : String ,value : String)
    {
        if value.isKindOfClass(NSString)
        {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    //for storing n getting NSDate in User Defaults
    func setUserDefaultDateFromKey(key : String ,value : NSDate)
    {
        if value.isKindOfClass(NSDate)
        {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    func getUserDefaultDateFromKey(key : String) -> NSDate
    {
        var value : NSDate = NSDate()
        
        if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
        {
            value = NSUserDefaults.standardUserDefaults().valueForKey(key) as! NSDate
            return value
        }
        return value
    }
    //for setting UserDefault Dictionary data into key
    func setUserDefaultDictionaryFromKey(key : String ,value : NSDictionary)
    {
        if value.isKindOfClass(NSDictionary)
        {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // for
    func setUserDefaultIntergerObjectFromKey(key : String ,object : Int)
    {
        if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil)
        {
            let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
            
            if(dic.isKindOfClass(NSDictionary))
            {
                if (dic.valueForKey(key) != nil)
                {
                    dic.setObject(object, forKey: key)
                    
                }
                else
                {
                    dic.setObject(object, forKey: key)
                }
            }
            NSUserDefaults.standardUserDefaults().setObject(dic, forKey: USER_DEFAULT_LOGIN_USER_DATA)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.DLog(NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!)
        }
        
    }
    
    // for set User Default String Object From Key
    func setUserDefaultStringObjectFromKey(key : String ,object : String)
    {
        if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil)
        {
            let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
            
            if(dic.isKindOfClass(NSDictionary))
            {
                if (dic.valueForKey(key) != nil)
                {
                    dic.setObject(object, forKey: key)
                    
                }
                else
                {
                    dic.setObject(object, forKey: key)
                }
            }
            NSUserDefaults.standardUserDefaults().setObject(dic, forKey: USER_DEFAULT_LOGIN_USER_DATA)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.DLog(NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!)
        }
    }
    
    // for set User Default BOOL Object From Key
    func setUserDefaultBOOLObjectFromKey(key : String ,object : Bool)
    {
        if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil)
        {
            var dic: NSMutableDictionary = ["":""]
            if let loginUserDict = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) as?NSMutableDictionary
            {
                dic = loginUserDict.mutableCopy() as! NSMutableDictionary
            }
            
            if(dic.isKindOfClass(NSDictionary))
            {
                if (dic.valueForKey(key) != nil)
                {
                    dic.setObject(object, forKey: key)
                    
                }
                else
                {
                    dic.setObject(object, forKey: key)
                }
            }
            NSUserDefaults.standardUserDefaults().setObject(dic, forKey: USER_DEFAULT_LOGIN_USER_DATA)
            NSUserDefaults.standardUserDefaults().synchronize()
            self.DLog(NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!)
        }
    }
    
    //MARK: - Directory path -
    func getDocumentsDirectory() -> NSString
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        self.DLog(documentsDirectory)
        print("documentsDirectory = \(documentsDirectory)")
        return documentsDirectory
    }
    
    func writeImageInDocumentDirectory(imageName:String , choosenImage:UIImage)
    {
        if let data = UIImagePNGRepresentation(choosenImage)
        {
            let filename = self.getDocumentsDirectory().stringByAppendingPathComponent(imageName)
            data.writeToFile(filename, atomically: true)
        }
        
    }
    
    
    
    //MARK: - Image Operation -
    // for
    func imageFromUrl(url : NSURL) -> UIImage?
    {
        if let imageData = NSData(contentsOfURL: url) {
            return UIImage(data: imageData)!
        }
        return nil
    }
    
    //MARK: - Dictinary Operation -
    // for
    func checkDicHaveKey(key: String ,dic : NSDictionary) -> Bool
    {
        if(dic.isKindOfClass(NSDictionary))
        {
            if dic.valueForKey(key) != nil
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    //MARK: - Array Operation -
    // for
    func getArrayFromDictinary(key: String ,dic : NSDictionary) -> NSArray
    {
        var array : NSArray = NSArray()
        if(dic.isKindOfClass(NSDictionary))
        {
            if dic.valueForKey(key) != nil
            {
                if dic[key]?.count > 0
                {
                    if ((dic[key]?.isKindOfClass(NSArray)) != nil)
                    {
                        array = dic[key] as! NSArray
                        return array
                    }
                }
            }
        }
        return array
    }
    
    //MARK: - String Operation -
    // for
    func checkStringContainCharacter(character : String , string : String) -> Bool
    {
        if string.containsString(character)
        {
            return true
        }
        return false
        
    }
    
    //MARK: - Date operation -
    // for
    func getUTCTime() -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        //        dateFormatter.lenient = false
        //        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.stringFromDate(NSDate())
        let temp =  dateFormatter.stringFromDate(NSDate())
        self.DLog(temp)
        return temp
    }
    
    // for
    func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        return components.month
    }
    
    // for
    func NSDatetoLocalTime() -> String
    {
        let date = NSDate();
        let dateFormatter = NSDateFormatter()
        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
        dateFormatter.timeZone = NSTimeZone()
        let localDate = dateFormatter.stringFromDate(date)
        return localDate
    }
    
    // for
    func convertDateFormater(date: String,inputDateFormate: String , outputDateFormate: String) -> String
    {
        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = inputDateFormate
        let date = dateFormatter.dateFromString(date)
        
        //dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = outputDateFormate
        var timeStamp = ""
        if (date != nil)
        {
            timeStamp = dateFormatter.stringFromDate(date!)
        }
        return timeStamp
    }
    
    func convertDateFromOneFormatToOtherFormat(dateToConvert: String, oldDateFormat: String, newDateFormat: String) -> String    {
        
        if dateToConvert.characters.count > 0
        {
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateFormat = oldDateFormat
            
            if let date:NSDate = dateFormatter1.dateFromString(dateToConvert)
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = newDateFormat // superset of OP's format
                var str = dateFormatter.stringFromDate(date)
                str = str.uppercaseString
                return str
            }
            return "***"
        }
        else
        {
            return ""
        }
    }
    
    // for
    func convertStringToFormatedDate(date: String ,dateformatter : String) -> NSDate
    {
        //yyyy-MM-ddTHH:mm:ss.fffffff+zzz
        //2015-11-09T21:30:28.4922328+11:00
        let dateString = date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateformatter// change to your date format
        
        let date = dateFormatter.dateFromString(dateString)
        
        return date!
    }
    
    // for
    func convertStringToFormatedDateString(date: String ,dateformatter : String) -> String
    {
        //yyyy-MM-ddTHH:mm:ss.fffffff+zzz
        //2015-11-09T21:30:28.4922328+11:00
        let dateString = date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateformatter// change to your date format
        
        let date = dateFormatter.dateFromString(dateString)
        
        //        let defaultTimeZoneStr = dateFormatter.stringFromDate(date!);
        // "2014-07-23 11:01:35 -0700" <-- same date, local, but with seconds
        //dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        let utcTimeZoneStr = dateFormatter.stringFromDate(date!);
        
        self.DLog(utcTimeZoneStr)
        
        return utcTimeZoneStr
    }
    
    // for
    func convertDateToUTC(date: String ,dateformatter : String) -> String
    {
        //yyyy-MM-ddTHH:mm:ss.fffffff+zzz
        //2015-11-09T21:30:28.4922328+11:00
        let dateString = date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateformatter// change to your date format
        
        let date = dateFormatter.dateFromString(dateString)
        
        //        let defaultTimeZoneStr = dateFormatter.stringFromDate(date!);
        // "2014-07-23 11:01:35 -0700" <-- same date, local, but with seconds
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        let utcTimeZoneStr = dateFormatter.stringFromDate(date!);
        
        self.DLog(utcTimeZoneStr)
        
        return utcTimeZoneStr
    }
    
    // for
    func dateDiffrenceBetweenTwoDates(startDate: String, endDate: String, dateformatter : String) -> Int
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateformatter
        
        let startDate:NSDate = dateFormatter.dateFromString(startDate)!
        let endDate:NSDate = dateFormatter.dateFromString(endDate)!
        
        let cal = NSCalendar.currentCalendar()
        let unit = NSCalendarUnit.Second
        let components = cal.components(unit, fromDate: startDate, toDate: endDate, options: [])
        
        self.DLog(components.second)
        return components.second
    }
    
    //To Convert string to date
    func convertDateToString(date : NSDate ,dateformat : String) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateformat // superset of OP's format
        let str = dateFormatter.stringFromDate(NSDate())
        return str
    }
    
    // for
    func convertGivenDateToString(date : NSDate ,dateformat : String) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateformat // superset of OP's format
        let str = dateFormatter.stringFromDate(date)
        return str
    }
    
    // for converting Time In Second to Minute
    func convertTimeInSecondToMinute(totalSeconds : Int) -> Int
    {
        let minutes = (totalSeconds / 60) % 60;
        return minutes
    }
    
    // for converting time In Second to second
    func convertTimeInSecondToSecond(totalSeconds : Int) -> Int
    {
        let second = totalSeconds % 60;
        return second
    }
    
    //MARK: - Document Dir Profile Pic -
    
    //for saving profile photo
    func saveProfilePic(image : UIImage) -> Bool
    {
        if image.isKindOfClass(UIImage)
        {
            let imageData: NSData = UIImagePNGRepresentation(image)!
            
            //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
            let result = imageData.writeToFile(getProfilePicPath(), atomically: true)
            
            return result
            
        }
        return false
    }
    
    // for getting profile photo path
    func getProfilePicPath() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let path = paths.stringByAppendingPathComponent("ProfilePic.png")
        
        return path
    }
    
    // for getting contact profile photo path
    func getContactProfilePicPath(contactName : String) -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let dataPath = paths.stringByAppendingPathComponent("ContactProfilePicture")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(dataPath)
        {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                NSLog("\(error.localizedDescription)")
            }
        }
        
        let path = dataPath.stringByAppendingPathComponent("\(contactName)")
        return path
    }
    
    // for saving contact profile photo
    func saveContactProfilePic(image : UIImage , name : String) -> Bool
    {
        if image.isKindOfClass(UIImage)
        {
            let imageData: NSData = UIImagePNGRepresentation(image)!
            
            //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
            let result = imageData.writeToFile(getContactProfilePicPath(name), atomically: true)
            return result
            
        }
        return false
    }
    
    // for checking profile photo is exist or not
    func isProfilePicExist() -> Bool
    {
        let fileManager = NSFileManager.defaultManager()
        
        if (fileManager.fileExistsAtPath(getProfilePicPath()))
        {
            return true
        }
        return false
    }
    
    //for deleting profile photo
    func deleteProfilePic()
    {
        let fileManager = NSFileManager.defaultManager()
        
        let path = getProfilePicPath()
        if (fileManager.fileExistsAtPath(path))
        {
            do {
                try fileManager.removeItemAtPath(path)
            } catch _ {
            }
        }
    }
    
    // for deleting contact Profile photo
    func deleteContactProfilePic()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let dataPath = paths.stringByAppendingPathComponent("ContactProfilePicture")
        
        if NSFileManager.defaultManager().fileExistsAtPath(dataPath)
        {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(dataPath)
            }
            catch _
            {
                
            }
        }
    }
    
    // MARK: - Image TO Base64 <-> Base64 TO Image -
    // convert images into base64 and keep them into string
    
    func convertImageToBase64(image: UIImage) -> String
    {
        let imageData = UIImageJPEGRepresentation(image,1.0)
        //        let imageData = UIImagePNGRepresentation(image)
        
        if imageData != nil
        {
            let base64String = imageData!.base64EncodedStringWithOptions([.Encoding64CharacterLineLength, .EncodingEndLineWithCarriageReturn])
            
            return base64String
            
        }
        return ""
        
    }// end convertImageToBase64
    
    // convert images into base64 and keep them into string
    
    func convertBase64ToImage(base64String: String) -> UIImage {
        
        //        let decodedData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions(rawValue: 0))
        //        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        var decodedimage = UIImage(named: "placeHolder")
        
        if let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0)) {
            decodedimage = UIImage(data: decodedData)
            
        } else {
            self.DLog("Not Base64")
        }
        if decodedimage == nil
        {
            decodedimage = UIImage(named: "placeHolder")
        }
        return decodedimage!
        
    }// end convertBase64ToImage
    
    
    // for clearing data of all login user
    func clearDataHistoryOfLoginUser()
    {
        self.deleteProfilePic()
        
        self.clearUserDefaultAllKey()
        
    }
    
    internal func isNilOrEmpty(string: NSString?) -> Bool
    {
        switch string
        {
        case .Some(let nonNilString):
            return nonNilString.length == 0
        default:
            return true
        }
    }
    
    // MARK: - Logout method
    func logOut()
    {
        appDelegate.distopiaUserType = DistopiaUserType.None
        
        appDelegate.isMinimisePlayerVisible = false
        if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
        {
            minimizeView.removeFromSuperview()
        }
        
        //        if (appDelegate.navigationController == nil)
        //        {
        //            appDelegate.loadFirstViewController("SignInViewController")
        //        }
        //        else if (!(appDelegate.navigationController?.topViewController?.isKindOfClass(SignInViewController))!)
        //        {
        //            appDelegate.loadFirstViewController("SignInViewController")
        //        }
        
        if appDelegate.playerView != nil
        {
            
            if appDelegate.playerTimer != nil
            {
                appDelegate.playerTimer?.invalidate()
                appDelegate.playerTimer = nil
                appDelegate.playerView.btnPlay.selected = false
                appDelegate.player.pause()
                appDelegate.playerView.pauseTime = nil
            }
            appDelegate.playerView = nil
        }
//        if appDelegate.player.rate != 0
//        {
//            appDelegate.player.pause()
//        }
        
        API.logout(nil , aViewController: self){ (result: JSON) in
            if ( result != nil )
            {
                self.DLog("#### logout API Response: \(result)")
                if self.isExistUserDefaultKey("favoritePlaylistId") == true
                {
                    BaseVC.sharedInstance.removeUserDefaultKey("favoritePlaylistId")
                }
                self.removeUserDefaultKey(Constants.userDefault.loginInfo)
                self.removeUserDefaultKey(Constants.userDefault.userProfileInfo)
            }
        }
    }
    
    // MARK: - Get Country List
    func getCountries()
    {
        let saveResult : JSON =  self.loadJSON(Constants.userDefault.countryList)
        if saveResult.count == 0
        {
            API.getCountryList(nil, aViewController:self) { (result: JSON) in
                
                if ( result != nil )
                {
                    self.DLog("getCountryList API Response: \(result)")
                    self.saveJSON(result,key:Constants.userDefault.countryList)
                    self.loadCountries()
                }
            }
        }
        else
        {
            self.loadCountries()
        }
    }
    
    func loadCountries()
    {
        let saveResult : JSON =  self.loadJSON(Constants.userDefault.countryList)
        
        if saveResult.count == 0
        {
            self.getCountries()
            return
        }
        
        var tempArray : [JSON] = []
        tempArray = saveResult.arrayValue
        self.countryListArray.removeAllObjects()
        for i in 0..<tempArray.count
        {
            let json : JSON = tempArray[i]
            let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
            dict.setObject(json["code"].stringValue, forKey: "code")
            dict.setObject(json["id"].stringValue, forKey: "id")
            dict.setObject(json["currency"].stringValue, forKey: "currency")
            dict.setObject(json["name"].stringValue, forKey: "name")
            self.countryListArray.addObject(dict)
            self.DLog("self.countryListArray count = \(self.countryListArray.count)")
        }
    }
    
    // MARK: - add Swip Gesture On View
    func addSwipGestureOnView()
    {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(BaseVC.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(BaseVC.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,action: #selector(BaseVC.respondToSwipeGesture(_:)))
        swipeLeft.direction=UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                self.DLog("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                self.DLog("Swiped down")
            case UISwipeGestureRecognizerDirection.Left:
                self.DLog("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                self.DLog("Swiped up")
            default:
                break
            }
        }
    }
    
    // for format String With Thousands Seperators
    func formatStringWithThousandsSeperators(numberStr:String , currency:String = "+$")-> String
    {
        let formatter = NSNumberFormatter()
        let fv = formatter.numberFromString(numberStr)
        formatter.numberStyle = .CurrencyStyle
        formatter.maximumFractionDigits = 0;
        if (fv != nil)
        {
            let amount = formatter.stringFromNumber(fv!)
            NSCharacterSet(charactersInString: "0123456789,").invertedSet
            let number = amount!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789,").invertedSet).joinWithSeparator("")
            return "\(currency) \(number)" // result: $3,534,235 –
        }
        else
        {
            return "$0"
        }
    }
    
    //for playing System Sound
    func playSystemSound(fileName:String = "")
    {
        //http://iphonedevwiki.net/index.php/AudioServices
        if (fileName.length == 0)
        {
            AudioServicesPlaySystemSound (SystemSoundID(1313))//1313	sms-received5.caf	SMSReceived_Selection
            //AudioServicesPlaySystemSound (SystemSoundID(1016))//1016	tweet_sent.caf	tweet_sent.caf	SMSSent
        }
        else
        {
            // Load playSystemSound("beep-23.mp3")
            // Load playSystemSound("beep-24.mp3")
            if let soundURL = NSBundle.mainBundle().URLForResource(fileName, withExtension: "mp3") {
                var mySound: SystemSoundID = 0
                AudioServicesCreateSystemSoundID(soundURL, &mySound)
                // Play
                AudioServicesPlaySystemSound(mySound);
                //AudioServicesDisposeSystemSoundID(mySound)
            }
        }
    }
    //for
    func vibratePhone()
    {
        AudioServicesPlayAlertSound(UInt32(kSystemSoundID_Vibrate))
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfileImageName()
    {
        // self.showLoader()
        
        var param = Dictionary<String, String>()
        param[kAPIUserType] = KAPIUserTypeValue
        param["house_owner_id"] = "\(BaseVC.sharedInstance.getUserDefaultDataFromKeyWithArchive(USER_DEFAULT_LOGIN_USER_DATA)!["house_owner_id"]!)"
        param["sessionCode"] = "\(BaseVC.sharedInstance.getUserDefaultStringFromKey(USER_DEFAULT_SESSION_CODE))"
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        let url = Constants.Network.baseUrl +  "getHouseOwnerProfile"
        DLog("param \(param)")
        
        self.printAPIURL("getHouseOwnerProfile", param: param)
        
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        self.DLog("JSON: \(json)")
                        if (json[kAPIResponseStatus].intValue == 1)
                        {
                            if  json[kAPIResponsedata] != nil
                            {
                                self.DLog("\(json[kAPIResponsedata])")
                                let profileimagename  = json[kAPIResponsedata]["photo"].stringValue
                                
                                if profileimagename == ""
                                {
                                    appDelegate.userProfilePhoto = UIImage(named:"profile_dp_dummy_placeholder.png")!
                                    
                                    NSNotificationCenter.defaultCenter().postNotificationName(kNotificationUpdateProfileImage, object: self)
                                    
                                }
                                else
                                {
                                    appDelegate.imagewithURL = BaseVC.sharedInstance.getDocumentsDirectory().stringByAppendingPathComponent(profileimagename)
                                    if appDelegate.fileManager.fileExistsAtPath(appDelegate.imagewithURL)
                                    {
                                        appDelegate.userProfilePhoto = UIImage(contentsOfFile:appDelegate.imagewithURL)!
                                        
                                        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationUpdateProfileImage, object: self)
                                        
                                    }
                                    else
                                    {
                                        self.getProfileFromAmazon(profileimagename)
                                    }
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
                    self.DAlert(ALERT_TITLE, message: "\(error.localizedDescription)", action: ALERT_OK, sender: self)
                }
        }
        
    }
    
    func getProfileFromAmazon(imageName:String)
    {
        self.showLoader()
        
        appDelegate.s3Manager = AFAmazonS3Manager.init(accessKeyID:ACCESS_KEY_ID, secret:SECRET_KEY_ID)
        appDelegate.s3Manager!.requestSerializer.bucket = BUCKET
        //Content-Type →image/png
        appDelegate.s3Manager!.requestSerializer.setValue("image/png", forHTTPHeaderField: "Content-Type")
        appDelegate.s3Manager?.getObjectWithPath(imageName, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
            
            self.DLog(Double( totalBytesWritten) / (Double(totalBytesExpectedToWrite) * 1.0) * 100)
            let progress = CGFloat( Double( totalBytesWritten) / (Double(totalBytesExpectedToWrite) * 1.0) * 100)
            self.DLog("progress \(progress)")
            }, success:
            {(responseObject) -> Void in
                
                self.DLog("Success:\(responseObject)")
                self.hideLoader()
                
                
                let imgName = NSUserDefaults.standardUserDefaults().objectForKey("profile") as? String
                if (imgName != nil)
                {
                    BaseVC.sharedInstance.writeImageInDocumentDirectory(imgName!, choosenImage:UIImage(data: responseObject.1)!)
                }
                
                appDelegate.userProfilePhoto =  UIImage(data: responseObject.1)!
                NSNotificationCenter.defaultCenter().postNotificationName(kNotificationUpdateProfileImage, object: self)
                
            })
        { (error) -> Void in
            self.hideLoader()
            self.DAlert(ALERT_TITLE, message: "\(error.localizedDescription)", action: ALERT_OK, sender: self)
        }
        
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject] {
        
        let data = text.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            
            if let dict = json as? [String: AnyObject]
            {
                return dict
                //                if let weather = dict["weather"] as? [AnyObject] {
                //                    for dict2 in weather {
                //                        let id = dict2["id"] as? Int
                //                        let main = dict2["main"] as? String
                //                        let description = dict2["description"] as? String
                //                        BaseVC.sharedInstance.DLog(id)
                //                        BaseVC.sharedInstance.DLog(main)
                //                        BaseVC.sharedInstance.DLog(description)
                //                    }
                //                }
            }
            else
            {
                return ["":""]
            }
        }
        catch {
            //self.DLog(error)
        }
        
        
        
        //
        //        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
        //
        //            do {
        //                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String : AnyObject]
        //                return json
        //            } catch {
        //                return ["":""]
        //            }
        //        }
        //        return ["":""]
        return ["":""]
        
    }
    
    //MARK: - Save JSON in UserDefault -
    func saveJSON(j: JSON,key:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        print("j.rawString : \(j.rawString())")
        defaults.setValue(j.rawString()!, forKey: key)
        // here I save my JSON as a string
    }
    
    
    // Load JSON from UserDefault
    func loadJSON(key:String) -> JSON
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.valueForKey(key) != nil)
        {
            return JSON.parse(defaults.valueForKey(key) as! String)
        }
        else
        {
            return nil
        }
        // JSON from string must be initialized using .parse()
    }
    
    //MARK: - Animation -
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func cyclicViewController(isPresenting : Bool, originFrame : CGRect, oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        
        oldViewController.willMoveToParentViewController(oldViewController)
        
        if isPresenting
        {
            oldViewController.addChildViewController(newViewController)
            self.addSubview(newViewController.view, toView:oldViewController.view)
            newViewController.view.alpha = 0
        }
        else
        {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
        }
        
        newViewController.view.layoutIfNeeded()
        
        
        //let thisView = oldViewController.view
        let toView = newViewController.view
        
        let herbView = newViewController.view
        
        let initialFrame = isPresenting ? originFrame : herbView.frame
        let finalFrame = isPresenting ? herbView.frame : originFrame
        
        let xScaleFactor = isPresenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = isPresenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if isPresenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            herbView.clipsToBounds = true
            
            oldViewController.view.addSubview(toView)
            oldViewController.view.bringSubviewToFront(herbView)
        }
        
        UIView.animateKeyframesWithDuration(0.36, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
            newViewController.view.alpha = 1
            
            if  isPresenting
            {
                oldViewController.view.alpha = 1
            }
            else
            {
                oldViewController.view.alpha = 0
            }
            
            herbView.transform = isPresenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                y: CGRectGetMidY(finalFrame))
            
            },
                                            completion: { finished in
                                                
                                                if isPresenting
                                                {
                                                    newViewController.didMoveToParentViewController(oldViewController)
                                                }
                                                else
                                                {
                                                    oldViewController.view.removeFromSuperview()
                                                    oldViewController.removeFromParentViewController()
                                                }
        })
    }
    
    func checkRateView()
    {
        
        
        
    /*    /* New implement by mitesh 2-3-17 */
        let vc = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ConfirmEnjoyDisctopiaVC") as! ConfirmEnjoyDisctopiaVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        navigationController.navigationBarHidden = true
        appDelegate.navigationController!.visibleViewController!.presentViewController(navigationController, animated: true, completion: nil)
         */
        
        
        let currentDate: NSDate =  NSDate()
        if let key = NSUserDefaults.standardUserDefaults().objectForKey(Constants.userDefault.appLaunchDate)
        {
            // exist
            if let lunchDate = defaultsAppLunchDate.objectForKey(Constants.userDefault.appLaunchDate) as? NSDate
            { let days = daysBetweenDates(lunchDate,endDate: currentDate)
                
                if days >= 7
                {
                    let vc = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ConfirmEnjoyDisctopiaVC") as! ConfirmEnjoyDisctopiaVC
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.modalPresentationStyle = .OverCurrentContext
                    navigationController.navigationBarHidden = true
                    appDelegate.navigationController!.visibleViewController!.presentViewController(navigationController, animated: true, completion: nil)
                    
                     BaseVC.sharedInstance.defaultsAppLunchDate.setObject(NSDate(), forKey:Constants.userDefault.appLaunchDate)
                    
/*                    if (!Constants.userDefault.rateMe && !Constants.userDefault.noThanks)
                    {
                        let rateAppVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("RateAppViewController") as! RateAppViewController
                        rateAppVC.view.translatesAutoresizingMaskIntoConstraints = false;
                        
                        for subview: UIView in appDelegate.navigationController!.visibleViewController!.view.subviews
                        {
                            if subview.tag == 1001
                            {
                                subview.removeFromSuperview()
                            }
                        }
                        self.cyclicViewController(true, originFrame: UIScreen.mainScreen().bounds, oldViewController: appDelegate.navigationController!.visibleViewController!, toViewController: rateAppVC)
                    } */
                }
            }
        }
        else
        {
            defaultsAppLunchDate.setObject(currentDate, forKey:Constants.userDefault.appLaunchDate )
        }
        //        if Constants.userDefault.appLaunchCounter > 5
        //        {
        //            if (!Constants.userDefault.rateMe && !Constants.userDefault.noThanks)
        //            {
        //                let rateAppVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("RateAppViewController") as! RateAppViewController
        //                rateAppVC.view.translatesAutoresizingMaskIntoConstraints = false;
        //
        //                for subview: UIView in appDelegate.navigationController!.visibleViewController!.view.subviews
        //                {
        //                    if subview.tag == 1001
        //                    {
        //                        subview.removeFromSuperview()
        //                    }
        //                }
        //                                    self.cyclicViewController(true, originFrame: UIScreen.mainScreen().bounds, oldViewController: appDelegate.navigationController!.visibleViewController!, toViewController: rateAppVC)
        //            }
        //        }
        //        Constants.userDefault.appLaunchCounter += 1
        //        self.DLog(Constants.userDefault.appLaunchCounter)
    }
    func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        return components.day
    }
    
    // MARK: - API
    /*
     func logout()
     {
     if appDelegate.playerView != nil
     {
     appDelegate.playerView = nil
     }
     if appDelegate.player.rate != 0
     {
     appDelegate.player.pause()
     }
     
     API.logout(nil , aViewController: self)
     {
     (result: JSON) in
     if ( result != nil )
     {
     self.DLog("#### logout API Response: \(result)")
     if self.isExistUserDefaultKey("favoritePlaylistId") == true
     {
     BaseVC.sharedInstance.removeUserDefaultKey("favoritePlaylistId")
     }
     }
     self.removeUserDefaultKey(Constants.userDefault.loginInfo)
     }
     
     appDelegate.isMinimisePlayerVisible = false
     if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
     {
     minimizeView.removeFromSuperview()
     }
     }
     */
    
    // Deactivate Account API
    func isPlayerPlaying()->Bool
    {
        if appDelegate.playerView != nil
        {
            if appDelegate.player.currentItem != nil
            {
                if (appDelegate.player.rate == 0 && CMTimeGetSeconds(appDelegate.player.currentItem!.duration) != CMTimeGetSeconds(appDelegate.player.currentItem!.currentTime()) /*&& self.videoPlaying*/)
                {
                    return true
                }
                else
                {
                    return false
                }
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    func deActivateAccount()
    {
        if appDelegate.playerView != nil
        {
            appDelegate.playerView = nil
        }
        if appDelegate.player.rate != 0
        {
            appDelegate.player.pause()
        }
        
        API.deActivateAccount(nil , aViewController: self)
        {
            (result: JSON) in
            if ( result != nil )
            {
                self.DLog("#### deActivateAccount API Response: \(result)")
                
                self.DLog("#### deActivateAccount API Response: \(result)")
                if self.isExistUserDefaultKey("favoritePlaylistId") == true
                {
                    BaseVC.sharedInstance.removeUserDefaultKey("favoritePlaylistId")
                }
            }
            self.removeUserDefaultKey(Constants.userDefault.loginInfo)
        }
        
        appDelegate.isMinimisePlayerVisible = false
        if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
        {
            minimizeView.removeFromSuperview()
        }
    }
    
    func updateSubscriptionAPI()
    {
        var param = Dictionary<String,String>()
        param["inappplan"] = appDelegate.planId
        param[kAPISessionToken] = appDelegate.appToken
        API.UpdateSubscriptionIOS(param,aViewController:self) {
            (result: JSON) in
            if (result != nil)
            {
                self.DAlert(ALERT_TITLE, message: "Update Subscription successfully", action: ALERT_OK, sender: self)
                //BaseVC.sharedInstance.getUserProfile()
                print("result\(result)")
            }
        }
    }
    // MARK: - Common API
    func getUserProfile()
    {
        API.getUserProfile(nil, aViewController:self) { (result: JSON) in
            
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("getUserProfile API Response: \(result)")
                self.saveJSON(result,key:Constants.userDefault.userProfileInfo)
                self.getFavPlaylistId()
            }
        }
        
    }
    
//    func getInAppList2()
//    {
//        API.getInAppList2("",aViewController: self) { (result: JSON) in
//            
//            if (result != nil) {
//                
//                appDelegate.managePriceMatrxJSONArray = result.arrayValue
//                self.DLog("managePriceMatrxJSONArray Array: \(appDelegate.managePriceMatrxJSONArray)")
//            }
//        }
//        
//    }
    // MARK: - GetPlaylist API -
    func getFavPlaylistId()
    {
        let profile : JSON =  self.loadJSON(Constants.userDefault.userProfileInfo)
        self.DLog("Saved userProfile: \(profile)")
        if profile.count > 0
        {
            let favplaylistId =  profile[0]["favPlaylistID"].stringValue
            BaseVC.sharedInstance.setUserDefaultStringFromKey("favoritePlaylistId", value:favplaylistId)
        }
        
        /*
         API.getPlaylist(nil , aViewController: self) { (result: JSON) in
         if ( result != nil )
         {
         BaseVC.sharedInstance.DLog("#### getPlayList API Response: \(result)")
         if (result["playlistDict"] != nil)
         {
         let playListArray = result["playlistDict"].array!
         BaseVC.sharedInstance.DLog("#### playListArray: \(playListArray)")
         for  i in 0...playListArray.count - 1
         {
         self.DLog("i = \(i)")
         let playlistDict = playListArray[i].dictionaryValue
         self.DLog("playlistDict = \(playlistDict)")
         self.DLog("playlistname = \(playlistDict["playlistname"]!)")
         if playlistDict["playlistname"]!.stringValue  == "Disctopia Favs"//"Favourite"
         {
         //appDelegate.favoritePlaylistId = playlistDict["playlistId"]!.stringValue
         self.DLog("fav playlistif before userdefault = \(playlistDict["playlistId"]!.stringValue)")
         BaseVC.sharedInstance.setUserDefaultStringFromKey("favoritePlaylistId", value: playlistDict["playlistId"]!.stringValue)
         self.DLog("fav playlistif after userdefault = \(BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId"))")
         }
         }
         
         
         }
         }
         }
         */
    }
    
    let AppBundleId = "com.disctopia.disctopia"
    let Purchase1 = "com.disctopia.disctopia.1"//RegisteredPurchase.Purchase1
    let Purchase2 = "com.disctopia.disctopia.2"//RegisteredPurchase.NonRenewingPurchaseMonthly
    
}

//MARK: - InApp -
enum RegisteredPurchase : String
{
    case Purchase1 = "1"
    case Purchase2 = "2"
    case NonConsumablePurchase = "nonConsumablePurchase"
    case ConsumablePurchase = "3"
    case AutoRenewablePurchase = "autoRenewablePurchase"
    case NonRenewingPurchaseMonthly = "monthly"
    case NonRenewingPurchaseYearly = "yearly"
    
    /*
     case Purchase1 = "purchase1"
     case Purchase2 = "purchase2"
     case NonConsumablePurchase = "nonConsumablePurchase"
     case ConsumablePurchase = "consumablePurchase"
     case AutoRenewablePurchase = "autoRenewablePurchase"
     case NonRenewingPurchase = "nonRenewingPurchase"
     */
}

//MARK: - DLog -

func DLog(message: AnyObject = "",file: String = #file, line: UInt = #line , function: String = #function)
{
    /*  #if DEBUG : In comment then display log
     #if DEBUG : Not comment then stop log
     */
    //#if IS_TESTING
    if (isTesting)
    {
        print("fuction:\(function) line:\(line) file:\(file) \n=================================================================================================\n \(message) ")
    }
    // #endif
}

extension BaseVC {

    // MARK: actions
    @IBAction func getInfo1() {
        getInfo(Purchase1)
    }
    @IBAction func purchase1() {
        purchase(Purchase1)
    }
    @IBAction func verifyPurchase1() {
        verifyPurchase(Purchase1)
    }
    @IBAction func getInfo2() {
        getInfo(Purchase2)
    }
    @IBAction func purchase2() {
        purchase(Purchase2)
    }
    @IBAction func verifyPurchase2() {
        verifyPurchase(Purchase2)
    }
    
    func getInfo(purchase: String) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([purchase]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(self.alertForProductRetrievalInfo(result))
        }
    }
    
    func purchase(purchase: String) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(purchase) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(self.alertForPurchaseResult(result))
        }
    }
    @IBAction func restorePurchases() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases() { results in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(self.alertForRestorePurchases(results))
        }
    }
    
    @IBAction func verifyReceipt() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.verifyReceipt() { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(self.alertForVerifyReceipt(result))
            
            if case .Error(let error) = result {
                if case .NoReceiptData = error {
                    self.refreshReceipt()
                }
            }
        }
    }
    
    func verifyPurchase(purchase: String) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.verifyReceipt() { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .Success(let receipt):
                
                let productId =  purchase
                
                // Specific behaviour for AutoRenewablePurchase
//                if purchase == .AutoRenewablePurchase {
//                    let purchaseResult = SwiftyStoreKit.verifySubscription(
//                        productId: productId,
//                        inReceipt: receipt,
//                        validUntil: NSDate()
//                    )
//                    self.showAlert(self.alertForVerifySubscription(purchaseResult))
//                }
//                else {
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
                        productId: productId,
                        inReceipt: receipt
                    )
                    self.showAlert(self.alertForVerifyPurchase(purchaseResult))
                //}
                
            case .Error(let error):
                self.showAlert(self.alertForVerifyReceipt(result))
                if case .NoReceiptData = error {
                    self.refreshReceipt()
                }
            }
        }
    }
    
    func refreshReceipt() {
        
        SwiftyStoreKit.refreshReceipt { (result) -> () in
            
            self.showAlert(self.alertForRefreshReceipt(result))
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

// MARK: User facing alerts
extension BaseVC {
    
    func alertWithTitle(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        return alert
    }
    
    func showAlert(alert: UIAlertController) {
        guard let _ = self.presentedViewController else {
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForProductRetrievalInfoOld(result: SwiftyStoreKit.RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.locale = product.priceLocale
            numberFormatter.numberStyle = .CurrencyStyle
            let priceString = numberFormatter.stringFromNumber(product.price ?? 0) ?? ""
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        }
        else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        }
        else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    func alertForProductRetrievalInfo(result: SwiftyStoreKit.RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.locale = product.priceLocale
            
            let langId = product.priceLocale.objectForKey(NSLocaleLanguageCode) as! String
            let countryId = product.priceLocale.objectForKey(NSLocaleCountryCode) as! String
            let language = "\(langId)-\(countryId)" // en-US on my machine
            appDelegate.countryId = "\(countryId)"
            numberFormatter.numberStyle = .CurrencyStyle
            let priceString = numberFormatter.stringFromNumber(product.price ?? 0) ?? ""
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString) \(language)")
        }
        else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        }
        else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }

    
       func alertForPurchaseResult(result: SwiftyStoreKit.PurchaseResult) -> UIAlertController {
        switch result
        {
        case .Success(let productId):
            print("Purchase Success: \(productId)")
            
            if appDelegate.isFromUpdateSubsription
            {
                updateSubscriptionAPI()
            }
            else
            {
                if appDelegate.isFromSubsription
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("updateSubscription", object: nil)
                }
                else
                {
                    let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
                    if saveResult != nil //check for register user or song purchase
                    {
                        NSNotificationCenter.defaultCenter().postNotificationName("inAppSongPayment", object: nil)
                    }
                    else
                    {
                        //call register API here
                        NSNotificationCenter.defaultCenter().postNotificationName("callCreateArtistRegisterIOS", object: nil)
                    }
                }
               
            }
            appDelegate.isFromSubsription = false
            appDelegate.isFromUpdateSubsription = false
            return alertWithTitle("Thank You", message: "Purchase completed")
        case .Error(let error):
            print("Purchase Failed: \(error)")
            appDelegate.isFromSubsription = false
            appDelegate.isFromUpdateSubsription  = false
            switch error {
            case .Failed(let error):
                if error.domain == SKErrorDomain {
                    return alertWithTitle("Purchase failed", message: "Please check your Internet connection or try again later")
                }
                return alertWithTitle("Purchase failed", message: "Unknown error. Please contact support")
            case .InvalidProductId(let productId):
                return alertWithTitle("Purchase failed", message: "\(productId) is not a valid product identifier")
            case .NoProductIdentifier:
                return alertWithTitle("Purchase failed", message: "Product not found")
            case .PaymentNotAllowed:
                return alertWithTitle("Payments not enabled", message: "You are not allowed to make payments")
            }
        }
    }
    
    func alertForRestorePurchases(results: SwiftyStoreKit.RestoreResults) -> UIAlertController {
        
        if results.restoreFailedProducts.count > 0 {
            print("Restore Failed: \(results.restoreFailedProducts)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        }
        else if results.restoredProductIds.count > 0 {
            print("Restore Success: \(results.restoredProductIds)")
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        }
        else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    
    
    func alertForVerifyReceipt(result: SwiftyStoreKit.VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case .Success(let receipt):
            print("Verify receipt Success: \(receipt)")
            return alertWithTitle("Receipt verified", message: "Receipt verified remotly")
        case .Error(let error):
            print("Verify receipt Failed: \(error)")
            switch (error) {
            case .NoReceiptData :
                return alertWithTitle("Receipt verification", message: "No receipt data, application will try to get a new one. Try again.")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed")
            }
        }
    }
    
    func alertForVerifySubscription(result: SwiftyStoreKit.VerifySubscriptionResult) -> UIAlertController {
        
        switch result {
        case .Purchased(let expiresDate):
            print("Product is valid until \(expiresDate)")
            return alertWithTitle("Product is purchased", message: "Product is valid until \(expiresDate)")
        case .Expired(let expiresDate):
            print("Product is expired since \(expiresDate)")
            return alertWithTitle("Product expired", message: "Product is expired since \(expiresDate)")
        case .NotPurchased:
            print("This product has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    func alertForVerifyPurchase(result: SwiftyStoreKit.VerifyPurchaseResult) -> UIAlertController {
        
        switch result {
        case .Purchased:
            print("Product is purchased")
            return alertWithTitle("Product is purchased", message: "Product will not expire")
        case .NotPurchased:
            print("This product has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    func alertForRefreshReceipt(result: SwiftyStoreKit.RefreshReceiptResult) -> UIAlertController {
        switch result {
        case .Success:
            print("Receipt refresh Success")
            return self.alertWithTitle("Receipt refreshed", message: "Receipt refreshed successfully")
        case .Error(let error):
            print("Receipt refresh Failed: \(error)")
            return self.alertWithTitle("Receipt refresh failed", message: "Receipt refresh failed")
        }
    }
    
}
//Disctopia InApp Purchase
//
//Test User name :
//Email : disctopiainapp1@gmail.com
//Password: Test@2016
//What is your name? InApp
//Store: India

//MARK: - Image
extension UIImage {
    class func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}


