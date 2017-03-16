//
//  AlbumDetailsVC.swift
//  Disctopia
//
//  Created by Mitesh on 24/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import MediaPlayer
import Branch

class AlbumDetailsVC: BaseVC,UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: - Variable
    var albumDetailsArray : [JSON] = []
    var artistAlbumArray : [JSON] = []
    var localAlbumArray:[MPMediaItemCollection] = []
    var albumId:String = ""
    var isFromSharing = false
    var decription = ""
    var isAlbumPaidAndFan = false
    // MARK: - Outlet
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var tracks: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet var lblMoreByArtist: UILabel!
    @IBOutlet weak var imgAlbum: UIImageView!
    @IBOutlet weak var onOptionMenuBtnClick: UIButton!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var buyAlbum: UIButton!
    @IBOutlet var btnReportAlbun: UIButton!
    @IBOutlet weak var lblAboutArtistDetails: UILabel!
    @IBOutlet var aboutArtistViewHeight: NSLayoutConstraint! //225
    @IBOutlet var collectionViewHeight: NSLayoutConstraint! //165
    @IBOutlet var moreByArtistViewHeight: NSLayoutConstraint! //52
    @IBOutlet weak var trackListContainerHightConstraint: NSLayoutConstraint!
    
    @IBOutlet var shareReportAddBtnView: UIView!
    @IBOutlet var btnShareAlbum: UIButton!
    @IBOutlet weak var aboutArtistView: UIView!
    @IBOutlet weak var lastSpaceView: UIView!
    @IBOutlet weak var scrollSubView: UIView!
    
    @IBOutlet var viewUpgradeForUnlimitedAccess: UIView!
    @IBOutlet var viewUpgradeUnlimitedAccessHeight: NSLayoutConstraint!
    
    @IBOutlet var btnUngradeAccess: UIButton!
    let transition = PopAnimator()
    var isLocal :  String = "0"
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    
    var trackCollection: MPMediaItemCollection?
    var aTracksVC: LibraryTracksViewController? = nil

    var branchUniversalObject: BranchUniversalObject!

       // MARK: - LifeCycle Method -
    override func viewDidLayoutSubviews()
    {
        /*
        if  aboutArtistViewHeight.constant > 0 && collectionViewHeight.constant > 0
        {
            self.detailsScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 1125.0)
        }
        else if collectionViewHeight.constant <= 0 && aboutArtistViewHeight.constant > 0
        {
          self.detailsScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 1125.0 - 221.0)
        }
        else if aboutArtistViewHeight.constant <= 0 && collectionViewHeight.constant > 0
        {
            self.detailsScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 1125.0 - 225.0)
        }
        else
        {
            self.detailsScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 1125.0 - 442.0)
        }
        */
         self.setScrollViewContainSize()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.viewUpgradeUnlimitedAccessHeight.constant = 0
        self.viewUpgradeForUnlimitedAccess.hidden = true
        self.btnUngradeAccess.layer.borderWidth = 1.0
        self.btnUngradeAccess.layer.borderColor = UIColor(red: 162/255, green: 207/255, blue: 100/255, alpha: 1).CGColor
        
        
         self.imgAlbum.layer.cornerRadius = 5.0
         self.imgAlbum.layer.masksToBounds = true
       
        shareReportAddBtnView.hidden = true
        onOptionMenuBtnClick.exclusiveTouch = true
        buyAlbum.exclusiveTouch = true

        btnReportAlbun.exclusiveTouch = true

        self.albumId = appDelegate.selectedAlbumId
       // playerContainerView.hidden = true
        //buyAlbum.hidden = false
        
        if aboutArtistViewHeight != nil
        {
            aboutArtistViewHeight.constant = 0 //225
        }
        
        lblAboutArtistDetails.text = ""
        if appDelegate.dictArtistDetails.count > 0
        {
            if let local = appDelegate.dictArtistDetails["isLocal"] as? String
            {
                isLocal = local
            }
            else
            {
                isLocal = "0"
            }
        }
        
        if isLocal == "0"
        {
            
            //Get Album Details From API
            self.getAlbumDetailsAPI()
            btnReportAlbun.hidden = false
            
        }
        else if isLocal == "1" //Get Details From Local Music Library.
        {
            //self.detailsScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, (1125.0 - 225.0))
            buyAlbum.hidden = true
            btnReportAlbun.hidden = true
            let otherData =  appDelegate.dictArtistDetails["otherData"] as! MPMediaItemCollection
            
            self.albumName.text = appDelegate.dictArtistDetails["albumName"] as? String
            self.artistName.text = appDelegate.dictArtistDetails["artistName"] as? String
           
            self.year.text = appDelegate.dictArtistDetails["desc"] as? String
            
            self.tracks.text = "\(otherData.count) Tracks"
            
            if let representativeItem = otherData.representativeItem
            {
                if self.artistName.text != nil
                {
                    self.lblMoreByArtist.text = "More by \( self.artistName.text!)"
                }
                else
                {
                    self.lblMoreByArtist.text = "More by \(representativeItem.artist)"
                }
                
                getLocalArtistAlbum(representativeItem.artistPersistentID.description)
                if let artwork = representativeItem.artwork
                {
                    let scale = UIScreen.mainScreen().scale
                    if let image =  artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                    {
                        
                        self.imgAlbum.image = image
                    }
                    else
                    {
                        self.imgAlbum.image = UIImage(named: DEFAULT_IMAGE)
                    }
                }
                else
                {
                    self.imgAlbum.image = UIImage(named: DEFAULT_IMAGE)
                }
            }
        }
        
        if self.aTracksVC != nil
        {
            self.aTracksVC?.trackBy = TrackBy.Album
            self.aTracksVC!.setTrackData(self.albumId, isLocal: self.isLocal,isFromEditPlaylist: false)
        }
        
        //self.detailsScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 1125.0)

        self.originFrame = CGRectMake(self.onOptionMenuBtnClick.frame.origin.x, self.onOptionMenuBtnClick.frame.origin.y, self.onOptionMenuBtnClick.frame.width, self.onOptionMenuBtnClick.frame.height)
        // Do any additional setup after loading the view.
        self.setScrollViewContainSize()
        
        
       
        //haself.addShareAlbumBtn()

    }
    

    func setScrollViewContainSize()
    {
        //self.trackListContainerHightConstraint.constant = 500
        // self.detailsScrollView.translatesAutoresizingMaskIntoConstraints = false
        /*
        let scrollNewHigth = self.lastSpaceView.frame.size.height + self.lastSpaceView.frame.origin.y + 200.0
        self.scrollSubView.frame = CGRectMake(0, 0, self.scrollSubView.frame.size.width, scrollNewHigth)
        self.DLog("scrollNewHigth = \(scrollNewHigth)")
        self.detailsScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, scrollNewHigth)
         */
    }
    
    func setrackListContainerHightConstraint(hight:CGFloat)
    {
        self.trackListContainerHightConstraint.constant = hight
        //self.detailsScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, hight + 300)
    }
    
    func setScrollViewContainSize1()
    {
        let scrollNewHigth = self.lastSpaceView.frame.size.height + self.lastSpaceView.frame.origin.y + 200.0
        //self.scrollSubView.frame = CGRectMake(0, 0, self.scrollSubView.frame.size.width, scrollNewHigth)
        self.DLog("scrollNewHigth = \(scrollNewHigth)")
        self.detailsScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, scrollNewHigth)
    }
    
    func getLocalArtistAlbum(artistID:String)
    {
        // Load albums
        let albumQuery = MPMediaQuery.albumsQuery()
        // Only Media type music
        albumQuery.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        // Include iCloud item
        albumQuery.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        if let collections = albumQuery.collections {
            
            let artistAlbumCountDict = NSMutableDictionary()
            
            var albumsItemsArray: [MPMediaItemCollection] = collections
            for  i in 0 ..< albumsItemsArray.count
            {
                let album = albumsItemsArray[i]
                
                let artistIdStr = album.representativeItem?.artistPersistentID.description
                
                if (artistID == artistIdStr)
                {
                    
                    let albumIdStr = album.representativeItem?.albumPersistentID.description
                    if let artistCount = artistAlbumCountDict[albumIdStr!] as? Int
                    {
                        artistAlbumCountDict[artistIdStr!] = artistCount + 1
                    }
                    else
                    {
                        artistAlbumCountDict[albumIdStr!] = 1
                        localAlbumArray.append(album)
                    }
                }
            }
            DLog("localAlbumArray = \(localAlbumArray)")
            self.myCollectionView.reloadData()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear AlbumDetailsVC")
        
        for subview: UIView in self.view!.subviews
        {
            if subview.tag == 100
            {
                subview.removeFromSuperview()
            }
        }
       
//        if appDelegate.audioPlayer != nil
//        {
//            if (appDelegate.audioPlayer!.playing)
//            {
//                playerContainerView.hidden = false
//            }
//            else
//            {
//                playerContainerView.hidden = true
//            }
//        }
        /*
            if (appDelegate.player.rate != 0 && appDelegate.player.error == nil)
            {
                playerContainerView.hidden = false
            }
            else
            {
                playerContainerView.hidden = true
            }
        */
        // playerContainerView.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AlbumDetailsVC.methodOfReceivedNotification1(_:)), name:"NotificationIdentifier1", object: nil)//OptionMenuVC to SearchForMusicVC
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AlbumDetailsVC.methodOfReceivedNotification2(_:)), name:"NotificationIdentifier2", object: nil)//SearchForMusicVC to OptionMenuVC
        
        
    }
    
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear AlbumDetailsVC")
       
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear AlbumDetailsVC")
        
        // Read the deep link paramters from the link
        let sessionParams = Branch.getInstance().getLatestReferringParams()
        //let itemId = sessionParams["item_id"]
        guard let isItemPresent = sessionParams?["item_id"] as? Bool else { return }
        if isItemPresent {
            // from here, you'd load the appropriate item from the item id
            print("Deep linked to page from Branch link with item id: %@", sessionParams["item_id"])
        }

    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        appDelegate.selectedAlbumId = ""

        BaseVC.sharedInstance.DLog("DidDisappear AlbumDetailsVC")
    }
    
    class func instantiateFromStoryboard() -> SettingsMenuVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SettingsMenuVC
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collectionview delegete method -
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isLocal == "0"
        {
            return artistAlbumArray.count
        }
        else if isLocal == "1" //Get Details From Local Music Library.
        {
            return localAlbumArray.count
        }
        else
        {
            return 0
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_id", forIndexPath: indexPath) as! moreByArtistCVC
        
        if isLocal == "0"
        {
            let albumDic:JSON = artistAlbumArray[indexPath.row]
            let imageUrl = albumDic["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: cell.imgMoreArtist)
            }
            else
            {
                cell.imgMoreArtist.image = UIImage(named: DEFAULT_IMAGE)
            }
        }
        else if isLocal == "1" //Get Details From Local Music Library.
        {
            let otherData =  localAlbumArray[indexPath.row]
            
            if let representativeItem = otherData.representativeItem
            {
                if let artwork = representativeItem.artwork
                {
                    let scale = UIScreen.mainScreen().scale
                    
                    if let image =  artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                    {
                        cell.imgMoreArtist.image = image
                    }
                    else
                    {
                        cell.imgMoreArtist.image = UIImage(named: DEFAULT_IMAGE)
                    }
                }
                else
                {
                    cell.imgMoreArtist.image = UIImage(named: DEFAULT_IMAGE)
                }
            }
        }
        
        // cell.imgMoreArtist.image = UIImage(named: "dummy_img5.png")
        
        return cell
    }
    
    //    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
    //                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    //    {
    //        return CGSizeMake(self.collectionView.frame.width/2, self.collectionView.frame.height)
    //    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        BaseVC.sharedInstance.DLog("Cell \(indexPath.row) is selected")
        appDelegate.dictArtistDetails.setObject(isLocal, forKey: "isLocal")

        if isLocal == "0"
        {
            let albumDic:JSON = artistAlbumArray[indexPath.row]
            let selectedAlbumId = albumDic["albumId"].stringValue
            if self.albumId != selectedAlbumId
            {
                appDelegate.selectedAlbumId = selectedAlbumId
                self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
            }
        }
        else if isLocal == "1" //Get Details From Local Music Library.
        {
            let curretnOtherData =  appDelegate.dictArtistDetails["otherData"] as! MPMediaItemCollection
            let otherData =  localAlbumArray[indexPath.row]
            
            if curretnOtherData.representativeItem != otherData.representativeItem
            {
                
                if let representativeItem = otherData.representativeItem
                {
                    
                    appDelegate.dictArtistDetails.setValue(representativeItem.albumTitle!, forKey: "albumName")
                    appDelegate.dictArtistDetails.setValue(representativeItem.artist!, forKey: "artistName")
                    appDelegate.dictArtistDetails.setValue("", forKey: "desc")
                    appDelegate.dictArtistDetails.setValue("\(representativeItem.albumPersistentID)", forKey: "albumId")
                    
                }
                appDelegate.dictArtistDetails.setObject(otherData, forKey: "otherData")
                appDelegate.dictArtistDetails.setObject(isLocal, forKey: "isLocal")
                appDelegate.isFromPlaylist = false
                appDelegate.selectedAlbumId = ""
                self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
            }
        }
    }
    // MARK: - Button Action
    
    @IBAction func btnByAlbumClicked(sender: AnyObject)
    {
//        let btnShoppingCartOutlet = UIAlertView()
//        btnShoppingCartOutlet.title = "Under Construction"
//        btnShoppingCartOutlet.addButtonWithTitle("OK")
//        btnShoppingCartOutlet.show()
        
        
        if !self.albumId.isEmpty
        {
            let vc : ConfirmAddtoCartVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ConfirmAddtoCartVC") as! ConfirmAddtoCartVC
            vc.idTrackOrAlbum = self.albumId
            vc.isFrom = 1
            let navigationController = UINavigationController(rootViewController: vc)
            
            navigationController.modalPresentationStyle = .OverCurrentContext
            navigationController.navigationBarHidden = true
            self.presentViewController(navigationController, animated: true, completion: nil)
        }

        //self.addAlbumInCart()
    }
    
    @IBAction func onBackClickBtn(sender: AnyObject)
    {
        //appDelegate.loadFirstViewController("MenuVC")
        
        if (!isFromSharing)
        {
            self.popToSelf(sender)
        }
        else
        {
            //BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("MenuVC", animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        //self.popToRootViewControllerAnimated(true)
        //appDelegate.pagingMenuController.moveToMenuPage(0, animated: true)

    }
    
    @IBAction func btnOpenPopUp(sender: AnyObject)
    {
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        
        //presentViewController(herbDetails, animated: true, completion: nil)
        
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
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
    
    @IBAction func onReportAlbumClick(sender: AnyObject)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let aReportAlbumViewController : ReportAlbumViewController = storyboard.instantiateViewControllerWithIdentifier("ReportAlbumViewController") as! ReportAlbumViewController
        
        let navigationController = UINavigationController(rootViewController: aReportAlbumViewController)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(navigationController, animated: true, completion: nil)
        
       // self.pushToViewControllerIfNotExistWithClassName("ReportAlbumViewController", animated: true)
    }
    
    @IBAction func btnShareAlbumClick(sender: AnyObject)
    {
        self.initiateSharing()
    }
    
    func setAboutArtistView()
    {
        if (self.aboutArtistViewHeight.constant <= 0)
        {
            self.aboutArtistView.hidden = true
        }
        else
        {
            self.aboutArtistView.hidden = false
        }
    }
    
    @IBAction func btnCreateAlbumPlaylist(sender: AnyObject)
    {
      
//        if  isAlbumPaidAndFan
//        {
//                let vc : ConfirmGoSubscriptionVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ConfirmGoSubscriptionVC") as! ConfirmGoSubscriptionVC
//                let navigationController = UINavigationController(rootViewController: vc)
//                navigationController.modalPresentationStyle = .OverCurrentContext
//                navigationController.navigationBarHidden = true
//                self.presentViewController(navigationController, animated: true, completion: nil)
//            
//        }
        
        let profile : JSON =  self.loadJSON(Constants.userDefault.userProfileInfo)
        if profile.count > 0
        {
            let usertype = profile[0]["userType"].intValue
            if usertype == 1
            {
                let vc : ConfirmGoSubscriptionVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ConfirmGoSubscriptionVC") as! ConfirmGoSubscriptionVC
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .OverCurrentContext
                navigationController.navigationBarHidden = true
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
            else
            {
                let vc : ConfirmAddAlbumInPlaylist = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ConfirmAddAlbumInPlaylist") as! ConfirmAddAlbumInPlaylist
                
                vc.playlistName =   self.albumName.text!
                vc.albumID = self.albumId
                let navigationController = UINavigationController(rootViewController: vc)
                
                navigationController.modalPresentationStyle = .OverCurrentContext
                navigationController.navigationBarHidden = true
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnUpgradeUnlimitedAccessClick(sender: AnyObject)
    {
        //appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
        //self.pushToViewControllerIfNotExistWithClassName("SettingsMenuVC", animated: true)
    }
    // MARK: - API -
    func getAlbumDetailsAPI()
    {
        self.showLoader()
        if self.aboutArtistViewHeight != nil
        {
            self.aboutArtistViewHeight.constant = 0.0
        }
        self.setAboutArtistView()
        
        var param = Dictionary<String, String>()
        param["albumid"] =  self.albumId
        DLog("param = \(param)")
        self.printAPIURL("GetAlbumDetails", param: param)
        API.GetAlbumDetails(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                self.albumDetailsArray = result.arrayValue
                self.DLog("albumDetailsArray = \(self.albumDetailsArray)")
                if self.albumDetailsArray.count > 0
                {
                    var GetAlbumDetailsDict = self.albumDetailsArray[0].dictionaryValue
                    let timeParts = GetAlbumDetailsDict["year"]!.stringValue.componentsSeparatedByString("-")
                    
                    self.albumName.text = GetAlbumDetailsDict["coverName"]!.stringValue
                   
                    if self.artistName.text != nil
                    {
                        self.artistName.text = GetAlbumDetailsDict["artistName"]!.stringValue

                        self.lblMoreByArtist.text = "More by \( self.artistName.text!)"
                    }
                    else
                    {
                        self.lblMoreByArtist.text = "More by \(GetAlbumDetailsDict["artistName"]!.stringValue)"
                    }
                    
                    
                    //Get Artist List
                    self.getArtistAlbumListFromAPI()
                    
                    
                    //self.lblMoreByArtist.text = "More by \( self.artistName.text!)"
                   
                    self.tracks.text = "\(GetAlbumDetailsDict["totalTrack"]!.stringValue) Tracks"
                    //isFreeAlbum
                    
                    let isFree = GetAlbumDetailsDict["isFreeAlbum"]!.boolValue
                    
                    if isFree
                    {
                        self.buyAlbum.hidden = true
                    }
                    else
                    {
                        let isPurchased = GetAlbumDetailsDict["isPurchased"]?.stringValue
                        if isPurchased == "0"
                        {
                            if let albumPrice = GetAlbumDetailsDict["iosPrice"]?.stringValue
                            {
                                if albumPrice == "0"
                                {
                                    self.buyAlbum.hidden = true
                                }
                                else
                                {
                                    let profile : JSON =  self.loadJSON(Constants.userDefault.userProfileInfo)
                                    if profile.count > 0
                                    {
                                        let usertype = profile[0]["userType"].intValue
                                        if usertype == 1
                                        {
                                            self.isAlbumPaidAndFan = true
                                            self.viewUpgradeUnlimitedAccessHeight.constant = 40
                                            self.viewUpgradeForUnlimitedAccess.hidden = false
                                        }
                                    }
                                    
                                    self.buyAlbum.hidden = true
                                    //self.buyAlbum.hidden = false
                                    self.buyAlbum.setTitle("$\(albumPrice)", forState: .Normal)
                                }
                            }
                            else
                            {
                                self.buyAlbum.hidden = true
                                //self.buyAlbum.hidden = false
                            }
                        }
                        else
                        {
                            self.isAlbumPaidAndFan = false
                             self.buyAlbum.hidden = true
                        }
                    }
                    
                    //let dec = GetAlbumDetailsDict["description"]!.stringValue
                    let dec = "\(GetAlbumDetailsDict["aboutme"]!.stringValue)\n"
                    
                    self.decription = "\(GetAlbumDetailsDict["aboutme"]!.stringValue)\n"
                    
                    if GetAlbumDetailsDict["aboutme"]!.stringValue.characters.count > 0
                    {
                        self.lblAboutArtistDetails.text = dec
                        self.lblAboutArtistDetails.sizeToFit()
                        if self.aboutArtistViewHeight != nil
                        {
                            self.aboutArtistViewHeight.constant = dec.heightWithConstrainedWidth(self.lblAboutArtistDetails.frame.size.width, font: self.lblAboutArtistDetails.font) + 67.0
                        }
                        
                    }
                    
                    self.setAboutArtistView()

                    self.year.text = timeParts[0]
                    
                    let imageUrl = GetAlbumDetailsDict["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                    if imageUrl.characters.count > 0
                    {
                        self.getAlbumImage(imageUrl,imageView: self.imgAlbum)
                    }
                    else
                    {
                        self.imgAlbum.image = UIImage(named: DEFAULT_IMAGE)
                    }
                }
                BaseVC.sharedInstance.DLog("#### GetAlbumDetails API Response: \(result)")
                self.shareReportAddBtnView.hidden = false
                self.addShareAlbumBtn()
            }
        }
    }
    
    func getArtistAlbumListFromAPI()
    {
        /*ttp://dsctpwebapiprod.azurewebsites.net/DisctopiaRestApi/GetArtistAlbumList?sessiontoken=78d13005-a521-4c88-93be-450daa54def7
        &artistName=Rek and Doodie
        &artistcategoryId=0
        &isPurchased=0
        &userId=18876e22-94d3-48ae-a260-26c6835cbd49
        */
        
        var param = Dictionary<String, String>()
        if self.artistName.text?.characters.count > 0
        {
            param["artistName"] = self.artistName.text//!.stringByReplacingOccurrencesOfString(" ", withString: "%20")//appDelegate.dictArtistDetails["artistName"] as? String
            param["artistcategoryId"] = "0"
            param["isPurchased"] = "0"
            DLog("param = \(param)")
            
            API.getArtistAlbumList(param, aViewController: self) { (result: JSON) in
                if ( result != nil )
                {
                    BaseVC.sharedInstance.DLog("#### getArtistAlbum API Response: \(result)")
                    self.artistAlbumArray = result.arrayValue
                    self.myCollectionView.reloadData()
                    
                    if result.arrayValue.count <= 0
                    {
                        self.collectionViewHeight.constant = 0
                        self.moreByArtistViewHeight.constant = 0
                    }
                    else
                    {
                        self.moreByArtistViewHeight.constant = 52
                        self.collectionViewHeight.constant = 165
                    }
                }
                else
                {
                    self.collectionViewHeight.constant = 0
                    self.moreByArtistViewHeight.constant = 0
                }
            }
        }
    }
    // MARK: - Addshoppingcart API
    func addAlbumInCart()
    {
        var param = Dictionary<String, String>()
        
        param["albumid"] = self.albumId
       //print("\(self.albumId)")
        //albumid
        API.AddShoppingCart(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### AddShoppingCart API Response: \(result)")
                //self.ViewshoppingcartData()
            }
            BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("CartSummaryVC", animated: true)
        }
        
    }
   
    // MARK: - Annimation functions -
    
   /* func addSubview(subView:UIView, toView parentView:UIView)
    {
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
 */
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
        
        if self.presenting
        {
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
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if (segue.identifier == "minimizePlayerVC")
//        {
//            if let minimizePVC = segue.destinationViewController as? MinimizePlayerVC
//            {
//                if let aPlayderView =  minimizePVC.view.viewWithTag(555) as? PlayerBaseVC
//                {
//                    appDelegate.minimizePlayerView = aPlayderView
//                }
//            }
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "AlbumTrack")
        {
            if let tracksVC = segue.destinationViewController as? LibraryTracksViewController
            {
                self.aTracksVC = tracksVC
                appDelegate.aTempLibraryVC = tracksVC
                self.aTracksVC!.trackBy = TrackBy.Album
               

            }
        }
    }
    
    // Branch.io Code
    func addShareAlbumBtn()
    {
        if self.albumDetailsArray.count > 0
        {
            var GetAlbumDetailsDict = self.albumDetailsArray[0].dictionaryValue
            let imageUrl = GetAlbumDetailsDict["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let uIdStr =  GetAlbumDetailsDict["userId"]!.stringValue
            let albumIdStr =  GetAlbumDetailsDict["id"]!.stringValue
            
//        let button = UIButton(frame: CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0))
//        button.addTarget(self, action: #selector(initiateSharing), forControlEvents: .TouchUpInside)
//        button.setTitle("Share Link", forState: .Normal)
//        button.center = self.view.center
//        button.backgroundColor = .grayColor()
//        self.view.addSubview(button)
        // Initialize a Branch Universal Object for the page the user is viewing
    
        branchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item_id_12345")
        // Define the content that the object represents
        //branchUniversalObject.title = "Disctopia Album"
       
        branchUniversalObject.title =   "\(self.artistName.text!)- \n \(self.albumName.text!)"
        branchUniversalObject.contentDescription = decription //"Check out this awesome Album  content"
        branchUniversalObject.imageUrl  = imageUrl  //"https://example.com/mycontent-12345.png"
       
        branchUniversalObject.addMetadataKey("item_id", value: albumIdStr)
        branchUniversalObject.addMetadataKey("user_id", value: uIdStr)
        branchUniversalObject.addMetadataKey("isAlbum", value: "1")
        
            // Trigger a view on the content for analytics tracking
        branchUniversalObject.registerView()
        // List on Apple Spotlight
        branchUniversalObject.listOnSpotlight()
       
        }

    }
    
    // This is the function to handle sharing when a user clicks the share button
    func initiateSharing()
    {
        // Create your link properties
        // More link properties available at https://dev.branch.io/getting-started/configuring-links/guide/#link-control-parameters
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "Sharing Album"
        // Show the share sheet for the content you want the user to share. A link will be automatically created and put in the message.
        branchUniversalObject.showShareSheetWithLinkProperties(linkProperties,
                                                               andShareText: " ",
                                                               fromViewController: self,
                                                               completion: { (activityType, completed) in
                                                                if (completed)
                                                                {
                                                                   
                                                                    // This code path is executed if a successful share occurs
                                                                }
        })
    }

}

//extension AlbumDetailsVC: UIViewControllerTransitioningDelegate
//{
//    func animationControllerForPresentedController(
//    presented: UIViewController,
//    presentingController presenting: UIViewController,
//    sourceController source: UIViewController) ->
//    UIViewControllerAnimatedTransitioning?
//    {
//        transition.originFrame = onOptionMenuBtnClick.superview!.convertRect(onOptionMenuBtnClick!.frame, toView: nil)
//        transition.presenting = true
//        return transition
//    }
//    
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
//    {
//        transition.presenting = false
//        return transition
//    }
//}
