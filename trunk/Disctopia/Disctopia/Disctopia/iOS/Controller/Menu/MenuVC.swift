//
//  MenuVC.swift
//  Disctopia
//
//  Created by Damini on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var usertype:Int = Int()

class MenuVC: BaseVC {
    
    @IBOutlet var menuView: UIView!
    var options: PagingMenuControllerCustomizable!
    
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    var deletePlaylistFrame = CGRect.zero


    //let transition = PopAnimator()
     @IBOutlet  var imgMenuTop: UIImageView!
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var onOptionClickBtn: UIButton!
    
    override func viewDidLoad()
    {
        
    
        super.viewDidLoad()
        self.webView.hidden = true
        appDelegate.isLoderRequired = true
       
        onOptionClickBtn.exclusiveTouch = true
        // self.loadDisctopiaLoader()
        // Do any additional setup after loading the view.
        appDelegate.selectedPlaylistId = Dictionary()
        
        self.originFrame = CGRectMake(self.onOptionClickBtn.frame.origin.x, self.onOptionClickBtn.frame.origin.y, self.onOptionClickBtn.frame.width, self.onOptionClickBtn.frame.height)
        
        let profile : JSON =  self.loadJSON(Constants.userDefault.userProfileInfo)
        self.DLog("Saved userProfile: \(profile)")
        if profile.count > 0
        {
            usertype = profile[0]["userType"].intValue
        }
        
        
        
        //let timer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: Selector(self.callArtistAlbum()), userInfo: nil, repeats: true)
        //let timer2 = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: Selector(self.callAlbumDetails()), userInfo: nil, repeats: true)
        
//        if appDelegate.isFromSharing == 1
//        {
//            self.callAlbumDetails()
//        }
//        else if appDelegate.isFromSharing == 2
//        {
//            self.callArtistAlbum()
//        }
        
    }
    
    func callArtistAlbum()
    {
        appDelegate.isFromSharing = 0
        let otherData = "{\n  \"city\" : \"alg\",\n  \"state\" : \"CA\",\n  \"aboutMe\" : \"my story\",\n  \"contactMe\" : null,\n  \"country\" : \"US\",\n  \"totalAlbum\" : 3,\n  \"artistNameSEO\" : \"dinesh\",\n  \"middleInitial\" : null,\n  \"firstName\" : \"dinesh\",\n  \"artistCategoryId\" : null,\n  \"lastName\" : \"m\",\n  \"instagram\" : \"INS\",\n  \"userId\" : \"24ab6913-f62e-42ea-95f9-dd358490f201\",\n  \"address2\" : \"california\",\n  \"user_image\" : \"dinesh\\/color-taj-sample-colorize(1).jpg\",\n  \"dateOfBirth\" : \"1989-10-12T00:00:00\",\n  \"artistName\" : \"dinesh\",\n  \"zipCode\" : \"7896\",\n  \"twitter\" : \"TWitt\",\n  \"address1\" : \"california\",\n  \"user_url\" : \"https:\\/\\/s3-us-west-2.amazonaws.com\\/devdisctopia-audio\\/dinesh\\/color-taj-sample-colorize(1).jpg\",\n  \"inBand\" : null,\n  \"disctopiaID\" : \"D673236153\",\n  \"sex\" : null\n}"
        
        // dic.setValue(self.artistListArray[i].rawString(), forKey: "otherData")
        let dic = NSMutableDictionary()
        dic.setValue("0", forKey: "isLocal")
        dic.setValue(otherData, forKey: "otherData")
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ArtistAlbumsVC = storyboard.instantiateViewControllerWithIdentifier("ArtistAlbumsVC") as! ArtistAlbumsVC
        vc.isFromLibraryArtist = true
        vc.artistAlbumDict = dic as? NSMutableDictionary
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        appDelegate.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
    }
    func callAlbumDetails()
    {
        appDelegate.isFromSharing = 0
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : AlbumDetailsVC = storyboard.instantiateViewControllerWithIdentifier("AlbumDetailsVC") as! AlbumDetailsVC
        //let navigationController = UINavigationController(rootViewController: vc)
        vc.isFromSharing = true
        self.navigationController?.navigationBar.hidden = true
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        //self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
        
    }
    func loadDisctopiaLoader()
    {
         /*
         let loaderHight = UIScreen.mainScreen().bounds.width / 2.0
         appDelegate.animatedLoaderWebView.frame = CGRectMake(0, 0, loaderHight, loaderHight) //self.view.frame
         appDelegate.animatedLoaderWebView.opaque = false
         appDelegate.animatedLoaderWebView.backgroundColor = UIColor.clearColor()
         appDelegate.animatedLoaderWebView.center = self.view.center
         self.view.addSubview(appDelegate.animatedLoaderWebView)
         */
        
        //appDelegate.animatedLoaderWebView.frame = self.webView.frame
        //self.webView = appDelegate.animatedLoaderWebView
       
         self.webView.hidden = true
        
        let path: String = NSBundle.mainBundle().pathForResource(animatedImageSVG, ofType: "svg")!
        let url: NSURL = NSURL.fileURLWithPath(path)  //Creating a URL which points towards our path
        
        //Creating a page request which will load our URL (Which points to our path)
        let request: NSURLRequest = NSURLRequest(URL: url)
        self.webView.loadRequest(request)  //Telling our webView to load our above request
         self.webView.scrollView.scrollEnabled = false
        self.webView.backgroundColor = UIColor.blueColor()
        //self.loadPageMenu()
    }
    
