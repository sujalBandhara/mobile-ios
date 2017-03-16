   //
// AppDelegate.swift
// Aamer
//
// Created by Sujal Bandhara on 03/12/2015.
// Copyright (c) 2015 byPeople Technologies Pvt Limited. All rights reserved.
//

let LOCATION_UPDATE_INTERVAL_TIME = 60.00 // 1 min
let LOCATION_PERMISSION_ALERT_NOT_ASKED = "Not Started"

import UIKit
import CoreLocation
import IQKeyboardManager
import SystemConfiguration
import ReachabilitySwift
import Alamofire
import SwiftyJSON
import MediaPlayer
import CoreTelephony
 
import Fabric
import Crashlytics
import Branch

let isLocalData = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,UIImagePickerControllerDelegate
{
    var isLoderRequired = false
    
    var isFromSharing = 0 // 0 - not from share , 1-Album share , 2 -Artist share
    //shopping cart
    var selectedCartId = ""
    var purchaseTier = ""
    var planId = ""
    var isAlbumCart = false
    //Player
    var playedTrackId = ""
    var playerTimer:NSTimer? = NSTimer()
    var playerTimerMinimize:NSTimer? = NSTimer()
    var trackObjArray = [Track]()
    var pagingMenuController : PagingMenuController! = nil
    //yourLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    @IBOutlet var playerView: PlayerBaseVC!
    //var minimizePlayerVC: MinimizePlayerVC?
    var minimizePlayerView: PlayerBaseVC?
    var backgroundSessionCompletionHandler: (() -> Void)?
    var currentSongId = ""
    var audioPlayer:AVAudioPlayer?
    var player = AVQueuePlayer()
    var shufflePlaylistArray = [String]()
    
    var inAppPlanId = ""
    var countryId = ""
   // let db = SQLiteDB.sharedInstance() // Local Database Instance
    
    var reachability: Reachability! //For Checking Internet Connectivity
    
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = 0
    
    var imagePicker = UIImagePickerController() // for picking image
    
    var timerUpdateLocation = NSTimer() // for updataing location
    
    var distopiaUserType : DistopiaUserType = DistopiaUserType.None // for User type
    
    // If application start automatically then applicationStatus = true [UIApplicationLaunchOptionsLocationKey]/////////////////
    var applicationStatus : Bool = false
    
    var lastSelectedMenuItems : Int = 1 // Menu Last selected Item
    var shoppingCartItemCount : Int = 0 // Menu Last selected Item
    
    var aamerUserData : NSMutableDictionary = [:] // for user Data
    var arrMediaItems : [MPMediaItem]  = []
    var userProfilePhoto :UIImage = UIImage()
    var providerProfilePhoto :UIImage = UIImage()
    var selectedAlbumId = ""
    var selectedArtistId = ""
    var selectedTrackId = ""
    
    var totalDuration : CGFloat = 0
    
    var favPlaylist : Playlist1VC? = nil
    var newPlaylist = ""
    var dictArtistDetails : NSMutableDictionary = [:] // for Store
    var selectedPlayListDictionary : NSMutableDictionary = [:]
    
    var isSelectFromPlaylist = false
    var isFromNewPlaylist = false
    var isFromPlaylist = false
    var isFromUpload = false
    var isResumeAvailable = false
    var isFromExplore = false
    var isFromSubsription = false
    var isFromUpdateSubsription = false
    var isFromGoSubsription = false
    var selectedPlaylistId : [String : JSON] = Dictionary()
    var newPlaylistId = ""
    var selectedTrackDict : [String : JSON] = Dictionary()
    var artistListDictionary : [String : JSON] = Dictionary()
    var exploreArray : [AnyObject]?
    
    let fileManager = NSFileManager.defaultManager()
    var popover:UIPopoverController?=nil
    var s3Manager : AFAmazonS3Manager?
    
    var profileimagename = ""
    var imagewithURL = ""

    var isNetworkReachable : Bool = false // for network reachabilty
    var deviceToken : String = "DeviceTokenNotAvailable"
    var appToken : String = ""
    var userId : String = ""
    
    var window : UIWindow?
    var navigationController : UINavigationController?
    
    var playlistVC: PlaylistVC = PlaylistVC.instantiateFromStoryboard()
    ////////////ParthStart////////////
    var isToLogin:String! = "NO"
    
    var playlistFrame = CGRect.zero
    var emailID : String! = ""
    var isMinimisePlayerVisible = false
     var appDynamicFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    var aTempLibraryVC:LibraryTracksViewController?
    
    var animatedLoaderWebView = UIWebView()
    let callCenter = CTCallCenter()
    
    
    var trackDownloadDictionary = NSMutableDictionary()

    var selectedTextField = UITextField()
    // MARK: - Application Delegate -
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        //let timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: Selector(self.callAlbumDetails()), userInfo: nil, repeats: true)
        
        print("in launch")
        callCenter.callEventHandler = callStatus
      
        //UIApplication.sharedApplication().idleTimerDisabled = true
        if #available(iOS 9.0, *)
        {
            //appDynamicFont = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3)
        }
        
        application.applicationIconBadgeNumber = 0
        
        self.makeAnimatedWebview()
        self.setStatusBar()
        self.loadViewController()
        
        //loadFirstViewController("WelcomeVC")
        // Initialise all instances
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {

            dispatch_async(dispatch_get_main_queue(),
                           {
                            self.initAPP()
                            
            });
        }

        ///////////If application start automatically then applicationStatus = true/////////////////
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            self.addBranchIO(launchOptions)
            dispatch_async(dispatch_get_main_queue(),
                           {
                            
            });
        }

        
        //set tint color
       self.window?.tintColor = UIColor.blackColor()
       self.applicationStatus = false
     //self.isResumeAvailable = true
       
        if launchOptions?[UIApplicationLaunchOptionsLocationKey] != nil
        {
            self.applicationStatus = true
        }
        
