//
//  LibraryVC.swift
//  Disctopia
//
//  Created by Damini on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class LibraryVC: BaseVC, UIScrollViewDelegate{
    
    var MostPlayedSongArray : [JSON] = []
    var MostRecentSongArray : [JSON] = []
    
    @IBOutlet var PlayViewYConstraint: NSLayoutConstraint!
    @IBOutlet var myScrollView: UIScrollView!
    var pagingMenuController : PagingMenuController! = nil
    var options: PagingMenuControllerCustomizable!
    
    @IBOutlet var libraryMenuView: UIView!
    
    @IBOutlet var lblTrackTitle: UILabel!
    @IBOutlet var lblArtistName: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var imgCoverImage: UIImageView!
    
    @IBOutlet var lblMostPlayedTrackTitle: UILabel!
    @IBOutlet var lblMostPlayedArtistName: UILabel!
    @IBOutlet var lblMostPlayedTags: UILabel!
    @IBOutlet var imgMostPlayedCoverImage: UIImageView!
    
    @IBOutlet var lblMostRecentTrackTitle: UILabel!
    @IBOutlet var lblMostRecentArtistName: UILabel!
    @IBOutlet var lblMostRecentTags: UILabel!
    @IBOutlet var imgMostRecentCoverImage: UIImageView!
    
    @IBOutlet var scrollViewBottomLayout: NSLayoutConstraint!
    
    @IBOutlet var libraryMenuViewBottomLaouyt: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.DLog("fav playlistId = \(BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId"))")
        
        self.myScrollView.delegate = self
        if appDelegate.isResumeAvailable == true
        {
            self.hideShowPlayView(true)   // for showing playview
        }
        else
        {
           self.hideShowPlayView(false)   // for hiding playview
        }
        //PlayViewYConstraint.constant = -216
        // Do any additional setup after loading the view.
        self.getMostPlayedSongAPI()
        self.GetRecentPlayedMusicAPI()
        appDelegate.selectedAlbumId = ""

    }

    override func viewDidLayoutSubviews()
    {
        //self.myScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,3000)
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.loadPageMenu()
            self.DLog("3 self.myScrollView = \(self.myScrollView)")
            self.resetScrolleFrame()
            self.DLog("4 self.myScrollView = \(self.myScrollView)")
        })
        
    }
    
    func resetScrolleFrame()
    {
        if appDelegate.isResumeAvailable == true
        {
            self.myScrollView.frame = CGRectMake(self.myScrollView.frame.origin.x, self.myScrollView.frame.origin.y, UIScreen.mainScreen().bounds.size.width, self.view.frame.size.height - 5.0)
        }
        else
        {
            self.myScrollView.frame = CGRectMake(self.myScrollView.frame.origin.x, self.myScrollView.frame.origin.y, UIScreen.mainScreen().bounds.size.width, self.view.frame.size.height)
        }
        
        self.myScrollView.contentSize.height = UIScreen.mainScreen().bounds.size.height
        
        if (appDelegate.minimizePlayerView != nil)
        {
            if (appDelegate.isMinimisePlayerVisible)
            {
                self.libraryMenuViewBottomLaouyt.constant = MINIMIZE_PLAYER_HEIGHT
                self.scrollViewBottomLayout.constant = MINIMIZE_PLAYER_HEIGHT
                //self.myScrollView.contentSize.height = 355
            }
            else
            {
                self.libraryMenuViewBottomLaouyt.constant = 0.0
                self.scrollViewBottomLayout.constant = 0.0
                self.myScrollView.contentSize.height = UIScreen.mainScreen().bounds.size.height
            }
        }
        
        //libraryMenuViewBottomLaouyt
        //libraryMenuView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        //DLog("scrollView.contentOffset.y = \(scrollView.contentOffset.y)")
        if (scrollView.contentOffset.y > 283 )
        {
            scrollView.contentOffset.y = 283
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        //BaseVC.sharedInstance.hideLoader()
        appDelegate.isLoderRequired = false
        if (appDelegate.minimizePlayerView != nil)
        {
            if (appDelegate.isMinimisePlayerVisible)
            {
                self.libraryMenuViewBottomLaouyt.constant = MINIMIZE_PLAYER_HEIGHT
                self.scrollViewBottomLayout.constant = MINIMIZE_PLAYER_HEIGHT

            }
            else
            {
                self.libraryMenuViewBottomLaouyt.constant = 0.0
                self.scrollViewBottomLayout.constant = 0.0
            }
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        DLog("1 self.myScrollView = \(self.myScrollView)")
        self.myScrollView.contentSize.height = UIScreen.mainScreen().bounds.size.height
        self.myScrollView.frame = CGRectMake(self.myScrollView.frame.origin.x, self.myScrollView.frame.origin.y, self.myScrollView.frame.size.width, self.view.frame.size.height)
        DLog("2 self.myScrollView = \(self.myScrollView)")
    }
    
    class func instantiateFromStoryboard() -> LibraryVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! LibraryVC
    }
   
    override func viewWillAppear(animated: Bool)
    {
        
    }
    
    @IBAction func btnMostRecentPlay(sender: AnyObject)
    {
        self.hideShowPlayView(true) // for showing play view
        //PlayViewYConstraint.constant = 0
    }
    
    @IBAction func btnMostPlayedPlay(sender: AnyObject)
    {
        //PlayViewYConstraint.constant = 0
        self.hideShowPlayView(true) // for showing play view
    }
    
    @IBAction func btnResumeTapped(sender: AnyObject)
    {
        self.hideShowPlayView(false)
        appDelegate.isResumeAvailable = false
        if self.MostRecentSongArray.count > 0
        {
            let MostRecentSongDict = self.MostRecentSongArray[0].dictionaryValue
            BaseVC.sharedInstance.DLog("MostRecentSongArray")
            appDelegate.distopiaUserType = .Artist
            //let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let aLocalSongPlayer = LocalSongPlayer.sharedPlayerInstance1
            let navigationController = UINavigationController(rootViewController: aLocalSongPlayer)
            navigationController.modalPresentationStyle = .OverCurrentContext
            self.presentViewController(navigationController, animated: true, completion: nil)
            var trackId = ""
            aLocalSongPlayer.trackArrayPlayer = self.MostRecentSongArray
            var dictTrackDetails = MostRecentSongDict
            trackId = (dictTrackDetails["trackId"]?.stringValue)!
            appDelegate.selectedTrackId = trackId
            /**/aLocalSongPlayer.currTrackIndex = 0
            /**/aLocalSongPlayer.isLocal = "0"
        }
        resetScrolleFrame()
    }
   
    // API : getMostPlayedSongAPI For Explore
    func getMostPlayedSongAPI()
    {
        API.getMostPlayedSong(nil , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                self.MostPlayedSongArray = result.arrayValue
                BaseVC.sharedInstance.DLog("#### getMostPlayedSong API Response: \(result)")
                //self.DLog("MostPlayedSongArray.count = \(self.MostPlayedSongArray.count)")
                if self.MostPlayedSongArray.count >= 0
                {
                    self.setMostPalyedSongDetails()
                }
                
            }
        }
    }
    
    // API : GetRecentPlayedMusicAPI For Explore
    func GetRecentPlayedMusicAPI()
    {
        API.GetRecentPlayedMusic(nil , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                self.MostRecentSongArray = result.arrayValue
                BaseVC.sharedInstance.DLog("#### GetRecentPlayedMusic API Response: \(result)")
                //self.DLog("MostRecentSongArray.count = \(self.MostRecentSongArray.count)")
                if self.MostRecentSongArray.count > 0
                {
                    self.setMostRecentSongDetails()
                }
                
            }
        }
    }
    
    func setMostPalyedSongDetails()
    {
        if (self.MostPlayedSongArray.count > 0)
        {
            var MostPlayedSongDict = self.MostPlayedSongArray[0].dictionaryValue
            //DLog(" MostPlayedSongDict =\(MostPlayedSongDict)")
            
            let timeParts = MostPlayedSongDict["year"]!.stringValue.componentsSeparatedByString("-")
            
            lblMostPlayedTrackTitle.text = MostPlayedSongDict["coverName"]!.stringValue
            lblMostPlayedArtistName.text = MostPlayedSongDict["artistName"]!.stringValue
            lblMostPlayedTags.text = "\(MostPlayedSongDict["tags"]!.stringValue)-\(timeParts[0])"
            //cell.lblE.text = "E"//artistAlbumListDict["coverName"].stringValue
            
            let imageUrl = MostPlayedSongDict["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: imgMostPlayedCoverImage)
            }
            else
            {
                imgMostPlayedCoverImage.image = UIImage(named: DEFAULT_IMAGE)
            }
        }
    }
    
    func setMostRecentSongDetails()
    {
        var MostRecentSongDict = self.MostRecentSongArray[0].dictionaryValue
        //DLog(" MostRecentSongDict =\(MostRecentSongDict)")
        
        let timeParts = MostRecentSongDict["playedTimeStamp"]!.stringValue.componentsSeparatedByString("-")
        
        if (MostRecentSongDict["name"] != nil)
        {
            lblTrackTitle.text = MostRecentSongDict["name"]!.stringValue
        }
        else
        {
            lblTrackTitle.text = ""
        }
        lblArtistName.text = MostRecentSongDict["artistName"]!.stringValue
        //lblMostRecentTags.text = "\(MostRecentSongDict["tags"]!.stringValue)-\(timeParts[0])"
        //cell.lblE.text = "E"//artistAlbumListDict["coverName"].stringValue
        
        let dateStr = "\(MostRecentSongDict["duration"]!.stringValue)"
        let durationArr = dateStr.componentsSeparatedByString(".")
        let duration: String = durationArr[0]
        lblTime.text = duration
        
        if (MostRecentSongDict["album_url"] != nil)
        {
            let imageUrl = MostRecentSongDict["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            DLog("----------image url = \(imageUrl)")
            
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: imgCoverImage)
            }
            else
            {
                imgCoverImage.image = UIImage(named: DEFAULT_IMAGE)
            }
        }
        else
        {
            imgCoverImage.image = UIImage(named: DEFAULT_IMAGE)
        }
    }
    
    func loadPageMenu()
    {
        BaseVC.sharedInstance.showLoader()
        if ( pagingMenuController == nil )
        {
            options =  PagingMenuOptionsLibrary()
            pagingMenuController = PagingMenuController(options: options)
            //let pagingMenuController = self.childViewControllers.first as! PagingMenuController
            pagingMenuController.delegate = self
            pagingMenuController.setup(options)
            self.addChildViewController(pagingMenuController)
            pagingMenuController.view.backgroundColor = UIColor.clearColor()
            self.libraryMenuView.addSubview(pagingMenuController.view)
            //pagingMenuController.didMoveToParentViewController(self)
        }
        pagingMenuController.view.frame = CGRectMake(0, 0,libraryMenuView.frame.size.width, libraryMenuView.frame.size.height)
        BaseVC.sharedInstance.hideLoader()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if appDelegate.minimizePlayerView == nil
        {
            if (segue.identifier == "minimizePlayerVC")
            {
                if let minimizePVC = segue.destinationViewController as? MinimizePlayerVC
                {
                    if let aPlayderView =  minimizePVC.view.viewWithTag(555) as? PlayerBaseVC
                    {
                        appDelegate.minimizePlayerView = aPlayderView
                    }
                }
            }
        }
    }
    // for hide/show play view
    func hideShowPlayView(hideStatus : Bool)
    {
        // hide - pass false
        // show - pass true
        if hideStatus == true
        {
            PlayViewYConstraint.constant = 0.0
            myScrollView.contentSize.height = 738.0
        }
        else
        {
            PlayViewYConstraint.constant = -216.0
            myScrollView.contentSize.height = 738.0-216.0
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

extension LibraryVC: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController)
    {
        //DLog("menuController \(menuController.dynamicType)")
        if menuController.dynamicType == LibraryTracksViewController.self //MyMusicExploreVC.self
        {
            if let aMenuController = menuController as? LibraryTracksViewController
            {
                aMenuController.trackBy = TrackBy.PurchaseTrack
                aMenuController.setTrackData("", isLocal: "1",isFromEditPlaylist: false)
            }
        }
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController)
    {
        menuController.viewWillAppear(true)
        menuController.viewDidAppear(true)
    }
    
    func willMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
    
    func didMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
}

