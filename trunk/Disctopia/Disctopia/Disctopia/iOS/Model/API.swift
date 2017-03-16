//
//  API.swift
//  Disctopia
//
//  Created by imac04 on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import Alamofire
import SwiftyJSON

class API
{
    class var sharedInstance: API
    {
        struct Singleton
        {
            static let instance = API()
        }
        return Singleton.instance
    }
    
    class func createUser(param:Dictionary<String, String>, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl + "CreateUserRegister" //"CreateUser"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func createArtist(param:Dictionary<String, String>, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "CreateArtistRegister" //"createArtist"
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func createArtistRegisterIOS(param:Dictionary<String, String>, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "createArtistRegisterIOS" //"createArtistRegisterIOS"
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func getTracksListByArtistIdandAlbumId(param:Dictionary<String, String>, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "GetTracksListByArtistIdandAlbumId"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    // GetAlbumDetails
    class func GetAlbumDetails(param:Dictionary<String, String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "GetAlbumDetails"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }

    // GetTracksListByArtistIdandAlbumId
    class func GetTracksListByArtistIdandAlbumId(param:Dictionary<String, String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "GetTracksListByArtistIdandAlbumId"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func GetAllTracks(param:Dictionary<String, String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        
        let url = Constants.Network.baseUrl +  "GetAllTracks"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func changePassword(param:Dictionary<String, String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "ChangePassword"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func signIn(userName:String,password:String , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        var param = Dictionary<String, String>()
        param["userName"] = userName
        param["password"] = password
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        let url = Constants.Network.baseUrl +  "SignIn"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func forgotPassword(email:String , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        var param = Dictionary<String, String>()
        param["email"] = email
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        let url = Constants.Network.baseUrl +  "ForgotPassword"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func getSubscriptionPlanList(email:String , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        //BaseVC.sharedInstance.showLoader()
        var param = Dictionary<String, String>()
       // param["email"] = email
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        let url = Constants.Network.baseUrl +  "GetSubscriptionPlanList"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func getInAppList(email:String , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        //BaseVC.sharedInstance.showLoader()
        var param = Dictionary<String, String>()
        param[kAPIDeviceToken] = appDelegate.deviceToken
        param["TypeId"] = "1"
        //let url = Constants.Network.baseUrl +  "GetInAppList"
        //########### NEED to CHNAGE this ####### @Mitesh
        let url = Constants.Network.baseUrlDeveloper +  "GetInAppList"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func getInAppList2(email:String , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        //BaseVC.sharedInstance.showLoader()
        var param = Dictionary<String, String>()
        param[kAPIDeviceToken] = appDelegate.deviceToken
        param["TypeId"] = "2"
        let url = Constants.Network.baseUrl +  "GetInAppList"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func primaryStyle(email:String , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        //BaseVC.sharedInstance.showLoader()
        var param = Dictionary<String, String>()
        // param["email"] = email
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        let url = Constants.Network.baseUrl +  "GetPrimaryStyle"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func secondaryStyle(email:String , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        //BaseVC.sharedInstance.showLoader()
        var param = Dictionary<String, String>()
        // param["email"] = email
        param[kAPIDeviceToken] = appDelegate.deviceToken
        
        let url = Constants.Network.baseUrl +  "GetSecondaryStyle"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    
    // Get Credit Card List API
    class func getCreditCardList(param:Dictionary<String, String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {

        let url = Constants.Network.baseUrl + "GetCardList"
        
        BaseVC.sharedInstance.DLog("URL = \(url)")
        BaseVC.sharedInstance.DLog("Param = \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { responce in
                
                completionHandler(result:API.returnResponse(responce,viewController: aViewController))
        }
        
    }
    
    //temporary
    class func getCreditCardList2(param:Dictionary<String, String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        
        let url = Constants.Network.baseUrl + "GetCardList"
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        BaseVC.sharedInstance.DLog("URL = \(url)")
        BaseVC.sharedInstance.DLog("Param = \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { responce in
                
                completionHandler(result:API.returnResponse(responce,viewController: aViewController))
        }
        
    }
    class func resendEmail(email:String , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        var param = Dictionary<String, String>()
        param["EmailId"] = email
        
        let url = Constants.Network.baseUrl +  "ResendActivationLink"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func syncMusic(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "GetPurchasedTrackByUser"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }

    class func searchTrackDetails(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "SearchTrackDetails"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        print("url = \(url) param : \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func searchAlbumDetails(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "SearchAlbumDetails"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
   
    class func searchArtistDetails(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "SearchArtistDetails"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func reportAlbum(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "reportAlbum"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }

    class func getPlaylistDetails(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()

        let url = Constants.Network.baseUrl +  "getPlaylistDetails"
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    // RegisterCreditCard API
    class func RegisterCreditCard(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "RegisterCreditCard"
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func EditCreditCard(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        
        let url = Constants.Network.baseUrl +  "EditCreditCard"
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func deleteCreditCard(param:Dictionary<String,String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl + "DeleteCreditCard"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param = \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { responce in
                completionHandler(result:API.returnResponse(responce, viewController: aViewController))
        }
    }
    
    
    class func GetArtistCategoryList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "GetArtistCategoryList"
        
        //let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func getExplorer(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "GetExplorer"
        
        //let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    
    class func addSongInPlayList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "AddSongInPlayList"
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func addSessionPara(inputPara :Dictionary<String, String>)-> Dictionary<String, String>
    {
        let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
        DLog("saveResult = \(saveResult)")
        var param = inputPara
        if saveResult != nil
        {
            appDelegate.appToken = saveResult[kAPIToken].stringValue
            param[kAPISessionToken] = appDelegate.appToken
            param[kAPIUserId] = saveResult[kAPIUserId].stringValue
            param[kAPIDeviceToken] = appDelegate.deviceToken
            BaseVC.sharedInstance.DLog("Saved token: \(saveResult[kAPIToken].stringValue)")
            BaseVC.sharedInstance.DLog("Saved userId: \(saveResult[kAPIUserId].stringValue)")
        }
        else
        {
            param[kAPISessionToken] = appDelegate.appToken
        }
        return param
    }

    class func getArtistAlbumList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "GetArtistAlbumList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        BaseVC.sharedInstance.printAPIURL("GetArtistAlbumList", param: param)
      
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func getArtistList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "getArtistList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func logout(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "logout"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func deActivateAccount(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        
        let url = Constants.Network.baseUrl +  "DeActivateAccoount"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func GetPurchasedTrackByUser(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "GetPurchasedTrackByUser"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
      
    class func CreatePlayList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()

        let url = Constants.Network.baseUrl +  "CreatePlayList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func PlaySong(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "SetPlayedTrack"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func AddShoppingCart(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "Addshoppingcart"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func deleteShoppingCart(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "Deleteshoppingcart"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func getViewshoppingcart(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "Viewshoppingcart"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func getPlaylist(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        //let url = "http://192.168.0.201:100/DisctopiaRestApi/getPlaylist"
        
        let url = Constants.Network.baseUrl +  "getPlaylist"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        BaseVC.sharedInstance.printAPIURL("getPlaylist", param: param)
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }

    
    class func getAlbumsList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        
        let url = Constants.Network.baseUrl +  "getAlbumsList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    
    class func GetArtistAlbumList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "GetArtistAlbumList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    

    class func DeletePlayList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        
        let url = Constants.Network.baseUrl +  "DeletePlayList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func DeleteSongInPlayList(param:Dictionary<String, String>? = nil , completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "DeleteSongInPlayList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON {  response in
                completionHandler(result:API.returnResponse(response, viewController: nil))
        }
    }
    
    class func UnFavouriteSong(param:Dictionary<String, String>? = nil , completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "UnFavouriteSong"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: nil))
        }
    }



    class func GetAllTrackByPlayListId(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        //BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "GetAllTrackByPlayListId"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func UpdatePlaylist(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        //BaseVC.sharedInstance.showLoader()
        let url = Constants.Network.baseUrl +  "UpdatePlayList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func getMostPlayedSong(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "getMostPlayedSong"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    class func setTrackIndexForPlayList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "setTrackIndexForPlayList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }

    class func GetRecentPlayedMusic(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "GetRecentPlayedMusic"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func getUserProfile(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "GetUserProfile"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
        class func getPaymentInfo(param: Dictionary<String,String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void {
            let url = Constants.Network.baseUrl + "GetPaymentInfo"
    
            let param = API.addSessionPara(param != nil ?param!: Dictionary<String,String>())
    
            BaseVC.sharedInstance.DLog("url = \(url)")
            BaseVC.sharedInstance.DLog("param = \(param)")
    
            Alamofire.request(.GET, url, parameters: param)
                .validate().responseJSON { response in
                    completionHandler(result:API.returnResponse(response,viewController: aViewController))
            }
        }
    
    class func createPayment(param: Dictionary<String,String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void {
        let url = Constants.Network.baseUrl + "Payment"
        
        let param = API.addSessionPara(param != nil ?param!: Dictionary<String,String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param = \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response,viewController: aViewController))
        }
    }
    class func PaymentIOS(param: Dictionary<String,String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl + "PaymentIOS"
        
        let param = API.addSessionPara(param != nil ?param!: Dictionary<String,String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog(" PaymentIOS param = \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response,viewController: aViewController))
        }
    }
    class func setPlayedTrack(param: Dictionary<String,String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void {
        let url = Constants.Network.baseUrl + "SetPlayedTrack"
        
        let param = API.addSessionPara(param != nil ?param!: Dictionary<String,String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param = \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response,viewController: aViewController))
        }
    }

    class func getGetArtistProfile(param: Dictionary<String,String>? = nil,aViewController: UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl + "GetArtistProfile"
        let param = API.addSessionPara(param != nil ? param!: Dictionary<String,String>())

        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param = \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response,viewController: aViewController))
        }
    }
    
    //class func get
    
    class func updateArtistProfile(param:Dictionary<String, String>? = nil ,profileImage:UIImage?, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        
      //  BaseVC.sharedInstance.showLoader()

        let url = Constants.Network.baseUrl +  "UpdateArtistProfile"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        let image = profileImage//UIImage(named: DEFAULT_IMAGE)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.upload(.POST, url, headers: ["enctype": "multipart/form-data"], multipartFormData: {
            multipartFormData in
            
            if let _image = image {
                if let imageData = UIImageJPEGRepresentation(_image, 0.5) {
                    multipartFormData.appendBodyPart(data: imageData, name: "ProfileUrl", fileName: "file.png", mimeType: "image/png")
                }
            }
            
            for (key, value) in param {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            }
            , encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        print("Uploading Avatar \(totalBytesWritten) / \(totalBytesExpectedToWrite)")
                        dispatch_async(dispatch_get_main_queue(),{
                            /**
                             *  Update UI Thread about the progress
                             */
                        })
                    }
                    upload.responseJSON { (JSON) in
                        dispatch_async(dispatch_get_main_queue(),{
                            //Show Alert in UI
                            //print("Avatar uploaded JSON \(JSON)");
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                           // BaseVC.sharedInstance.DAlert(ALERT_TITLE, message: "Update artist profile successfully ", action: ALERT_OK, sender: BaseVC())
                            
                            let savechangesVCObj: SaveChangesVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("SaveChangesVC") as! SaveChangesVC
                            let navigationController = UINavigationController(rootViewController: savechangesVCObj)
                            navigationController.modalPresentationStyle = .OverCurrentContext
                            navigationController.navigationBarHidden = true
                            appDelegate.navigationController?.presentViewController(navigationController, animated: true, completion: {
                                print("Save changesVC Presented")
                            })
                            
                            let selectedDateDictionary = ["isSuccess" : true]
                            NSNotificationCenter.defaultCenter().postNotificationName("UpdateSuccessProfile", object: nil, userInfo: selectedDateDictionary)
                            completionHandler(result:nil)
                            

                        })
                    }
                    
                case .Failure(let encodingError):
                    //Show Alert in UI
                    //print("Avatar uploaded \(encodingError)");
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
        })
    }
    
    class func updatePaymentInformation(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "UpdatePaymentInfo"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func updateSubscription(param: Dictionary<String, String>? = nil, aViewController: UIViewController, completionHandler: (result: JSON ) -> Void ) -> Void
    {
        let url = Constants.Network.baseUrl + "UpdateSubscription"
        let param = API.addSessionPara(param != nil ? param! :Dictionary<String,String>())
        
            BaseVC.sharedInstance.DLog("url = \(url)")
            BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON
        {  response in
            completionHandler(result: API.returnResponse(response, viewController: aViewController))
        }
    }
    class func UpdateSubscriptionIOS(param: Dictionary<String, String>? = nil, aViewController: UIViewController, completionHandler: (result: JSON ) -> Void ) -> Void
    {
        let url = Constants.Network.baseUrl + "UpdateSubscriptionIOS"
        let param = API.addSessionPara(param != nil ? param! :Dictionary<String,String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON
            {  response in
                completionHandler(result: API.returnResponse(response, viewController: aViewController))
        }
    }

    class func changeDefaultCard(param: Dictionary<String, String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void ) -> Void
    {
        let url = Constants.Network.baseUrl + "ChangeDefaultCard"
        
        let param = API.addSessionPara(param != nil ? param!: Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result: API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func returnResponse (response: Response <AnyObject, NSError>, viewController:UIViewController?)->JSON
    {
        
        if !appDelegate.isLoderRequired
        {
                BaseVC.sharedInstance.hideLoader()
        }
        switch response.result {
        case .Success:
            if let value = response.result.value
            {
                let json = JSON(value)
                if (json[kAPIResponseStatus].intValue == 1)
                {
                    if  json[kAPIResponsedata] != nil
                    {
                        return json[kAPIResponsedata]
                    }
                    else
                    {
                        //BaseVC.sharedInstance.DAlert(ALERT_TITLE, message: "\(json[kAPIResponseErrorDesc].stringValue)", action: ALERT_OK, sender: viewController)
                        
                        let newJson = JSON([kAPIResponseErrorDesc : json[kAPIResponseErrorDesc].stringValue])
                        return newJson
                    }
                }
                else if (json[kAPIResponseStatus].intValue == -2)
                {
                    BaseVC.sharedInstance.logOut()
                    return nil
                }
                else
                {
                    
                    let errorMsg = "\(json[kAPIResponseErrorDesc].stringValue)"
                    
                    if errorMsg.uppercaseString  == "Your subscription period has exprired.".uppercaseString
                    {
                        if  json[kAPIResponsedata] != nil
                        {
                            return json[kAPIResponsedata]
                        }
                        else
                        {
                            //BaseVC.sharedInstance.DAlert(ALERT_TITLE, message: "\(json[kAPIResponseErrorDesc].stringValue)", action: ALERT_OK, sender: viewController)
                            
                            let newJson = JSON([kAPIResponseErrorDesc : json[kAPIResponseErrorDesc].stringValue])
                            return newJson
                        }
                    }
                    else
                    {
                        if (viewController != nil)
                        {
                            if errorMsg == ""
                            {}
                            else
                            {
                            BaseVC.sharedInstance.DAlert(ALERT_TITLE, message: "\(json[kAPIResponseErrorDesc].stringValue)", action: ALERT_OK, sender: viewController!)
                            }
                        }
                        return nil
                    }
                }
                
            }
        case .Failure(let error):
            if (viewController != nil)
            {
                BaseVC.sharedInstance.DAlert(ALERT_TITLE, message: "\(error.localizedDescription)", action: ALERT_OK, sender: viewController!)
            }
            return nil
        }
        
        return nil
    }
    
    class func getCountryList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "GetCountryList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    class func getStateList(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "GetStateList"
        
        let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    
    class func CheckForEmailExist(param:Dictionary<String, String>? = nil , aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        let url = Constants.Network.baseUrl +  "CheckForEmailExist"
        
        //let param = API.addSessionPara(param != nil ? param!:Dictionary<String, String>())
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.GET, url, parameters: param)
            .validate().responseJSON { response in
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }
    
    
    class func AddMutipleSongInPlayList(param:Dictionary<String, String>? = nil, aViewController:UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        BaseVC.sharedInstance.showLoader()
        
        let url = Constants.Network.baseUrl +  "AddMutipleSongInPlayList"
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        BaseVC.sharedInstance.DLog("param \(param)")
        
        Alamofire.request(.POST, url, parameters: param)
            .validate().responseJSON { response in
                
                completionHandler(result:API.returnResponse(response, viewController: aViewController))
        }
    }    
    
    //MARK: - Help API -
    class func help(aViewController: UIViewController, completionHandler: (result: JSON) -> Void) -> Void
    {
        
        //let url = NSURL(string: "https://disctopia.zendesk.com/api/v2/help_center/en-us/sections/206471888-General-iOS/articles.json")
        let url = NSURL(string: "https://disctopia.zendesk.com/api/v2/help_center/en-us/articles.json")
        
        BaseVC.sharedInstance.DLog("url = \(url)")
        
        Alamofire.request(.GET, url!)
            .validate().responseJSON { response in
                
                if let value = response.result.value
                {
                    let json = JSON(value)
                    completionHandler(result:json)
                }
                else
                {
                    completionHandler(result:nil)
                }
        }
    }
}


/*
 API to get Track are as follows
 http://dsctpapi.azurewebsites.net/DisctopiaRestApi/GetPurchasedTrackByUser?userId=398f4085-c280-4084-aa49-6e4aebde4e12&sessiontoken=07803799-0e42-49f5-89e4-381ad5c22c3b
 
 
http://dsctpapi.azurewebsites.net/DisctopiaRestApi/GetTracksListByArtistIdandAlbumId?userId=398f4085-c280-4084-aa49-6e4aebde4e12&device_token=DeviceTokenNotAvailable&sessiontoken=07803799-0e42-49f5-89e4-381ad5c22c3b&albumId=29
 
http://dsctpapi.azurewebsites.net/DisctopiaRestApi/SearchTrackDetails?TrackName=a
 
 */