    override  func viewDidLayoutSubviews()
    {
        self.showLoader()
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
                       {
            self.loadPageMenu()
            self.hideLoader()
        })
    }
   
    override func viewWillAppear(animated: Bool)
    {
         onOptionClickBtn.exclusiveTouch = true
        super.viewWillAppear(true)
        self.DLog("WillAppear MenuVC")
        
        for subview: UIView in self.view!.subviews
        {
            if subview.tag == 100
            {
                subview.removeFromSuperview()
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuVC.addOptionEditPlaylist), name:"addOptionEditPlaylist", object: nil)
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuVC.deletePlaylistClicked(_:)), name:"deletePlaylistClicked", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuVC.deletePlayistOptionNoClicked(_:)), name:"deletePlayistOptionNoClicked", object: nil)//Open PlaylistOptionListVC when No Clicked
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuVC.deletePlayistOptionYesClicked(_:)), name:"deletePlayistOptionYesClicked", object: nil)//Open PlaylistOptionListVC when No Clicked

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuVC.methodOfReceivedNotification1(_:)), name:"NotificationIdentifier1", object: nil)//OptionMenuVC to SearchForMusicVC
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuVC.methodOfReceivedNotification2(_:)), name:"NotificationIdentifier2", object: nil)//SearchForMusicVC to OptionMenuVC
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
       self.DLog("WillDisappear MenuVC")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        self.DLog("DidAppear MenuVC")
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        self.DLog("DidDisappear MenuVC")
    }
    
    class func instantiateFromStoryboard() -> SettingsMenuVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SettingsMenuVC
    }
   
    func addOptionEditPlaylist()
    {
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("PlaylistOptionListVC") as! PlaylistOptionListVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        
        //herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewControllerPlaylist(self, toViewController: herbDetails)
        //herbDetails.endAppearanceTransition()
    }
    
    func addOptionDeletePlaylist()
    {
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("PlaylistOptionListVC") as! PlaylistOptionListVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        
        //herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewControllerPlaylist(self, toViewController: herbDetails)
        //herbDetails.endAppearanceTransition()
    }
   
    func loadPageMenu()
    {
        //self.hideLoader()
        if (appDelegate.pagingMenuController == nil)
        {
            options =  PagingMenuOptionsSujal()
            appDelegate.pagingMenuController = PagingMenuController(options: options)
            //let pagingMenuController = self.childViewControllers.first as! PagingMenuController
            appDelegate.pagingMenuController.delegate = self
            appDelegate.pagingMenuController.setup(options)
            self.addChildViewController(appDelegate.pagingMenuController)
            self.menuView.translatesAutoresizingMaskIntoConstraints = false
            appDelegate.pagingMenuController.view.frame = self.menuView.frame
            self.menuView.backgroundColor = UIColor.clearColor()
            //CGRectMake(0, 100,pagingMenuController.view.frame.size.width, pagingMenuController.view.frame.size.height - 100)
            appDelegate.pagingMenuController.view.backgroundColor = UIColor.clearColor()
            self.view.addSubview(appDelegate.pagingMenuController.view)
            DLog("pagingMenuController.view = \(appDelegate.pagingMenuController.view)")
            //pagingMenuController.didMoveToParentViewController(self)
        }

        if appDelegate.isFromSharing == 1
        {
            self.callAlbumDetails()
        }
    }
    
    @IBAction func onOptionClick(sender: AnyObject)
    {
        onOptionClickBtn.userInteractionEnabled = false
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
        
        //onOptionClickBtn.userInteractionEnabled = true
    }
    
    @IBAction func onSearchClick(sender: AnyObject)
    {
        let aSearchForMusicVC = storyboard!.instantiateViewControllerWithIdentifier("SearchForMusicVC") as! SearchForMusicVC
        aSearchForMusicVC.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        aSearchForMusicVC.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: aSearchForMusicVC)
        aSearchForMusicVC.endAppearanceTransition()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func cycleFromViewControllerPlaylist(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.view!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        
        //let thisView = oldViewController.view
        let toView = newViewController.view
        
        let herbView = newViewController.view
        
        var frame = CGRect.zero
        
        frame = appDelegate.playlistFrame
        
        
        let initialFrame = self.presenting ? frame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : frame
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if self.presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            herbView.clipsToBounds = true
            
            self.view.addSubview(toView)
            self.view.bringSubviewToFront(herbView)
        }
        
        UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                y: CGRectGetMidY(finalFrame))
            
            /*UIView.animateWithDuration(0.3, delay:0.0,
             usingSpringWithDamping: 0.0,
             initialSpringVelocity: 0.0,
             options: [],
             animations: {
             herbView.transform = self.presenting ?
             CGAffineTransformIdentity : scaleTransform
             
             herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
             y: CGRectGetMidY(finalFrame))
             
             }, completion:{_ in
             newViewController.didMoveToParentViewController(self)
             })
             }, completion: { finished in
             
             //newViewController.didMoveToParentViewController(self)
             })*/
            },
                                            
                                            completion: { finished in
                                                
                                                newViewController.didMoveToParentViewController(self)
        })
    }

    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController)
    {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.view!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        
        //let thisView = oldViewController.view
        let toView = newViewController.view
        
        let herbView = newViewController.view
        
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : self.originFrame
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if self.presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            herbView.clipsToBounds = true
            
            self.view.addSubview(toView)
            self.view.bringSubviewToFront(herbView)
        }
        
        UIView.animateKeyframesWithDuration(0.36, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
            self.onOptionClickBtn.userInteractionEnabled = true
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                y: CGRectGetMidY(finalFrame))
            
            },completion: { finished in
                newViewController.didMoveToParentViewController(self)
        })
    }
    
    
    func deletePlaylistClicked(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("deletePlaylistClicked called")
        
        let optionVC = storyboard!.instantiateViewControllerWithIdentifier("deleteYesNoViewController") as! deleteYesNoViewController
        optionVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(optionVC)
        self.addSubview(optionVC.view, toView: self.view)
        
        self.deletePlaylistFrame = (notification.object?.frame)!
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            optionVC.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
        })
        
    }
    
    
    
    func deletePlayistOptionNoClicked(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("deletePlayistOptionNoClicked called")
        
        let optionVC = storyboard!.instantiateViewControllerWithIdentifier("PlaylistOptionListVC") as! PlaylistOptionListVC
        optionVC.view.translatesAutoresizingMaskIntoConstraints = false;
        optionVC.deletePlaylistFrame = self.deletePlaylistFrame
        optionVC.isFromNo = true
        
        self.addChildViewController(optionVC)
        self.addSubview(optionVC.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            optionVC.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //NSNotificationCenter.defaultCenter().postNotificationName("animationViewOnDeletePlaylist", object: nil)
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
        })
        
    }
    
    
    func deletePlayistOptionYesClicked(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("deletePlayistOptionYesClicked called")
        
        let playlistDeletedVC = storyboard!.instantiateViewControllerWithIdentifier("PlaylistDeletedVC") as! PlaylistDeletedVC
        playlistDeletedVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChildViewController(playlistDeletedVC)
        self.addSubview(playlistDeletedVC.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            playlistDeletedVC.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //NSNotificationCenter.defaultCenter().postNotificationName("animationViewOnDeletePlaylist", object: nil)
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
        })
        
    }

    
    func methodOfReceivedNotification1(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification1 called")
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("SearchForMusicVC") as! SearchForMusicVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //herbDetails.beginAppearanceTransition(true, animated: true)
        //herbDetails.endAppearanceTransition()
        
        self.addChildViewController(herbDetails)
        self.addSubview(herbDetails.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            herbDetails.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
                                    self.didMoveToParentViewController(self)
        })
        
    }
    
    func methodOfReceivedNotification2(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification2 called")
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //herbDetails.beginAppearanceTransition(true, animated: true)
        //herbDetails.endAppearanceTransition()
        
        self.addChildViewController(herbDetails)
        self.addSubview(herbDetails.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            herbDetails.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
                                    //self.didMoveToParentViewController(self)
        })
        
    }
}

