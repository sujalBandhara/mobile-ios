
//
//  LibraryTracksViewController.swift
//  Disctopia
//
//  Created by Damini on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MediaPlayer
import AlamofireImage

class LibraryTracksViewController: BaseVC,UITableViewDelegate,UITableViewDataSource
{
    let tableHeight: CGFloat = 55.0
    var trackArray:[JSON] = []
    var arrLocalTracks : [MPMediaItem]  = []
    var isLocal : String = "0" // 0- Server Song // 1- Music (itunes) local songs
    var trackBy : TrackBy = TrackBy.PurchaseTrack // 0- All Purchase track // 1 - Explore Album // 2 - playlist // 3 - upload
    var playlistId = ""
    var albumId = ""
    var artistId = ""
    var trackId = ""
    var inputId = ""
    var localTrackObjects : MPMediaPlaylist? = nil
    var selectedTrackArray:NSMutableArray = NSMutableArray()
    var isTrackDownloadRequired = false //PlaylistVc1 button download show hide
    //private var localTrackCollection: [MPMediaItemCollection] = []
    var tracksCommonArray = [Track]()
    var animatedLoaderWebView = UIWebView()

    
    @IBOutlet var lblTracksDataAlert: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet weak var trackAddedNotificationView: UIView!
    @IBOutlet var viewSVGLoader: UIView!

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        BaseVC.sharedInstance.hideLoader()
        /*
         if self.trackBy == TrackBy.PurchaseTrack
         {
         self.setTrackData("", isLocal: "0")
         }
         */
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LibraryTracksViewController.reloadTrackData), name: "reloadTrackData", object: nil)
        //reloadTrackData()
        //self.tblView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.selectedTrackArray.removeAllObjects()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.tblView.scrollEnabled = true
        if self.parentViewController != nil
        {
            if let aAlbumDetailsVC = self.parentViewController as? AlbumDetailsVC
            {
                self.tblView.scrollEnabled = false
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
            }
        }
        
        super.viewWillAppear(true)
        //print("viewWillAppear LibraryTracks")
        // Do any additional setup after loading the view.
        //        if appDelegate.isFromUpload == true
        //        {
        //            trackBy = TrackBy.Artist
        //            self.setTrackData("", isLocal: "0")
        //        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        //BaseVC.sharedInstance.hideLoader()
        makeAnimatedWebview()

        super.viewDidAppear(true)
        //        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        //        dispatch_after(dispatchTime, dispatch_get_main_queue(),
        //                       {
        //            self.tblView.reloadData()
        //            });
        // Do any additional setup after loading the view.
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadTrackData", object: nil)
    }
    override func viewDidDisappear(animated: Bool)
    {
         super.viewDidDisappear(true)
        self.tblView.dataSource = nil
        self.tblView.delegate = nil
        
    }
    
    //MARK: - make Animated Loader -
    
    func makeAnimatedWebview()
    {

        let path: String = NSBundle.mainBundle().pathForResource(animatedImageSVG, ofType: "svg")!
        
        let url: NSURL = NSURL.fileURLWithPath(path)  //Creating a URL which points towards our path
        //Creating a page request which will load our URL (Which points to our path)
        let request: NSURLRequest = NSURLRequest(URL: url)
        self.animatedLoaderWebView.loadRequest(request)
        self.animatedLoaderWebView.scrollView.scrollEnabled = false
        self.animatedLoaderWebView.opaque = false
        self.animatedLoaderWebView.center = self.viewSVGLoader.center
        self.animatedLoaderWebView.backgroundColor = UIColor.clearColor()
        self.viewSVGLoader.addSubview(self.animatedLoaderWebView)
        
        let loaderwidth =         self.viewSVGLoader.bounds.width / 2.0
        let loaderHight =         self.viewSVGLoader.bounds.height / 2.0
        
        
        self.animatedLoaderWebView.frame = CGRectMake(loaderwidth, loaderHight, 60, 60)
        self.animatedLoaderWebView.center = self.viewSVGLoader.center
        //self.viewSVGLoader.backgroundColor = UIColor.clearColor()
        self.viewSVGLoader.hidden = true

    }

    //    @IBAction func onCloseSaveChangeView(sender: UIButton)
    //    {
    //        self.trackAddedNotificationView.hidden = true
    //    }
    
    
    //MARK: - SetTrack Data -
    
    func setTrackData(inputId:String,isLocal:String,isFromEditPlaylist : Bool)
    {
        
        if self.tblView != nil
        {
            self.tblView.dataSource = self
            self.tblView.delegate = self
            
            self.isLocal = isLocal
            self.inputId = inputId
            
            
            switch trackBy
            {
            case TrackBy.PurchaseTrack:
                
                self.tblView.allowsMultipleSelection = false
                
                self.getDeviceLocalTracks()
                //self.GetPurchasedTrackByUserAPI()
                break
                
            case TrackBy.Album:
                
                self.tblView.allowsMultipleSelection = false
                
                albumId = inputId
                if self.isLocal == "0"
                {
                    self.GetTracksListByAlbumId()
                }
                else
                {
                    let trackData =  appDelegate.dictArtistDetails["otherData"] as! MPMediaItemCollection
                    
                    for i in 0..<trackData.count
                    {
                        let trackDetails : MPMediaItem = trackData.items[i]
                        self.arrLocalTracks.append(trackDetails)
                    }
                }
                break
                
            case TrackBy.Playlist:
                
                self.tblView.allowsMultipleSelection = false
                
                playlistId = inputId
                DLog("playlistId \(playlistId)")
                //            if appDelegate.shufflePlaylistArray.contains(playlistId)
                //            {
                //                if appDelegate.playerView != nil
                //                {
                //                    appDelegate.playerView.isShuffle = true
                //                    appDelegate.playerView.btnshuffle.setImage(UIImage.init(named: "grey_crossfade"), forState: .Normal)
                //                }
                //            }
                
                if self.isLocal == "0"
                {
                    self.getAllTrackByPlaylistIdAPI(isFromEditPlaylist)
                }
                else
                {
                    // let playlistObj : MPMediaPlaylist = appDelegate.selectedPlayListDictionary["otherData"] as! MPMediaPlaylist
                    if (self.localTrackObjects != nil)
                    {
                        for i in 0..<self.localTrackObjects!.count
                        {
                            let trackDetails : MPMediaItem = self.localTrackObjects!.items[i]
                            self.arrLocalTracks.append(trackDetails)
                        }
                    }
                    tblView.reloadData()
                }
                break
                
            case TrackBy.Artist:
                
                self.tblView.allowsMultipleSelection = false
                
                artistId = inputId
                self.GetTracksListByArtistIdandAlbumIdAPI()
                break
                
            case TrackBy.AllTrack:
                dispatch_async(dispatch_get_main_queue(),
                               {
                                self.showLoader()
                });
                //                dispatch_async(dispatch_get_main_queue()) {
                //                                  }
                self.tblView.allowsMultipleSelection = true
                GetAllTracks()
                break
            }
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                // Any Large Task
                self.setTrackData(inputId,isLocal:isLocal,isFromEditPlaylist: false)
                dispatch_async(dispatch_get_main_queue(),
                               {
                                // Update UI in Main thread
                });
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instantiateFromStoryboard() -> LibraryTracksViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! LibraryTracksViewController
    }
    
    // MARK: - Table View Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.isLocal == "0"
        {
            if self.parentViewController != nil
            {
                if let aAlbumDetailsVC = self.parentViewController as? AlbumDetailsVC
                {
                    if aAlbumDetailsVC.trackListContainerHightConstraint != nil
                    {
                        let hight = CGFloat(self.trackArray.count) * self.tableHeight
                        DLog("hight \(hight)")
                        aAlbumDetailsVC.setrackListContainerHightConstraint(hight)
                        //aAlbumDetailsVC.trackListContainerHightConstraint.constant = CGFloat(self.trackArray.count) * self.tableHeight
                        //aAlbumDetailsVC.setScrollViewContainSize()
                    }
                }
                else if let aPlaylist1VC = self.parentViewController as? Playlist1VC
                {
                    aPlaylist1VC.lblNumberOfTracks.text = "number of tracks (\(self.trackArray.count))"
                }
            }
            
            return self.trackArray.count
        }
        else if self.isLocal == "1"
        {
            if self.parentViewController != nil
            {
                if let aAlbumDetailsVC = self.parentViewController as? AlbumDetailsVC
                {
                    if aAlbumDetailsVC.trackListContainerHightConstraint != nil
                    {
                        let hight = CGFloat(self.arrLocalTracks.count) * self.tableHeight
                        DLog("hight \(hight)")
                        aAlbumDetailsVC.setrackListContainerHightConstraint(hight)
                        // aAlbumDetailsVC.trackListContainerHightConstraint.constant = CGFloat(self.arrLocalTracks.count) * self.tableHeight
                        //aAlbumDetailsVC.setScrollViewContainSize()
                    }
                }
                else if let aPlaylist1VC = self.parentViewController as? Playlist1VC
                {
                    aPlaylist1VC.lblNumberOfTracks.text = "number of tracks (\(self.arrLocalTracks.count))"
                }

            }
            
            return self.arrLocalTracks.count
        }
        else
        {
            if self.parentViewController != nil
            {
                if let aAlbumDetailsVC = self.parentViewController as? AlbumDetailsVC
                {
                    if aAlbumDetailsVC.trackListContainerHightConstraint != nil
                    {
                        //aAlbumDetailsVC.setrackListContainerHightConstraint(0)
                        //aAlbumDetailsVC.trackListContainerHightConstraint.constant = 0.0
                        //aAlbumDetailsVC.setScrollViewContainSize()
                    }
                }
                else if let aPlaylist1VC = self.parentViewController as? Playlist1VC
                {
                    aPlaylist1VC.lblNumberOfTracks.text = "number of tracks (0)"
                }

            }
            
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: LibraryTracksTableViewCell = LibraryTracksTableViewCell()
        
        if trackBy == TrackBy.Album
        {
            cell = tableView.dequeueReusableCellWithIdentifier("TracksCellAlbum", forIndexPath: indexPath) as! LibraryTracksTableViewCell
            
        }
        else
        {
            cell = tableView.dequeueReusableCellWithIdentifier("TracksCell", forIndexPath: indexPath) as! LibraryTracksTableViewCell
        }
        cell.btnPlus.addTarget(self, action:#selector(LibraryTracksViewController.btnPlusButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnPlus.tag = indexPath.row
        
        cell.btnFavourite.addTarget(self, action:#selector(LibraryTracksViewController.btnFavouriteTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnFavourite.tag = indexPath.row
        //cell.btnTrackPrice.addTarget(self, action:#selector(LibraryTracksViewController.btnPurchaseTrack(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //cell.btnTrackPrice.tag = indexPath.row
        var trackIdStr = "0"
        if isLocal == "0"
        {
            cell.btnPlus.hidden = false
            cell.btnFavourite.hidden = false
            if cell.btnDownload != nil
            {
                cell.btnDownload.addTarget(self, action:#selector(LibraryTracksViewController.btnDownloadTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.btnDownload.tag = indexPath.row
                cell.btnDownload.hidden = true
            }
            if (self.trackArray.count > indexPath.row)
            {
                var dictTrackDetails = self.trackArray[indexPath.row].dictionaryValue
                
                //let timeParts = GetAlbumDetailsDict["year"]!.stringValue.componentsSeparatedByString("-")
                cell.lblTrackTitle.text = dictTrackDetails["trackName"]!.stringValue
                cell.lblArtist.text = dictTrackDetails["artistName"]!.stringValue
                // print("current album id is:\(dictTrackDetails["albumId"]?.stringValue)")
                trackIdStr = dictTrackDetails["trackId"]!.stringValue
                //for isFavourite = "1"
                // 1 - Favourite , 0 - not favourite
                if dictTrackDetails["isFavorite"] != nil
                {
                    if dictTrackDetails["isFavorite"]!.stringValue == "1"
                    {
                        cell.btnFavourite.selected = true
                    }
                    else
                    {
                        cell.btnFavourite.selected = false
                    }
                }
                else
                {
                    cell.btnFavourite.selected = false
                }
                
                //for isPurchased = "1"
                //cell.btnTrackPrice.hidden = true
                cell.btnPlus.hidden = false
                if dictTrackDetails["isPurchased"] != nil
                {
                    let isPurchased = dictTrackDetails["isPurchased"]!.stringValue
                    if isPurchased == "0"
                    {
                        if dictTrackDetails["iosPrice"]!.stringValue != "0"
                        {
                            //cell.btnTrackPrice.hidden = false
                            cell.btnPlus.hidden = true
                            
                            let newPrice = dictTrackDetails["iosPrice"]!.floatValue
                            
                            if newPrice >= 1
                            {
                                //cell.btnTrackPrice.setTitle("$\(newPrice)", forState: UIControlState.Normal)
                            }
                            else
                            {
                                let centPrice : Int = Int(newPrice * 100)
                                //cell.btnTrackPrice.setTitle("\(centPrice)¢", forState: UIControlState.Normal)
                            }
                        }
                    }
                }
                if dictTrackDetails["isFreeTrack"] != nil
                {
                    let isFreeTrack = dictTrackDetails["isFreeTrack"]!.stringValue
                    if isFreeTrack == "true"
                    {
                        //cell.btnTrackPrice.hidden = true
                        cell.btnPlus.hidden = false
                    }
                }
                let dateStr = "\(dictTrackDetails["duration"]!.stringValue)"
                let durationArr = dateStr.componentsSeparatedByString(".")
                let duration: String = durationArr[0]
                let dur = converHoursToMinut(duration)
                cell.lblTime.text = dur
                
                if trackBy == TrackBy.Album
                {
                    if cell.lblTrackId != nil
                    {
                        cell.lblTrackId.text = dictTrackDetails["number"]!.stringValue
                    }
                    cell.btnPlay.hidden = true
                    if cell.trackLeading != nil
                    {
                        if cell.PlayButtonView != nil
                        {
                            //cell.trackLeading.constant = -1 * cell.PlayButtonView.frame.size.width
                            //cell.trackViewWidth.constant = 1 * cell.PlayButtonView.frame.size.width
                        }
                    }
                }
                else
                {
                    cell.btnPlay.hidden = false
                    if cell.trackLeading != nil
                    {
                        if cell.PlayButtonView != nil
                        {
                            //cell.trackLeading.constant = 0
                        }
                    }
                    
                    let albumURL_str = dictTrackDetails["album_url"]!.stringValue
                    if albumURL_str.characters.count > 0
                    {
                        let imageUrlStr = albumURL_str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                        let imageURL = NSURL(string:imageUrlStr)
                        if imageURL != nil
                        {
                            cell.btnPlay.af_setBackgroundImageForState(.Normal, URL: imageURL!, placeHolderImage: UIImage(named: DEFAULT_IMAGE)!, completion: { response in
                                //self.DLog(response.result.value!) //# UIImage
                                //self.DLog(response.result.error!) //# NSError
                            })
                        }
                    }
                }
                if trackBy ==  TrackBy.Artist
                {
                    cell.btnPlus.hidden = true
                    
                    if let isApprove =  dictTrackDetails["isApproved"]?.boolValue
                    {
                        if isApprove == false
                        {
                            cell.lblTrackTitle.textColor = UIColor.redColor()
                            cell.lblArtist.textColor = UIColor.redColor()
                            cell.lblTime.textColor = UIColor.redColor()
                        }
                        else
                        {
                            cell.lblTrackTitle.textColor = UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1)
                            cell.lblArtist.textColor = UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1)
                            cell.lblTime.textColor = UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1)
                        }
                    }
                }
                if let isApprove =  dictTrackDetails["isApproved"]?.boolValue
                {
                    if isApprove == false
                    {
                        cell.lblTrackTitle.textColor = UIColor.redColor()
                        cell.lblArtist.textColor = UIColor.redColor()
                        cell.lblTime.textColor = UIColor.redColor()
                    }
                    else
                    {
                        cell.lblTrackTitle.textColor = UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1)
                        cell.lblArtist.textColor = UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1)
                        cell.lblTime.textColor = UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1)
                    }
                }
                if trackBy ==  TrackBy.Playlist
                {
                    self.showDownloadButton(cell, dictionaryValue: dictTrackDetails)
                }
               
            }
        
            
        }
        else if isLocal == "1"
        {
            cell.btnPlus.hidden = true
            cell.btnFavourite.hidden = true
            if cell.btnDownload != nil
            {
                cell.btnDownload.hidden = true
            }
            //cell.btnTrackPrice.hidden = true
            if (self.arrLocalTracks.count > indexPath.row)
            {
                let trackDetails : MPMediaItem = self.arrLocalTracks[indexPath.row]
                cell.lblTrackTitle.text = trackDetails.title
                cell.lblArtist.text = trackDetails.artist
                cell.lblTime.text = self.timeString(trackDetails.playbackDuration)
                trackIdStr = "\(trackDetails.persistentID)"
            }
            
            if trackBy == TrackBy.Album
            {
                if cell.lblTrackId != nil
                {
                    let trackDetails : MPMediaItem = self.arrLocalTracks[indexPath.row]
                    cell.lblTrackId.text = "\(trackDetails.albumTrackNumber + 1)"
                }
                
                if cell.lblTrackId != nil
                {
                    cell.lblTrackId.text = String(indexPath.row + 1)
                }
               
                cell.btnPlay.hidden = true
                if cell.trackLeading != nil
                {
                    if cell.PlayButtonView != nil
                    {
                        //cell.trackLeading.constant = -1 * cell.PlayButtonView.frame.size.width
                        //cell.trackViewWidth.constant = 1 * cell.PlayButtonView.frame.size.width
                    }
                }
            }
            else
            {
                cell.btnPlay.hidden = false
                if cell.trackLeading != nil
                {
                    if cell.PlayButtonView != nil
                    {
                        //cell.trackLeading.constant = 0
                    }
                }
                
                if (self.arrLocalTracks.count > indexPath.row)
                {
                    let trackDetails : MPMediaItem = self.arrLocalTracks[indexPath.row]
                    if trackDetails.artwork != nil
                    {
                        if let image =  trackDetails.artwork?.imageWithSize(cell.btnPlay.frame.size)
                        {
                            cell.btnPlay.setBackgroundImage(image, forState: .Normal)
                        }
                        else
                        {
                            cell.btnPlay.setBackgroundImage(UIImage(named: DEFAULT_IMAGE), forState: .Normal)
                            //cell.artistImage.image = nil
                        }
                        
                        //cell.btnPlay.setBackgroundImage(trackDetails.artwork?.imageWithSize(cell.btnPlay.frame.size), forState: .Normal)
                    }
                }
            }
            
        }
        if trackBy == TrackBy.AllTrack
        {
            if  selectedTrackArray.containsObject(self.trackArray[indexPath.row].dictionaryObject!){
                cell.contentView.backgroundColor = UIColor(colorLiteralRed: 184.0/255.0, green: 233.0/255.0, blue: 134.0/255.0, alpha: 0.6)
            }
            else{
                cell.contentView.backgroundColor = UIColor.clearColor()
            }
        }
                
        if trackIdStr == appDelegate.currentSongId
        {
            self.tblView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        }
        //cell.btnTrackPrice.hidden = true
        
        return cell
        
    }
    func showDownloadButton(cell:LibraryTracksTableViewCell,dictionaryValue: [String : JSON])
    {
        if cell.btnDownload != nil
        {
            let dictTrackDetails = dictionaryValue
            cell.btnDownload.hidden = false
            let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
            let trackIdStr = dictTrackDetails["trackId"]!.stringValue
            let destinationUrl = documentsUrl.URLByAppendingPathComponent("\(trackIdStr).mp3")
           
           // print("showDownloadButton : destinationUrl : \(destinationUrl)")
            if NSFileManager().fileExistsAtPath(destinationUrl.path!)
            {
                cell.btnDownload.hidden = true
            }
            else
            {
                if dictTrackDetails["isPurchased"] != nil
                {
                    let isPurchased = dictTrackDetails["isPurchased"]!.stringValue
                    if isPurchased == "0"
                    {
                        if dictTrackDetails["iosPrice"]!.stringValue != "0"
                        {
                            cell.btnDownload.hidden = true
                        }
                        else
                        {
                            cell.btnDownload.hidden = false
                            isTrackDownloadRequired = true
                        }
                    }
                    else
                    {
                        isTrackDownloadRequired = true
                    }
                }
                if dictTrackDetails["isFreeTrack"] != nil
                {
                    let isFreeTrack = dictTrackDetails["isFreeTrack"]!.stringValue
                    if isFreeTrack == "true"
                    {
                        cell.btnDownload.hidden = false
                        isTrackDownloadRequired = true
                    }
                }
            }
           
        }
       
    }
    func setSelectedRow(currTrackIndex : Int)
    {
        let cellCount = self.tblView.numberOfRowsInSection(0)
        
        if  currTrackIndex <= cellCount
        {
            let rowToSelect:NSIndexPath = NSIndexPath(forRow: currTrackIndex, inSection: 0);
            self.tblView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
        }
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        if trackBy == TrackBy.AllTrack
        {
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! LibraryTracksTableViewCell
            selectedCell.contentView.backgroundColor = UIColor(colorLiteralRed: 184.0/255.0, green: 233.0/255.0, blue: 134.0/255.0, alpha: 0.6)
            
            self.selectedTrackArray.addObject(self.trackArray[indexPath.row].dictionaryObject!)
            
            NSNotificationCenter.defaultCenter().postNotificationName("selectedTrackData", object: nil, userInfo: ["array":self.selectedTrackArray])
            
            self.DLog("Selected Array count:\(self.selectedTrackArray.count)")
            
        }
        else
        {
            BaseVC.sharedInstance.DLog("didSelect")
            appDelegate.distopiaUserType = .Artist
            let aLocalSongPlayer = LocalSongPlayer.sharedPlayerInstance1
            if (appDelegate.minimizePlayerView != nil)
            {
                if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
                {
                    appDelegate.playerView = minimizeView
                    appDelegate.minimizePlayerView = minimizeView
                }
                else
                {
                    appDelegate.playerView = appDelegate.minimizePlayerView
                }
            }
            self.tracksCommonArray.removeAll()
            if self.isLocal == "0"
            {
                for i in 0 ..< trackArray.count
                {
                    let tempdic = self.trackArray[i].dictionaryObject
                    let trackObj = Track(trackJSON: JSON(tempdic!))
                    self.tracksCommonArray.append(trackObj)
                }
            }
            else if  self.isLocal == "1"
            {
                appDelegate.arrMediaItems = self.arrLocalTracks
                for i in 0 ..< appDelegate.arrMediaItems.count
                {
                    let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                    dict.setObject("1", forKey: "isLocal")
                    dict.setObject(appDelegate.arrMediaItems[i], forKey: "trackInfo")
                    let dictTrackDetail =  NSMutableDictionary(dictionary: dict as [NSObject : AnyObject])
                    let trackObj = Track(trackDictionary: dictTrackDetail)
                    
                    /**/self.tracksCommonArray.append(trackObj)
                }
            }
            self.setupSharePlayer(indexPath.row)
        }
      
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if trackBy == TrackBy.AllTrack
        {
            let DeSelectedCell = tableView.cellForRowAtIndexPath(indexPath) as! LibraryTracksTableViewCell//tableView.dequeueReusableCellWithIdentifier("TracksCell", forIndexPath: indexPath) as! LibraryTracksTableViewCell
            DeSelectedCell.contentView.backgroundColor = UIColor.clearColor()
            
            //self.selectedTrackArray.addObject(self.trackArray[indexPath.row].dictionaryObject!)
            self.selectedTrackArray.removeObject(self.trackArray[indexPath.row].dictionaryObject!)
            
            NSNotificationCenter.defaultCenter().postNotificationName("selectedTrackData", object: nil, userInfo: ["array":self.selectedTrackArray])
            
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if trackBy == TrackBy.Album
        {
            return 0
            
        }
        else
        {
           return 50.0
        }
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView(frame: CGRectMake(0, 0, 1, 50))
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }
    func converHoursToMinut(currentTime : String) -> String
    {
       
            let timeParts = currentTime.componentsSeparatedByString(":")
            if (timeParts.count > 2)
            {
                //startTimer = "00:07:37"
                let hr = Int(timeParts[0])!*60
                let min = Int(timeParts[1])! + hr
                let sec = timeParts[2]
                if Int(min) <= 9
                {
                     return "0\(min):\(sec)"
                }
                else
                {
                    return "\(min):\(sec)"
                }
                
        }
        return "00:00"
    }
    func playsong()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            // Any Large Task
            // your function here
            
            dispatch_async(dispatch_get_main_queue(),
                           {
                            // Update UI in Main thread
                            if appDelegate.playerView != nil
                            {
                                appDelegate.playerView.isLocal = LocalSongPlayer.sharedPlayerInstance1.isLocal
                                appDelegate.playerView.currTrackIndex = LocalSongPlayer.sharedPlayerInstance1.currTrackIndex
                                appDelegate.playerView.trackArrayPlayer = LocalSongPlayer.sharedPlayerInstance1.trackArrayPlayer
                                appDelegate.playerView.btnPlay.selected = false
                                //  appDelegate.playerView.isShuffle = false
                                //  appDelegate.playerView.btnshuffle.setImage(UIImage.init(named: "grey_crossfade"), forState: .Normal)
                                
                                //            if appDelegate.playerView.viewPlayer != nil
                                //            {
                                //                // appDelegate.playerView.viewPlayer.layer.cornerRadius = 3.0
                                //            }
                                
                                appDelegate.playerView.parentVC = self
                                
                                appDelegate.playerView.preparePlayerArray()
                                
                                appDelegate.playerView.onPlayClick(nil)
                                
                                appDelegate.playerView.loadMinimizePlayer()
                            }
                            
            });
        }
    }
    
    func btnPurchaseTrack(sender: AnyObject)
    {
        let index = sender.tag
        
        
        if (self.trackArray.count > index)
        {
            let trackDic:JSON = trackArray[index]
            let trackId = trackDic["trackId"].stringValue
            
            if !trackId.isEmpty
            {
                let vc : ConfirmAddtoCartVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ConfirmAddtoCartVC") as! ConfirmAddtoCartVC
                vc.idTrackOrAlbum = trackId
                vc.isFrom = 0
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .OverCurrentContext
                navigationController.navigationBarHidden = true
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
           
           // self.AddTrackInCart(trackId)
        }
    }
    
    func preloadMinimizeMusicPlayer(index:Int)
    {
        //var trackId = ""
        let aLocalSongPlayer = LocalSongPlayer.sharedPlayerInstance1
        
        if isLocal == "0"
        {
            aLocalSongPlayer.trackArrayPlayer = self.trackArray
            //var dictTrackDetails = self.trackArray[index].dictionaryValue
            //trackId = (dictTrackDetails["trackId"]?.stringValue)!
            //appDelegate.selectedTrackId = trackId
        }
        else
        {
            appDelegate.arrMediaItems = self.arrLocalTracks
        }
        
        ///**/aLocalSongPlayer.currTrackIndex = index
        /**/aLocalSongPlayer.isLocal = isLocal
        //            if /**/aLocalSongPlayer.playerView.seekSlider != nil
        //            {
        //                if appDelegate.currentSongId != trackId
        //                {
        //                    /**/aLocalSongPlayer.playerView.seekSlider.value = 0
        //                }
        //            }
        
        let trackObj = Track(trackJSON: JSON(self.trackArray[index].dictionaryObject!))
        //trackObj.updateTrackURL()
        if trackObj.track_play_url != nil
        {
            appDelegate.playerView.preparePlayerArray()
        }
        else
        {
            let TrackNotAvailableObj: TrackNotAvailableVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("TrackNotAvailableVC") as! TrackNotAvailableVC
            let navigationController = UINavigationController(rootViewController: TrackNotAvailableObj)
            navigationController.modalPresentationStyle = .OverCurrentContext
            navigationController.navigationBarHidden = true
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    func setupSharePlayer(index:Int)
    {
        // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        // {
        //  dispatch_async(dispatch_get_main_queue(),
        //                 {
        if self.tracksCommonArray.count > index
        {
            let trackObj = self.tracksCommonArray[index]
            
            
            if appDelegate.playerView != nil
            {
                appDelegate.trackObjArray.removeAll()
                
                appDelegate.playerView.isLocal = trackObj.isLocal
                appDelegate.playerView.currTrackIndex = index
                appDelegate.playerView.trackArrayPlayer = []
                appDelegate.trackObjArray = self.tracksCommonArray
                appDelegate.selectedTrackId = trackObj.trackId!
                appDelegate.playerView.btnPlay.selected = false
                
                appDelegate.playerView.parentVC = self
                
                appDelegate.playerView.addTracksToPlayer()
                
                appDelegate.playerView.onPlayClick(nil)
                
                appDelegate.playerView.loadMinimizePlayer()
                
                appDelegate.playerView.trackPercentage = 0
                
                if (trackObj.isLocal == "0")
                {
                    self.PlaySongAPI()
                }
            }
        }
        //  });
        
        //}
        
        //        if isLocal == "0"
        //        {
        //            if self.trackArray.count > index
        //            {
        //                aLocalSongPlayer.trackArrayPlayer = self.trackArray
        //                var dictTrackDetails = self.trackArray[index].dictionaryValue
        //                trackId = (dictTrackDetails["trackId"]?.stringValue)!
        //                appDelegate.selectedTrackId = trackId
        //
        //                if self.trackBy == TrackBy.Playlist
        //                {
        //                    //Track(trackJSON: self.trackArray[index]).updateTrackURLWithDownload(true)
        //                }
        //                else if self.trackBy == TrackBy.Album
        //                {
        //
        //                }
        //                self.PlaySongAPI()
        //            }
        //        }
        //        else
        //        {
        //            appDelegate.arrMediaItems = self.arrLocalTracks
        //        }
        //        /**/aLocalSongPlayer.currTrackIndex = index
        //        /**/aLocalSongPlayer.isLocal = isLocal
        
    }
    
    func timeString(secondTimes: NSTimeInterval?) -> String
    {
        
        if let unwrappedTime = secondTimes {
            if isnan(unwrappedTime) {
                return "00:00"
            }
            
            let min = Int(unwrappedTime / 60)
            let sec = Int(unwrappedTime % 60)
            
            return ((min < 10) ? "0" : "") + "\(min)" + ":" + ((sec < 10) ? "0" : "") + "\(sec)"
        } else {
            return "00:00"
        }
    }
    
    @IBAction func btnPlusButton(sender: AnyObject)
    {
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
                let index = sender.tag
                BaseVC.sharedInstance.DLog("index :\(index)")
                
                var trackId =  ""
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : AddTrackVC = storyboard.instantiateViewControllerWithIdentifier("AddTrackVC") as! AddTrackVC
                
                
                if isLocal == "0"
                {
                    if (trackArray.count > index)
                    {
                        let trackDic:JSON = trackArray[index]
                        trackId = trackDic["trackId"].stringValue
                        vc.selectedTrack = Track(trackJSON: trackDic)
                    }
                }
                else
                {
                    if (self.arrLocalTracks.count > index)
                    {
                        let trackDetails : MPMediaItem = self.arrLocalTracks[index]
                        trackId = ("\(trackDetails.persistentID)")
                        vc.trackDetails = trackDetails
                    }
                }
                vc.selectedTrackId = trackId
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .OverCurrentContext
                appDelegate.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func btnFavouriteTapped(sender: AnyObject)
    {
        
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
                if let btn = sender as? UIButton
                {
                    let index = btn.tag
                    BaseVC.sharedInstance.DLog("index :\(index)")
                    var trackId =  ""
                    if isLocal == "0"
                    {
                        if (trackArray.count > index)
                        {
                            let trackDic = trackArray[index]
                            trackId = trackDic["trackId"].stringValue
                            if !btn.selected == true
                            {
                                self.DLog("fav playlistId = \(BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId"))")
                                self.addSongInPlayListAPI(trackId,playlistId : BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId"))
                            }
                            else
                            {
                                //                        LibraryTrackNotificationObj.lbl = "track removed from Disctopia favorites"
                                
                                self.UnFavouriteSongAPI(trackId,playlistId : BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId"))
                            }
                        }
                    }
                    else
                    {
                        if (self.arrLocalTracks.count > index)
                        {
                            let trackDetails : MPMediaItem = self.arrLocalTracks[index]
                            trackId = ("\(trackDetails.persistentID)")
                        }
                    }
                    
                    
                    //            let navigationController = UINavigationController(rootViewController: LibraryTrackNotificationObj)
                    //            navigationController.modalPresentationStyle = .OverCurrentContext
                    //            navigationController.navigationBarHidden = true
                    //            self.presentViewController(navigationController, animated: true, completion: nil)
                    //            btn.selected = !btn.selected
                }
            }
        }
    }
    
    @IBAction func btnDownloadTapped(sender: AnyObject)
    {
        if let btn = sender as? UIButton
        {
            let index = btn.tag
            BaseVC.sharedInstance.DLog("index :\(index)")
            
            if isLocal == "0"
            {
                if (trackArray.count > index)
                {
                    let trackDic:JSON = trackArray[index]
                    let selectedTrack = Track(trackJSON: trackDic)
                    selectedTrack.updateTrackURLWithDownload(true)
                }
            }
        }
    }

    // MARK: - DeleteSongInPlayList API
    func UnFavouriteSongAPI(trackid : String ,playlistId : String)
    {
        var param = Dictionary<String, String>()
        param["PlayListId"] = playlistId
        param["TrackId"] = trackid
        DLog("UnFavouriteSongAPI param : \(param)")
        
        API.UnFavouriteSong(param) { (result: JSON) in
            if ( result != nil )
            {
                
                let LibraryTrackNotificationObj: LibraryTrackNotificationVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("LibraryTrackNotificationVC") as! LibraryTrackNotificationVC
                LibraryTrackNotificationObj.lbl = "track removed from Disctopia favorites"
                let navigationController = UINavigationController(rootViewController: LibraryTrackNotificationObj)
                navigationController.modalPresentationStyle = .OverCurrentContext
                navigationController.navigationBarHidden = true
                self.presentViewController(navigationController, animated: true, completion: nil)
                
                
                
                BaseVC.sharedInstance.DLog("#### UnFavouriteSong API Response: \(result)")
                self.setTrackData(self.inputId, isLocal: self.isLocal,isFromEditPlaylist: false)
                
                if (appDelegate.favPlaylist != nil)
                {
                    appDelegate.favPlaylist!.initVC()
                }
            }
        }
    }
    
    // MARK: - addSongInPlayListAPI
    func addSongInPlayListAPI(trackid : String ,playlistId : String)
    {
        var param = Dictionary<String, String>()
        param["PlayListId"] = playlistId
        param["TrackId"] = trackid
        param["IsAlbum"] = "0"
        
        DLog("addSongInPlayListAPI param \(param)")
        API.addSongInPlayList(param, aViewController:self) { (result: JSON) in
            if ( result != nil )
            {
                let LibraryTrackNotificationObj: LibraryTrackNotificationVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("LibraryTrackNotificationVC") as! LibraryTrackNotificationVC
                LibraryTrackNotificationObj.lbl = "track added to Disctopia favorites"
                                let navigationController = UINavigationController(rootViewController: LibraryTrackNotificationObj)
                navigationController.modalPresentationStyle = .OverCurrentContext
                navigationController.navigationBarHidden = true
                self.presentViewController(navigationController, animated: true, completion: nil)
                
                
                BaseVC.sharedInstance.DLog("addSongInPlayList API Response: \(result)")
                //self.getAllTrackByPlaylistIdAPI()
                self.setTrackData(self.inputId, isLocal: self.isLocal,isFromEditPlaylist: false)
                if (appDelegate.favPlaylist != nil)
                {
                    appDelegate.favPlaylist!.initVC()
                }
            }
        }
    }
   
    
    // MARK: - GetTracksListByAlbumId
    func GetTracksListByAlbumId()
    {
        var param = Dictionary<String, String>()
        if !appDelegate.selectedAlbumId.isEmpty
        {
            param["albumId"] = appDelegate.selectedAlbumId   // "107"
            DLog("GetTracksListByAlbumId param = \(param)")
            //        self.printAPIURL("GetTracksListByArtistIdandAlbumId", param: param)
            API.GetTracksListByArtistIdandAlbumId(param, aViewController: self) { (result: JSON) in
                if ( result != nil )
                {
                    BaseVC.sharedInstance.DLog("#### GetTracksListByAlbumId API Response: \(result)")
                    self.trackArray = result.arrayValue
                    self.tblView.hidden = false
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tblView.reloadData()
                    }
                    
                    //self.preloadMinimizeMusicPlayer(0)
                    self.DLog("trackArray = \(self.trackArray)")
                }
            }
        }
    }
    
    // MARK: - GetPurchasedTrackByUser API
    func GetPurchasedTrackByUserAPI()
    {
        API.GetPurchasedTrackByUser(nil, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### GetPurchasedTrackByUserAPI API Response: \(result)")
                self.trackArray = result.arrayValue
                self.tblView.hidden = false
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tblView.reloadData()
                })
                // self.preloadMinimizeMusicPlayer(0)
                // self.DLog("trackArray = \(self.trackArray)")
            }
        }
    }
    // MARK: - PlaySong API
    func PlaySongAPI()
    {
        var param = Dictionary<String, String>()
        
        if appDelegate.selectedTrackId.characters.count > 0
        {
            param["trackId"] = appDelegate.selectedTrackId
            DLog("track id = \(appDelegate.selectedTrackId)")
            API.setPlayedTrack(param , aViewController: self) { (result: JSON) in
                if ( result != nil )
                {
                    appDelegate.playedTrackId = result["playedTrackId"].stringValue
                }
            }
            
            //            API.PlaySong(param, aViewController: self) { (result: JSON) in
            //                if ( result != nil )
            //                {
            //                    BaseVC.sharedInstance.DLog("#### PlaySong API Response: \(result)")
            //                }
            //            }
        }
    }
    
    
    // MARK: - getAllTrackByPlaylistIdAPI For Explore
    func getAllTrackByPlaylistIdAPI(isFromEditPlaylist : Bool)
    {
        if (self.playlistId.characters.count > 0)
        {
            var param = Dictionary<String, String>()
            
            param["playlistId"] = self.playlistId
            
            dispatch_async(dispatch_get_main_queue()) {

                self.tblView.reloadData()

                /*
                * Created Date: 17 Jan 2016 S
                * Updated Date:
                * Ticket No:
                * Description : Playlists do not load or load very slowly after navigating away from area Playlists
                * Logic:
                */
                //show loader if loading the data
                if isFromEditPlaylist == true
                {
                    //edit playlist then forefully show loader
                    self.viewSVGLoader.hidden = false

                }
                else
                {
                    if self.trackArray.count == 0
                    {
                        self.viewSVGLoader.hidden = false
                    }
                }
            }

            DLog("getAllTrackByPlaylistIdAPI param = \(param)")
            API.GetAllTrackByPlayListId(param, aViewController: self) { (result: JSON) in
                
                if ( result != nil )
                {
                    self.DLog("Response for getAllTrackByPlaylistIdAPI for Playlist = \(result)")
                    self.isTrackDownloadRequired = false
                    self.trackArray = result.arrayValue
                    //self.DLog("trackListArray  count = \(self.trackArray.count)")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.viewSVGLoader.hidden = true

                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
    // MARK: - Addshoppingcart API
    func AddTrackInCart(trackId:String)
    {
        var param = Dictionary<String, String>()
        
        param["trackId"] = trackId
        DLog("track id = \(appDelegate.selectedTrackId)")
        //albumid
        API.AddShoppingCart(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### AddShoppingCart API Response: \(result)")
                self.setTrackData(self.inputId, isLocal: self.isLocal,isFromEditPlaylist: false)
                //self.ViewshoppingcartData()
            }
            BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("CartSummaryVC", animated: true)
        }
        
    }
    
    // MARK: - Viewshoppingcart API
    func ViewshoppingcartData()
    {
        API.getViewshoppingcart(nil, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### getViewshoppingcart API Response: \(result)")
                
            }
        }
        
        //        data : [{
        //        "trackId" : 236,
        //        "price" : 1.5,
        //        "isAlbum" : false,
        //        "id" : 236,
        //        "albumId" : 32,
        //        "userId" : "398f4085-c280-4084-aa49-6e4aebde4e12",
        //        "count" : 1,
        //        "name" : "Have a Toast"
        //        }, {
        //        "trackId" : 237,
        //        "price" : 1.5,
        //        "isAlbum" : false,
        //        "id" : 237,
        //        "albumId" : 32,
        //        "userId" : "398f4085-c280-4084-aa49-6e4aebde4e12",
        //        "count" : 1,
        //        "name" : "Big Bang Theory"
        //        }]
        
    }
    
    // MARK: - GetTracksListByArtistIdandAlbumId For Explore
    func GetTracksListByArtistIdandAlbumIdAPI()
    {
        
        var param = Dictionary<String, String>()
        let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
        if saveResult != nil
        {
            param["sessiontoken"] = appDelegate.appToken
            param["artistId"] =  saveResult[kAPIUserId].stringValue
        }
        DLog("param = \(param)")
        API.GetTracksListByArtistIdandAlbumId(param, aViewController: self) { (result: JSON) in
            
            if ( result != nil )
            {
                self.tblView.hidden = false
                self.lblTracksDataAlert.hidden = true
                self.DLog("Response for GetTracksListByArtistIdandAlbumIdAPI for Playlist = \(result)")
                self.trackArray = result.arrayValue
                //self.DLog("trackListArray  count = \(self.trackArray.count)")
                if self.trackArray.count == 0
                {
                    self.tblView.hidden = true
                    self.lblTracksDataAlert.hidden = false
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tblView.reloadData()
                }
            }
            else
            {
                self.tblView.hidden = true
                self.lblTracksDataAlert.hidden = false
            }
        }
    }
    
    
    func GetAllTracks()
    {
        /*  self.view.layoutIfNeeded()
         let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
         myActivityIndicator.center = self.view.center
         myActivityIndicator.startAnimating()
         view.addSubview(myActivityIndicator)*/
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.showLoader()
        }
        
        
        var param = Dictionary<String, String>()
        let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
        if saveResult != nil
        {
            param["sessiontoken"] = appDelegate.appToken
            // param["artistId"] =  saveResult[kAPIUserId].stringValue
        }
        DLog("param = \(param)")
        API.GetAllTracks(param, aViewController: self) { (result: JSON) in
            
            
            if ( result != nil )
            {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.hideLoader()
                }
                
                
                self.DLog("GetAllTracks response = \(result)")
                
                self.trackArray = result.arrayValue
                
                if self.trackArray.count == 0
                {
                    self.tblView.hidden = true
                    self.lblTracksDataAlert.hidden = false
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tblView.reloadData()
                    }
                }
                
                //reload tableview to display all tracks
                
            }
        }
    }
    
    
    
    func getDeviceLocalTracks()
    {
        self.arrLocalTracks.removeAll()
        // Load songs
        let query = MPMediaQuery.albumsQuery()
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        query.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        // Only Media type music
        
        if let albumObjects = query.collections {
            
            for album: MPMediaItemCollection in albumObjects
            {
                for song: MPMediaItem in album.items
                {
                    self.arrLocalTracks.append(song)
                }
            }
            
            /*
             for i in 0..<collections.count
             {
             let trackDetails : MPMediaItem = collections[i].representativeItem!
             }
             for i in 0..<self.localTrackCollection.count
             {
             let trackDetails : MPMediaItem = self.localTrackCollection[i].representativeItem!
             self.arrLocalTracks.append(trackDetails)
             }
             */
            self.isLocal = "1"
            if self.arrLocalTracks.count == 0
            {
                self.tblView.hidden = true
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tblView.reloadData()
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
