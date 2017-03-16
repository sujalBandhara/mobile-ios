//
//  HeaderConstant.swift
//  Aamer
//
//  Created by Sujal Bandhara on 03/12/2015.
//  Copyright (c) 2015 byPeople Technologies Pvt Limited. All rights reserved.
//

struct Constants
{
    struct Network
    {
        static let baseUrlLocal = "http://192.168.0.201:100/DisctopiaRestApi/"
        static let baseUrlDeveloper = "http://dsctpapi-acmdacm.azurewebsites.net/DisctopiaRestApi/"
        
        /* 
         http://dsctpapi-acmdacm.azurewebsites.net/DisctopiaRestApi/
         http://dsctpapi.azurewebsites.net/DisctopiaRestApi/ */
        
        static let baseUrlLive = "http://dsctpapi.azurewebsites.net/DisctopiaRestApi/"
        
        /*"https://dsctpwebapiprod.azurewebsites.net/DisctopiaRestApi/"*/
        
        //static let baseUrl = baseUrlDeveloper
        static let baseUrl = baseUrlDeveloper
        
        static let authToken = "________"
        static let authTokenName = "auth_token"
        static let statusCodeString = "statusCode"
        static let SuccessCode = 200
        static let successRange = 200..<300
        static let Unauthorized = 401
        static let NotFoundCode = 404
        static let ServerError = 500
    }
    
    struct userDefault
    {
        static let loginInfo = "loginInfo"
        static let userProfileInfo = "userProfileInfo"
        static let countryList = "countryList"
        static var appLaunchCounter:Int = 0
        static var noThanks = Bool()
        static var rateMe = Bool()
        static var appLaunchDate = "appLaunchDate"
    }
    
    struct Formatters
    {
        static let debugConsoleDateFormatter: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            formatter.timeZone = NSTimeZone(name: "UTC")!
            return formatter
        }()
    }
    
    struct Debug
    {
        static let crashlytics = false
        static let jsonResponse = false
    }
}

func DEBUGLog(message: String, file: String = #file, line: Int = #line, function: String = #function) {
    
    #if DEBUG
        let fileURL = NSURL(fileURLWithPath: file)
        let fileName = fileURL.URLByDeletingPathExtension?.lastPathComponent ?? ""
        BaseVC.sharedInstance.DLog("\(NSDate().dblog()) \(fileName)::\(function)[L:\(line)] \(message)")
    #endif
    // Nothing to do if not debugging
}

func DEBUGJson(value: AnyObject) {
    #if DEBUG
        if Constants.Debug.jsonResponse {
            //  BaseVC.sharedInstance.DLog(JSONStringify(value))
        }
    #endif
}

//Facebook iOS Test: - Credential -
let isSVGNeeded = true
let animatedImageSVG = "ring"

let IS_TESTING = true
let FB_APP_ID = "129854237091490"

let LoaderColor = UIColor(red: 247.0 / 255, green: 210.0 / 255, blue: 63.0 / 255, alpha: 1.0)
let AppFontGrayColor = UIColor(red: 75.0 / 255, green: 106.0 / 255, blue: 128.0 / 255, alpha: 1.0)
let AppFontBlueColor = UIColor(red: 64.0 / 255, green: 207.0 / 255, blue: 255.0 / 255, alpha: 1.0)
let AppBackground =  UIColor.clearColor()
// UIColor(red: 60.0 / 255, green: 81.0 / 255, blue: 95.0 / 255, alpha: 1.0)
//let AppBackground = UIColor(red: 45.0 / 255, green: 63.0 / 255, blue: 77.0 / 255, alpha: 1.0)

let DEFAULT_IMAGE = "default_img.png"

//MARK: - ALERT -

let ALERT_NO_INTERNET       = "ALERT_NO_INTERNET".localized
let ALERT_TITLE             = "Disctopia"
let ALERT_OK                = "OK"
let ALERT_CANCEL            = "Cancel"


