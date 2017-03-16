//
//  APIConnection.swift
//  Aamer
//
//  Created by Sujal Bandhara on 03/12/2015.
//  Copyright (c) 2015 byPeople Technologies Pvt Limited. All rights reserved.
//

import UIKit

let TIME_OUT_TIME = 60.0  // in seconds

protocol APIConnectionDelegate {
    
    func connectionFailedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    
    func connectionDidFinishedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    
    func connectionDidFinishedErrorResponceForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    
    func connectionDidUpdateAPIProgress(action: Int,bytesWritten: Int64, totalBytesWritten: Int64 ,totalBytesExpectedToWrite: Int64)
    
}

class APIConnection: NSObject {
    
    var delegate: APIConnectionDelegate! =  nil
    var param : NSDictionary?
    
    
    func CoreHTTPAuthorizationHeaderWithXAuthToken(param : NSDictionary , token : String) -> NSDictionary
    {
        let username: AnyObject? = param[kAPIUsername]
        let password: AnyObject? = param[kAPIPassword]
        var headers: NSDictionary?
        
        if param.count > 0 && username != nil && password != nil
        {
            //send x-auth token and authorization header
            //let str = "\(username!):\(password!)"
            //let base64Encoded = BaseVC.sharedInstance.encodeStringToBase64(str)
            
            headers = [
                "Content-Type":"application/json, charset=utf-8",
                "Authorization": "Bearer \(token)"
                /*"x-auth": token,*/
                /*"authorization": "Basic \(base64Encoded)"*/
            ]
        }
        else
        {
            //send x-auth token
            headers = ["x-auth": token]
        }
        return headers!
    }
    func SocialCoreHTTPAuthorizationHeaderWithXAuthToken(param : NSDictionary , token : String) -> NSDictionary
    {
        let socialType: AnyObject? = param[kAPISocialType]
        let socialId: AnyObject? = param[kAPISocialId]
        let socialToken: AnyObject? = param[kAPISocialToken]
        
        var headers: NSDictionary?
        
        if param.count > 0 && param[kAPISocialType] != nil && param[kAPISocialId] != nil && param[kAPISocialToken] != nil
        {
            //send x-auth token and authorization header
            let str = "\(socialType!)_\(socialId!):\(socialToken!)"
            let base64Encoded = BaseVC.sharedInstance.encodeStringToBase64(str)
            
            headers = [
                "x-auth": token,
                "authorization": "Basic \(base64Encoded)"
            ]
        }
        else
        {
            //send x-auth token
            headers = ["x-auth": token]
        }
        return headers!
    }
    
