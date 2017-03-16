//
//  PlaylistVC.swift
//  Disctopia
//
//  Created by Damini on 08/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import MediaPlayer
import Crashlytics

var syncPlaylistArray = NSMutableArray()

//struct PlaylistItemCustom: MenuItemViewCustomizable {}
//
//var arrStruct = [
//    PlaylistItemCustom()
//]
//var arrStruct = [
//    PlaylistItemCustom()
//]

var arrStruct1 : [MenuItemViewCustomizable] = []

class PlaylistVC: BaseVC,ACTabScrollViewDelegate,ACTabScrollViewDataSource
{
    var playlists: [MPMediaPlaylist] = []
    var playListArray : [JSON] = []
    var currentPlaylistIndex = 0
    @IBOutlet weak var menuTopConstraint: NSLayoutConstraint!
    var pagingMenuController : PagingMenuController! = nil
    var options: PagingMenuControllerCustomizable!
    
    @IBOutlet var playlistView: UIView!
    
    @IBOutlet var tabScrollView: ACTabScrollView!
    
    var playlistVCArray:[UIViewController] = []

    var contentViews : [UIView] = []
    let transition = PopAnimator()
    
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    var deletePlaylistFrame = CGRect.zero
    var isFromSettingBtn = true
    var playlistY : CGFloat = 0.0
    var menuTopConstraintConstant : CGFloat = 0 //71
    @IBOutlet weak var btnSettingClick: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.reloadPlaylist), name:"reloadPlaylist", object: nil)
        
       // initScrollView()
        btnSettingClick.exclusiveTouch = true

        self.showMenu(false)
        initVC()
    }
    
    func reloadPlaylist()
    {
        self.showMenu(true)
        //self.popToRootViewControllerAnimated(false)
        //appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
        initVC()
    }
   
    func initVC()
    {
        syncPlaylistArray.removeAllObjects()
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // your function here
            
            //appDelegate.selectedPlaylistId = Dictionary()
           
            // Load playlists
            let query = MPMediaQuery.playlistsQuery()
            //MPMediaItemPropertyMediaType MPMediaItemPropertyReleaseDate
            query.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
            // query.addFilterPredicate(MPMediaPropertyPredicate(value:" ",forProperty: MPMediaItemPropertyReleaseDate))
            query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
            
            if let collections = query.collections
            {
                self.playlists = collections as? [MPMediaPlaylist] ?? []
                
            }
            self.syncPlayList()
            self.getPlayListAPI()
        })
    }
    
    func showMenu(isShow : Bool)
    {
        return
        if (menuTopConstraint != nil)
        {
            if isShow
            {
                menuTopConstraint.constant = menuTopConstraintConstant
            }
            else
            {
                menuTopConstraint.constant = -38.0
            }
        }
        else
        {
            if self.tabScrollView != nil
            {
                var playlistViewRact = self.tabScrollView.frame
                
                if isShow
                {
                    playlistViewRact.origin.y = playlistY
                }
                else
                {
                    playlistViewRact.origin.y = playlistY - 120.0
                }
                
                self.tabScrollView.frame = playlistViewRact
            }
        }
    }

    func initScrollView()
    {
        appDelegate.isSelectFromPlaylist = true

        if tabScrollView == nil
        {
            return
        }
//      all the following properties are optional
        tabScrollView.defaultPage = 0
//      tabScrollView.arrowIndicator = true
        tabScrollView.tabSectionHeight = 38.0
        tabScrollView.changePageToIndex(currentPlaylistIndex, animated: false)
        tabScrollView.tabSectionBackgroundColor = UIColor.clearColor()
        tabScrollView.contentSectionBackgroundColor = UIColor.clearColor()
//      tabScrollView.tabGradient = true
        tabScrollView.pagingEnabled = true
        tabScrollView.cachedPageLimit = 1

        tabScrollView.delegate = self
        tabScrollView.dataSource = self
        playlistY =  self.tabScrollView.frame.origin.y

        //self.showMenu(false)

        
       
        /*
        
        if syncPlaylistArray.count > 1
        {
            let playListDictionary = syncPlaylistArray[1]
            
            let isLocal = playListDictionary["isLocal"] as! String
            appDelegate.isFromPlaylist = true
            if isLocal == "0"
            {
                appDelegate.selectedPlayListDictionary = playListDictionary as! NSMutableDictionary
                let aplayListDict = JSON.parse(playListDictionary["otherData"] as! String)
                appDelegate.selectedPlaylistId = aplayListDict.dictionary!
            }
            else if isLocal == "1"
            {
                appDelegate.selectedPlayListDictionary = playListDictionary as! NSMutableDictionary
            }

        }
         */
        //self.reloadAllPlaylist()
        
        // create content views from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        for childVC in self.childViewControllers
        {
            childVC.removeFromParentViewController()
        }
        
        for i in 0 ..< syncPlaylistArray.count /* number of pages */
        {
            dispatch_async(dispatch_get_main_queue())
            {
                if i == 0
                {
                   
                    if let vc = storyboard.instantiateViewControllerWithIdentifier("createNewPlaylistVC") as? createNewPlaylistVC
                    {
                        /* set somethings for vc */ //PlaylistCategoryVC
                        self.addChildViewController(vc) // don't forget, it's very important
                        self.contentViews.append(vc.view)
                    }
                    
//                    if let vc = storyboard.instantiateViewControllerWithIdentifier("PlaylistCategoryVC") as? PlaylistCategoryVC
//                    {
//                        /* set somethings for vc */ //PlaylistCategoryVC
//                        self.addChildViewController(vc) // don't forget, it's very important
//                        self.contentViews.append(vc.view)
//                    }
                }
                else
                {
                    if let vc = storyboard.instantiateViewControllerWithIdentifier("Playlist1VC") as? Playlist1VC
                    {
                        let playListDictionary = syncPlaylistArray[i]
                        
                        /* set somethings for vc */
                        if let isLocal = playListDictionary["isLocal"] as? String
                        {
                            vc.isLocal = isLocal
                            self.addChildViewController(vc) // don't forget, it's very important
                            self.contentViews.append(vc.view)
                            
                            // appDelegate.isFromPlaylist = true
                            if isLocal == "0"
                            {
                                if let aPlayListDictionary = playListDictionary as? NSMutableDictionary
                                {
//                                 appDelegate.selectedPlayListDictionary = aPlayListDictionary
//                                  self.DLog("appDelegate.selectedPlayListDictionary \(appDelegate.selectedPlayListDictionary)")
                                    
                                    if let otherDataStr = aPlayListDictionary["otherData"] as? String
                                    {
                                        let playListDict = JSON.parse(otherDataStr)
                                        
                                        if playListDict.dictionary != nil
                                        {
                                            appDelegate.selectedPlaylistId = playListDict.dictionary!
                                            vc.playlistDict = playListDict.dictionary!
                                            
                                            
                                            if appDelegate.newPlaylistId == playListDict["playlistId"].stringValue
                                            {
                                               self.currentPlaylistIndex = i
                                            }
                                            else if appDelegate.newPlaylistId == "0"
                                            {
                                                 self.currentPlaylistIndex = 0
                                            }
                                            
                                            if (playListDict["playlistId"].stringValue == BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId")) //"Favourite"
                                            {
                                                
                                                appDelegate.favPlaylist = vc
                                            }
                                        }
//
//                                        if (playListDict["playlistname"].stringValue == "Disctopia Favs") //"Favourite"
//                                        {
//                                            appDelegate.favPlaylist = vc
//                                        }
                                    }
                                }
                            }
                            else if isLocal == "1"
                            {
                                if let aPlayListDictionary = playListDictionary as? NSMutableDictionary
                                {
                                    //appDelegate.selectedPlayListDictionary = aPlayListDictionary
                                    vc.PlayListDictionary = aPlayListDictionary
                                }
                            }
                            vc.initVC()
                            //vc.performSelector(#selector(vc.initVC), withObject: self, afterDelay: 0.02)
                        }
                        else
                        {
                            Crashlytics.sharedInstance().setObjectValue("initScrollView isLocal not found = \(syncPlaylistArray.count)", forKey:"issue3" )
                        }
                    }
                }

            }
        }
 
        dispatch_async(dispatch_get_main_queue()) {
            
            if (syncPlaylistArray.count > 0)
            {
                //self.tabScrollView.layoutSubviews()
                self.tabScrollView.reloadData()
                self.tabScrollView.reloadInputViews()
                self.tabScrollView.changePageToIndex(self.currentPlaylistIndex, animated: true)
            }
            
            //print("syncPlaylistArray count= \(syncPlaylistArray.count)")
            // print("contentViews count= \(self.contentViews.count)")

        }
        Crashlytics.sharedInstance().setObjectValue("syncPlaylistArray count= \(syncPlaylistArray.count)", forKey:"issue4" )
        //
        //self.viewDidLayoutSubviews()
        
    }
    
    func reloadAllPlaylist()
    {
        if syncPlaylistArray.count > 0
        {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                        {
                            self.createAllPlaylistVC()
                           // Any Large Task
                            dispatch_async(dispatch_get_main_queue(),
                            {
                                // Update UI in Main thread

                                for childVC in self.childViewControllers
                                {
                                    childVC.removeFromParentViewController()
                                }

                                for cnt in 0 ..< self.playlistVCArray.count
                                {
                                    if let vc = self.playlistVCArray[cnt] as? Playlist1VC
                                    {
                                        self.addChildViewController(vc)
                                        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                                            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                                                    // Do your task here
                                                    vc.initVC()
                                                })
                                    }
                                    else
                                    {
                                        self.addChildViewController(self.playlistVCArray[cnt])
                                    }
                                }
                                
                                if (self.playlistVCArray.count > 0)
                                {
                                    //self.tabScrollView.layoutSubviews()
                                    self.tabScrollView.reloadData()
                                    self.tabScrollView.reloadInputViews()
                                    self.tabScrollView.changePageToIndex(self.currentPlaylistIndex, animated: true)
                                }

                            });
                        }
        }
        else
        {
            self.playlistVCArray.removeAll()
            self.tabScrollView.reloadData()
            self.tabScrollView.reloadInputViews()
            self.tabScrollView.changePageToIndex(currentPlaylistIndex, animated: true)
        }
    }
    
    func createAllPlaylistVC()
    {
        self.playlistVCArray.removeAll()
        
        // create content views from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())

        for i in 0 ..< syncPlaylistArray.count /* number of pages */
        {
            if i == 0
            {
                if let vc = storyboard.instantiateViewControllerWithIdentifier("createNewPlaylistVC") as? createNewPlaylistVC
                {
                    self.playlistVCArray.append(vc)
                }
            }
            else
            {
                if let vc = storyboard.instantiateViewControllerWithIdentifier("Playlist1VC") as? Playlist1VC
                {
                    let playListDictionary = syncPlaylistArray[i]
                    
                    /* set somethings for vc */
                    if let isLocal = playListDictionary["isLocal"] as? String
                    {
                        vc.isLocal = isLocal
                        // appDelegate.isFromPlaylist = true
                        if isLocal == "0"
                        {
                            if let aPlayListDictionary = playListDictionary as? NSMutableDictionary
                            {
                                //appDelegate.selectedPlayListDictionary = aPlayListDictionary
                                //self.DLog("appDelegate.selectedPlayListDictionary \(appDelegate.selectedPlayListDictionary)")
                                
                                if let otherDataStr = aPlayListDictionary["otherData"] as? String
                                {
                                    let playListDict = JSON.parse(otherDataStr)
                                    if playListDict.dictionary != nil
                                    {
                                        appDelegate.selectedPlaylistId = playListDict.dictionary!
                                        vc.playlistDict = playListDict.dictionary!
                                        
                                        if (playListDict["playlistId"].stringValue == BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId")) //"Favourite"
                                        {
                                            appDelegate.favPlaylist = vc
                                        }
                                        //                                    if (playListDict["playlistname"].stringValue == "Disctopia Favs") //"Favourite"
                                        //                                    {
                                        //                                        appDelegate.favPlaylist = vc
                                        //                                    }
                                    }
                                }
                            }
                        }
                        else if isLocal == "1"
                        {
                            if let aPlayListDictionary = playListDictionary as? NSMutableDictionary
                            {
                                //appDelegate.selectedPlayListDictionary = aPlayListDictionary
                                vc.PlayListDictionary = aPlayListDictionary
                            }
                        }
                        
                        self.playlistVCArray.append(vc)
                        
                    }
                }
            }
        }
    }
    
    // MARK: - ACTabScrollViewDelegate -
    func tabScrollView(tabScrollView: ACTabScrollView, didChangePageTo index: Int)
    {
       
        print(index)
        currentPlaylistIndex = index
        self.tabScrollView(tabScrollView, refreshPage: index)
       /* if index == 0
        {
        }
        else
        {
            let playListDictionary = syncPlaylistArray[index]
            
            DLog(playListDictionary)
            let isLocal = playListDictionary["isLocal"] as! String
            // appDelegate.isFromPlaylist = true
            if isLocal == "0"
            {
                appDelegate.selectedPlayListDictionary = playListDictionary as! NSMutableDictionary
                let aplayListDict = JSON.parse(playListDictionary["otherData"] as! String)
                appDelegate.selectedPlaylistId = aplayListDict.dictionary!
            }
            else if isLocal == "1"
            {
                appDelegate.selectedPlayListDictionary = playListDictionary as! NSMutableDictionary
               
                //added at 16 Jan 2017
//                let aplayListDict = JSON.parse(playListDictionary["otherData"] as! String)
//                appDelegate.selectedPlaylistId = aplayListDict.dictionary!
            }
            
            if (contentViews.count > index)
            {
                let vc : Playlist1VC =   (self.childViewControllers[index] as? Playlist1VC)!
                if (playListDictionary["playlistId"] != nil)
                {
                    vc.refreshCurrentPlaylistTrack()
                }

            }
          }*/
        
        // NSNotificationCenter.defaultCenter().postNotificationName("reloadTrackData", object: nil)
    }
    
    func tabScrollView(tabScrollView: ACTabScrollView, refreshPage index: Int)
    {
        if index == 0
        {
        }
        else
        {
            let playListDictionary = syncPlaylistArray[index]
            
            DLog(playListDictionary)
            let isLocal = playListDictionary["isLocal"] as! String
            // appDelegate.isFromPlaylist = true
            if isLocal == "0"
            {
                appDelegate.selectedPlayListDictionary = playListDictionary as! NSMutableDictionary
                let aplayListDict = JSON.parse(playListDictionary["otherData"] as! String)
                appDelegate.selectedPlaylistId = aplayListDict.dictionary!
            }
            else if isLocal == "1"
            {
                appDelegate.selectedPlayListDictionary = playListDictionary as! NSMutableDictionary
                
                //added at 16 Jan 2017
                //                let aplayListDict = JSON.parse(playListDictionary["otherData"] as! String)
                //                appDelegate.selectedPlaylistId = aplayListDict.dictionary!
            }
            
            if (contentViews.count > index)
            {
                let vc : Playlist1VC =   (self.childViewControllers[index] as? Playlist1VC)!
                if (playListDictionary["playlistId"] != nil)
                {
                    vc.refreshCurrentPlaylistTrack(false)
                }
            }
        }
    }

    //zhewnrum@boximail.com
    func tabScrollView(tabScrollView: ACTabScrollView, didScrollPageTo index: Int)
    {
        appDelegate.isSelectFromPlaylist = true
    }
    
    // MARK: - ACTabScrollViewDataSource -
    func numberOfPagesInTabScrollView(tabScrollView: ACTabScrollView) -> Int {
       
        return syncPlaylistArray.count/* number of pages */
    }
    
    func tabScrollView(tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView
    {
        // create a label
        let label = UILabel()
        let playListDictionary = syncPlaylistArray[index]
        if index == 0
        {
           label.text = playListDictionary["name"] as? String
        }
        else
        {
            let isLocal = playListDictionary["isLocal"] as! String
            
            if isLocal == "0"
            {
                var playListDict = JSON.parse(playListDictionary["otherData"] as! String)
                
                var aPlaylistname = playListDict["playlistname"].stringValue
               
                label.text =  aPlaylistname.capitalizedString
                
            }
            else if isLocal == "1"
            {
                let playlistObj : MPMediaPlaylist = playListDictionary["otherData"] as! MPMediaPlaylist
                label.text = playlistObj.name
                
                
            }
        }
        appDelegate.isSelectFromPlaylist = true
        
//        label.text = "NewText"/* tab title at {index} */
            label.textAlignment = .Center
        
        // if the size of your tab is not fixed, you can adjust the size by the following way.
        label.sizeToFit() // resize the label to the size of content
        //label.textColor = UIColor.whiteColor()
        label.textColor = UIColor.lightGrayColor()
        
//        label.backgroundColor = UIColor.redColor()

        label.font = self.changeFont(label.font)
        
        var padding: CGFloat = 50.0
        
        if (DeviceType.IS_IPHONE_6P)
        {
            padding = 20.0
        }
        else if (DeviceType.IS_IPHONE_6)
        {
            padding = 22.0
        }
        else
        {
            padding = 18.0
        }
        label.frame.origin = CGPointMake(label.frame.origin.x, label.frame.origin.y-10)
        label.frame.size = CGSize(
            width: label.frame.size.width + 40,
            height: label.frame.size.height + padding) // add some paddings  //+ 30
       
        if label.text == "Home"
        {
           label.backgroundColor = UIColor(red: 44.0/255.0, green: 38.0/255.0, blue: 67.0/255.0, alpha: 0.8)
        }
        return label
    }
    
    func tabScrollView(tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView
    {
        if index == 0
        {
            
        }
        else
        {
            let playListDictionary = syncPlaylistArray[index]
            let isLocal = playListDictionary["isLocal"] as! String
           // appDelegate.isFromPlaylist = true
//            if isLocal == "0"
//            {
//                appDelegate.selectedPlayListDictionary = playListDictionary as! NSMutableDictionary
//                DLog("appDelegate.selectedPlayListDictionary \(appDelegate.selectedPlayListDictionary)")
//                let aplayListDict = JSON.parse(playListDictionary["otherData"] as! String)
//                appDelegate.selectedPlaylistId = aplayListDict.dictionary!
//            }
//            else if isLocal == "1"
//            {
//                appDelegate.selectedPlayListDictionary = playListDictionary as! NSMutableDictionary
//            }
        }
        if (contentViews.count > index)
        {
            //return playlistVCArray[index].view
            return contentViews[index]
        }
        else
        {
            return UIView()
        }
    }
    
    // MARK: - getPlayList API For Playlist -
    func getPlayListAPI()
    {
        API.getPlaylist(nil , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### getPlayList API Response: \(result)")
                
                if (result["playlistDict"] != nil)
                {
                    self.playListArray = result["playlistDict"].array!
                    BaseVC.sharedInstance.DLog("#### playListArray: \(self.playListArray)")
                }
            }
            self.syncPlayList()
        }
    }
    
    func syncPlayList()
    {
        syncPlaylistArray.removeAllObjects()
        self.contentViews.removeAll()

        let dic:NSMutableDictionary = NSMutableDictionary()
        dic.setValue("Home", forKey: "name")
         syncPlaylistArray.insertObject(dic.mutableCopy(), atIndex: 0)

        
        //Local Music album list
        for  i in 0 ..< self.playlists.count
        {
            let playlist = self.playlists[i]
            
            //print("playlist.items[i].releaseDate \(playlist.item.releaseDate)")
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("1", forKey: "isLocal")
            dic.setValue(playlist, forKey: "otherData")
            syncPlaylistArray.addObject(dic.mutableCopy())
        }
        
        //API Albums list
        for i in 0 ..< self.playListArray.count
        {
            // let tempdic = self.playListArray[i].dictionaryValue
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("0", forKey: "isLocal")
            dic.setValue(self.playListArray[i].rawString(), forKey: "otherData")
            
            if (self.playListArray[i]["playlistname"].stringValue == "Disctopia Favs") //"Favourite"
            {
                syncPlaylistArray.insertObject(dic.mutableCopy(), atIndex: 1)
            }
            else
            {
                syncPlaylistArray.addObject(dic.mutableCopy())
            }
        }
        
       
        
        initScrollView()
        //loadPageMenu()
        DLog("syncPlaylistArray = \(syncPlaylistArray)")
    }
    
    override  func viewDidLayoutSubviews() {
       // self.loadPageMenu()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear PlaylistVC")
        
        //if already playlist exist and we have to forcefully reload that playlist
        if syncPlaylistArray.count > 0
        {
            DLog( currentPlaylistIndex)
            DLog( tabScrollView.pageIndex)
            self.tabScrollView(tabScrollView, refreshPage: tabScrollView.pageIndex)
        }

        
        BaseVC.sharedInstance.DLog("Saumil WillAppear PlaylistVC")
        
        self.originFrame = CGRectMake(self.btnSettingClick.frame.origin.x, self.btnSettingClick.frame.origin.y, self.btnSettingClick.frame.size.width, self.btnSettingClick.frame.size.height)
        
        for subview: UIView in self.view!.subviews
        {
            if subview.tag == 100
            {
                subview.removeFromSuperview()
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.methodOfReceivedNotification1(_:)), name:"NotificationIdentifier1", object: nil)//OptionMenuVC to SearchForMusicVC
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.methodOfReceivedNotification2(_:)), name:"NotificationIdentifier2", object: nil)//SearchForMusicVC to OptionMenuVC
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.methodOfReceivedNotification3(_:)), name:"openPlaylistOption", object: nil)//Open PlaylistOptionListVC on PlaylistCategoryTableViewCell3
        
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.deletePlaylistClicked(_:)), name:"deletePlaylistClicked", object: nil)//Open deleteYesNoViewController when deletePlaylistClicked Clicked
        
     //   NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.deletePlayistOptionNoClicked(_:)), name:"deletePlayistOptionNoClicked", object: nil)//Open PlaylistOptionListVC when No Clicked
        
     //   NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.deletePlayistOptionYesClicked(_:)), name:"deletePlayistOptionYesClicked", object: nil)//Open PlaylistOptionListVC when No Clicked
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear PlaylistVC")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear PlaylistVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear PlaylistVC")
    }
    
    class func instantiateFromStoryboard() -> PlaylistVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! PlaylistVC
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPageMenu()
    {
        if (pagingMenuController == nil)
        {
            self.showLoader()
            options =  PagingMenuOptionPlaylist()
            
            pagingMenuController = PagingMenuController(options: options)
            //let pagingMenuController = self.childViewControllers.first as! PagingMenuController
            pagingMenuController.delegate = self
            pagingMenuController.setup(options)
            self.addChildViewController(pagingMenuController)
            pagingMenuController.view.frame = self.playlistView.frame
            
            //CGRectMake(0, 100,pagingMenuController.view.frame.size.width, pagingMenuController.view.frame.size.height - 100)
            pagingMenuController.view.backgroundColor = UIColor.clearColor()
            
            self.view.addSubview(pagingMenuController.view)
            //pagingMenuController.didMoveToParentViewController(self)
            self.hideLoader()
        }
    }
    
    @IBAction func btnSetting(sender: AnyObject)
    {
        //        let vc : OptionMenuVC = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        //        //herbDetails.herb = selectedHerb
        //        vc.transitioningDelegate = self
        //        presentViewController(vc, animated: true, completion: nil)
        
        isFromSettingBtn = true
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
        
    }
    
    @IBAction func btnBackMyMusic(sender: AnyObject)
    {
        self.showMenu(false)

        appDelegate.isFromPlaylist = false
        appDelegate.isSelectFromPlaylist = false
        appDelegate.pagingMenuController.moveToMenuPage(0, animated: true)
        //self.popToRootViewControllerAnimated(true)
        //self.pushToViewControllerIfNotExistWithClassName("MenuVC", animated: true)

    }
    
    // MARK: - Animation
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.view!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        
        //let thisView = oldViewController.view
        let toView = newViewController.view
        
        let herbView = newViewController.view
        
        var frame = CGRect.zero
        
        if isFromSettingBtn
        {
            frame = self.originFrame
        }
        else
        {
            frame = appDelegate.playlistFrame
        }
        
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
    
    func methodOfReceivedNotification3(notification: NSNotification)
    {
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification3 called")
        
        isFromSettingBtn = false
        
        appDelegate.playlistFrame = (notification.object?.convertRect(notification.object!.frame, toView: self.view))!
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("PlaylistOptionListVC") as! PlaylistOptionListVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        self.cycleFromViewController(self, toViewController: herbDetails)
        
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
        
        let optionVC = storyboard!.instantiateViewControllerWithIdentifier("Playlist1VC") as! Playlist1VC
        optionVC.view.translatesAutoresizingMaskIntoConstraints = false;
        optionVC.deletePlaylistFrame = self.deletePlaylistFrame
       // optionVC.isFromNo = true
        
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
    
}
extension PlaylistVC: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        DLog("menuController \(menuController.dynamicType)")
        
        /*
        if menuController.dynamicType == ExploreCategoryVC.self
        {
            self.pushToViewControllerIfNotExistWithClassName("ExploreVC", animated: true)
        }
        */
        
