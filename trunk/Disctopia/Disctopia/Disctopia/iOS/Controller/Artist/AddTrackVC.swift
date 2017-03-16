//
//  AddTrackVC.swift
//  Disctopia
//
//  Created by Mitesh on 29/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import MediaPlayer

class AddTrackVC: BaseVC, iCarouselDelegate,iCarouselDataSource
{
    
    // MARK: - Outlet -
    @IBOutlet weak var scrollImageOutlet: UIView!
    @IBOutlet weak var trackAddedNotificationView: UIView!
    @IBOutlet weak var btnDoneOutlet: UIButton!
    @IBOutlet weak var lblPlayListTitle: UILabel!
    var selectedTrack : Track?
    // MARK: - Variable -
    var carousel : iCarousel! = nil
    var selectedTrackId : String = ""
    var trackDetails : MPMediaItem = MPMediaItem()
    var set: [AnyObject] = [AnyObject]()
    var playListId = ""
    var arrPlaylistAll : NSMutableArray = []
    
    var isp:InfiniteScrollPicker!
    
    // MARK: - LifeCycle Method -
    override func viewDidLoad()
    {
        self.navigationController?.navigationBarHidden = true
        super.viewDidLoad()
        
        //Get Playlist From Local Music library.
        //getPlaylistFromLocalLibrary()
        
        //Get Playlist From API.
        getPlaylistFromAPI()
        
        if self.selectedTrackId.characters.count == 0
        {
            //self.selectedTrackId = appDelegate.selectedTrackId
        }
        
    }
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
        btnDoneOutlet.layer.borderWidth = 1.0
        btnDoneOutlet.layer.borderColor = UIColor(white: 1.0, alpha: 1).CGColor
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    func getPlaylistFromLocalLibrary()
    {
        // Load playlists
        let query = MPMediaQuery.playlistsQuery()
        // Only Media type music
        query.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        // Include iCloud item
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        
        arrPlaylistAll = NSMutableArray()
        
        var playlists: [MPMediaPlaylist] = []
        
        playlists = query.collections as? [MPMediaPlaylist] ?? []
        
        for i in 0..<playlists.count
        {
            let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
            dict.setObject("1", forKey: "isLocal")
            
            let playlist = playlists[i]
            
            dict.setObject(playlist, forKey: "playlistInfo")
            
            self.arrPlaylistAll.addObject(dict)
        }
    }
    