private var pagingControllers: [BaseVC]
{
     BaseVC.sharedInstance.showLoader()
    let verificationCodeViewController1 = LibraryAlbumsViewController.instantiateFromStoryboard()
    let verificationCodeViewController2 = LibraryArtistsViewController.instantiateFromStoryboard()
    let verificationCodeViewController3 = LibraryTracksViewController.instantiateFromStoryboard()
    appDelegate.isLoderRequired = false
    BaseVC.sharedInstance.hideLoader()
    return [verificationCodeViewController1, verificationCodeViewController2, verificationCodeViewController3]
}

struct LibraryItem1: MenuItemViewCustomizable {}
struct LibraryItem2: MenuItemViewCustomizable {}
struct LibraryItem3: MenuItemViewCustomizable {}

struct PagingMenuOptionsLibrary: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .Three
    }
    struct MenuOptions: MenuViewCustomizable
    {
        
        var backgroundColor: UIColor {
            return UIColor.clearColor()
        }
        var selectedBackgroundColor: UIColor {
            return UIColor.clearColor()
        }
        var displayMode: MenuDisplayMode {
            
            return .SegmentedControl
            return .Standard(widthMode: .Fixed(width: UIScreen.mainScreen().bounds.width/4.225), centerItem: false, scrollingMode: .PagingEnabled)
           // return .Infinite(widthMode: .Flexible, scrollingMode: .ScrollEnabled)
            //return .Infinite(widthMode: .Fixed(width: UIScreen.mainScreen().bounds.width/4.225), scrollingMode: .ScrollEnabled)
        }

//        var displayMode: MenuDisplayMode {
//            return .Infinite(widthMode: .Flexible, scrollingMode: .ScrollEnabled)
//        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [LibraryItem1(), LibraryItem2(), LibraryItem3()]
        }
        var focusMode: MenuFocusMode {
            
            //return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(red: 0.0 / 255, green:0.0 / 255, blue: 0.0 / 255, alpha: 0.3))
            return .RoundRect(radius: 0, horizontalPadding: 0, verticalPadding: 0, selectedColor: UIColor.init(colorLiteralRed: 44.0/255.0, green: 38.0/255.0, blue: 67.0/255.0, alpha: 0.8))
        }
    }
    
    struct LibraryItem1: MenuItemViewCustomizable
    {
     
//        var horizontalMargin: CGFloat {
//            return 30
//        }
        var displayMode: MenuItemDisplayMode {
            
            //let title = MenuItemText(text: "albums")
            let title = LibraryMenuItemText(text: "albums")
            //let description = MenuItemText(text: String(self))
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct LibraryItem2: MenuItemViewCustomizable {
        
//        var horizontalMargin: CGFloat {
//            return 30
//        }
        var displayMode: MenuItemDisplayMode {
            let title = LibraryMenuItemText(text: "artists")
            //let description = MenuItemText(text: String(self))
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
    }
    
    struct LibraryItem3: MenuItemViewCustomizable {
        
//        var horizontalMargin: CGFloat {
//            return 30
//        }
        var displayMode: MenuItemDisplayMode {
            let title = LibraryMenuItemText(text: "tracks")
            //let description = MenuItemText(text: String(self))
            
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
        //              var menuItemText: MenuItemText {
        //                  return MenuItemText(text: "tracks", color: UIColor.redColor(), selectedColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(16), selectedFont: UIFont.boldSystemFontOfSize(16))
        //              }
    }
 }