let ALERT_SETTINGS                      = "Settings"
let ALERT_MOBILE_OR_EMAIL               = "Mobile Number or Email"
let ALERT_PASSWORD                      = "Password"
let ALERT_ACCESS                        = "Access"
let ALERT_BLANK_MOBILE_EMAIL            = "Please enter your Email Address"
//let ALERT_BLANK_PASSWORD                = "Please enter your Password"
//let ALERT_BLANK_FIRSTNAME               = "Please enter your First Name"
//let ALERT_BLANK_LASTNAME                = "Please enter your Last Name"
//let ALERT_BLANK_GENDER                  = "Please choose your Gender"
//let ALERT_BLANK_EMAIL                   = "Please enter your Email Address"
let ALERT_BLANK_MOBILE_NUMBER           = "Please enter your Mobile Number"
//let ALERT_BLANK_BIRTHDATE               = "Please choose your Birthday"
let ALERT_VALID_MOBILE_NUMBER           = "Please enter valid Mobile Number"
//let ALERT_VALID_EMAIL_ADDRESS           = "Enter a valid email address"
//let ALERT_EMAILADRESS_ALREADY_USED      = "The email address has been already used"
let ALERT_MOBILE_ALREADY_USED           = "The mobile has already been used"
let ALERT_INCORRECTUSERNAME             = "Mobile Number or Email was not registered"
//let ALERT_INCORRECTPASSWORD             = "You might be entered the wrong password"
//let ALERT_SOCAIL_LOCKED_OUT             = "Your account has been somehow locked out"
//let ALERT_SOCAIL_INVALID_ACCESS_CODE    = "Your account's access token did not return correct information. The access token is garbage"

let ALERT_BLANK_SUBJECT                 = "Please enter Subject"
let ALERT_BLANK_DESC                    = "Please enter Description"

//the account exists but has bad login record
let ALERT_TURN_ON_LOCATION_FROM_APP             = "Turn On Location Service to Determine Your Location"
let ALERT_UNEXPECTED                            = "Something is not right here. Please try again later!!"
let ALERT_INFORM_NOT_PUSH_NOTIFICATION          = "We will not send you push notification. Note, however, that until you give access to Push Notification (by turning it on in settings) you will not receive any tasks."
let ALERT_TURN_ON_LOCATION_FROM_DEVICE_PRIVACY  = "\(ALERT_TITLE) doesn't work without the Location Services enabled. To turn it on, go to Settings > Privacy > Location Services > On"
let ALERT_SESSION_TIME_OUT                      = "Session Timeout. Please login again."
let ALERT_404_FOUND                             = "HTTP standard response code indicating that the client was able to communicate with a given server, but the server could not find what was requested."
let ALERT_TITLE_404                             = "404 - File or directory not found"
let ALERT_LOGOUT_CONFIRMATION                   = "Are you sure you want to logout?"



let USER_DEFAULT_TRACK_DIC = "trackDownloadDictionary"

//MARK: - SERVER URL's -

// Aamer Production
let BASE_URL = "http://aamerapp.com/index.php?r=api/"

// Aamer Development server Byptserver
//let BASE_URL = "http://192.168.0.201/klefixphp/index.php?r=api/"
//let BASE_URL = "http://52.35.93.122/klefixphp/index.php?r=api/"

let kNotificationUpdateProfileImage    = "updateProfileImage"

let kAPIToken                        =   "token"
let kAPISessionToken                 =   "sessiontoken"
let CONTENT_TYPE_ENCODED             =   "urlencoded"
let CONTENT_TYPE_JSON                =   "json"
//MARK: - API Keys -
let kAPIResponseMessage             =   "msg"
let kAPIResponseStatus              =   "status"
let kAPIResponseErrorCode           =   "errorCode"
let kAPIResponseErrorDesc           =   "message"
let kAPIResponsedata                =   "data"
let kAPIUserType                    =   "userType"
let kAPIDeviceToken                 =   "device_token"
let kAPIDeviceType                  =   "device_type"
let kAPIBuildVersion                =   "build_version"
let kAPIBuildVersionValue           =   "1.0"
let kAPISession                     =   "sessionCode"

let KAPIUserTypeValue               =   "2"  //userType : 1- Service Provider , 2- House Owner
let deviceType_IOS                  =   "2" //device_type : 1- Android, 2- IOS

let kAPIUsername                    =   "email"
let kAPIPassword                    =   "password"

let kAPIAuth_Token                  =   "auth_token"
let kAPINotification_Id             =   "notification_id"
let kAPIUserData                    =   "data"
let kAPIStartDate                   =   "sdate"
let kAPIUserId                      =   "userId"
//let kAPIEventId                     =   "event_id"
//let kAPIClubId                     =   "club_id"