    func addQueryStringToUrl(url : String, param : NSDictionary) -> String
    {
        var queryString : String = url
        
        if param.count > 0
        {
            for (key, value) in param {
                
                BaseVC.sharedInstance.DLog("\(key) = \(value)")
                
                if queryString.rangeOfString("?") == nil
                {
                    queryString = queryString.stringByAppendingString("?\(key)=\(value)")
                }
                else
                {
                    queryString = queryString.stringByAppendingString("&\(key)=\(value)")
                    
                }
            }
            BaseVC.sharedInstance.DLog("\(queryString)")
            return queryString
            
        }
        return queryString
        
    }
    func GET(action: Int,withAPIName apiName: String, andMessage message: String, param:NSDictionary, withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool , token : String) -> AnyObject
    {
        if isProgresshudShow == true
        {
            BaseVC.sharedInstance.showLoader()
        }
        
        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(param, token: token)
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.addQueryStringToUrl( BASE_URL +  apiName ,param: param))!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: TIME_OUT_TIME)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers as? [String : String] 
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let httpResponse = response as? NSHTTPURLResponse
            
            /*if (error != nil) {
           self.DLog(error)
            } else {
           self.DLog(httpResponse)
            }*/
            
            dispatch_async(dispatch_get_main_queue()) {
                self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.GET.rawValue)
            }
            
        })
        
        dataTask.resume()
        return self
    }
    
    func PUT(action: Int,withAPIName apiName: String, andMessage message: String, param:[String:AnyObject], withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool , token : String) -> AnyObject
    {
        if isProgresshudShow == true
        {
            BaseVC.sharedInstance.showLoader()
        }
        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(param, token: token)
        
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval:TIME_OUT_TIME)
        request.HTTPMethod = "PUT"
        request.allHTTPHeaderFields = headers as? [String : String] 
        /* request.HTTPBody = self.convertDicToMutableData(param)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")*/
        request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions())
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        BaseVC.sharedInstance.DLog(request.allHTTPHeaderFields!)
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let httpResponse = response as? NSHTTPURLResponse
            
            /*if (error != nil) {
           self.DLog(error)
            } else {
            let httpResponse = response as? NSHTTPURLResponse
           self.DLog(httpResponse)
            }*/
            dispatch_async(dispatch_get_main_queue()) {
                self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.PUT.rawValue)
            }
        })
        
        dataTask.resume()
        
        return self
    }
    
    func POST(action: Int, withAPIName apiName: String, withMessage message: String, withParam param: [String:AnyObject], withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool) -> AnyObject
    {
        if isProgresshudShow == true
        {
            BaseVC.sharedInstance.showLoader()
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: TIME_OUT_TIME)
        request.HTTPMethod = "POST"
        request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param , options: NSJSONWritingOptions())
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let httpResponse = response as? NSHTTPURLResponse
            
            /* if (error != nil) {
           self.DLog(error)
            } else {
            let httpResponse = response as? NSHTTPURLResponse
           self.DLog(httpResponse)
            }*/
            dispatch_async(dispatch_get_main_queue()) {
                self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.POST.rawValue)
            }
            
        })
        
        dataTask.resume()
        return self
    }
    
    func POST_WITH_HEADER(action: Int,withAPIName apiName: String, andMessage message: String, param:NSDictionary,paramHeader:NSDictionary, withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool , token : String, ContentType : String) -> AnyObject
    {
        if isProgresshudShow == true
        {
            BaseVC.sharedInstance.showLoader()
        }
        
        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(paramHeader, token: token)
        
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: TIME_OUT_TIME)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String : String]
        
        if ContentType == CONTENT_TYPE_ENCODED
        {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            if param.count > 0
            {
                request.HTTPBody = self.convertDicToMutableData(param)
            }
        }                    
        else
        {
            //json
            if param[kAPIData] != nil
            {
                request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param[kAPIData]! , options: NSJSONWritingOptions())
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
            }
            else
            {
                request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param , options: NSJSONWritingOptions())
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
            }
        }
        
        BaseVC.sharedInstance.DLog(request.allHTTPHeaderFields!)
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let httpResponse = response as? NSHTTPURLResponse
            
            /*if (error != nil) {
           self.DLog(error)
            } else {
            
           self.DLog(httpResponse)
            }*/
            dispatch_async(dispatch_get_main_queue()) {
                self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.POST.rawValue)
            }
            
        })
        dataTask.resume()
        return self
    }
    func POST_WITH_SOCIAL_HEADER(action: Int,withAPIName apiName: String, andMessage message: String, param:NSDictionary,paramHeader:NSDictionary, withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool , token : String, ContentType : String) -> AnyObject
    {
        if isProgresshudShow == true
        {
            BaseVC.sharedInstance.hideLoader()
            
            BaseVC.sharedInstance.showLoader()
        }
        
        let headers: NSDictionary  = SocialCoreHTTPAuthorizationHeaderWithXAuthToken(paramHeader, token: token)
        
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: TIME_OUT_TIME)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String : String]
        
        if ContentType == CONTENT_TYPE_ENCODED
        {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            if param.count > 0
            {
                request.HTTPBody = self.convertDicToMutableData(param)
            }
        }
        else
        {
            //json
            if param[kAPIData] != nil
            {
                request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param[kAPIData]! , options: NSJSONWritingOptions())
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
            }
        }
        
        BaseVC.sharedInstance.DLog(request.allHTTPHeaderFields!)
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let httpResponse = response as? NSHTTPURLResponse
            
            /*if (error != nil) {
           self.DLog(error)
            } else {
            
           self.DLog(httpResponse)
            }*/
            dispatch_async(dispatch_get_main_queue()) {
                self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.POST.rawValue)
            }
            
        })
        dataTask.resume()
        return self
    }
    
    func DELETE(action: Int,withAPIName apiName: String, andMessage message: String, param:NSDictionary,paramHeader:NSDictionary, withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool , token : String) -> AnyObject
    {
        if isProgresshudShow == true
        {
            BaseVC.sharedInstance.showLoader()
        }
        
        let headers: NSDictionary  = SocialCoreHTTPAuthorizationHeaderWithXAuthToken(paramHeader, token: token)
        
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: TIME_OUT_TIME)
        request.HTTPMethod = "DELETE"
        request.allHTTPHeaderFields = headers as? [String : String]
        BaseVC.sharedInstance.DLog(request.allHTTPHeaderFields!)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let httpResponse = response as? NSHTTPURLResponse
            
            /* if (error != nil) {
           self.DLog(error)
            } else {
           self.DLog(httpResponse)
            }*/
            dispatch_async(dispatch_get_main_queue()) {
                self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method :Method.DELETE.rawValue )
            }
            
        })
        
        dataTask.resume()
        return self
    }
    
    func UPLOAD_PROFILE_PIC(action: Int, withAPIName apiName: String, withMessage message: String, withParam param:NSDictionary, withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool, token : String) -> AnyObject
    {
        
        if isProgresshudShow == true
        {
            BaseVC.sharedInstance.showLoader()
        }
        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(param, token: token)
        
        if BaseVC.sharedInstance.isProfilePicExist()
        {
            let image: UIImage = UIImage(contentsOfFile: BaseVC.sharedInstance.getProfilePicPath())!
            
            let base64String = BaseVC.sharedInstance.convertImageToBase64(image)
            
            let param = ["ImageData" : "\(base64String)"]
            
            //let postData = NSMutableData(data: "ImageData=\(base64String)".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            BaseVC.sharedInstance.DLog("ImageData=\(base64String)")
            
            let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
                cachePolicy: .UseProtocolCachePolicy,
                timeoutInterval: TIME_OUT_TIME)
            request.HTTPMethod = "PUT"
            request.allHTTPHeaderFields = headers as? [String : String]
            request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param , options: NSJSONWritingOptions())
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            BaseVC.sharedInstance.DLog(request.allHTTPHeaderFields!)
            
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                let httpResponse = response as? NSHTTPURLResponse
                
                /* if (error != nil) {
               self.DLog(error)
                } else {
               self.DLog(httpResponse)
                }*/
                dispatch_async(dispatch_get_main_queue()) {
                    self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.PUT.rawValue)
                }
            })
            
            dataTask.resume()
            
        }
        
        return self
    }
    //MARK: - Respose Handling -
    func coreResponseHandling(request: NSURLRequest,response: NSHTTPURLResponse?,json: NSData!,error: NSError?,action: Int,method : String)
    {
        //BaseVC.sharedInstance.DLog("Stop loading \(action)")
        
        if !appDelegate.isLoderRequired
        {
            BaseVC.sharedInstance.hideLoader()
        }
        if(error != nil)
        {
            BaseVC.sharedInstance.DLog("\(error!.localizedDescription) res:\(response?.statusCode)")
            
            if(response == nil)
            {
                if let delegate = self.delegate
                {
                    delegate.connectionFailedForAction(action, andWithResponse: nil, method : method)
                }
            }
            else
            {
                if let delegate = self.delegate
                {
                    delegate.connectionFailedForAction(action, andWithResponse: nil, method : method)
                }
                
            }
        }
        else
        {
            BaseVC.sharedInstance.DLog("req:\(request) \n res:\(response?.statusCode) \n \(error) ")
            
            if(response?.statusCode == 200)
            {
                var dic : NSDictionary = NSDictionary()
                var string : String = String()
                
                if (json  != nil)
                {
                    //String
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as? String
                        // use anyObj here
                        if (jsonResult != nil && jsonResult?.characters.count > 0)
                        {
                            BaseVC.sharedInstance.DLog(jsonResult!)
                            
                            if ( jsonResult!.isKindOfClass(NSString))
                            {
                                string = jsonResult!
                                
                                //if (action == APIName.AuthenticationTokens.rawValue) || (action == APIName.socialauthenticationtokens.rawValue)
                                //{
                                    let myDict:NSDictionary = [kAPIAuthToken : string]
                                    dic = myDict
                                    
                               // }
                                BaseVC.sharedInstance.DLog(string)
                            }
                        }
                        
                    }
                    catch
                    {
                       // BaseVC.sharedInstance.DLog(error)
                        BaseVC.sharedInstance.DAlert(ALERT_TITLE_404, message: ALERT_404_FOUND, action: ALERT_OK, sender: (appDelegate.navigationController?.topViewController)!)//\(jsonParseError.localizedDescription)
                        
                    }
                    
                    //NSDictinary
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        // use anyObj here
                        if (( jsonResult?.isKindOfClass(NSDictionary)) != nil)
                        {
                            //BaseVC.sharedInstance.DLog(jsonResult)
                            
                            dic = jsonResult!
                        }
                        
                    } catch {
                      // BaseVC.sharedInstance.DLog(error)
                        BaseVC.sharedInstance.DAlert(ALERT_TITLE_404, message: ALERT_404_FOUND, action: ALERT_OK, sender: (appDelegate.navigationController?.topViewController)!)//\(jsonParseError.localizedDescription)
                        
                    }
                    
                    //Array
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as? NSArray
                        // use anyObj here
                        if (( jsonResult?.isKindOfClass(NSArray)) != nil)
                        {
                            BaseVC.sharedInstance.DLog(jsonResult!)
                            
                            let dicMutable : NSMutableDictionary = NSMutableDictionary()
                            dicMutable.setObject(jsonResult!, forKey: kAPIData)
                            dic = dicMutable as NSDictionary
                        }
                        
                        
                    } catch {
                       // BaseVC.sharedInstance.DLog(error)
                        BaseVC.sharedInstance.DAlert(ALERT_TITLE_404, message: ALERT_404_FOUND, action: ALERT_OK, sender: (appDelegate.navigationController?.topViewController)!)//\(jsonParseError.localizedDescription)
                        
                    }
                    
                    
                    if let delegate = self.delegate
                    {
                        delegate.connectionDidFinishedForAction(action, andWithResponse: dic,method : method)
                    }
                }
            }
            else
            {
                var dic : NSDictionary = NSDictionary()
                
                if (json  != nil)
                {
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(json, options: []) as! [NSDictionary:AnyObject]
                        
                        if jsonResult.count > 0
                        {
                            dic = jsonResult as NSDictionary
                            BaseVC.sharedInstance.DLog(dic)
                            //AccessDenied
                            if(response?.statusCode == 400 && dic[kAPIResponseErrorCode] as? String == "AccessDenied")//GenericError
                            {
                                if appDelegate.navigationController != nil
                                {
                                    //Check for if kAPIAuthToken is available then session is running otherwise session time out.
                                    let dicLoginData: NSMutableDictionary = BaseVC.sharedInstance.getUserDefaultDataFromKey(USER_DEFAULT_LOGIN_USER_DATA)
                                    
                                    if(dicLoginData.isKindOfClass(NSDictionary))
                                    {
                                        if dicLoginData.valueForKey(kAPIAuthToken) != nil
                                        {
                                            let alert = UIAlertView()
                                            alert.title = ALERT_TITLE
                                            alert.message = ALERT_SESSION_TIME_OUT
                                            alert.addButtonWithTitle(ALERT_OK)
                                            alert.show()
                                            
                                            
                                            BaseVC.sharedInstance.clearDataHistoryOfLoginUser()
                                            BaseVC.sharedInstance.popToRootViewController()
                                            
                                            
                                            //BaseVC.sharedInstance.popForcefullyLoginScreenWhenSessionTimeOutWithClassName(WelComeStep1aLoginVC(), identifier:"WelComeStep1aLoginVC" , animated: true, animationType: AnimationType.Default)
                                            
                                            
                                            
                                        }
                                    }
                                }
                            }
                            else
                            {
                                if let delegate = self.delegate
                                {
                                    delegate.connectionDidFinishedErrorResponceForAction(action, andWithResponse: dic,method: method )
                                }
                            }
                        }
                        
                        
                        // use anyObj here
                    } catch {
                        //BaseVC.sharedInstance.DLog(error)
                        
                        BaseVC.sharedInstance.DAlert(ALERT_TITLE_404, message: ALERT_404_FOUND, action: ALERT_OK, sender: (appDelegate.navigationController?.topViewController)!)//\(jsonParseError.localizedDescription)
                    }
                }
                else
                {
                    //static
                    if let delegate = self.delegate
                    {
                        delegate.connectionDidFinishedForAction(action, andWithResponse: dic,method : method)
                    }
                }
            }
        }
    }
    
    
    //MARK: - Convert Dictinary To Data -
    //        request.HTTPBody = self.convertDicToMutableData(param)
    //request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    func convertDicToMutableData(param:NSDictionary) -> NSMutableData
    {
        var postData : NSMutableData?
        
        if param.count > 0
        {
            for (key, value) in param
            {
                // BaseVC.sharedInstance.DLog("\(key) : \(value)")
                
                if postData == nil
                {
                    postData = NSMutableData(data: "\(key)=\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
                }
                else
                {
                    postData!.appendData("&\(key)=\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
                }
            }
            return postData!
            
        }
        return postData!
    }
    
}


func APIDemo()
{
    /*
    
    https://docs.google.com/document/u/1/d/1p8A6pTC54Yfan7cMg4zvWbxsZk8BgC_8vs8BQIFERvk/mobilebasic
    
    Input : Row Body JSON :
    
    API Endpoint : http://dev2.Aamer.com/api/index.php?method=login
    
    {
    
    "email":"nidhi@soms.in",
    
    "password":123456,
    
    "device_token":"2135465465546",
    
    "device_type":1
    
    }
    
    
    
    Successful Response
    
    
    {
    
    "status": 1,
    
    "msg": "success",
    
    "errorCode": "",
    
    "errorDesc": "",
    
    "data": {
    
    "user_id": "34",
    
    "firstname": "",
    
    "lastname": "",
    
    "display_name": "Aamer owner",
    
    "email": "nidhi@soms.in",
    
    "last_login": "2016-01-07 23:48:19",
    
    "user_level": "4",
    
    "auth_token": "d8995ab3bb66f95f21c987b600c4e600",
    
    "base_url": "http://dev2.Aamer.com/",
    
    "image_base_url": "uploads/user_profile/",
    
    "user_image": "usersimages/noimage.jpg"
    
    }
    
    }
    
    
    Input : Row Body JSON :
    
    {
    
    "email":"nidhi@soms.in",
    
    "password":1234567,
    
    "device_token":"2135465465546",
    
    "device_type":1
    
    }
    
    
    
    Mismatch password failed Response
    
    
    {
    
    "status": 0,
    
    "msg": "Email or Password is wrong",
    
    "errorCode": "101",
    
    "errorDesc": "login_failed",
    
    "data": ""
    
    }
    
    
    
    Input : Row Body JSON :
    
    
    {
    
    "email":"nidhi@",
    
    "password":"",
    
    "device_token":"2135465465546",
    
    "device_type":1
    
    }
    
    
    
    
    Password Blank failed Response
    
    
    {
    
    "status": 0,
    
    "msg": "Email or Password is empty",
    
    "errorCode": "101",
    
    "errorDesc": "login_failed",
    
    "data": ""
    
    }
    
    
    
    
    
    
    Other Login Error message
    
    
    1.
    
    {
    
    "status": 0,
    
    "msg": "Email or Password is empty",
    
    "errorCode": "101",
    
    "errorDesc": "login_failed",
    
    "data": ""
    
    }
    
    
    2.
    
    {
    
    "status": 0,
    
    "msg": "Email is not valid",
    
    "errorCode": "101",
    
    "errorDesc": "login_failed",
    
    "data": ""
    
    }
    
    
    Query 1 : Could you please provide me working login and password ? I’m not able to get correct details from above given credential. Done
    
    
    Query 2 : Could you also share all the possible responses of each api ? Hold
    
    
    Query 3 : Could you also share all the possible error codes, desc and other metadata of every response ? This will help us to understand and handle all types of response of api.  Done
    
    
    Query 4 : In user_image field, I think we should only provide image name and image base url. Done  Example :
    
    "user_image": "http://dev2.Aamer.com/uploads/user_profile/usersimages/noimage.jpg",
    
    Base URL of App : http://dev2.Aamer.com/
    
    Image Base URL  :  uploads/user_profile/usersimages/  OR http://dev2.Aamer.com/uploads/user_profile/usersimages/
    
    
    In API response , it should provide only image name. ie. noimage.jpg
    
    
    Query 5 : I think we should receive session id or unique token in response of login api, which will be use with all other api access for security purpose. Done
    
    
    http://dev2.Aamer.com/api/index.php?method=forgotpassword
    
    Input : Row Body JSON : we are not hitting proper owner api bcoz password will be reset please check this email id, we are getting email
    
    {
    
    "email":"nawedita@soms.in"
    
    }
    
    Successful response
    
    {
    
    "status": 1,
    
    "msg": "success",
    
    "errorCode": "",
    
    "errorDesc": "",
    
    "data": ""
    
    }
    
    
    http://dev2.Aamer.com/api/index.php?method=logout
    
    Input : Row Body JSON :
    
    {
    
    "user_id":"34",
    
    "auth_token":"d8995ab3bb66f95f21c987b600c4e600",
    
    "device_token":"2135465465546",
    
    "device_type":1
    
    }
    
    
    
    Successful response
    
    
    {
    
    "status": 1,
    
    "msg": "logout successfully.",
    
    "errorCode": "",
    
    "errorDesc": "",
    
    "data": ""
    
    }
    
    
    Wrong input
    
    
    {
    
    "user_id":"34",
    
    "auth_token":"75d0d969da82ca61c004e7b22df6aa621",
    
    "device_token":"2135465465546",
    
    "device_type":1
    
    }
    
    
    Failed Response
    
    
    {
    
    "status": 0,
    
    "msg": "authorisation token not valid.",
    
    "errorCode": "",
    
    "errorDesc": "",
    
    "data": ""
    
    }
    
    
    
    API Endpoint : http://dev2.Aamer.com/api/index.php?method=dashboard
    
    Input : Row Body JSON :
    
    {
    
    "user_id":34
    
    }
    
    
    Successful response with promoter(it is showing one because it has only one it will show three when it will be three max limit is 3)
    
    
    {
    
    "status": 1,
    
    "msg": "success",
    
    "errorCode": "",
    
    "errorDesc": "",
    
    "data": {
    
    "currency": "$",
    
    "total_revenue": 5400,
    
    "current_month_revenue": 4300,
    
    "previous_month_revenue": 1100,
    
    "event_revenue": 0,
    
    "pending_event_revenue": 0,
    
    "pending_club_revenue": 1100,
    
    "club_revenue": 4300,
    
    "top_promoter_list": [
    
    {
    
    "display_name": "vikas rawat",
    
    "total_sale": "1100",
    
    "base_url": "http://dev2.Aamer.com/",
    
    "image_base_url": "uploads/user_profile/",
    
    "user_image": "noimage.png"
    
    }
    
    ]
    
    }
    
    }
    
    
    
    Input Raw data With no proter List
    
    
    {
    
    "user_id":35
    
    }
    
    
    Successful Response
    
    
    {
    
    "status": 1,
    
    "msg": "success",
    
    "errorCode": "",
    
    "errorDesc": "",
    
    "data": {
    
    "currency": "$",
    
    "total_revenue": 1000,
    
    "current_month_revenue": 1000,
    
    "previous_month_revenue": 0,
    
    "event_revenue": 0,
    
    "pending_event_revenue": 0,
    
    "pending_club_revenue": 0,
    
    "club_revenue": 1000,
    
    "top_promoter_list": []
    
    }
    
    }
    
    
    
    http://dev2.Aamer.com/api/index.php?method=getclubsbyowner
    
    
    API Input Json
    
    
    {
    
    "user_id":34
    
    }
    
    
    Successful Response
    
    
    {
    
    "status": 1,
    
    "msg": "success",
    
    "errorCode": "",
    
    "errorDesc": "",
    
    "total_club": 3,
    
    "data": [
    
    {
    
    "club_id": "256",
    
    "user_id": "33",
    
    "club_registration_id": "Bon_1452159053",
    
    "country_id": "236",
    
    "state_id": "4139",
    
    "city_id": "3824",
    
    "pin_code": "89109",
    
    "location": "",
    
    "club_name": "Bond Bar",
    
    "club_website": "http://www.cosmopolitanlasvegas.com/experience/lounges-and-bars/bond.aspx",
    
    "budget": "0",
    
    "description": "",
    
    "address": "3708 Las Vegas Boulevard South ",
    
    "latitude": " ",
    
    "longitude": " ",
    
    "contact_no_1": "(702) 698-7000",
    
    "contact_no_2": "",
    
    "following": "0",
    
    "follower": "0",
    
    "gallery": "0",
    
    "tax_id": "",
    
    "timing": "",
    
    "logo": " ",
    
    "is_active": "1",
    
    "is_approved": "1",
    
    "creation_date": "2016-01-07 15:00:53",
    
    "modified_date": "2016-01-07 15:13:38",
    
    "ip_address": "::1",
    
    "features": "",
    
    "club_email": "",
    
    "club_image": "no-image.png",
    
    "club_services": {
    
    "Music Type": [
    
    "Blues",
    
    "Dance Music",
    
    "Electronic Music",
    
    "Punjabi Music"
    
    ],
    
    "Features": [
    
    "Air Conditioning",
    
    "DJ Booth",
    
    "Dance Floor",
    
    "Free Mixers",
    
    "Wifi"
    
    ],
    
    "Good for": [
    
    "Birthday Parties",
    
    "Bachelorette Parties",
    
    "Bachelor Parties",
    
    "Late Night",
    
    "Girls night out",
    
    "Guys night out"
    
    ],
    
    "Atmosphere": [
    
    "Upscaletrendy"
    
    ]
    
    },
    
    "opening_hours": "Monday 10:00 AM-10:00 PM <br/>Tuesday 10:00 AM-10:00 PM <br/>Wednesday 10:00 AM-10:00 PM <br/>Thursday 10:00 AM-10:00 PM <br/>Friday 10:00 AM-10:00 PM <br/>Saturday Closed <br/>Sunday Closed <br/>",
    
    "state_name": "Nevada",
    
    "city_name": "Las Vegas",
    
    "country_code": "USA",
    
    "rate": "0",
    
    "total_revenue": {
    
    "total_sale": 1100,
    
    "booking_count": 1
    
    },
    
    "total_pending_revenue": {
    
    "total_sale": 1100,
    
    "booking_count": 1
    
    },
    
    "ticket_table_sales_count": {
    
    "sale_ticket": 0,
    
    "sale_table": 0,
    
    "total_ticket": 0,
    
    "total_table": 1
    
    },
    
    "history": [
    
    {
    
    "date": "2016-01-02",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-03",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-04",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-05",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-06",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-07",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-08",
    
    "sale": "0"
    
    }
    
    ],
    
    "base_url": "http://dev2.Aamer.com/",
    
    "image_base_url": "uploads/club_image/"
    
    },
    
    {
    
    "club_id": "255",
    
    "user_id": "33",
    
    "club_registration_id": "Gho_1452157529",
    
    "country_id": "236",
    
    "state_id": "4139",
    
    "city_id": "3824",
    
    "pin_code": "89103",
    
    "location": "",
    
    "club_name": "Ghostbar",
    
    "club_website": "http://www.palms.com/nightlife/ghostbar",
    
    "budget": "0",
    
    "description": "",
    
    "address": "4321 W Flamingo Rd",
    
    "latitude": " ",
    
    "longitude": " ",
    
    "contact_no_1": "(702) 942-6832",
    
    "contact_no_2": "",
    
    "following": "0",
    
    "follower": "0",
    
    "gallery": "0",
    
    "tax_id": "",
    
    "timing": "",
    
    "logo": " ",
    
    "is_active": "1",
    
    "is_approved": "1",
    
    "creation_date": "2016-01-07 14:35:29",
    
    "modified_date": "2016-01-07 15:13:58",
    
    "ip_address": "::1",
    
    "features": "",
    
    "club_email": "",
    
    "club_image": "no-image.png",
    
    "club_services": {
    
    "Music Type": [
    
    "Blues",
    
    "Dance Music",
    
    "Electronic Music",
    
    "Punjabi Music"
    
    ],
    
    "Features": [
    
    "Air Conditioning",
    
    "DJ Booth",
    
    "Dance Floor",
    
    "Free Mixers",
    
    "Wifi"
    
    ],
    
    "Good for": [
    
    "Birthday Parties",
    
    "Bachelorette Parties",
    
    "Bachelor Parties",
    
    "Late Night",
    
    "Girls night out",
    
    "Guys night out"
    
    ],
    
    "Atmosphere": [
    
    "Upscaletrendy"
    
    ]
    
    },
    
    "opening_hours": "Monday 9:30 AM-10:00 PM <br/>Tuesday 9:30 AM-10:00 PM <br/>Wednesday 9:30 AM-10:00 PM <br/>Thursday 9:30 AM-10:00 PM <br/>Friday Closed <br/>Saturday 9:30 AM-10:00 PM <br/>Sunday Closed <br/>",
    
    "state_name": "Nevada",
    
    "city_name": "Las Vegas",
    
    "country_code": "USA",
    
    "rate": "0",
    
    "total_revenue": {
    
    "total_sale": 2300,
    
    "booking_count": 1
    
    },
    
    "total_pending_revenue": {
    
    "total_sale": 0,
    
    "booking_count": 0
    
    },
    
    "ticket_table_sales_count": {
    
    "sale_ticket": 0,
    
    "sale_table": 2300,
    
    "total_ticket": 0,
    
    "total_table": 1
    
    },
    
    "history": [
    
    {
    
    "date": "2016-01-02",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-03",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-04",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-05",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-06",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-07",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-08",
    
    "sale": "0"
    
    }
    
    ],
    
    "base_url": "http://dev2.Aamer.com/",
    
    "image_base_url": "uploads/club_image/"
    
    },
    
    {
    
    "club_id": "254",
    
    "user_id": "33",
    
    "club_registration_id": "Cha_1452157067",
    
    "country_id": "236",
    
    "state_id": "4139",
    
    "city_id": "3824",
    
    "pin_code": "89109",
    
    "location": "",
    
    "club_name": "Chateau Nightclub & Rooftop",
    
    "club_website": "http://chateaunights.com",
    
    "budget": "0",
    
    "description": "",
    
    "address": "3655 Las Vegas Blvd. South",
    
    "latitude": " ",
    
    "longitude": " ",
    
    "contact_no_1": "(702) 776-7770",
    
    "contact_no_2": "",
    
    "following": "0",
    
    "follower": "0",
    
    "gallery": "0",
    
    "tax_id": "",
    
    "timing": "",
    
    "logo": " ",
    
    "is_active": "1",
    
    "is_approved": "1",
    
    "creation_date": "2016-01-07 14:27:47",
    
    "modified_date": "2016-01-07 15:14:11",
    
    "ip_address": "::1",
    
    "features": "",
    
    "club_email": "",
    
    "club_image": "no-image.png",
    
    "club_services": {
    
    "Music Type": [
    
    "Blues",
    
    "Dance Music",
    
    "Electronic Music",
    
    "Punjabi Music"
    
    ],
    
    "Features": [
    
    "Air Conditioning",
    
    "DJ Booth",
    
    "Dance Floor",
    
    "Free Mixers",
    
    "Wifi"
    
    ],
    
    "Good for": [
    
    "Birthday Parties",
    
    "Bachelorette Parties",
    
    "Bachelor Parties",
    
    "Late Night",
    
    "Girls night out",
    
    "Guys night out"
    
    ],
    
    "Atmosphere": [
    
    "Upscaletrendy"
    
    ]
    
    },
    
    "opening_hours": "Monday 10:30 AM-8:30 PM <br/>Tuesday 10:30 AM-8:30 PM <br/>Wednesday 10:30 AM-8:30 PM <br/>Thursday 10:30 AM-8:30 PM <br/>Friday 10:30 AM-8:30 PM <br/>Saturday Closed <br/>Sunday Closed <br/>",
    
    "state_name": "Nevada",
    
    "city_name": "Las Vegas",
    
    "country_code": "USA",
    
    "rate": "0",
    
    "total_revenue": {
    
    "total_sale": 2000,
    
    "booking_count": 2
    
    },
    
    "total_pending_revenue": {
    
    "total_sale": 0,
    
    "booking_count": 0
    
    },
    
    "ticket_table_sales_count": {
    
    "sale_ticket": 0,
    
    "sale_table": 2000,
    
    "total_ticket": 0,
    
    "total_table": 2
    
    },
    
    "history": [
    
    {
    
    "date": "2016-01-02",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-03",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-04",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-05",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-06",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-07",
    
    "sale": "0"
    
    },
    
    {
    
    "date": "2016-01-08",
    
    "sale": "0"
    
    }
    
    ],
    
    "base_url": "http://dev2.Aamer.com/",
    
    "image_base_url": "uploads/club_image/"
    
    }
    
    ]
    
    }
    
    
    
    http://dev2.Aamer.com/api/index.php?method=notifications
    
    
    Input JSON
    
    
    {
    
    "user_id":34
    
    }
    
    
    Successful response
    
    
    {
    
    "status": 1,
    
    "msg": "success",
    
    "errorCode": "",
    
    "errorDesc": "",
    
    "data": {
    
    "data": {
    
    "1": {
    
    "type": "Add Event",
    
    "notification": "blu added new event test event",
    
    "create_date": "Nov 28,2015"
    
    },
    
    "2": {
    
    "type": "Upcoming Event",
    
    "notification": "new event coming this sunday ",
    
    "create_date": "Nov 28,2015"
    
    },
    
    "3": {
    
    "type": "Add  Event",
    
    "notification": "event brite add new event for birthday ",
    
    "create_date": "Nov 28,2015"
    
    }
    
    },
    
    "total_count": 2
    
    }
    
    }
    
    
    
    Scan API  http://dev2.Aamer.com/api/index.php?method=notifications
    
    
    INPUT
    
    
    {
    
    
    
    "ticket_id":"#VU000017",
    
    "club_manager_id":41
    
    
    }
    
    
    Response
    
    
    {
    
    "status": 0,
    
    "msg": "Fields are empty.",
    
    "errorCode": "",
    
    "errorDesc": "",
    
    "data": ""
    
    }
    */
}