//        if menuController.dynamicType == MyMusicExploreVC.self
//        {
//            self.pushToViewControllerIfNotExistWithClassName("ExploreVC", animated: true)
//        }
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        
    }
    
    func willMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
        
    }
    
    func didMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
        
    }
}

private var pagingControllers: [BaseVC]
{
    
    var arrViewController : [BaseVC] = []
//    arrStruct1.removeAll()    
    
    for _ in 0..<syncPlaylistArray.count
    {
        let verificationCodeViewController1 = PlaylistCategoryVC.instantiateFromStoryboard()

        arrViewController.append(verificationCodeViewController1)
        
//        arrStruct.append(PlaylistItemCustom())
        
        struct PlaylistItemCustom11: MenuItemViewCustomizable {}

        arrStruct1.append(PlaylistItemCustom11())
    }
    
    //return arrViewController
    
    
    let verificationCodeViewController1 = PlaylistCategoryVC.instantiateFromStoryboard()
    let verificationCodeViewController2 = PlaylistCategoryVC.instantiateFromStoryboard()
    let verificationCodeViewController3 = PlaylistCategoryVC.instantiateFromStoryboard()
    let verificationCodeViewController4 = PlaylistCategoryVC.instantiateFromStoryboard()
    
    return [verificationCodeViewController1, verificationCodeViewController2, verificationCodeViewController3, verificationCodeViewController4]
}