let kAPIAuthToken                   =   "APIAuthToken"
let kAPIAgreeToGpsTracking          =   "AgreeToGpsTracking"
let kAPIAgreeToPushNotifications    =   "AgreeToPushNotifications"
//let kAPIFirstName                   =   "FirstName"
//let kAPILastName                    =   "LastName"
//let kAPIEmailAddress                =   "EmailAddress"
let kAPIMobilePhone                 =   "MobilePhone"
let kDisplayMobilePhone             =   "DisplayMobilePhone"
//let KAPIBirthMonth                  =   "BirthMonth"
//let kAPIBirthYear                   =   "BirthYear"
//let kAPIGender                      =   "Gender"
let kAPIDevicePushNotificationToken =   "DevicePushNotificationToken"
let kAPINotificationGapRequired     =   "NotificationGapRequired"
let kAPIImageData                   =   "ImageData"
let kAPILatitude                    =   "Latitude"
let kAPILongitude                   =   "Longitude"
let kAPIDateCollected               =   "DateCollected"
let kCountryCode                    =   "CountryCode"
let kLanguageCode                   =   "LanguageCode"
let kCountryCodeAU                  =   "AU"
let kLanguageCodeEN                 =   "en"
let kAPIData                        =   "Data"
let kAPIRadiusMetres                =   "RadiusMetres"
let kAPIPointOfInterestId           =   "PointOfInterestId"
let kAPIIsInbound                   =   "IsInbound"
let kAPINote                        =   "Note"
let kMobilePhone                    =   "MobilePhone"
let kAPICreateDate                  =   "CreateDate"
let kAPISocialType                  =   "SocialType"
let kAPISocialId                    =   "SocialId"
let kAPISocialToken                 =   "SocialToken"


let kAPISocialTypeFacebook          =   1

//MARK: - Amazon key

let ACCESS_KEY_ID = "AKIAJ2KVCRDFPSAA6A7A"
let SECRET_KEY_ID = "uaDjpFL6EYd8nOqp313U3XFyReow7DMcSVSSKH4C"
let BUCKET = "aamer"

////MARK: - LOGIN WITH FB KEYS -
//let kFBId                           =   "id"
//let kFBFirst_name                   =   "first_name"
//let kFBEmail                        =   "email"
//let kFBGender                       =   "gender"
//let kFBLast_name                    =   "last_name"
//let kFBPicture                      =   "picture"
//let kFBData                         =   "data"
//let kFBUrl                          =   "url"
//let kFBOauthToken                   =   "oauthToken"
//

//MARK: - UserDefault Key -
let USER_DEFAULT_LOGIN_USER_DATA                =   "loginUserData"
let USER_DEFAULT_SESSION_CODE                   =   "sessionCode"
let USER_DEFAULT_DEVICE_TOKEN                   =   "deviceToken"
let USER_DEFAULT_LOCATION_PERMISSION_ALERT      =   "isLocationPermissionAlertAsk"
let USER_DEFAULT_SIGNUP_ALL_STEPS_FINISHED      =   "isSignUpProcessFinish"
let USER_DEFAULT_DEVICE_CROSS_5KM_REGION        =   "DeviceCross5kmregion"
let USER_DEFAULT_OFFICE                         =   "Office"
let USER_DEFAULT_PUSH_NOTIFICATION_PERMISSION_ALERT      =   "isPushNotificationPermissionAlertAsk"
let USER_DEFAULT_ACCOUNT_SETUP_FROM_LOGIN       =   "accountSetupWithUsingLoginCredential"
let USER_DEFAULT_SOCIAL_TYPE                    =   "SocialType"
let USER_DEFAULT_FB_ACCESS_TOKEN                =   "oauthToken"



let USER_DEFAULT_SAVE_FACEBOOK_DATA             =   "loginWithFacebookData"

//MARK:- Database Keys -