//        if (launchOptions != nil)
//        {
//            if let aPushNotification = launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject:AnyObject]
//            {
//                DLog("aPushNotification = \(aPushNotification)")
//                // Do something with push's payload
//                self.pushNotificationAction(aPushNotification)
//            }
//        }
        
        
        return true
    }
    
    func addBranchIO(launchOptions: [NSObject: AnyObject]?)
    {
        // Branch.io code
        Branch.getInstance().initSessionWithLaunchOptions(launchOptions, andRegisterDeepLinkHandler: { params, error in
            guard error == nil else { return }
            guard let userDidClick = params?["+clicked_branch_link"] as? Bool else { return }
            if userDidClick {
                // This code will execute when your app is opened from a Branch deep link, which
                // means that you can route to a custom activity depending on what they clicked.
                // In this example, we'll just print out the data from the link that was clicked.
                print("deep link data: ", params)
                
                if let isAlbum = params["isAlbum"] as? String
                {
                    if isAlbum == "1"
                    {
                        if let albumId = params["item_id"] as? String
                        {
                            appDelegate.isFromSharing = 1
                            print("album id : \(albumId)")
                            self.callAlbumDetails(albumId)
                        }
                    }
                    else
                    {
                        if let artistId = params["item_id"] as? String
                        {
                            print("artistId  : \(artistId)")
                        }
                    }
                }
                else
                {
                    print("not availabl")
                }
                
                
                
                // Load a reference to the storyboard and grab a reference to the navigation controller
                //let navC = self.window!.rootViewController!.navigationController
                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // create the destination view controller
                //let nextVC = storyboard.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
                // route to it!
                //navC?.setViewControllers([nextVC], animated: true)
            }
        })

    }
    // Respond to URI scheme links
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // For Branch to detect when a URI scheme is clicked
        Branch.getInstance().handleDeepLink(url)
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
        return true
    }
    // Respond to Universal Links
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        // For Branch to detect when a Universal Link is clicked
        Branch.getInstance().continueUserActivity(userActivity)
        return true
    }

    
    func callStatus(call:CTCall)
    {
        
        //callCenter.callEventHandler = { (call:CTCall!) in
        
        switch call.callState
        {
        case CTCallStateConnected:
            
            print("CTCallStateConnected")
            
        case CTCallStateDialing:
            print("CTCallStateDialing")
            
        case CTCallStateIncoming:
            
            print("CTCallStateIncoming")
            
        case CTCallStateDisconnected:
            print("CTCallStateDisconnected")
            
            if appDelegate.playerView != nil
            {
                if appDelegate.playerView.btnPlay.selected
                {
                    appDelegate.player.play()
                    print("play")
                }
            }
            
        default:
            //Not concerned with CTCallStateDialing or CTCallStateIncoming
            print("****************")
            break
            //}
        }
    }

    func applicationWillResignActive(application: UIApplication)
    {
        self.backgroundUpdateTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(
        {
            // self.endBackgroundUpdateTask()
        })

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication)
    {
        self.enableAudioInBackground()
        if (appDelegate.player.currentItem != nil)
        {
            let currentItem = appDelegate.player.currentItem?.asset as? AVURLAsset
            if (currentItem != nil)
            {
                if (self.playerView != nil)
                {
                    self.playerView.configNowPlayingCenter(currentItem!)
                }
            }
        }

        // application.applicationIconBadgeNumber = 0
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       // setAllObjectToUserDefault()
    }
    
    func applicationWillEnterForeground(application: UIApplication)
    {
        checkForDownload()
        application.applicationIconBadgeNumber = 0
        self.endBackgroundUpdateTask()
        
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    func checkForDownload()
    {
        for (key, value) in appDelegate.trackDownloadDictionary
        {
            print("appDelegate.trackDownloadDictionary \(key) -> \(value)")
            
            startDownload(value as! Track)
        }
        
    }
    func applicationDidBecomeActive(application: UIApplication)
    {
        // Remove the "afterResume" Flag after the app is active again.
        self.applicationStatus = false
        let saveResult2: JSON = BaseVC.sharedInstance.loadJSON( Constants.userDefault.userProfileInfo)
        if (saveResult2 != nil)
        {
             BaseVC.sharedInstance.getUserProfile()
        }
        //Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        BaseVC.sharedInstance.checkRateView()
        
        
        let saveResult: JSON = BaseVC.sharedInstance.loadJSON( Constants.userDefault.userProfileInfo)
        if (saveResult != nil)
        {
            let usertype = saveResult[0]["userType"].intValue
            if usertype == 2
            {
                let isSubscriptionExpired = saveResult[0]["isSubscriptionExpired"].stringValue
                if isSubscriptionExpired == "1"
                {
                    BaseVC.sharedInstance.logOut()
                }
            }
        }
    }
    
    func applicationWillTerminate(application: UIApplication)
    {
        application.applicationIconBadgeNumber = 0
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func getallLocalTracks()
    {
        // Load songs
        let query = MPMediaQuery.songsQuery()
        // Only Media type music
        // Include iCloud item
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        
        if let collections = query.collections
        {
            for i in 0..<collections.count
            {
                let trackDetails : MPMediaItem = collections[i].representativeItem!
               //print("trackDetails = \(trackDetails)")
            }
        }
    }
    func callAlbumDetails(albumIDstr : String)
    {
        appDelegate.selectedAlbumId = albumIDstr
        appDelegate.isFromExplore = true
        let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
        if saveResult != nil
        {
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : AlbumDetailsVC = storyboard.instantiateViewControllerWithIdentifier("AlbumDetailsVC") as! AlbumDetailsVC
            //let navigationController = UINavigationController(rootViewController: vc)
            vc.isFromSharing = true
            self.navigationController?.navigationBar.hidden = true
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
            //self.navigationController?.pushViewController(vc, animated: true)
            //self.loadNavigationControllerToWindow()
            //self.loadFirstViewController("AlbumDetailsVC")
        }
        else
        {
            if((NSUserDefaults.standardUserDefaults().valueForKey("isFirstTime") != nil))
            {
                self.loadFirstViewController("LoginVC") // for loading first view controller
            }
            else
            {
                self.loadFirstViewController("WelcomeVC") // for loading first view controller
            }
        }
    }
    
    // MARK: - Application Supporting Funcations -
    func loadFirstViewController(viewController: String)
    {
        // for loading first view Controller
        let storyBoard = appDelegate.AppStoryBoard()
        /////////////////////////Add Navigation Controller and set Root View Controller///////////////////////////////////////
        let object = storyBoard.instantiateViewControllerWithIdentifier(viewController) // for prelogin navigation
        self.navigationController = UINavigationController(rootViewController: object)
        self.navigationController?.navigationBar.hidden = true
        self.loadNavigationControllerToWindow()
    }
    
    func loadNavigationControllerToWindow()
    {
        if self.window == nil
        {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        }
        // for loading root view
        self.window!.rootViewController = self.navigationController!
        self.window!.makeKeyAndVisible()
    }
   
    func initAPP()
    {
        BaseVC.sharedInstance.DLog("DD path = \(BaseVC.sharedInstance.getDocumentsDirectory())")
       // self.setStatusBar() // To status Bar Style

        //self.loadFirstViewController("SearchForMusicVC")
       // self.loadViewController()
        //self.addDelay() // for delay splash screen
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                        {
                           // Any Large Task
                            // your function here
                            
                            self.checkInternet() // for checking Internet
                            //self.registerForPushNotification() // for push notification registration
                            self.loadKeyboardManager() // for manage keyboard
                            self.addFabric() // to provide adhoc test build
                            BaseVC.sharedInstance.getCountries()
                            //BaseVC.sharedInstance.getInAppList2()// to get all country List
                            //self.playlistVC.showMenu(false)
                            //self.otherLogs()
                            // self.startUpdatingLocationInterval() // for updating location
                            //self.addBackgroundToWindow()
                            // printFonts()  // for printing font name
                            //appDelegate.playlistVC.reloadPlaylist()
                            self.enableAudioInBackground()
                            //getallLocalTracks()
                            
                            self.completeIAPTransactions()
                            dispatch_async(dispatch_get_main_queue(),
                            {
                               // Update UI in Main thread
                                self.makeAnimatedWebview()

                            });
                        }
       
    }
    
    func makeAnimatedWebview()
    {
        let path: String = NSBundle.mainBundle().pathForResource(animatedImageSVG, ofType: "svg")!
        
        let url: NSURL = NSURL.fileURLWithPath(path)  //Creating a URL which points towards our path
        //Creating a page request which will load our URL (Which points to our path)
        let request: NSURLRequest = NSURLRequest(URL: url)
        self.animatedLoaderWebView.loadRequest(request)
        self.animatedLoaderWebView.scrollView.scrollEnabled = false
        self.animatedLoaderWebView.opaque = false
        self.animatedLoaderWebView.backgroundColor = UIColor.clearColor()
        //BaseVC.sharedInstance.showLoader()
    }
    
    func enableAudioInBackground()
    {
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .DefaultToSpeaker)
        }
        catch
        {
            NSLog("Failed to set audio session category.  Error: \(error)")
        }
    }
    
    func loadViewController()
    {
        let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
        if saveResult != nil
        {
            appDelegate.appToken = saveResult[kAPIToken].stringValue
            self.distopiaUserType = .Artist
            self.loadFirstViewController("MenuVC") // for loading first view controller
           

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                        {
                           // Any Large Task
                            BaseVC.sharedInstance.loadCategory()

                            BaseVC.sharedInstance.getCountries()
                            BaseVC.sharedInstance.getUserProfile()
                            BaseVC.sharedInstance.getArtistAlbumListAPIForExplore()

                            dispatch_async(dispatch_get_main_queue(),
                            {
                               // Update UI in Main thread
                            });
                        }
        }
        else
        {
            if((NSUserDefaults.standardUserDefaults().valueForKey("isFirstTime") != nil))
            {
                self.loadFirstViewController("LoginVC") // for loading first view controller
            }
            else
            {
                self.loadFirstViewController("WelcomeVC") // for loading first view controller
            }
        }
    }
    
    
    func addDelay()
    {
        // for delay splash screen
        NSThread.sleepForTimeInterval(0.2)
    }
    
    func checkInternet()
    {
        // for checking Internet
        self.isNetworkReachable = self.isConnectedToNetwork()
        self.addRechabilityObserver()
    }
    
    func setStatusBar()
    {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent,animated: true )
    }
    
    func registerForPushNotification()
    {
        // for push notification registration
        let userNotificationType : UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge]
        let settings = UIUserNotificationSettings(forTypes: userNotificationType, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func loadKeyboardManager()
    {
        // KeyBoad Manager
        //Enabling keyboard manager
        IQKeyboardManager.sharedManager().enable = true
        
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 15
        
        //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
        IQKeyboardManager.sharedManager().toolbarManageBehaviour = IQAutoToolbarManageBehaviour.BySubviews
        
        //Resign textField if touched outside of UITextField/UITextView.
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        //Giving permission to modify TextView's frame
        IQKeyboardManager.sharedManager().canAdjustTextView = true
    }
    
    func addFabric()
    {
        // to provide adhoc test build
        Fabric.with([Crashlytics.self, Branch.self])
    }
    
    func getDocumentDirectoryPath()-> String
    {
        ////////////////////////////////////////////////////////////////
        //_ = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0]
        let path = NSHomeDirectory() + "/Documents"
        return path
    }
    
    func otherLogs()
    {
        if self.isNetworkReachable
        {
            BaseVC.sharedInstance.DLog("Network is Reachable")
        }
        else
        {
            BaseVC.sharedInstance.DLog("Network is Reachable")
        }
        BaseVC.sharedInstance.DLog(self.getDocumentDirectoryPath())
        //self.logAllFonts()
    }
    
    func addBackgroundToWindow()
    {
        // //////////////////////////////////////////////////////////////
        //        let imageName = "backgroundBlack"
        //        let image = UIImage(named: imageName)
        //        let imageView = UIImageView(image: image!)
        //        imageView.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
        //        self.window!.addSubview(imageView)
        let overlayImage = UIView()
        overlayImage.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
        overlayImage.backgroundColor = UIColor.clearColor()
        self.window!.addSubview(overlayImage)
    }
    
   
    // MARK: - Reachability -
    func isConnectedToNetwork() -> Bool
    {
        //for connecting network
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func addRechabilityObserver()
    {
        //For Checking Internet Connectivity
        
        do
        {
            self.reachability = try Reachability.reachabilityForInternetConnection()
        }
        catch
        {
            BaseVC.sharedInstance.DLog("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(AppDelegate.reachabilityChanged(_:)),
                                                         name: ReachabilityChangedNotification,
                                                         object: reachability)
        
        do
        {
            try self.reachability.startNotifier()
        }
        catch
        {
            BaseVC.sharedInstance.DLog("Unable to start notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification)
    {
        //For Checking Internet reachability
        let reachability = note.object as! Reachability
        
        if reachability.isReachable()
        {
            if reachability.isReachableViaWiFi()
            {
                BaseVC.sharedInstance.DLog("Reachable via WiFi")
            }
            else
            {
                BaseVC.sharedInstance.DLog("Reachable via Cellular")
            }
            checkForDownload()
            self.isNetworkReachable = true
            
        }
        else
        {
            BaseVC.sharedInstance.DLog("Not reachable")
            self.isNetworkReachable = false
        }
    }
    
    func stopRechabilityNotification()
    {
        self.reachability.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self,name: ReachabilityChangedNotification,object: self.reachability)
    }
    
    func endBackgroundUpdateTask()
    {
        UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    
    // MARK: - Push Notification Delegate -
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        // registration for remote notification  with device token
        
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        let deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString(" ", withString: "") as String
        
        if !deviceTokenString.isEmpty
        {
            self.deviceToken = deviceTokenString
            BaseVC.sharedInstance.setUserDefaultBoolFromKey(kAPIAgreeToPushNotifications, value: true)
            BaseVC.sharedInstance.setUserDefaultStringFromKey(kAPIDevicePushNotificationToken, value: deviceTokenString)
        }
        
        BaseVC.sharedInstance.DLog("DeviceToken = [\(deviceTokenString)]")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        // for fail to register for remote notification
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_PUSH_UPDATE, object: self)
        
        if error.code == 3010 {
            BaseVC.sharedInstance.DLog("Push notifications did not support on the iOS simulator")  //simulator does not allow Push Notification
        } else {
            BaseVC.sharedInstance.DLog("Error in register for remote notifications : \(error.localizedDescription)")
        }
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    {
        // register user notofication settiing
        var value : String = String()
        
        value = BaseVC.sharedInstance.getUserDefaultStringFromKey(USER_DEFAULT_PUSH_NOTIFICATION_PERMISSION_ALERT)
        
        if !value.isEmpty
        {
            var isAllowPushNotifiaction : Bool = false
            
            if UIApplication.sharedApplication().isRegisteredForRemoteNotifications() {
                BaseVC.sharedInstance.DLog("registered for remote notifications")
                
                let types = UIApplication.sharedApplication().currentUserNotificationSettings()?.types
                
                if let type = types
                {
                    if type == .None
                    {
                        isAllowPushNotifiaction = false
                    }
                    else
                    {
                        isAllowPushNotifiaction = true
                    }
                }
            }
            
            if isAllowPushNotifiaction
            {
                // Allow Push Notification
            }
            else
            {
                // Don't Allow Push Notification
            }
        }
        else
        {
            BaseVC.sharedInstance.DLog("Not started push notification")
        }
        
        
    }
    
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        //self.pushNotificationAction(userInfo)
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        // receiving notification
        
        BaseVC.sharedInstance.DLog("received : \(userInfo)")
        
        //application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1; // counter
      
        
    }
    
    func pushNotificationAction(notificationDict:[NSObject:AnyObject])
    {
        return
        BaseVC.sharedInstance.DLog("\(notificationDict)")
        
        let alert = UIAlertView()
        alert.title = ALERT_TITLE
        alert.message = "\(notificationDict)"
        alert.addButtonWithTitle("Dismiss")
        //alert.show()
        
        if let notificationDic = notificationDict["aps"] as? [NSObject:AnyObject]
        {
            if let notificationId = notificationDic["notificationTypeId"] as? Int
            {
                if notificationId == 2 //accept request
                {
                    
//                    let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
//                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
//                        // your function here
//                        DLog("---------------- > Notification Post")
//                        
////                        if (!(self.navigationController?.topViewController?.isKindOfClass(HomeScreenViewController))!)
////                        {
////                            self.loadFirstViewController("HomeScreenViewController")
////                        }
////                        NSNotificationCenter.defaultCenter().postNotificationName("notificationReceived", object: notificationDict)
//
//                    })
                    
                }
            }
        }
        
    }
    
    // MARK: StoryBoard
    func AppStoryBoard()->UIStoryboard
    {
        // for storyboard identification
        var appStoryBoard:UIStoryboard!
        
        BaseVC.sharedInstance.DLog("UserType = \(distopiaUserType.rawValue)")
        
        switch (distopiaUserType)
        {
        case .Artist:
            appStoryBoard = STORY_BOARD_MAIN
            break;
        case .Fan:
            appStoryBoard = STORY_BOARD_MAIN
            break;
        case .None:
            appStoryBoard = STORY_BOARD_PRELOGIN
            break;
        }
        return appStoryBoard
    }
    
    func getShoppingCartItemCount()
    {
        let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
        if saveResult != nil
        {
            API.getViewshoppingcart(nil, aViewController: (self.navigationController?.visibleViewController)!) { (result: JSON) in
                
                if ( result != nil )
                {
                    // BaseVC.sharedInstance.DLog("#### getViewshoppingcart API Response: \(result)")
                    self.shoppingCartItemCount = result.count
                }
                NSNotificationCenter.defaultCenter().postNotificationName("updateCart", object: nil)
            }
        }
    }
   
    func completeIAPTransactions() {
        
        SwiftyStoreKit.completeTransactions() { completedTransactions in
            
            for completedTransaction in completedTransactions {
                
                if completedTransaction.transactionState == .Purchased || completedTransaction.transactionState == .Restored {
                    
                    print("purchased: \(completedTransaction.productId)")
                }
            }
        }
    }
}