extension MenuVC: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        
        DLog("1 menuController \(menuController.dynamicType)")
        //options =  PagingMenuOptionsSujal()
        //appDelegate.pagingMenuController = PagingMenuController(options: options)
        //appDelegate.pagingMenuController.setup(options)
        
        if menuController.dynamicType == ExploreVC.self //MyMusicExploreVC.self
        {
             appDelegate.isFromExplore = true
            
            //imgMenuTop.image = UIImage(named: "topbar_green.png")
            self.manageMenu(false)
            let saveExploreCategoryResult : JSON =  BaseVC.sharedInstance.loadJSON("exploreCategoryList")
            //self.DLog("saveExploreCategoryResult = \(saveExploreCategoryResult)")
           
            if saveExploreCategoryResult != nil
            {
                if saveExploreCategoryResult.count > 0
                {
                    //self.pushToViewControllerIfNotExistWithClassName("ExploreVC", animated: false)
                    if let aExploreVC = menuController as? ExploreVC
                    {
                        aExploreVC.showMenu(true)
                    }
                }
            }
           
        }
        else if menuController.dynamicType == PlaylistVC.self //MyMusicPlaylistVC.self
        {
            appDelegate.isFromExplore = false
            imgMenuTop.image = UIImage(named: "topbar_blue.png")
            self.manageMenu(false)
            if let aPlaylistVC = menuController as? PlaylistVC
            {
                aPlaylistVC.showMenu(true)
            }
            //self.pushToViewControllerIfNotExistWithClassName("PlaylistVC", animated: false)
        }
        else if menuController.dynamicType == SettingsMenuVC.self
        {
             appDelegate.isFromExplore = false
            self.manageMenu(false)
            //self.pushToViewControllerIfNotExistWithClassName("SettingsMenuVC", animated: false)
        }
        else
        {
             appDelegate.isFromExplore = false
             imgMenuTop.image = UIImage(named: "topbar_blue.png")
            self.manageMenu(true)
        }