    func initiCarousel()
    {
        //let carousel = iCarousel(frame: self.scrollImageOutlet.frame)
        carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: scrollImageOutlet.width, height: scrollImageOutlet.height))
        
        carousel.dataSource = self
        carousel.delegate = self
        carousel.type = .Rotary
        
        scrollImageOutlet.addSubview(carousel)
        
        if (carousel.currentItemIndex >= 0)
        {
            if (self.arrPlaylistAll.count > carousel.currentItemIndex )
            {
                let dict:NSMutableDictionary = self.arrPlaylistAll[carousel.currentItemIndex] as! NSMutableDictionary
                
                if dict["isLocal"]?.integerValue == 1
                {
                    let playlistObj : MPMediaPlaylist = dict["playlistInfo"] as! MPMediaPlaylist
                    
                    lblPlayListTitle.text = playlistObj.name
                }
                else
                {
                    lblPlayListTitle.text = dict["playlistname"] as? String
                }
            }
            else
            {
                lblPlayListTitle.text = "No Playlist found"
            }
        }
        else
        {
            lblPlayListTitle.text = "No Playlist found"
        }
    }
    
    // MARK: - Button Action
    @IBAction func btnPrevious(sender: AnyObject)
    {
        if (self.arrPlaylistAll.count > 0)
        {
            carousel.scrollToItemAtIndex(carousel.currentItemIndex - 1, animated:true)
        }
        //isp.moveToPrevious()
    }
    
    @IBAction func btnNext(sender: AnyObject)
    {
        if (self.arrPlaylistAll.count > 0)
        {
            carousel.scrollToItemAtIndex(carousel.currentItemIndex + 1, animated:true)
        }
        //isp.moveToNext()
    }
    
    @IBAction func btnTapToAddPlaylist(sender: AnyObject)
    {
        if self.arrPlaylistAll.count > 0
        {
            let dict:NSMutableDictionary = self.arrPlaylistAll[carousel.currentItemIndex] as! NSMutableDictionary
            
            if dict["isLocal"]?.integerValue == 1
            {
                let playlistObj : MPMediaPlaylist = dict["playlistInfo"] as! MPMediaPlaylist
                
                if #available(iOS 9.3, *)
                {
                    playlistObj.addMediaItems([self.trackDetails], completionHandler: { (error: NSError?) in
                        
                        BaseVC.sharedInstance.DLog(" Error : \(error!)")
                    })
                    
                    //playlistObj.addMediaItems([self.trackDetails], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
            else
            {
                BaseVC.sharedInstance.DLog("playlistId \(dict["playlistId"])")
                playListId = ("\(dict["playlistId"]!)")
                
                BaseVC.sharedInstance.DLog("Button tapped \(playListId)")
                addSongInPlayListAPI()
            }
        }
    }
    
    @IBAction func btnDone(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func btnTrackAdded(sender: AnyObject)
    {
        
        //trackAddedNotificationView.hidden = true
    }
    
    // MARK: - carousel Delegate
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int
    {
        return self.arrPlaylistAll.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView
    {
        let imageView: UIImageView
        var button : UIButton
        if view != nil
        {
            //imageView = view as! UIImageView
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollImageOutlet.height - 10, height: scrollImageOutlet.height - 10))
            
            button = view as! UIButton
        }
        else
        {
            //imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: scrollImageOutlet.height - 10))
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollImageOutlet.height - 10, height: scrollImageOutlet.height - 10))

        }
        
        button = UIButton(frame: CGRect(x: 0, y: 0, width: scrollImageOutlet.height - 10, height: scrollImageOutlet.height - 10))
        button.center.x = self.view.center.x
        button.setTitle("", forState: .Normal)
        button.setBackgroundImage(imageView.image, forState: .Normal)
        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        if self.arrPlaylistAll.count > index
        {
            let dict:NSMutableDictionary = self.arrPlaylistAll[index] as! NSMutableDictionary
            BaseVC.sharedInstance.DLog("dict \(dict)")
            
            var imageUrl : String = ""
            
            if dict["isLocal"]?.integerValue == 1
            {
                let playlistObj : MPMediaPlaylist = dict["playlistInfo"] as! MPMediaPlaylist
                BaseVC.sharedInstance.DLog(playlistObj)
            }
            else
            {
                
                imageUrl = dict["album_url"]!.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            }
            
            if imageUrl.characters.count > 0
            {
                let URL:NSURL = NSURL(string:imageUrl)!
                let placeholderImage = UIImage(named: DEFAULT_IMAGE)!
                button.setBackgroundImage(placeholderImage, forState: .Normal)
                button.af_setBackgroundImageForState(UIControlState.Normal, URL: URL)
            }
            else
            {
                button.setBackgroundImage(UIImage(named:DEFAULT_IMAGE), forState: .Normal)
            }
        }
        return button
    }
    
    func buttonAction(sender: UIButton!)
    {
        if self.arrPlaylistAll.count > carousel.currentItemIndex
        {
            let dict:NSMutableDictionary = self.arrPlaylistAll[carousel.currentItemIndex] as! NSMutableDictionary
            
            if dict["isLocal"]?.integerValue == 1
            {
                let playlistObj : MPMediaPlaylist = dict["playlistInfo"] as! MPMediaPlaylist
                
                if #available(iOS 9.3, *)
                {
                    playlistObj.addMediaItems([self.trackDetails], completionHandler: { (error: NSError?) in
                        
                        BaseVC.sharedInstance.DLog(" Error : \(error!)")
                    })
                    
                    //playlistObj.addMediaItems([self.trackDetails], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
            else
            {
                BaseVC.sharedInstance.DLog("playlistId \(dict["playlistId"])")
                playListId = ("\(dict["playlistId"]!)")
                
                BaseVC.sharedInstance.DLog("Button tapped \(playListId)")
                addSongInPlayListAPI()
            }
        }
    }
    @IBAction func onCloseSaveChangeView(sender: UIButton)
    {
        self.trackAddedNotificationView.hidden = true
    }
    func carouselDidEndDecelerating(carousel: iCarousel)
    {
        DLog("center \(carousel.currentItemIndex)")
    }
    func carouselCurrentItemIndexDidChange(carousel: iCarousel)
    {
        DLog("index \(carousel.currentItemIndex)")
        if (carousel.currentItemIndex >= 0)
        {
            if (self.arrPlaylistAll.count > carousel.currentItemIndex)
            {
                let dict:NSMutableDictionary = self.arrPlaylistAll[carousel.currentItemIndex] as! NSMutableDictionary
                
                if dict["isLocal"]?.integerValue == 1
                {
                    let playlistObj : MPMediaPlaylist = dict["playlistInfo"] as! MPMediaPlaylist
                    
                    lblPlayListTitle.text = playlistObj.name
                }
                else
                {
                    lblPlayListTitle.text = dict["playlistname"] as? String
                }
            }
            else
            {
                lblPlayListTitle.text = "No Playlist found"
            }
        }
        else
        {
            lblPlayListTitle.text = "No Playlist found"
        }
    }
    
    // MARK: - API -
    func getPlaylistFromAPI()
    {
        API.getPlaylistDetails(nil, aViewController:self) { (json: JSON) in
            
            if ( json != nil )
            {
                self.DLog("JSON: \(json)")
                var playlistArray : [JSON] = []
                
                playlistArray = json.arrayValue
                
                for i in 0..<playlistArray.count
                {
                    let json : JSON = playlistArray[i]
                    
                    let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                    
                    dict.setObject("0", forKey: "isLocal")
                    
                    let albumURL_str = json["album_images"][0].stringValue
                    if albumURL_str.characters.count > 0
                    {
                        let imageUrlStr = albumURL_str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                        dict.setObject(imageUrlStr, forKey: "album_url")
                    }
                    else
                    {
                        dict.setObject("", forKey: "album_url")
                    }
                    dict.setObject(json["playlistname"].stringValue, forKey: "playlistname")
                    dict.setObject(json["playlistId"].stringValue, forKey: "playlistId")
                    
                    self.arrPlaylistAll.addObject(dict)
                }
                self.initiCarousel()
            }
        }
    }
    
    func addSongInPlayListAPI()
    {
        var param = Dictionary<String, String>()
        param["PlayListId"] = "\(playListId)"
        param["TrackId"] = selectedTrackId
        
        API.addSongInPlayList(param, aViewController:self) { (result: JSON) in
            if ( result != nil )
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    // do some task
                    if self.selectedTrack != nil
                    {
                        self.selectedTrack?.updateTrackURLWithDownload(true)
                    }
                    
                    //appDelegate.playlistVC.reloadPlaylist()
                    dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                    }
                }
               
                BaseVC.sharedInstance.DLog("addSongInPlayList API Response: \(result)")
                self.trackAddedNotificationView.hidden = false
                NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(AddTrackVC.onCloseSaveChangeView(_:)), userInfo: nil, repeats: false)
            }
        }
    }
    
    /*
     func getListFromAPI()
     {
     
     API.getPlaylist(nil, aViewController:self) { (result: JSON) in
     
     if ( result != nil )
     {
     BaseVC.sharedInstance.DLog("getPlaylist API Response: \(result)")
     self.playlistArray =  result.arrayValue
     
     let playListDict = NSMutableDictionary(dictionary: result["playlistDict"].dictionaryObject!)
     let playLostDictKeys = playListDict.allKeys
     for  index in 0 ..< playLostDictKeys.count
     {
     if let dictKey =  playLostDictKeys[index] as? String
     {
     let aDict = NSMutableDictionary()
     aDict["playlistName"] = dictKey
     aDict["playListImageURL"] = ""
     if let playListtrackArray = playListDict[dictKey] as? NSArray
     {
     if playListtrackArray.count > 0
     {
     if let playListtrackDict = playListtrackArray[0] as? NSDictionary
     {
     if let playListImageURLStr = playListtrackDict["album_url"] as? String
     {
     aDict["playListImageURL"] = playListImageURLStr
     }
     
     if let playListIdStr = playListtrackDict["playListId"] as? String
     {
     aDict["playListId"] = playListIdStr
     }
     }
     }
     }
     self.playlistArray.addObject(aDict)
     }
     }
     self.DLog("self.playlistArray = \(self.playlistArray)")
     }
     }
     }
     
     */
    /*
     func loadOldImageSlider()
     {
     //        for var i in 0 ..< 10
     //        {
     // set.append(UIImage(named: "dummy_img5.png")!)
     //        }
     
     set.append(UIImage(named: "dummy_img1.png")!)
     set.append(UIImage(named: "default_img.png")!)
     set.append(UIImage(named: "dummy_img4.png")!)
     set.append(UIImage(named: "dummy_img5.png")!)
     set.append(UIImage(named: "dummy_img2.png")!)
     
     func btnTouched(sender: UIButton)
     {
     DLog("\(sender.tag)")
     }
     scrollImageOutlet.layoutIfNeeded()
     isp = InfiniteScrollPicker(frame: CGRectMake(0, 0, scrollImageOutlet.width, scrollImageOutlet.height))
     isp.itemSize = CGSizeMake(scrollImageOutlet.width / 5  , scrollImageOutlet.height - 70)
     //UIScreen.mainScreen().bounds.width/4
     isp.imageAry = set
     isp.heightOffset = 25
     isp.positionRatio = 2
     isp.alphaOfobjs = 0.8
     isp.setSelectedItem(0)
     self.scrollImageOutlet!.addSubview(isp)
     
     //let button = UIButton(frame: CGRect(x: isp.center.x - (scrollImageOutlet.width / 4), y: 0, width: scrollImageOutlet.width / 4, height: scrollImageOutlet.height))
     //        button.center.x = self.view.center.x
     //        button.backgroundColor =  .None
     //        button.setTitle("", forState: .Normal)
     //        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
     //  self.scrollImageOutlet.addSubview(button)
     }
     func buttonAction(sender: UIButton!)
     {
     BaseVC.sharedInstance.DLog("Button tapped")
     //trackAddedNotificationView.hidden = false
     self.trackAddedNotificationView.hidden = false
     NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AddTrackVC.onCloseSaveChangeView(_:)), userInfo: nil, repeats: false)
     }
     @IBAction func onCloseSaveChangeView(sender: UIButton)
     {
     self.trackAddedNotificationView.hidden = true
     }
     func infiniteScrollPicker(infiniteScrollPicker: InfiniteScrollPicker, didSelectAtImage imageView: UIImageView)
     {
     
     NSLog("selected image \(imageView.tag - (set.count-1))")
     NSLog("Selected Image Tag \((imageView.tag - (set.count-1))%set.count + 1)")
     }
     
     */
    
}