struct PlaylistItem1: MenuItemViewCustomizable {}
struct PlaylistItem2: MenuItemViewCustomizable {}
struct PlaylistItem3: MenuItemViewCustomizable {}
struct PlaylistItem4: MenuItemViewCustomizable {}

struct PagingMenuOptionPlaylist: PagingMenuControllerCustomizable
{
    var componentType: ComponentType {
        return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .Three
    }
    struct MenuOptions: MenuViewCustomizable {
        
        var backgroundColor: UIColor {
            return UIColor.clearColor()
        }
        var selectedBackgroundColor: UIColor {
            //return  UIColor(red: 0.0 / 255, green:0.0 / 255, blue: 0.0 / 255, alpha: 0.3)
            return  UIColor(red: 70.0 / 255, green: 139.0 / 255, blue: 60.0 / 255, alpha: 1.0)
        }
        
        var displayMode: MenuDisplayMode {
            return .Infinite(widthMode: .Flexible, scrollingMode: .ScrollEnabled)
        }
        var itemsOptions: [MenuItemViewCustomizable]
        {
            
            //return arrStruct1
            return [PlaylistItem1(), PlaylistItem2(), PlaylistItem3(), PlaylistItem4()]
        }
        var focusMode: MenuFocusMode
        {
             return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(red: 0.0 / 255, green:0.0 / 255, blue: 0.0 / 255, alpha: 0.3))
           // return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(red: 49.0 / 255, green: 101.0 / 255, blue: 210.0 / 255, alpha: 1.0))
        }
    }
    
    struct PlaylistItem1: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "playlist1")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
        //        var menuItemText: MenuItemText {
        //            return MenuItemText(text: "explore", color: UIColor.whiteColor(), selectedColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(16), selectedFont: UIFont.boldSystemFontOfSize(16))
        //        }
    }
    
    struct PlaylistItem2: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "work")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct PlaylistItem3: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "purchased")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct PlaylistItem4: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "favorites")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
}


extension PlaylistVC: UIViewControllerTransitioningDelegate
{
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning?
    {
        
        if btnSettingClick.superview != nil
        {
            transition.originFrame = btnSettingClick.superview!.convertRect(btnSettingClick!.frame, toView: nil)
        }
        transition.presenting = true
        
        return transition
        
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        transition.presenting = false
        return transition
    }
    
}