//        DLog("menuController \(menuController.dynamicType)")
//        if menuController.dynamicType == MyMusicExploreVC.self
//        {
//            self.pushToViewControllerIfNotExistWithClassName("ExploreVC", animated: true)
//        }
//        else if menuController.dynamicType == MyMusicPlaylistVC.self
//        {
//            self.pushToViewControllerIfNotExistWithClassName("PlaylistVC", animated: true)
//        }
//        else if menuController.dynamicType == SettingsMenuVC.self
//        {
//            self.pushToViewControllerIfNotExistWithClassName("SettingsMenuVC", animated: true)
//        }
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController)
    {
        DLog("2 menuController \(menuController.dynamicType)")
    }
    
    func willMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView)
    {
        menuItemView.alpha = 0.5
        previousMenuItemView.alpha = 0.5
    }
    
    func didMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView)
    {
        menuItemView.alpha = 1.0
        previousMenuItemView.alpha = 0.5
    }
    
    func manageMenu(isShow:Bool)
    {
        let isShow = true
        if isShow
        {
            appDelegate.pagingMenuController.menuView!.hidden = false
            appDelegate.pagingMenuController.view.frame = CGRectMake(appDelegate.pagingMenuController.view.frame.origin.x, 60.0, appDelegate.pagingMenuController.view.frame.size.width, UIScreen.mainScreen().bounds.height - 60.0)
            //appDelegate.pagingMenuController.view.frame = CGRectMake(appDelegate.pagingMenuController.view.frame.origin.x, appDelegate.pagingMenuController.menuView!.frame.size.height * 1, appDelegate.pagingMenuController.view.frame.size.width, appDelegate.pagingMenuController.view.frame.size.height - appDelegate.pagingMenuController.menuView!.frame.size.height)
        }
        else
        {
            appDelegate.pagingMenuController.view.frame = CGRectMake(appDelegate.pagingMenuController.view.frame.origin.x, -50.0, appDelegate.pagingMenuController.view.frame.size.width, UIScreen.mainScreen().bounds.height + 50)
            appDelegate.pagingMenuController.menuView!.hidden = true
        }
    }
}