let DB_DELETE_ALL_REGIONS           =   "Delete ALL Regions"
let DB_ADD_NEW_REGION               =   "Add New Region"
let DB_FIRE_EXIT_REGION             =   "Exit Region"
let DB_FIRE_ENTER_REGION            =   "Enter Region"
let DB_UPDATED_TO_SERVER            =   "Updated To Server"
let DB_UPDATED_TO_SERVER_ApiLogging = "ApiLogging Updated To Server "
let DB_RESCHEDLE_REGION             =   "Reschdule Region"
let DB_START_RESCHEDLE_REGION       =   "Start Reschdule Region"
let DB_APP_UPDATE                   = "App update"
let DB_LOCATION_MANAGER_OFF         = "Location Manager Off"

let DB_UPDATED_TO_SERVER_EXIT_REGION = "Updated Exit To Server"


//MARK: - Notification Key -
let NOTIFICATION_PUSH_UPDATE = "pushNotificationNofity"

let MINIMIZE_PLAYER_HEIGHT = ScreenSize.SCREEN_HEIGHT * 0.0815217
//@available(iOS 9.0, *)
//let APP_DYNAMIC_FONT = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)


let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

//let APP_DYNAMIC_FONT = appDelegate.appDynamicFont
//var STORY_BOARD =  appDelegate.AppStoryBoard()//  UIStoryboard(name: "Main", bundle: nil)
let STORY_BOARD_PRELOGIN = UIStoryboard(name: "PreLogin", bundle: nil)
let STORY_BOARD_MAIN = UIStoryboard(name: "Main", bundle: nil)

//MARK: - Enum -

enum EventType: Int {
    case OnEntry = 0
    case OnExits
}

enum DistopiaUserType : Int
{
    case Fan = 1
    case Artist = 2
    case None
    
}
enum CLError : Int {
    case LocationUnknown // location is currently unknown, but CL will keep trying
    case Denied // Access to location or ranging has been denied by the user
    // ...
}
enum UserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}
enum CompassPoint
{
    case North
    case South
    case East
    case West
}
enum SurveyNotificationType : Int
{
    /// <summary>
    /// Time the survey is received on the phone
    /// </summary>
    case PhoneReceived = 1
    
    /// <summary>
    /// They clicked the notification on the phone
    /// </summary>
    case  PhoneClicked = 2
    
    /// <summary>
    /// they clicked the red box in the app to start the survey
    /// </summary>
    case  AppClicked = 3
    
    /// <summary>
    /// the notification has expired
    /// </summary>
    case Expired = 4
    
    /// <summary>
    /// the app survey process has expired
    /// </summary>
    case   AppExpired = 5
    
    /// <summary>
    /// They cancelled the survey in the app
    /// </summary>
    case  AppCancelled = 6
}

enum SurveyScreenType : Int
{
    case    Finish      = 1
    case    YesNo       = 2
    case    Text        = 3 
    case    WordList    = 4
    case    Word        = 5
    case    Image       = 6
}

enum MemberType : Int
{
    case InvalidNumber              = 0
    case AlreadyInvited             = 1
    case AlreadyMember              = 2
    case Invitable                  = 3
    case OutsideCountry             = 4
    case Invited                    = 100
    
}

enum AccountType : String
{
    case AccountType_FB              = "0"
    case AccountType_Twitter         = "1"
}


enum OperationSystemType : Int
{
    case Android                    = 1
    case blackberry                 = 2
    case iOS                        = 3
    case WindowsPhone               = 4
}

enum NotificationGapRequired : Int
{
    case NoDelay                    = 1
    case OncePerDay                 = 2
    case EveryFewDays               = 3
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPHONE            = UIDevice.currentDevice().userInterfaceIdiom == .Phone
}

public enum TrackBy :Int{
    
    case PurchaseTrack
    case Album
    case Playlist
    case Artist
    case AllTrack
}
//#define BASE_URL_GLOBAL @"http://byptserver.com/blowngo/index.php?r=api/"

struct AnimationType
{
    static let Default              = 1
    static let ScrollView           = 2
}

public enum Method: String {
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}
//MARK: - COLOR -

let IndicaterColor = UIColor(red: 64.0/255.0, green: 207.0/255.0, blue: 255.0/255.0, alpha: 1.0)

import UIKit
import Foundation
import CoreLocation

class HeaderConstant: BaseVC
{
    
    //    @IBOutlet var scrollView: UIScrollView!
    
    //MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let instanceOfCustomObject: ObjCToSwift = ObjCToSwift()
        instanceOfCustomObject.someMethod()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    internal func test()
    {
        
    }
}