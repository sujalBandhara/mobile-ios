//
//  SearchTracksFilterVC.swift
//  Disctopia
//
//  Created by Damini on 05/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer

class SearchTracksFilterVC: BaseVC,UITableViewDelegate,UITableViewDataSource
{
    
    // MARK: - Internal property
    private var artists: [MPMediaItemCollection] = []
    var tracksCommonArray = [Track]()
    
    var tracksArray:[JSON] = []
    
    var syncTracksArray = NSMutableArray()
    var trackBy : TrackBy = TrackBy.PurchaseTrack // 0- All Purchase track // 1 - Explore Album // 2 - playlist // 3 - upload

     var selectedTrackArray:NSMutableArray = NSMutableArray()
    @IBOutlet var trackTableView: UITableView!
    
    //MARK: - View Life Cycle -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchTracksFilterVC.reloadTableData(_:)), name: "reloadTrackFilterTbl", object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear SearchForMusicVC")
        //initVC()
        self.view.backgroundColor = UIColor.clearColor()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchTracksFilterVC.reloadTableData(_:)), name: "reloadTrackFilterTbl", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear SearchForMusicVC")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear SearchForMusicVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear SearchForMusicVC")
        
    }
    
    func reloadTableData(notification: NSNotification)
    {
    
        if let dict = notification.object as? NSDictionary
        {
            txtSearchStr = dict["searchText"] as! String
            initVC()
            
        }
        else
        {
            txtSearchStr = ""
            syncTracksArray.removeAllObjects()
            self.tracksArray.removeAll()
            self.trackTableView.reloadData()
        }

//        let dict = notification.object as! NSDictionary
//        txtSearchStr = dict["searchText"] as! String
//        initVC()
        
    }
  
    func  initVC()
    {
        if txtSearchStr != ""
        {
            searchTracksFilterFromAPI()
        }
    }
    
    func syncLocalTrack()
    {
        
        self.tracksCommonArray.removeAll()
        //txtSearchStr = txtSearchStr.stringByReplacingOccurrencesOfString(" ", withString: "")
        // Load artists
        
        let queryArtist = MPMediaQuery.artistsQuery()
        queryArtist.groupingType = MPMediaGrouping.AlbumArtist
        queryArtist.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        queryArtist.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        queryArtist.addFilterPredicate(MPMediaPropertyPredicate(value: txtSearchStr, forProperty: MPMediaItemPropertyArtist, comparisonType: MPMediaPredicateComparison.Contains))
        
        if let collections = queryArtist.collections
        {
            self.artists = collections
            var artistsTrack: [MPMediaItemCollection] = self.artists
            
            //Local Music album list
            for  i in 0 ..< artistsTrack.count
            {
                let track = artistsTrack[i]
                let dic:NSMutableDictionary = NSMutableDictionary()
                dic.setValue("1", forKey: "isLocal")
                dic.setValue(track, forKey: "otherData")
                
                if let representativeItem = track.representativeItem
                {
                    let localTrackDict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                    localTrackDict.setObject("1", forKey: "isLocal")
                    localTrackDict.setObject(track.representativeItem!, forKey: "trackInfo")
                    let dictTrackDetail =  NSMutableDictionary(dictionary: localTrackDict as [NSObject : AnyObject])
                    let trackObj = Track(trackDictionary: dictTrackDetail)
                    self.tracksCommonArray.append(trackObj)
                    
                    
                    let trackTitle =  representativeItem.title
                    let artistnm = representativeItem.artist
                    let tagsStr = representativeItem.genre
                    let releaseDate = representativeItem.releaseDate
                    var desc = ""
                    if releaseDate != nil
                    {
                        if tagsStr != nil
                        {
                            desc = "\(tagsStr!)-\(releaseDate)"
                        }
                    }
                    else
                    {
                        if tagsStr != nil
                        {
                            desc = "\(tagsStr!)"
                        }
                        else
                        {
                            desc = " "
                        }
                    }
                    // use for sorting
                    dic.setValue(trackTitle, forKey: "name")
                    dic.setValue(desc, forKey: "tag")
                    dic.setValue(artistnm, forKey: "artistName")
                    dic.setValue("\(representativeItem.persistentID)", forKey: "trackId")
                }
                syncTracksArray.addObject(dic.mutableCopy())
            }
        }
        
        
        
        let trackPredicate: MPMediaPropertyPredicate = MPMediaPropertyPredicate(value: txtSearchStr, forProperty: MPMediaItemPropertyTitle, comparisonType: MPMediaPredicateComparison.Contains)
        
        //let artistPredicate: MPMediaPropertyPredicate =  MPMediaPropertyPredicate(value: txtSearchStr, forProperty: MPMediaItemPropertyArtist, comparisonType: MPMediaPredicateComparison.Contains)
        
        
        let query = MPMediaQuery.songsQuery()
        query.groupingType = MPMediaGrouping.AlbumArtist
        //query.addFilterPredicate(artistPredicate)
        query.addFilterPredicate(trackPredicate)
        query.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        // query.addFilterPredicate(MPMediaPropertyPredicate(value: txtSearchStr, forProperty: MPMediaItemPropertyTitle, comparisonType: MPMediaPredicateComparison.Contains))
        
        if let collections = query.collections
        {
            var tracks: [MPMediaItemCollection] = collections
            
            //Local Music album list
            for  i in 0 ..< tracks.count
            {
                let track = tracks[i]
                let dic:NSMutableDictionary = NSMutableDictionary()
                dic.setValue("1", forKey: "isLocal")
                dic.setValue(track, forKey: "otherData")
                
                
                
                if let representativeItem = track.representativeItem
                {
                    let localTrackDict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                    localTrackDict.setObject("1", forKey: "isLocal")
                    localTrackDict.setObject(track.representativeItem!, forKey: "trackInfo")
                    let dictTrackDetail =  NSMutableDictionary(dictionary: localTrackDict as [NSObject : AnyObject])
                    let trackObj = Track(trackDictionary: dictTrackDetail)
                    self.tracksCommonArray.append(trackObj)
                    
                    
                    let trackTitle =  representativeItem.title
                    let artistnm = representativeItem.artist
                    let tagsStr = representativeItem.genre
                    let releaseDate = representativeItem.releaseDate
                    var desc = ""
                    if releaseDate != nil
                    {
                        if tagsStr != nil
                        {
                            desc = "\(tagsStr!)-\(releaseDate)"
                        }
                    }
                    else
                    {
                        if tagsStr != nil
                        {
                            desc = "\(tagsStr!)"
                        }
                        else
                        {
                            desc = " "
                        }
                    }
                    // use for sorting
                    dic.setValue(trackTitle, forKey: "name")
                    dic.setValue(desc, forKey: "tag")
                    dic.setValue(artistnm, forKey: "artistName")
                    dic.setValue("\(representativeItem.persistentID)", forKey: "trackId")
                }
                syncTracksArray.addObject(dic.mutableCopy())
            }
        }
        self.trackTableView.reloadData()
        // DLog("syncTracksArrayLocal = \(self.syncTracksArray)")
    }
    
    func syncTracks()
    {
        //API Albums list
        for i in 0 ..< tracksArray.count
        {
            var tempdic = self.tracksArray[i].dictionaryValue
            
            
            let trackObj = Track(trackJSON: JSON(tempdic))
            self.tracksCommonArray.append(trackObj)
            
            
            
            
            let dateStr = "\(tempdic["year"]!.stringValue)"
            let dateArr = dateStr.componentsSeparatedByString("T")
            let date: String = dateArr[0]
            let aDate:String = self.convertDateFormater(date, inputDateFormate: "yyyy-MM-dd", outputDateFormate: "yyyy")
            let tag = "\(tempdic["tags"]!.stringValue) \(aDate)"
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("0", forKey: "isLocal")
            dic.setValue(self.tracksArray[i].rawString(), forKey: "otherData")
            
            // use for sorting
            if let trackName = tempdic["trackName"]?.stringValue
            {
                dic.setValue(trackName, forKey: "name")
            }
            else if let trackName = tempdic["name"]?.stringValue
            {
                dic.setValue(trackName, forKey: "name")
            }
            
            if let artistNameStr = tempdic["artistName"]?.stringValue
            {
                dic.setValue(artistNameStr, forKey: "artistName")
            }
            
            if let trackIdStr = tempdic["trackId"]?.stringValue  //Development Server
            {
                dic.setValue(trackIdStr, forKey: "trackId")
            }
            else if let trackIdStr = tempdic["tackId"]?.stringValue //Live Server
            {
                dic.setValue(trackIdStr, forKey: "trackId")
            }
            
            dic.setValue(tag, forKey: "tag")
            syncTracksArray.addObject(dic.mutableCopy())
        }
        //DLog("syncTracksArray = \(syncTracksArray)")
        self.trackTableView.reloadData()
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instantiateFromStoryboard() -> SearchTracksFilterVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SearchTracksFilterVC
    }
    
    // MARK: - TableView Methods -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.view.superview != nil
        {
            self.view.superview!.backgroundColor = UIColor.clearColor()
        }
        
        return tracksCommonArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTrackCell", forIndexPath: indexPath) as! SearchTrackFilterTableViewCell
        
        cell.btnAdd.addTarget(self, action:#selector(SearchTracksFilterVC.btnPlusButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnAdd.tag = indexPath.row
        
        
        let trackDict = self.tracksCommonArray[indexPath.row]
        let isLocal = trackDict.isLocal //albumListDict["isLocal"] as! String
        
        cell.lblTrackTitle.text =  trackDict.name //albumListDict["name"] as? String
        cell.lblArtistName.text = trackDict.artist  //albumListDict["artistName"] as? String
        
        if isLocal == "0"
        {
            cell.btnAdd.hidden = false
            //var trackDic = JSON.parse(albumListDict["otherData"] as! String)
            //            cell.lblTrackTitle.text =  albumListDict["name"]!!.stringValue
            //            cell.lblArtistName.text = albumListDict["artistNameSEO"]!!.stringValue
            //
            //            let dateStr = "\(trackDic["year"].stringValue)"
            //            let dateArr = dateStr.componentsSeparatedByString("T")
            //            let date: String = dateArr[0]
            //            //  let time: String = dateArr[1]
            //
            //            let aDate:String = self.convertDateFormater(date, inputDateFormate: "yyyy-MM-dd", outputDateFormate: "yyyy")
            //            cell.lblTags.text = "\(trackDic["tags"].stringValue) \(aDate)" // trackDic["year"].stringValue
            
            DLog("trackDict.artist \(trackDict)")
            if self.syncTracksArray.count > indexPath.row
            {
                let albumListDict = self.syncTracksArray[indexPath.row]
                cell.lblTags.text =  albumListDict["tag"] as? String
            }
            else
            {
                cell.lblTags.text = ""
            }
            
            let imageUrl = trackDict.imageURL.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            //trackDic["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: cell.trackImage)
            }
            else
            {
                cell.trackImage.image = UIImage(named: DEFAULT_IMAGE)
            }
        }
        else
        {
            cell.btnAdd.hidden = true
            //let otherData =  albumListDict["otherData"] as! MPMediaItemCollection
            
            if self.syncTracksArray.count > indexPath.row
            {
                let albumListDict = self.syncTracksArray[indexPath.row]
                cell.lblTags.text =  albumListDict["tag"] as? String
            }
            else
            {
                cell.lblTags.text = ""
            }
            
            cell.trackImage.image = trackDict.trackImage
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let trackDict = self.tracksCommonArray[indexPath.row]
        let isLocal = trackDict.isLocal //albumListDict["isLocal"] as! String
        if isLocal == "0"
        {
            appDelegate.selectedTrackId = trackDict.trackId!
        }
        
        appDelegate.distopiaUserType = .Artist
        let aLocalSongPlayer = LocalSongPlayer.sharedPlayerInstance1
        
        self.setupSharePlayer(indexPath.row)
        
        if (appDelegate.minimizePlayerView != nil)
        {
            if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
            {
                appDelegate.minimizePlayerView = minimizeView
                appDelegate.playerView = minimizeView
            }
            else
            {
                appDelegate.playerView = appDelegate.minimizePlayerView
            }
        }
        //self.playsong()
        
        //        appDelegate.distopiaUserType = .Artist
        //        //let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let aLocalSongPlayer = LocalSongPlayer.sharedPlayerInstance1
        //        //let navigationController = UINavigationController(rootViewController: aLocalSongPlayer)
        //        //navigationController.modalPresentationStyle = .OverCurrentContext
        //        self.setupSharePlayer(indexPath.row)
        //
        //        //        if (appDelegate.minimizePlayerView != nil)
        //        //        {
        //        //            appDelegate.playerView = appDelegate.minimizePlayerView
        //        ////            if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
        //        ////            {
        //        ////                appDelegate.playerView = minimizeView
        //        ////            }
        //        //        }
        //
        //        if (appDelegate.minimizePlayerView != nil)
        //        {
        //            if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
        //            {
        //                appDelegate.minimizePlayerView = minimizeView
        //                appDelegate.playerView = minimizeView
        //            }
        //            else
        //            {
        //                appDelegate.playerView = appDelegate.minimizePlayerView
        //            }
        //        }
        //
        //        self.playsong()
        //        //self.presentViewController(navigationController, animated: true, completion: nil)
        //        //tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView(frame: CGRectMake(0, 0, 1, 50))
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }
    
    func setupSharePlayer(index:Int)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            dispatch_async(dispatch_get_main_queue(),
                           {
                            if self.tracksCommonArray.count > index
                            {
                                let trackObj = self.tracksCommonArray[index]
                                
                                if appDelegate.playerView != nil
                                {
                                    
                                    appDelegate.playerView.isLocal = trackObj.isLocal
                                    appDelegate.playerView.currTrackIndex = index
                                    appDelegate.playerView.trackArrayPlayer = []
                                    appDelegate.trackObjArray = self.tracksCommonArray

                                    appDelegate.playerView.btnPlay.selected = false
                                    
                                    appDelegate.playerView.parentVC = self
                                    
                                    appDelegate.playerView.addTracksToPlayer()

                                    //appDelegate.playerView.preparePlayerArray()
                                    
                                    appDelegate.playerView.onPlayClick(nil)
                                    
                                    appDelegate.playerView.loadMinimizePlayer()
                                }
                            }
            });
            
        }
    }
    
    
    //MARK: - API SearchTrackDetails -
    func searchTracksFilterFromAPI()
    {
        syncTracksArray.removeAllObjects()
        self.tracksCommonArray.removeAll()
        
        syncLocalTrack()
      //   txtSearchStr = txtSearchStr.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        var param = Dictionary<String, String>()
        param["TrackName"] = txtSearchStr
        param["isPurchased"] = "1"
        
        
        API.searchTrackDetails(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### SearchTrackDetails API Response: \(result)")
                self.tracksArray = result.arrayValue
            }
            self.syncTracks()
        }
    }
    
    // MARK: - Button Actions -
    @IBAction func btnPlusButton(sender: AnyObject)
    {
        let index = sender.tag
        BaseVC.sharedInstance.DLog("index :\(index)")
        
        NSNotificationCenter.defaultCenter().postNotificationName("removeSearchView", object: nil)//To remove SearchForMusicVC on this Button Click

        
        let albumListDict = self.syncTracksArray[index]
        let isLocal = albumListDict["isLocal"] as! String
        var trackId =  ""
        
        if isLocal == "0"
        {
            
            trackId =  albumListDict["trackId"] as! String
        }
        else
        {
            trackId =  albumListDict["trackId"] as! String
        }
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : AddTrackVC = storyboard.instantiateViewControllerWithIdentifier("AddTrackVC") as! AddTrackVC
        vc.selectedTrackId = trackId
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        appDelegate.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
        
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