private var pagingControllers: [BaseVC]
{
    let verificationCodeViewController1 = LibraryVC.instantiateFromStoryboard()
    let verificationCodeViewController2 = appDelegate.playlistVC // MyMusicPlaylistVC.instantiateFromStoryboard()
    //let verificationCodeViewController3 = LibraryVC.instantiateFromStoryboard()
    let verificationCodeViewController3 = UploadVC.instantiateFromStoryboard()
    let verificationCodeViewController4 = ExploreVC.instantiateFromStoryboard()//MyMusicExploreVC.instantiateFromStoryboard()
    
    //return [verificationCodeViewController1, verificationCodeViewController2, verificationCodeViewController3, verificationCodeViewController4]
    
    if usertype == 1
    {
        return [verificationCodeViewController1, verificationCodeViewController2, verificationCodeViewController4]
    }
    else
    {
        return [verificationCodeViewController1, verificationCodeViewController2, verificationCodeViewController3, verificationCodeViewController4]
    }
}

struct MenuItem1: MenuItemViewCustomizable {}
struct MenuItem2: MenuItemViewCustomizable {}
struct MenuItem3: MenuItemViewCustomizable {}
struct MenuItem4: MenuItemViewCustomizable {}

struct PagingMenuOptionsSujal: PagingMenuControllerCustomizable {
   
    var componentType: ComponentType {
        return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    var lazyLoadingPage: LazyLoadingPage {
        return .Three
    }
    
    var menuControllerSet: MenuControllerSet {
        return .Multiple
    }
   
    struct MenuOptions: MenuViewCustomizable {
        
        var backgroundColor: UIColor {
            return UIColor.clearColor()
        }
        var selectedBackgroundColor: UIColor {
            return UIColor.clearColor()
        }
        
        var displayMode: MenuDisplayMode {
            return .Infinite(widthMode: .Fixed(width: 60.0), scrollingMode: .ScrollEnabled)
        }
        var itemsOptions: [MenuItemViewCustomizable]
        {
            if usertype == 1
            {
                return [MenuItem1(), MenuItem2(), MenuItem4()]
            }
            else
            {
                return [MenuItem1(), MenuItem2(), MenuItem3(), MenuItem4()]
            }
            
        }
        var focusMode: MenuFocusMode
        {
            return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(red: 0.0 / 255, green:0.0 / 255, blue: 0.0 / 255, alpha: 0.3))
           
            if appDelegate.isFromExplore
            {
                return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(red: 70.0 / 255, green: 139.0 / 255, blue: 60.0 / 255, alpha: 1.0))
            }
            else
            {
                return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(red: 49.0 / 255, green: 101.0 / 255, blue: 210.0 / 255, alpha: 1.0))
            }
        }
        
    }
    
    struct MenuItem1: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Music")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
//        var menuItemText: MenuItemText {
//            return MenuItemText(text: "explore", color: UIColor.whiteColor(), selectedColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(16), selectedFont: UIFont.boldSystemFontOfSize(16))
//        }
    }
    
    struct MenuItem2: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Playlists")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
        

    }
    
    struct MenuItem3: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Uploads")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
        

    }
    
    struct MenuItem4: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Explore")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
    }
    
}

//extension MenuVC: UIViewControllerTransitioningDelegate {
//    func animationControllerForPresentedController(
//        presented: UIViewController,
//        presentingController presenting: UIViewController,
//                             sourceController source: UIViewController) ->
//        UIViewControllerAnimatedTransitioning? {
//            
//            transition.originFrame = onOptionClickBtn.superview!.convertRect(onOptionClickBtn!.frame, toView: nil)
//            transition.presenting = true
//            
//            return transition
//            
//    }
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.presenting = false
//        return transition
//    }
//    
//}

