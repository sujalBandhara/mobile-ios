//
//  PlayerBaseVC.swift
//  Disctopia
//
//  Created by Mitesh on 02/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer
import AVKit
import AVFoundation
//let /**/self = PlayerBaseVC.sharedInstancePlayer
//let rand = Int(arc4random_uniform(10))

@IBDesignable class PlayerBaseVC: UIView
{
    @IBOutlet weak var maximizePlayerView: UIView!
    
    
   
    
    var parentVC: UIViewController?
    var isOpenView : Bool = false
    //static let sharedInstancePlayer = PlayerBaseVC()
    //let sself = PlayerBaseVC.sharedInstancePlayer ..
    let audioSession = AVAudioSession.sharedInstance()
    var activeDownloads = [String: Download]()
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?
    var aTracksVC: LibraryTracksViewController? = nil

     var trackPercentage = 0
    
    lazy var downloadsSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("bgSessionConfiguration")
        let session = NSURLSession(configuration: configuration, delegate: /**/self, delegateQueue: nil)
        return session
    }()
    
    // MARK: - Outlet -
    @IBOutlet  var lblTrackTitle: UILabel!
    @IBOutlet  var lblArtistTitle: UILabel!
    @IBOutlet  var lblTrackCurrentTime: UILabel!
    @IBOutlet  var lblTrackEndTime: UILabel!
    @IBOutlet  var lblAlbumTitle: UILabel!
    @IBOutlet  var imgArtwork: UIImageView!
    @IBOutlet  var btnPlay: UIButton!
    @IBOutlet  var seekSlider: UISlider!
    @IBOutlet  var addSongClick: UIButton!
    @IBOutlet  var btnPurchase: UIButton!
    @IBOutlet var btnFavourit: UIButton!
    
    @IBOutlet weak var btnshuffle: UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var viewPlayer: UIView!
    
    // MARK: - Variable -
    let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
    var trackArrayPlayer:[JSON] = []
    //var originalTrackArray:[JSON] = []
    var isRepeatTrack : Int = 0 //0 = No Repeat , 1 = Repeat All , 2 = Repeat One.
    var isShuffle = false
    //var arrTrackList  = NSMutableArray()
    //var  originalArrTrackList = NSMutableArray()
    var isLocal : String = ""
    
    var currTrackIndex : Int = 0
    var pauseTime : NSTimeInterval!
    var trackDurationInSecond : CGFloat = 0
    
    //var audioPlayer:AVAudioPlayer?
    let transition = PopAnimator()
    var isPurchased = "1"
    private var myContext = 0
    //var player = AVPlayer()
    var previousNumber: UInt32? // used in randomNumber()
    
    // Our custom view from the XIB file
    var view: UIView!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        if self.subviews.count == 0 {
            xibSetup()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        xibSetup()
        // 3. Setup view from .xib file
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        if (self.dynamicType == MinimizePlayerView.self)
        {
            if (appDelegate.minimizePlayerView  == nil)
            {
                appDelegate.minimizePlayerView = self
                
            }
            setMinimizePlayerFrame()
        }
        else
        {
            self.addShadow()
        }
        
        customInit()
    }
    
    func addShadow()
    {
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // your function here
            if self.maximizePlayerView != nil
            {
                let shadowPath = UIBezierPath(rect: self.maximizePlayerView.bounds)
                self.maximizePlayerView.layer.masksToBounds = false
                self.maximizePlayerView.layer.shadowColor = UIColor.blackColor().CGColor
                self.maximizePlayerView.layer.shadowOffset = CGSizeMake(0.0, 5.0)
                self.maximizePlayerView.layer.shadowOpacity = 0.5
                self.maximizePlayerView.layer.shadowPath = shadowPath.CGPath
                
                //self.maximizePlayerView.layer.masksToBounds = false
                //self.maximizePlayerView.layer.shadowOffset = CGSizeMake(-5, 10)
                //self.maximizePlayerView.layer.shadowRadius = 5
                //self.maximizePlayerView.layer.shadowOpacity = 0.5
                self.maximizePlayerView.layer.cornerRadius = 5
            }
        })
    }
    
    // MARK: - Progress View
    @IBOutlet var progressBar: YLProgressBar!
    
    func setProgressPerc(per:CGFloat)
    {
        self.setProgress(per, animated: true)
        self.seekSlider.setValue(Float(per), animated: true)
    }
    
    func setProgress(progress: CGFloat, animated: Bool)
    {
        if self.progressBar != nil
        {
            self.progressBar.setProgress(progress, animated: animated)
        }
        if  self.seekSlider != nil
        {
            self.seekSlider.setValue(Float(progress), animated: true)
        }
    }
    
    func initFlatRainbowProgressBar()
    {
        if self.progressBar != nil
        {
        
            
        let tintColors: [AnyObject] = [UIColor(red: 107 / 255.0, green: 191 / 255.0, blue: 113 / 255.0, alpha: 1.0),
                                       UIColor(red: 161 / 255.0, green: 200 / 255.0, blue: 117 / 255.0, alpha: 1.0)]
        self.progressBar.type = .Flat
       
        self.progressBar.progressTintColors = tintColors
        self.progressBar.hideStripes = true
        self.progressBar.hideTrack = true
        self.progressBar.behavior = .Default
        self.progressBar.layoutIfNeeded()
        self.progressBar.setProgress(0.0, animated: false)

        }
    }
    
    // MARK: - Set Frame
    func setMinimizePlayerFrame()
    {
        if (appDelegate.minimizePlayerView != nil)
        {
            let minimizePlayerHight = MINIMIZE_PLAYER_HEIGHT
            appDelegate.minimizePlayerView!.frame = CGRect(x: 0, y: ScreenSize.SCREEN_HEIGHT - minimizePlayerHight , width: ScreenSize.SCREEN_WIDTH, height: minimizePlayerHight)
            appDelegate.minimizePlayerView!.translatesAutoresizingMaskIntoConstraints = true
            appDelegate.minimizePlayerView?.layoutIfNeeded()
            appDelegate.minimizePlayerView?.updateConstraintsIfNeeded()
        }
    }
    
    class func instanceFromNib() -> UIView
    {
        return UINib(nibName: "MinimizePlayerView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    func loadViewFromNib() -> UIView
    {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        if (self.dynamicType == MinimizePlayerView.self)
        {
            let nib = UINib(nibName: "MinimizePlayerView", bundle: bundle)
            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
            //MinimizePlayerView
            return view
        }
        else
        {
            let nib = UINib(nibName: "PlayerBaseVC", bundle: bundle)
            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
            return view
        }
        
    }
    
    func customInit()
    {
        //UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        //background playing
        
        //        do
        //        {
        //            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .DefaultToSpeaker)
        //        }
        //        catch
        //        {
        //            NSLog("Failed to set audio session category.  Error: \(error)")
        //        }
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleInterruption(_:)), name: AVAudioSessionInterruptionNotification, object: nil)
        
        //appDelegate.player.actionAtItemEnd = .Advance
        appDelegate.player.addObserver(/**/self, forKeyPath: "currentItem", options: OCUtils.keyValueObservingOptions() , context: &myContext)
        appDelegate.player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 100), queue: dispatch_get_main_queue())
        {time in
        }
        
        self.initFlatRainbowProgressBar()
        self.setPurchaseBtn()
       // self.setFavoriteBtn()
        NSNotificationCenter.defaultCenter().addObserver(/**/self, selector: #selector(PlayerBaseVC.setName), name: "basePlayer", object: nil)
        
        self.view.backgroundColor = UIColor.clearColor()
        
        if (self.dynamicType == MinimizePlayerView.self)
        {
            self.seekSlider.hidden = true
            if (appDelegate.minimizePlayerView  != nil)
            {
                self.seekSlider.thumbTintColor = UIColor.clearColor()
                self.seekSlider.setThumbImage(nil, forState: UIControlState.Normal)
                self.seekSlider.setMaximumTrackImage(UIImage(named: "seekbar_grey.png"), forState: UIControlState.Normal)
                self.seekSlider.setMinimumTrackImage(UIImage(named: "seekbar_color.png"), forState: UIControlState.Normal)
                self.seekSlider.setThumbImage(nil, forState: UIControlState.Highlighted)
            }
            
        }
        else
        {
            self.seekSlider.hidden = false
            self.seekSlider.setThumbImage(UIImage(named: "green_slider_bar"), forState: UIControlState.Normal)
            self.seekSlider.setMaximumTrackImage(UIImage(named: "seekbar_grey.png"), forState: UIControlState.Normal)
            self.seekSlider.setMinimumTrackImage(UIImage(named: "seekbar_color.png"), forState: UIControlState.Normal)
            self.seekSlider.setThumbImage(UIImage(named: "green_slider_bar"), forState: UIControlState.Highlighted)
        }
        
    }
    
    deinit
    {
        //appDelegate.player.removeObserver(self, forKeyPath: "currentItem", context: &myContext)
        NSNotificationCenter.defaultCenter().removeObserver(/**/self)
    }
    /*
     // MARK: - #LifeCycle Method -
     override func viewDidLoad()
     {
     super.viewDidLoad()
     
     UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
     //background playing
     
     do {
     try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .DefaultToSpeaker)
     } catch {
     NSLog("Failed to set audio session category.  Error: \(error)")
     }
     
     //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleInterruption(_:)), name: AVAudioSessionInterruptionNotification, object: nil)
     
     //appDelegate.player.actionAtItemEnd = .Advance
     appDelegate.player.addObserver(/**/self, forKeyPath: "currentItem", options: OCUtils.keyValueObservingOptions() , context: &myContext)
     //reloadArray()
     }
     
     override func viewWillAppear(animated: Bool)
     {
     super.viewWillAppear(animated)
     BaseVC.sharedInstance.DLog("WillAppear PlayerBaseVC")
     reloadArray()
     preparePlayerArray()
     NSNotificationCenter.defaultCenter().addObserver(/**/self, selector: #selector(PlayerBaseVC.setName), name: "basePlayer", object: nil)
     }
     
     override func viewWillDisappear(animated: Bool)
     {
     super.viewWillDisappear(animated)
     NSNotificationCenter.defaultCenter().removeObserver(/**/self)
     }
     
     override func viewDidAppear(animated: Bool)
     {
     super.viewDidAppear(animated)
     }
     */
    // MARK: - #Observer
    func setName(data: NSNotification)
    {
        if let aplayerView = data.object
        {
            //            if appDelegate.playerView != nil
            //            {
            //                self.viewPlayer =  appDelegate.playerView
            //            }
            
            BaseVC.sharedInstance.DLog("setName playerView.currTrackIndex = \(appDelegate.playerView.currTrackIndex)")
            BaseVC.sharedInstance.DLog("setName self.currTrackIndex = \(self.currTrackIndex)")
            
            appDelegate.trackObjArray = /**/aplayerView as! [Track]
            self.currTrackIndex = /**/appDelegate.playerView.currTrackIndex
            self.btnPlay.selected = appDelegate.playerView.btnPlay.selected
            self.imgArtwork.image = appDelegate.playerView.imgArtwork.image
            
            self.initFlatRainbowProgressBar()
            
            if appDelegate.playerView.progressBar != nil
            {
                self.progressBar = appDelegate.playerView.progressBar
            }
//            if appDelegate.playerView.seekSlider != nil
//            {
//                self.seekSlider = appDelegate.playerView.seekSlider
//            }
            if appDelegate.playerView.lblTrackCurrentTime != nil
            {
                self.lblTrackCurrentTime = appDelegate.playerView.lblTrackCurrentTime
            }
        }
        reloadArray()
        
    }
    
    // MARK: PlayerDidFinishPlaying
    func playerDidFinishPlaying(note: NSNotification)
    {
        // Your code here
        if let playerItem = note.object as? AVPlayerItem
        {
            BaseVC.sharedInstance.DLog("playerDidFinishPlaying playerItem = \(playerItem)")
        }
        NSNotificationCenter.defaultCenter().removeObserver(note)
        /**//**/self.onNextTrackClick(nil)
        
        NSNotificationCenter.defaultCenter().postNotificationName("basePlayer", object: appDelegate.trackObjArray)
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
                                     successfully flag: Bool)
    {
        
    }
    
    // MARK: KVO Update Name of the Song
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if keyPath == "currentItem", let player = object as? AVPlayer,
            currentItem = player.currentItem?.asset as? AVURLAsset
        {
            ///**/self.lblTrackTitle.text = currentItem.URL.lastPathComponent?.stringByReplacingOccurrencesOfString(".mp3", withString: "") ?? "Unknown"
            configNowPlayingCenter(currentItem)
        }
        else if keyPath == "rate", let player = object as? AVPlayer,
            currentItem = player.currentItem?.asset as? AVURLAsset
        {
            
        }
        
    }
    
    //Configuration NowPlayingCenter
    func configNowPlayingCenter(currentItem: AVURLAsset)
    {
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // your function here
            BaseVC.sharedInstance.DLog("configNowPlayingCenter with \(currentItem)")
            if (NSClassFromString("MPNowPlayingInfoCenter") != nil) {
                
                for atrackObj in /**/appDelegate.trackObjArray
                {
                    let trackObj = atrackObj
                    //trackObj.updateTrackURL()
                    let url : NSURL?
                    //if (trackObj.track_play_url! == currentItem.URL) //TODO change this
                    //                if (trackObj.isLocal == "0")
                    //                {
                    //                    url = NSURL(string: trackObj.track_url!.stringByReplacingOccurrencesOfString("\\/", withString: "/"))!
                    //                }
                    //                else
                    //                {
                    //                    url = trackObj.track_play_url!
                    //                }
                    
                    
                    if trackObj.track_play_url != nil
                    {
                        url = trackObj.track_play_url!
                        if (url! == currentItem.URL)
                        {
                            var songInfo = Dictionary<String, AnyObject>()
                            var albumArt = MPMediaItemArtwork(image: trackObj.trackImage)
                            
                            
                            if /**/self.isLocal == "0"
                            {
                                     //albumArt = MPMediaItemArtwork(image:self.imgArtwork.image!)
                                albumArt = MPMediaItemArtwork(image: trackObj.trackImage)
                            }
                            else
                            {
                                    albumArt = MPMediaItemArtwork(image: trackObj.trackImage)
                            }
                            
                            
                            songInfo[MPMediaItemPropertyTitle] = trackObj.name
                            songInfo[MPMediaItemPropertyArtist] = trackObj.artist
                            songInfo[MPMediaItemPropertyAlbumTitle] = trackObj.albumName
                            songInfo[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(double: 1.0)
                            songInfo[MPMediaItemPropertyArtwork] = albumArt
                            if (appDelegate.player.currentItem != nil)
                            {
                                DLog("seconds : \(appDelegate.player.currentItem!.duration.seconds)")
                                //songInfo[MPMediaItemPropertyPlaybackDuration] = NSNumber(double: (appDelegate.player.currentItem?.duration.seconds)!)
                                songInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(double:(appDelegate.player.currentTime().seconds))
                                songInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds((appDelegate.player.currentItem?.duration)!)
                            }
                            else
                            {
                                //songInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(double: 0.0)
                                
                                if trackObj.track_play_url != nil
                                {
                                    let playerItem = AVPlayerItem(URL: trackObj.track_play_url!)
                                    let duration : CMTime = playerItem.asset.duration
                                    songInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(duration)
                                }
                            }
                            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
                            break
                        }
                    }
                }
            }
            
        })
    }
    
    // MARK: - #Funcations
    func reloadArray()
    {
        BaseVC.sharedInstance.DLog("1@ self.currTrackIndex = \(self.currTrackIndex)")
        
        
        if appDelegate.playerView != nil
        {
            self.view = appDelegate.playerView
        }
        
        self.isRepeatTrack = appDelegate.playerView.isRepeatTrack
        self.isLocal = appDelegate.playerView.isLocal
        self.currTrackIndex = appDelegate.playerView.currTrackIndex
        
        
        if appDelegate.trackObjArray.count > self.currTrackIndex
        {
            let trackObj = appDelegate.trackObjArray[/**/self.currTrackIndex]
            self.isLocal = trackObj.isLocal
            if self.btnFavourit != nil
            {
                let isfav = trackObj.isFavorite
                if isfav == "1"
                {
                    self.btnFavourit.selected = true
                }
                else
                {
                    self.btnFavourit.selected = false
                }
            }
            if appDelegate.playerTimer != nil
            {
                self.trackDurationInSecond = /**/appDelegate.playerView.trackDurationInSecond
                /**/self.startTrackProgress()
            }
            
            self.isShuffle = appDelegate.playerView.isShuffle
            
            self.setPlayerViewData()
            //  self.setFavoriteBtn()
        }
        
    }
    func preparePlayerArray()
    {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        appDelegate.trackObjArray.removeAll()
        // self.isLocal = /**/self.isLocal
        //var playerItemArray:[AVPlayerItem] = []
        
        if /**/self.isLocal == "0"
        {
            for index in 0..</**/self.trackArrayPlayer.count
            {
                let trackObj = Track(trackJSON: JSON(/**/self.trackArrayPlayer[index].dictionaryObject!))
                //trackObj.updateTrackURL()
//                if trackObj.track_play_url != nil
//                {
//                    //let playerItem = AVPlayerItem(URL:trackObj.track_play_url!)
//                   // playerItemArray.append(playerItem)
//                    /**/self.trackObjArray.append(trackObj)
//                }
                appDelegate.trackObjArray.append(trackObj)
            }
            
            DLog("1 trackObjArray \(/**/appDelegate.trackObjArray)")
        }
        else
        {
            for i in 0 ..< appDelegate.arrMediaItems.count
            {
                let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                dict.setObject("1", forKey: "isLocal")
                dict.setObject(appDelegate.arrMediaItems[i], forKey: "trackInfo")
                let dictTrackDetail =  NSMutableDictionary(dictionary: dict as [NSObject : AnyObject])
                let trackObj = Track(trackDictionary: dictTrackDetail)
               
//                if trackObj.track_play_url != nil
//                {
//                    let playerItem = AVPlayerItem(URL:trackObj.track_play_url!)
//                    playerItemArray.append(playerItem)
//                }
                /*else
                 {
                 let TrackNotAvailableObj: TrackNotAvailableVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("TrackNotAvailableVC") as! TrackNotAvailableVC
                 let navigationController = UINavigationController(rootViewController: TrackNotAvailableObj)
                 navigationController.modalPresentationStyle = .OverCurrentContext
                 navigationController.navigationBarHidden = true
                 self.parentVC!.presentViewController(navigationController, animated: true, completion: nil)
                 }*/
                /**/appDelegate.trackObjArray.append(trackObj)
                
            }
            
            DLog("2 trackObjArray \(/**/appDelegate.trackObjArray)")
        }
        self.addTracksToPlayer()
    }
    
    func addTracksToPlayer()
    {
//        if self.trackArrayPlayer.count > self.currTrackIndex
//        {
//            let isfav = self.trackArrayPlayer[self.currTrackIndex]["isFavorite"].stringValue
//            
//            if self.btnFavourit != nil
//            {
//                if isfav == "1"
//                {
//                    self.btnFavourit.selected = true
//                }
//                else
//                {
//                    self.btnFavourit.selected = false
//                }
//            }
//        }

        var playerItemArray:[AVPlayerItem] = []
        if appDelegate.trackObjArray.count > 0
        {
            for cnt in 0...appDelegate.trackObjArray.count-1
            {
                if let trackObj = appDelegate.trackObjArray[cnt] as? Track
                {
                    if (self.currTrackIndex == cnt)
                    {
                        if self.btnFavourit != nil
                        {
                            self.btnFavourit.selected = false
                            if (trackObj.isLocal == "0")
                            {
                                if trackObj.isFavorite == "1"
                                {
                                    self.btnFavourit.selected = true
                                }
                            }
                        }
                    }
                    
                    if trackObj.track_play_url != nil
                    {
                        let playerItem = AVPlayerItem(URL:trackObj.track_play_url!)
                        playerItemArray.append(playerItem)
                    }
                   
                }
            }
            
            //self.trackObjArray = /**/self.trackObjArray
            appDelegate.player = AVQueuePlayer(items: playerItemArray)
            appDelegate.player.actionAtItemEnd = .Advance
            DLog("3 appDelegate.player.items().count \(appDelegate.player.items().count)")
            
            if (appDelegate.player.currentItem != nil)
            {
                NSNotificationCenter.defaultCenter().addObserver(/**/self, selector: #selector(PlayerBaseVC.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: appDelegate.player.currentItem)
                
                NSNotificationCenter.defaultCenter().addObserver(/**/self, selector: #selector(PlayerBaseVC.playerDidFinishPlaying(_:)), name: AVPlayerItemPlaybackStalledNotification, object: appDelegate.player.currentItem)
            }
            
            startDownloadingUrls()
            //NSNotificationCenter.defaultCenter().addObserver(/**/self, selector: #selector(PlayerBaseVC.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: appDelegate.player.items().last)
        }
    }
    
    
    //MARK: - Button Action -
    @IBAction func onPlayClick(sender: UIButton?)
    {
        setMinimizePlayerFrame()
        
        if /**/self.btnPlay != nil
        {
            
            if /**//**/self.btnPlay.selected
            {
                if appDelegate.playerTimer != nil
                {
                    appDelegate.playerTimer?.invalidate()
                    appDelegate.playerTimer = nil
                    
                    /**//**/self.btnPlay.selected = false
                    appDelegate.player.pause()
                    if (!appDelegate.player.currentTime().seconds.isNaN)
                    {
                        /**/self.pauseTime = appDelegate.player.currentTime().seconds
                    }
                    else
                    {
                        self.pauseTime = nil
                    }
                }
            }
            else
            {
                /**/self.playMusic()
            }
        }
    }
    
    @IBAction func onNextTrackClick(sender: AnyObject?)
    {
        trackPercentage = 0
        BaseVC.sharedInstance.DLog("onNextTrackClick")
        //setMinimizePlayerFrame()
        /**/self.reloadArray()
        self.currentQueueToShuffle()
        
        //0 = No Repeat , 1 = Repeat All , 2 = Repeat One.
        
        if /**//**/self.isRepeatTrack == 2
        {
            if appDelegate.playerTimer != nil
            {
                appDelegate.playerTimer?.invalidate()
                appDelegate.playerTimer = nil
            }
            /**/self.pauseTime = nil
            /**/self.seekSlider.value = 0
            if (self.progressBar != nil)
            {
                self.progressBar.setProgress(0.0, animated: false)
            }
            appDelegate.player.pause()
            /**/self.playMusic()
        }
        else if /**//**/self.isRepeatTrack == 1
        {
            if /**//**/self.currTrackIndex >= /**//**/appDelegate.trackObjArray.count-1
            {
                self.currTrackIndex = 0
            }
            else
            {
                /**//**/self.currTrackIndex += 1;
            }
            /**/self.pauseTime = nil
            /**/self.playMusic()
        }
        else
        {
            if /**//**/self.currTrackIndex >= /**//**/appDelegate.trackObjArray.count-1
            {
                self.currTrackIndex = 0
                if appDelegate.playerTimer != nil
                {
                    appDelegate.playerTimer?.invalidate()
                    appDelegate.playerTimer = nil
                }
                self.pauseTime = nil
                self.seekSlider.value = 0
                if (self.progressBar != nil)
                {
                    self.progressBar.setProgress(0.0, animated: false)
                }
                appDelegate.player.pause()
                appDelegate.playerView.btnPlay.selected = false
            }
            else
            {
                self.currTrackIndex += 1;
                self.pauseTime = nil
                self.playMusic()
            }
            
        }
    }
    
    @IBAction func onPreviousTrackClick(sender: AnyObject?)
    {
        trackPercentage = 0
        setMinimizePlayerFrame()
        /**/self.reloadArray()
        self.currentQueueToShuffle()
        
        if appDelegate.playerTimer != nil
        {
            appDelegate.playerTimer?.invalidate()
            appDelegate.playerTimer = nil
            //
            //        if appDelegate.playerTimer != nil
            //        {
            //            appDelegate.playerTimer!.invalidate()
            appDelegate.player.pause()
            if (!appDelegate.player.currentTime().seconds.isNaN)
            {
                /**/self.pauseTime = appDelegate.player.currentTime().seconds
            }
            else
            {
                self.pauseTime = nil
            }
        }
        if /**//**/self.isRepeatTrack == 2
        {
            if appDelegate.playerTimer != nil
            {
                appDelegate.playerTimer?.invalidate()
                appDelegate.playerTimer = nil
            }
            /**/self.pauseTime = nil
            if (self.progressBar != nil)
            {
                self.progressBar.setProgress(0.0, animated: false)
            }
            /**/self.seekSlider.value = 0
            appDelegate.player.pause()
            /**/self.playMusic()
        }
        else if /**//**/self.isLocal == "0"
        {
            if /**//**/self.currTrackIndex <= 0
            {
                /**//**/self.currTrackIndex = /**//**/appDelegate.trackObjArray.count-1
            }
            else
            {
                /**//**/self.currTrackIndex -= 1;
            }
            /**/self.pauseTime = nil
            /**/self.playMusic()
        }
        else
        {
            if /**//**/self.currTrackIndex <= 0
            {
                /**//**/self.currTrackIndex = /**//**/appDelegate.trackObjArray.count-1
            }
            else
            {
                /**//**/self.currTrackIndex -= 1;
            }
            /**/self.pauseTime = nil
            /**/self.playMusic()
        }
    }
    
    @IBAction func seekSliderValueChange(sender: UISlider)
    {
        //setMinimizePlayerFrame()
        let prog : CGFloat = CGFloat(/**//**/self.seekSlider.value)
        let timeCurrent : Float64 = Float64(prog * /**/self.trackDurationInSecond)
        
        if (self.progressBar != nil)
        {
            self.progressBar.setProgress(CGFloat(self.seekSlider.value), animated: true)
        }
        
        
        if (!appDelegate.player.currentTime().seconds.isNaN)
        {
            self.pauseTime = appDelegate.player.currentTime().seconds
        }
        else
        {
            self.pauseTime = nil
        }
        //        if (appDelegate.player.rate != 0 && appDelegate.player.error == nil)
        //        {
        //            // BaseVC.sharedInstance.DLog("playing Sec \(self.trackDurationInSecond)")
        //        }
        //        else
        //        {
        //            //          BaseVC.sharedInstance.DLog("playing Stops P count \(appDelegate.player.items().count) Sec \(self.trackDurationInSecond)")
        //            //          self.playMusic()
        //            //            if (appDelegate.player.items().isEmpty)
        //            //            {
        //            //                self.preparePlayerArray()
        //            //            }
        //            //appDelegate.player.play()
        //        }
        //appDelegate.player.pause()
        //appDelegate.player.play()
        
        if (appDelegate.player.currentItem != nil)
        {
            appDelegate.player.seekToTime(CMTimeMakeWithSeconds(timeCurrent, appDelegate.player.currentItem!.asset.duration.timescale))
        }
       
        
        if (/**/self.lblTrackCurrentTime != nil)
        {
            if (!appDelegate.player.currentTime().seconds.isNaN)
            {
                self.lblTrackCurrentTime.text = timeFormatted(Int(appDelegate.player.currentTime().seconds))
            }
        }
    }
    
    func setPlayerViewData()
    {
        trackPercentage = 0
       
        if (/**/appDelegate.trackObjArray.count > /**/self.currTrackIndex )
        {
            let trackObj = /**/appDelegate.trackObjArray[/**/self.currTrackIndex]
            self.isLocal = trackObj.isLocal
            let trackId = trackObj.trackId
            
            if appDelegate.currentSongId != trackId
            {
                DLog("appDelegate.currentSongId \(appDelegate.currentSongId) NOT MATCH trackId \(trackId)")
                pauseTime = nil
                appDelegate.currentSongId = trackId!
                self.seekSlider.value = 0
                if (self.progressBar != nil)
                {
                    self.progressBar.setProgress(0.0, animated: false)
                }
            }
            
            if self.lblTrackTitle != nil
            {
                self.lblTrackTitle.text = trackObj.name
            }
            if self.lblArtistTitle != nil
            {
                self.lblArtistTitle.text = trackObj.artist
            }
            if self.lblAlbumTitle != nil
            {
                /**/self.lblAlbumTitle.text = trackObj.albumName
            }
            if (/**/self.lblTrackEndTime != nil)
            {
                /**//**/self.lblTrackEndTime.text = trackObj.track_time
                self.trackDurationInSecond = trackObj.duration
            }
            
            if (self.btnshuffle != nil)
            {
                if self.isShuffle
                {
                    btnshuffle.setImage(UIImage.init(named: "green_crossfade"), forState: .Normal)
                }
                else
                {
                    btnshuffle.setImage(UIImage.init(named: "grey_crossfade"), forState: .Normal)
                }
            }
            
            if /**/self.isLocal == "0"
            {
                if  self.btnFavourit != nil
                {
                    self.btnFavourit.hidden = false
                }
                if (self.imgArtwork != nil)
                {
                    let imageUrl = trackObj.imageURL.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                    if imageUrl.characters.count > 0
                    {
                        /**/BaseVC.sharedInstance.getAlbumImage(imageUrl,imageView: /**//**/self.imgArtwork)
                    }
                    else
                    {
                        self.imgArtwork.image = UIImage(named: DEFAULT_IMAGE)
                    }
                }

                self.setPurchaseBtn()
            }
            else
            {
                if  self.btnFavourit != nil
                {
                    /**/ self.btnFavourit.hidden = true
                }
                if  self.btnPurchase != nil
                {
                    /**/self.btnPurchase.hidden = true
                    /**/self.addSongClick.hidden = true
                }
                if (/**/self.imgArtwork != nil)
                {
                    /**//**/self.imgArtwork.image = trackObj.trackImage
                }
            }
            if  self.btnPurchase != nil
            {
                /**/self.btnPurchase.hidden = true
               
            }
           
            
            if (appDelegate.favPlaylist != nil)
            {
                appDelegate.favPlaylist!.initVC()
            }
            
            
            //TODO test comment
           // appDelegate.playlistVC.reloadPlaylist()
            //NSNotificationCenter.defaultCenter().postNotificationName("reloadPlaylist", object: nil)
           
            appDelegate.aTempLibraryVC?.tblView.reloadData()
            
        }
        else
        {
            if  self.btnPurchase != nil
            {
                /**/self.btnPurchase.hidden = true
            }
            if  self.addSongClick != nil
            {
                /**/self.addSongClick.hidden = true
            }
            if  self.btnFavourit != nil
            {
                /**/ self.btnFavourit.hidden = true
            }
        }
    }
    // MARK: - playMusic   -
    func playMusic()
    {
        self.setPlayerViewData()
        
        BaseVC.sharedInstance.DLog("playMusic \(self.currTrackIndex)")
        if appDelegate.playerTimer != nil
        {
            appDelegate.playerTimer?.invalidate()
            appDelegate.playerTimer = nil
        }
        self.playcurrentSong()
        if self.isRepeatTrack == 2
        {
            appDelegate.player.seekToTime(kCMTimeZero)
        }
        
        if (/**/appDelegate.trackObjArray.count > /**/self.currTrackIndex )
        {
            let trackObj = /**/appDelegate.trackObjArray[/**/self.currTrackIndex]
            self.isLocal = trackObj.isLocal
            if trackObj.track_play_url != nil
            {
                /**/self.playAudioFromUrl(trackObj.track_play_url!)
            }
            else
            {
                let TrackNotAvailableObj: TrackNotAvailableVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("TrackNotAvailableVC") as! TrackNotAvailableVC
                let navigationController = UINavigationController(rootViewController: TrackNotAvailableObj)
                navigationController.modalPresentationStyle = .OverCurrentContext
                navigationController.navigationBarHidden = true
                self.parentVC!.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
    }
    func playcurrentSong()
    {
        //
        if (appDelegate.minimizePlayerView != nil)
        {
            if(appDelegate.player.error == nil)
            {
                //TODO : APP crash here
                if appDelegate.player.rate > 0.99
                {
                    appDelegate.player.seekToTime(kCMTimeZero)
                    appDelegate.player.pause()
                }
            }
            if  appDelegate.player.items().count > 0
            {
                appDelegate.player.removeAllItems()
            }
            
            if (self.currTrackIndex < 0)
            {
                self.currTrackIndex = 0
            }
            
            if appDelegate.trackObjArray.count > self.currTrackIndex
            {
                for index in self.currTrackIndex..<appDelegate.trackObjArray.count
                {
                    if let trackObj = appDelegate.trackObjArray[index] as? Track
                    {
                        if (index < self.currTrackIndex + 2)
                        {
                            if trackObj.track_play_url != nil
                            {
                                let playerItem = AVPlayerItem(URL: trackObj.track_play_url!)
                                
                                if appDelegate.player.canInsertItem(playerItem, afterItem: nil)
                                {
                                    appDelegate.player.seekToTime(kCMTimeZero)
                                    appDelegate.player.insertItem(playerItem, afterItem: nil)
                                }
                            }
                        }
                        else
                        {
                            break
                        }
                    }
                }
            }
            //appDelegate.player.play()
        }
    }
    func playAudioFromUrl(passMusicFileURL: NSURL?)
    {
        if appDelegate.playerView != nil
        {
            appDelegate.playerView.currTrackIndex = self.currTrackIndex
        }
        BaseVC.sharedInstance.DLog("playAudioFromUrl : currTrackIndex \(self.currTrackIndex)")
        BaseVC.sharedInstance.DLog("passMusicFileURL \(passMusicFileURL)")
        
        let trackObj = /**/appDelegate.trackObjArray[/**/self.currTrackIndex]
        appDelegate.player.pause()
        
        if trackObj.track_play_url != nil
        {
            let playerItem = AVPlayerItem(URL:trackObj.track_play_url!)
            self.trackDurationInSecond  = trackObj.duration
             BaseVC.sharedInstance.DLog("*** trackDurationInSecond \(trackObj.duration)")
            appDelegate.player.rate = 1.0;
            if self.pauseTime == nil
            {
                self.seekSlider.value = 0
                if (self.progressBar != nil)
                {
                    self.progressBar.setProgress(0.0, animated: false)
                }
            }
            else if /**/self.pauseTime != nil
            {
                let prog : CGFloat = CGFloat(self.seekSlider.value)
                let timeCurrent : Float64 = Float64((prog * self.trackDurationInSecond))
                appDelegate.player.seekToTime(/**/self.playerTime(timeCurrent))
            }
            
            if (appDelegate.player.currentItem != nil)
            {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object:appDelegate.player.currentItem!)
            }
            appDelegate.player.play()
            BaseVC.sharedInstance.DLog("player.play()")
            
            
            let currentItem = playerItem.asset as? AVURLAsset
            if (currentItem != nil)
            {
                NSNotificationCenter.defaultCenter().addObserver(/**/self, selector: #selector(PlayerBaseVC.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: appDelegate.player.currentItem)
                self.configNowPlayingCenter(currentItem!)
            }
            if self.btnPlay != nil
            {
                self.btnPlay.selected = true
                self.startTrackProgress()
            }
        }
        else
        {
            self.seekSlider.value = 0
            if (self.progressBar != nil)
            {
                self.progressBar.setProgress(0.0, animated: false)
            }
        }
        
    }

    func setPurchaseBtn()
    {
        if self.addSongClick != nil && self.btnPurchase != nil
        {
            if (appDelegate.trackObjArray.count > self.currTrackIndex)
            {
                /**/self.addSongClick.hidden = true
                /**/self.btnPurchase.hidden = true
                
                let trackObj = /**/appDelegate.trackObjArray[/**/self.currTrackIndex]
                
                if /**/self.isLocal == "0"
                {
                    //Purchased song or not ..
                    if  /**/self.btnPurchase != nil && /**/self.addSongClick != nil
                    {
                        /**/self.isPurchased = trackObj.isPurchased
                        if /**/self.isPurchased == "0"
                        {
                            if trackObj.track_price != "0"
                            {
                                /**/self.addSongClick.hidden = true
                               // /**/self.btnPurchase.hidden = false
                                self.btnPurchase.hidden = true
                                self.btnPurchase.layer.borderWidth = 1
                                //self.btnPurchase.layer.borderColor = UIColor.blackColor().CGColor
                                self.btnPurchase.layer.borderColor = UIColor(red: 162/255, green: 207/255, blue: 100/255, alpha: 1).CGColor
                                
                                
                                if Float(trackObj.track_price) >= 1
                                {
                                    let newPrice = Float(trackObj.track_price)
                                    self.btnPurchase.setTitle("$\(newPrice!)", forState: UIControlState.Normal)
                                }
                                else
                                {
                                    let newPrice = Float(trackObj.track_price)
                                    let centPrice : Int = Int(newPrice! * 100)
                                    self.btnPurchase.setTitle("\(centPrice)¢", forState: UIControlState.Normal)
                                }
                                
                                ///**/self.btnPurchase.setTitle("$\(trackObj.track_price)", forState: UIControlState.Normal)
                            }
                            else
                            {
                                /**/self.addSongClick.hidden = false
                                /**/self.btnPurchase.hidden = true
                            }
                        }
                        else
                        {
                            /**/self.addSongClick.hidden = false
                            /**/self.btnPurchase.hidden = true
                        }
                    }
                    
                    if (trackObj.isFreeTrack == "true")
                    {
                        /**/self.addSongClick.hidden = false
                        /**/self.btnPurchase.hidden = true
                    }
                }
            }
        }
    }
    
    
    func setFavoriteBtn()
    {
        if self.trackArrayPlayer.count > self.currTrackIndex
        {
            let isfav = self.trackArrayPlayer[self.currTrackIndex]["isFavorite"].stringValue
            
            if self.btnFavourit != nil
            {
                if isfav == "1"
                {
                    self.btnFavourit.selected = true
                }
                else
                {
                    self.btnFavourit.selected = false
                }
            }
        }
    }
    
    
    override func canBecomeFirstResponder() -> Bool
    {
        return true
    }
    
    @IBAction func onFavouriteClick(sender: UIButton)
    {
        let index = self.currTrackIndex
        BaseVC.sharedInstance.DLog("index :\(index)")
        
        var trackId =  ""
        
        //  let vc : LibraryTrackNotificationVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("LibraryTrackNotificationVC") as! LibraryTrackNotificationVC
        
        
        //  self.presentViewControllerWithAnimation("LibraryTrackNotificationVC", animated: true)
        
        if isLocal == "0"
        {
            if (appDelegate.trackObjArray.count > index)
            {
                // let trackDic = self.trackObjArray[index]

                trackId = appDelegate.trackObjArray[index].trackId!//trackDic["trackId"]

                if !sender.selected == true
                {
                    // vc.lbl = "track added to Disctopia favorites."
                    //  self.trackAddedNotificationView.hidden = false
                    //  NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(LibraryTracksViewController.onCloseSaveChangeView(_:)), userInfo: nil, repeats: false)
                    DLog("fav playlistId = \(BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId"))")
                    self.addSongInPlayListAPI(trackId,playlistId : BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId"))
                }
                else
                {
                    //vc.lbl = "track removed from Disctopia favorites."
                    
                    self.UnFavouriteSongAPI(trackId,playlistId : BaseVC.sharedInstance.getUserDefaultStringFromKey("favoritePlaylistId"))
                }
            }
        }
        else
        {
            //                if (self.arrLocalTracks.count > index)
            //                {
            //                    let trackDetails : MPMediaItem = self.arrLocalTracks[index]
            //                    trackId = ("\(trackDetails.persistentID)")
            //                }
        }
        
        //        let navigationController = UINavigationController(rootViewController: vc)
        //        navigationController.modalPresentationStyle = .OverCurrentContext
        //        navigationController.navigationBarHidden = true
        //        self.parentVC!.presentViewController(navigationController, animated: true, completion: nil)
        
        
        
        //btn.selected = !btn.selected
        if sender.selected
        {
            sender.selected = false
        }
        else
        {
            sender.selected = true
        }
    }
    
    @IBAction func onAddSongClick(sender: UIButton)
    {
        if (/**/appDelegate.trackObjArray.count > /**/self.currTrackIndex)
        {
            //var dictTrackDetails = /**//**/self.trackArrayPlayer[/**//**/self.currTrackIndex].dictionaryValue
            //let trackId = dictTrackDetails["trackId"]?.stringValue
            let trackObj = /**/appDelegate.trackObjArray[/**/self.currTrackIndex]
            let trackId = trackObj.trackId
            
            if (parentVC != nil)
            {
                let vc : AddTrackVC = parentVC!.storyboard!.instantiateViewControllerWithIdentifier("AddTrackVC") as! AddTrackVC
                vc.selectedTrackId = trackId!
                //herbDetails.herb = selectedHerb
                vc.modalPresentationStyle = .CurrentContext
                // vc.view.backgroundColor = .None
                parentVC!.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnPurchaseAction(sender: AnyObject)
    {
        self.onClosePlayerClick(sender as! UIButton)
        let trackObj = /**/appDelegate.trackObjArray[/**/self.currTrackIndex]
        
        if trackObj.trackId != nil
        {
            self.AddTrackInCart(trackObj.trackId!)
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
                BaseVC.sharedInstance.DLog("#### UnFavouriteSong API Response: \(result)")
                // self.setTrackData(self.inputId, isLocal: self.isLocal)
                if (appDelegate.favPlaylist != nil)
                {
                    appDelegate.favPlaylist!.initVC()
                }
                
                //TODO test comment
                //NSNotificationCenter.defaultCenter().postNotificationName("reloadPlaylist", object: nil)
                if(appDelegate.isFromExplore == true)
                {
                    appDelegate.aTempLibraryVC!.trackBy = TrackBy.Album
                    appDelegate.aTempLibraryVC!.setTrackData("\(playlistId)", isLocal: self.isLocal,isFromEditPlaylist: false)
                }

                let vc : LibraryTrackNotificationVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("LibraryTrackNotificationVC") as! LibraryTrackNotificationVC
                vc.lbl = "track removed from Disctopia favorites."
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .OverCurrentContext
                navigationController.navigationBarHidden = true
                self.parentVC!.presentViewController(navigationController, animated: true, completion: nil)
                
            }
        }
    }
    
    // MARK: - addSongInPlayListAPI
    func addSongInPlayListAPI(trackid : String ,playlistId : String)
    {
        var param = Dictionary<String, String>()
        param["PlayListId"] = playlistId
        param["TrackId"] = trackid
        
        DLog("addSongInPlayListAPI param \(param)")
        var aVc = appDelegate.navigationController!.visibleViewController
        
        if self.parentVC != nil
        {
            aVc = self.parentVC
        }
        
        API.addSongInPlayList(param, aViewController:aVc!) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("addSongInPlayList API Response: \(result)")
                //self.getAllTrackByPlaylistIdAPI()
                if (appDelegate.favPlaylist != nil)
                {
                    appDelegate.favPlaylist!.initVC()
                }
                //TODO test comment
                //NSNotificationCenter.defaultCenter().postNotificationName("reloadPlaylist", object: nil)

                if(appDelegate.isFromExplore == true)
                {
                    appDelegate.aTempLibraryVC!.trackBy = TrackBy.Album
                    appDelegate.aTempLibraryVC!.setTrackData("\(playlistId)", isLocal: self.isLocal,isFromEditPlaylist: false)
                    //appDelegate.isFromExplore = false
                }
                let vc : LibraryTrackNotificationVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("LibraryTrackNotificationVC") as! LibraryTrackNotificationVC
                vc.lbl = "track added to Disctopia favorites."
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .OverCurrentContext
                navigationController.navigationBarHidden = true
                self.parentVC!.presentViewController(navigationController, animated: true, completion: nil)
                
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
        
        var aVc = appDelegate.navigationController!.visibleViewController
        
        if self.parentVC != nil
        {
            aVc = self.parentVC
        }
        
        API.AddShoppingCart(param, aViewController: aVc!) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### AddShoppingCart API Response: \(result)")
                //self.setTrackData(self.inputId, isLocal: self.isLocal)
                //self.ViewshoppingcartData()
            }
            BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("CartSummaryVC", animated: true)
        }
    }
    
    @IBAction func onShuffleClick(sender: UIButton)
    {
        if /**//**/self.isRepeatTrack == 0
        {
            btnRepeat.setImage(UIImage.init(named: "green_repeat.png"), forState: .Normal)
            /**//**/self.isRepeatTrack = 1
        }
        else if /**//**/self.isRepeatTrack == 1
        {
            btnRepeat.setImage(UIImage.init(named: "green_repeat_one.png"), forState: .Normal)
            /**//**/self.isRepeatTrack = 2
        }
        else
        {
            btnRepeat.setImage(UIImage.init(named: "grey_repeat.png"), forState: .Normal)
            /**//**/self.isRepeatTrack = 0
        }
    }
    
    @IBAction func onCrossFadeClick(sender: UIButton)
    {
        if appDelegate.isSelectFromPlaylist
        {
            if let selectedPlaylistid:String = appDelegate.selectedPlaylistId["playlistId"]!.stringValue
            {
                if (selectedPlaylistid.characters.count > 0)
                {
                    
                    let playlistId = appDelegate.selectedPlaylistId["playlistId"]!.stringValue
                    if appDelegate.shufflePlaylistArray.contains(playlistId)
                    {
                        appDelegate.shufflePlaylistArray.removeAtIndex(appDelegate.shufflePlaylistArray.indexOf(playlistId)!)
                    }
                    else
                    {
                        //btnshuffle.setImage(UIImage.init(named: "green_crossfade"), forState: .Normal)
                        appDelegate.shufflePlaylistArray.append(playlistId)
                    }
                }
            }
        }
        
        if /**//**/self.isShuffle
        {
            
            /**//**/self.isShuffle = false
            btnshuffle.setImage(UIImage.init(named: "grey_crossfade"), forState: .Normal)
        }
        else
        {
            /**//**/self.isShuffle = true
            btnshuffle.setImage(UIImage.init(named: "green_crossfade"), forState: .Normal)
            //currentQueueToShuffle(/**//**/self.isShuffle)
        }
    }
    
    func loadMinimizePlayer()
    {
        if (appDelegate.minimizePlayerView != nil)
        {
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                
                }, completion: { (finished) -> Void in
                    if finished {
                        appDelegate.minimizePlayerView!.hidden = false
                        appDelegate.minimizePlayerView!.frame = CGRect(x: 0, y: ScreenSize.SCREEN_HEIGHT - MINIMIZE_PLAYER_HEIGHT, width: ScreenSize.SCREEN_WIDTH, height: MINIMIZE_PLAYER_HEIGHT)
                        appDelegate.minimizePlayerView!.translatesAutoresizingMaskIntoConstraints = true
                        appDelegate.minimizePlayerView?.layoutIfNeeded()
                        appDelegate.minimizePlayerView?.updateConstraintsIfNeeded()
                    }
            })
        }
        
        if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
        {
            setMinimizePlayerFrame()
        }
        else
        {
            if (appDelegate.window?.viewWithTag(666) == nil)
            {
                if (appDelegate.minimizePlayerView != nil)
                {
                    appDelegate.minimizePlayerView!.tag = 666
                    setMinimizePlayerFrame()
                    appDelegate.window?.addSubview(appDelegate.minimizePlayerView!)
                }
            }
        }
    }
    
    @IBAction func onClosePlayerClick(sender: UIButton)
    {
        self.closePlayerClick(true)
    }
    
    func closePlayerClick(animated:Bool)
    {
        if (appDelegate.minimizePlayerView != nil)
        {
            if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
            {
              
                appDelegate.minimizePlayerView = minimizeView
                appDelegate.playerView = minimizeView
            }
            else
            {
                if appDelegate.minimizePlayerView != nil
                {
                     appDelegate.minimizePlayerView!.btnPlay.selected = appDelegate.playerView.btnPlay.selected
                    if (appDelegate.minimizePlayerView!.progressBar != nil)
                    {
                        appDelegate.minimizePlayerView!.progressBar.setProgress(CGFloat(appDelegate.playerView.seekSlider.value), animated: false)
                    }
                }
               
                //appDelegate.playerView.trackDurationInSecond = self.trackDurationInSecond

                appDelegate.playerView = appDelegate.minimizePlayerView
            }
        }

        appDelegate.playerView.currTrackIndex = self.currTrackIndex
        appDelegate.playerView.isShuffle = self.isShuffle
        loadMinimizePlayer()
        
        
        if /**/self.isLocal == "0"
        {
            let trackObj = appDelegate.trackObjArray[/**/self.currTrackIndex]
            appDelegate.currentSongId = trackObj.trackId!
        }
        
        if (self.parentVC != nil)
        {
            self.parentVC!.dismissViewControllerAnimated(animated, completion: {
                
                NSNotificationCenter.defaultCenter().postNotificationName("basePlayer", object: appDelegate.trackObjArray)
            })
        }
    }
    
    @IBAction func onPlayerOpen(sender: AnyObject)
    {
        
        //self.currentQueueToShuffle()
        if (appDelegate.minimizePlayerView != nil)
        {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                
                }, completion: { (finished) -> Void in
                    if finished {
                        appDelegate.minimizePlayerView!.hidden = true
                    }
            })
            //LocalSongPlayer.sharedPlayerInstance1.currTrackIndex = self.currTrackIndex
        }
        
        
        //        if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
        //        {
        //            minimizeView.removeFromSuperview()
        //        }
        
        let aExpandedPlayerVC = LocalSongPlayer.sharedPlayerInstance1
        aExpandedPlayerVC.isFromMinimisePlayer = true

        aExpandedPlayerVC.sliderValue = appDelegate.playerView.seekSlider.value
        aExpandedPlayerVC.trackDurationInSecond =  appDelegate.playerView.trackDurationInSecond
        aExpandedPlayerVC.btnPlaySelected = appDelegate.playerView.btnPlay.selected
        aExpandedPlayerVC.isShuffle = appDelegate.playerView.isShuffle
        aExpandedPlayerVC.currTrackIndex = self.currTrackIndex
        
        let navigationController = UINavigationController(rootViewController: aExpandedPlayerVC)
        navigationController.modalPresentationStyle = .OverCurrentContext
        appDelegate.navigationController?.visibleViewController!.presentViewController(navigationController, animated: true, completion: nil)
        aExpandedPlayerVC.sliderValue = appDelegate.playerView.seekSlider.value

    }
    
        // MARK: - Queue shuffle -
    func currentQueueToShuffle()
    {
        shuffle()
    }
    
    func isshuffleOn()->Bool
    {
        if appDelegate.isSelectFromPlaylist
        {
            if appDelegate.selectedPlaylistId["playlistId"] != nil
            {
                if (appDelegate.selectedPlaylistId["playlistId"]!.stringValue.characters.count > 0)
                {
                    let playlistId = appDelegate.selectedPlaylistId["playlistId"]!.stringValue
                    
                    if (appDelegate.shufflePlaylistArray.count > 0 )
                    {
                        if appDelegate.shufflePlaylistArray.contains(playlistId)
                        {
                            if (self.btnshuffle != nil)
                            {
                                btnshuffle.setImage(UIImage.init(named: "green_crossfade"), forState: .Normal)
                            }
                            return true
                        }
                        else
                        {
                            return false
                        }
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    return false
                }
            }
            else
            {
                return false
            }
        }
        else
        {
            return self.isShuffle
        }
    }
    
    func shuffle()
    {
        if self.isshuffleOn()
        {
            if appDelegate.trackObjArray.count > 1
            {
                let cnt:UInt32 = UInt32(appDelegate.trackObjArray.count)
                let rand  = Int(arc4random_uniform(cnt))
                //if rand != self.currTrackIndex
                //{
                self.currTrackIndex = rand
                //}
            }
        }
        else
        {
            if (self.btnshuffle != nil)
            {
                btnshuffle.setImage(UIImage.init(named: "grey_crossfade"), forState: .Normal)
            }
        }
    }
    func randomNumber() -> UInt32 {
        var randomNumber = arc4random_uniform(10)
        while previousNumber == randomNumber {
            randomNumber = arc4random_uniform(10)
        }
        previousNumber = randomNumber
        return randomNumber
    }
    
    
    func setPlayedTrack(tarckId:String)
    {
        var param = Dictionary<String, String>()
        if tarckId.characters.count > 0
        {
            //param["trackid"] = tarckId
            if appDelegate.playedTrackId.characters.count > 0
            {
                param["SetPlayedTrackId"] = appDelegate.playedTrackId
                param["IsFifteenPercentPlayed"] = "1"
                
                var aVc = appDelegate.navigationController!.visibleViewController
                
                if self.parentVC != nil
                {
                    aVc = self.parentVC
                }
                
                API.setPlayedTrack(param , aViewController: aVc!) { (result: JSON) in
                    if ( result != nil )
                    {
                        appDelegate.playedTrackId = result["playedTrackId"].stringValue
                    }
                }
            }
        }
    }
    
    func setPlayedTrack75Peresent(playedTrackId:String)
    {
        var param = Dictionary<String, String>()
        
        if playedTrackId.characters.count > 0
        {
            param["SetPlayedTrackId"] = playedTrackId
            
            var aVc = appDelegate.navigationController!.visibleViewController
            
            if self.parentVC != nil
            {
                aVc = self.parentVC
            }
            
            API.setPlayedTrack(param , aViewController: aVc!) { (result: JSON) in
                if ( result != nil )
                {
                    //playedTrackId
                }
            }
        }
    }
   
    func timerAction()
    {
        /*
         For E.g. Song Duration : 344 Second. Then We have to progress 0.01 out of 1.0 when 10% song completed.
         So, When 3.44(10% of 344) second song completed then we have to show progress 0.01.
         And 6.88(3.44 * 2) then show progress 0.02 (0.01 * 2)
         Calculation for progress = (songCurrentTime * 0.01) / (Total Song Duration/100)
         */
        let audioPlayerCurrentTime = CMTimeGetSeconds(appDelegate.player.currentTime())

        
        if (!audioPlayerCurrentTime.isNaN)
        {
            var trackDurationInSecondTemp:CGFloat = 1.0
            
            if /**/self.trackDurationInSecond > 0
            {
                trackDurationInSecondTemp = /**/self.trackDurationInSecond
            }
            let progress : CGFloat = CGFloat(audioPlayerCurrentTime)/trackDurationInSecondTemp //CGFloat(audioPlayerCurrentTime * 0.01) / (trackDurationInSecondTemp/100)
            
//           
//            print("### audioPlayerCurrentTime :\(audioPlayerCurrentTime)")
//            print("### trackDurationInSecond :\(self.trackDurationInSecond)")
//            print("### progress :\(progress)")
            if appDelegate.playerView.seekSlider != nil
            {
                appDelegate.playerView.seekSlider.setValue(Float(progress), animated: true)
            }
                //self.seekSlider.setValue(Float(progress), animated: true)
            
            if (self.progressBar != nil)
            {
                self.progressBar.setProgress(CGFloat(progress), animated: true)
            }
            
            
            if Int(floor(progress*1000)) == 150
            {
                if trackPercentage != 15
                {
                    trackPercentage = 15
                    let trackObj = appDelegate.trackObjArray[self.currTrackIndex]
                    //print("Heyyyyy User has played track more then 15% \(progress) \(trackObj.name) \(trackObj.trackId)")
                    if trackObj.isLocal == "0"
                    {
                        setPlayedTrack(trackObj.trackId!)
                    }
                }
            }
            else if Int(floor(progress*1000)) == 750
            {
                if trackPercentage != 75
                {
                    trackPercentage = 75
                    let trackObj = appDelegate.trackObjArray[self.currTrackIndex]
                    //print("$#$#$# Heyyyyy User has played track more then 75% \(progress) \(trackObj.name) \(trackObj.trackId)")
                    if trackObj.isLocal == "0"
                    {
                        setPlayedTrack75Peresent(appDelegate.playedTrackId)
                    }
                }
            }
            
            // Hide player following duration
            appDelegate.totalDuration = appDelegate.totalDuration + 0.1
            if appDelegate.totalDuration >= 3600
            {
                appDelegate.totalDuration = 0
                if (appDelegate.minimizePlayerView != nil)
                {
                    UIView.animateWithDuration(1.0, animations: { () -> Void in
                        
                        }, completion: { (finished) -> Void in
                            if finished {
                                appDelegate.minimizePlayerView!.hidden = true
                            }
                    })
                    LocalSongPlayer.sharedPlayerInstance1.currTrackIndex = self.currTrackIndex
                }
            }
            
            
            
            self.pauseTime = appDelegate.player.currentTime().seconds
            
            if (/**/self.lblTrackCurrentTime != nil)
            {
                if appDelegate.player.currentItem != nil
                {
                    if (appDelegate.player.currentItem!.status.rawValue == AVPlayerStatus.ReadyToPlay.rawValue)
                    {
                        /**//**/self.lblTrackCurrentTime.text = timeFormatted(Int(audioPlayerCurrentTime))
                       
                    }
                }
                
            }
            
            if CGFloat(audioPlayerCurrentTime) == 0
            {
                if /**/self.btnPlay.selected == false
                {
                    if appDelegate.playerTimer != nil
                    {
                        appDelegate.playerTimer?.invalidate()
                        appDelegate.playerTimer = nil
                    }
                    /**/self.pauseTime = nil
                    if (/**/self.lblTrackCurrentTime != nil)
                    {
                        /**//**/self.lblTrackCurrentTime.text = "00:00"
                    }
                    if (/**/self.lblTrackEndTime != nil)
                    {
                        /**//**/self.lblTrackEndTime.text = "00:00"
                    }
                    //0 = No Repeat , 1 = Repeat All , 2 = Repeat One.
                    if /**//**/self.isRepeatTrack == 0
                    {
                        if /**//**/self.currTrackIndex >= /**//**/appDelegate.trackObjArray.count-1
                        {
                            /**//**/self.btnPlay.selected = false
                        }
                        else
                        {
                            /**//**/self.onNextTrackClick(nil)
                        }
                    }
                    else
                    {
                        /**/self.onNextTrackClick(nil)
                    }
                }
            }
        }
        else
        {
            
        }
    }
    
    
    func startTrackProgress()
    {
        if appDelegate.playerTimer != nil
        {
            appDelegate.playerTimer?.invalidate()
            appDelegate.playerTimer = nil
        }
        // start the progress
        appDelegate.playerTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: /**/self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func timerForHideMinimizePlayer()
    {
        appDelegate.playerTimerMinimize = NSTimer.scheduledTimerWithTimeInterval(0.1, target: /**/self, selector: #selector(hideMinimizeTimerAction), userInfo: nil, repeats: true)
    }
    func hideMinimizeTimerAction()
    {
        // Hide player following duration
        appDelegate.totalDuration = appDelegate.totalDuration + 0.1
        
        if appDelegate.totalDuration >= 3600
        {
            if appDelegate.playerTimerMinimize != nil
            {
                appDelegate.playerTimerMinimize!.invalidate()
                appDelegate.playerTimerMinimize = nil
            }
            appDelegate.totalDuration = 0
            if (appDelegate.minimizePlayerView != nil)
            {
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            appDelegate.minimizePlayerView!.hidden = true
                        }
                })
            }
        }
    }
    func playerTime(timeCurrent:Float64) -> CMTime
    {
        if (appDelegate.player.currentItem != nil)
        {
            return CMTimeMakeWithSeconds(timeCurrent, appDelegate.player.currentItem!.asset.duration.timescale)
        }
        else
        {
            return CMTimeMakeWithSeconds(timeCurrent, CMTimeScale(integerLiteral: 1))
        }
    }
    
    func getItem( songId: NSNumber ) -> MPMediaItem
    {
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        query.addFilterPredicate( property )
        var items: [MPMediaItem] = query.items! as [MPMediaItem]
        return items[items.count - 1]
    }
    //    func timeFormatted(totalSeconds: Int) -> String {
    //        let seconds: Int = totalSeconds % 60
    //        let minutes: Int = (totalSeconds / 60) % 60
    //        let hours: Int = totalSeconds / 3600
    //        if hours <= 0
    //        {
    //            return String(format: "%02d:%02d",minutes, seconds)
    //        }
    //        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    //    }
    
    //    func currentTrack() -> NSMutableDictionary?
    //    {
    //        if /**/self.currTrackIndex != NSNotFound && /**/self.arrTrackList.count > /**/self.currTrackIndex
    //        {
    //            return /**/self.arrTrackList[/**/self.currTrackIndex] as? NSMutableDictionary
    //        }
    //        return nil
    //    }
    //    func currentServerTrack() -> [String : JSON]
    //    {
    //        if /**/self.currTrackIndex != NSNotFound && /**//**/self.trackObjArray.count > /**//**/self.currTrackIndex
    //        {
    //            return /**/self.trackArrayPlayer[/**//**/self.currTrackIndex].dictionaryValue
    //        }
    //        return ["" : nil]
    //    }
    
}

// MARK: - download song  -
// Create a loop to start downloading your urls
func startDownloadingUrls()
{
    return
    if (appDelegate.playerView != nil)
    {
        for trackObj in /**//**/appDelegate.trackObjArray
        {
            //let trackId = dictTrackDetails["trackId"].stringValue
            //let trackUrl = dictTrackDetails["track_url"].stringValue
            //let trackObj = Track(trackJSON: dictTrackDetails)
            //trackObjArray.append(trackObj)
            startDownload(trackObj)
        }
    }
}

// MARK: Download methods
// Called when the Download button for a track is tapped
func startDownload(track: Track)
{
    if track.isLocal == "1"
    {
        return
    }
    
    let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
    
    dispatch_after(dispatchTime, dispatch_get_main_queue(),
                   {
                    resumeDownload(track)
    })
    
    return
    /*
     // Any Large Task
     if let urlString = track.trackId,
     download = appDelegate.playerView.activeDownloads[urlString]
     {
     
     }
     else
     {
     let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
     
     dispatch_after(dispatchTime, dispatch_get_main_queue(),
     {
     // your function here
     let destinationUrl = appDelegate.playerView.documentsUrl.URLByAppendingPathComponent("\(track.trackId!).mp3")
     DLog("destinationUrl \(destinationUrl)")
     
     if (!NSFileManager().fileExistsAtPath(destinationUrl.path!))
     {
     if (track.track_download_url.characters.count > 0)
     //if let urlString = track.track_download_url, url =  NSURL(string: urlString)
     {
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
     {
     // Any Large Task
     // 1
     let download = Download(track: track)
     // 2
     download.downloadTask = appDelegate.playerView.downloadsSession.downloadTaskWithURL(NSURL(string: track.track_download_url)!)
     
     download.downloadTask!.taskDescription = track.trackId!
     // 3
     download.downloadTask!.resume()
     // 4
     download.isDownloading = true
     // 5
     appDelegate.playerView.activeDownloads[download.track.trackId!] = download
     //                            dispatch_async(dispatch_get_main_queue(),
     //                            {
     //                               // Update UI in Main thread
     //                            });
     }
     }
     else
     {
     DLog("Download Not needed (Stream)")
     }
     }
     })
     }
     
     */
}

// Called when the Pause button for a track is tapped
func pauseDownload(track: Track)
{
    DLog("pauseDownload For track name \(track.trackId) (\(track.name))")
    
    if (appDelegate.playerView != nil)
    {
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        //{
        if let urlString = track.trackId,
            download = appDelegate.playerView.activeDownloads[urlString] {
            if(download.isDownloading) {
                download.downloadTask!.taskDescription = track.trackId!
                download.downloadTask?.cancelByProducingResumeData { data in
                    if data != nil {
                        download.resumeData = data
                    }
                }
                download.isDownloading = false
            }
        }
        //}
    }
}

// Called when the Cancel button for a track is tapped
func cancelDownload(track: Track) {
    
    DLog("Download Cancel For track name \(track.trackId) (\(track.name))")
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
    //{
    
    if let urlString = track.trackId,
        download = appDelegate.playerView.activeDownloads[urlString] {
        download.downloadTask!.taskDescription = track.trackId!
        download.downloadTask?.cancel()
        appDelegate.playerView.activeDownloads[urlString] = nil
    }
    //}
}

// Called when the Resume button for a track is tapped
func resumeDownload(track: Track) {
    
    DLog("resumeDownload For track name \(track.trackId!) (\(track.name))")
    if (appDelegate.playerView != nil)
    {
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        //{
        // Any Large Task
        
        appDelegate.trackDownloadDictionary["\(track.trackId!)"] = track
        
        
        //print("appDelegate.trackDownloadDictionary : \(appDelegate.trackDownloadDictionary)")
        
        //NSUserDefaults.standardUserDefaults().setObject(appDelegate.trackDownloadDictionary, forKey: USER_DEFAULT_TRACK_DIC)
        
        //BaseVC.sharedInstance.setUserDefaultDataFromKeyWithArchive(USER_DEFAULT_TRACK_DIC,dic: appDelegate.trackDownloadDictionary)
        
        print("Starting.....")
        
        if let urlString = track.trackId,
            download = appDelegate.playerView.activeDownloads[urlString] {
            
            download.downloadTask!.taskDescription = track.trackId!
            download.isDownloading = true
            download.downloadTask!.resume()
           
            
           
            //BaseVC.sharedInstance.setUserDefaultDataFromKey(USER_DEFAULT_TRACK_DIC,dic: appDelegate.trackDownloadDictionary)
            
            //BaseVC.sharedInstance.setUserDefaultDataFromKeyWithArchiveForArray(USER_DEFAULT_TRACK_ARRAY, array: appDelegate.trackDownloadDictionary)
            /*
             if let resumeData = download.resumeData
             {
             //download.downloadTask = appDelegate.playerView.downloadsSession.downloadTaskWithResumeData(resumeData)
             download.downloadTask!.taskDescription = track.trackId!
             download.isDownloading = true
             download.downloadTask!.resume()
             }
             else
             {
             //download.downloadTask = appDelegate.playerView.downloadsSession.downloadTaskWithURL(url)
             download.downloadTask!.taskDescription = track.trackId!
             download.downloadTask!.resume()
             download.isDownloading = true
             appDelegate.playerView.activeDownloads[download.track.trackId!] = download
             }
             */
        }
        else
        {
            let destinationUrl = appDelegate.playerView.documentsUrl.URLByAppendingPathComponent("\(track.trackId!).mp3")
            DLog("destinationUrl \(destinationUrl)")
            if (!NSFileManager().fileExistsAtPath(destinationUrl.path!))
            {
                if (track.track_download_url.characters.count > 0)
                    //if let urlString = track.track_download_url, url =  NSURL(string: urlString)
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                    {
                        // Any Large Task
                        // 1
                        let download = Download(track: track)
                        // 2
                        download.downloadTask = appDelegate.playerView.downloadsSession.downloadTaskWithURL(NSURL(string: track.track_download_url)!)
                        
                        download.downloadTask!.taskDescription = track.trackId!
                        // 3
                        download.downloadTask!.resume()
                        // 4
                        download.isDownloading = true
                        // 5
                        appDelegate.playerView.activeDownloads[download.track.trackId!] = download
                        //    dispatch_async(dispatch_get_main_queue(),
                        //    {
                        //       // Update UI in Main thread
                        //    });
                    }
                }
                else
                {
                    DLog("Download Not needed (Stream)")
                }
            }
        }
        
    }
    /*
     dispatch_async(dispatch_get_main_queue(),
     {
     // Update UI in Main thread
     });*/
    //}
    
    
}

// This method attempts to play the local file (if it exists) when the cell is tapped
func playDownload(track: Track)
{
    if let urlString = track.trackId, url = localFilePathForUrl(urlString)
    {
        let moviePlayer:MPMoviePlayerViewController! = MPMoviePlayerViewController(contentURL: url)
        //presentMoviePlayerViewControllerAnimated(moviePlayer)
    }
}
// MARK: Download helper methods

// This method generates a permanent local file path to save a track to by appending
// the lastPathComponent of the URL (i.e. the file name and extension of the file)
// to the path of the app’s Documents directory.
func localFilePathForUrl(previewUrl: String) -> NSURL?
{
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    DLog("documentsPath \(documentsPath)")
    if let url = NSURL(string: previewUrl), lastPathComponent = url.lastPathComponent {
        let fullPath = "\(documentsPath.stringByAppendingPathComponent(lastPathComponent)).mp3"
        return NSURL(fileURLWithPath:fullPath)
    }
    return nil
}

// This method checks if the local file exists at the path generated by localFilePathForUrl(_:)
func localFileExistsForTrack(track: Track) -> Bool {
    if let urlString = track.trackId, localUrl = localFilePathForUrl(urlString)
    {
        var isDir : ObjCBool = false
        if let path = localUrl.path {
            return NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)
        }
    }
    return false
}

func trackIndexForDownloadTask(downloadTask: NSURLSessionDownloadTask) -> Int? {
    if let url = downloadTask.originalRequest?.URL?.absoluteString {
        if (appDelegate.playerView != nil)
        {
            for (index, track) in appDelegate.trackObjArray.enumerate() {
                if url == track.track_url {
                    return index
                }
            }
        }
    }
    return nil
}

class Track : NSObject{
    
    var trackId: String?
    var imageURL: String = ""
    var name: String = ""
    var track_price:String = ""
    var track_time:String = ""
    var trackImage:UIImage = UIImage(named: DEFAULT_IMAGE)!
    
    var track_url: String? // Full URL of song .Wav
    var track_sample_url: String = "" // Sample URL of 30 sec .mp3
    var track_full_url: String = "" // Full URL of song .mp3
    var track_play_url: NSURL? // NSURL base on Condition
    var track_download_url: String = ""
    
    var artist: String = ""
    
    var albumId: String = ""
    var albumName:String = ""
    var albumURL:String = ""
    var isFreeTrack:String = ""
    var isPurchased:String = ""
    var isFavorite:String = ""
    var isLocal:String = ""
    var duration : CGFloat = 0
    var tierStem : String = "0"
    
    override init()
    {
        super.init()
    }
    
    init(name: String?, artist: String?, previewUrl: String?,trackId: String?)
    {
        super.init()
        self.trackId = "\(trackId!)"
        self.name = name!
        self.artist = artist!
        self.track_url = previewUrl!
    }
    
    init(trackDictionary : NSMutableDictionary?)
    {
        super.init()
        if trackDictionary == nil
        {
            self.trackId = ""
            self.track_sample_url = ""
            self.track_full_url = ""
            self.track_url = ""
            self.track_play_url = nil
            return
        }
        else
        {
            self.isLocal = "1"
            
            if let trackDetails = trackDictionary!["trackInfo"] as? MPMediaItem
            {
                self.trackId = String (trackDetails.persistentID)
                self.isFavorite = "0"
                
                if let passMusicFileURL = trackDetails.valueForProperty( MPMediaItemPropertyAssetURL ) as? NSURL
                {
                    self.track_play_url = passMusicFileURL
                    if self.track_play_url != nil
                    {
                        let playerItem = AVPlayerItem(URL: self.track_play_url!)
                        let duration : CMTime = playerItem.asset.duration
                        let seconds : Float64 = CMTimeGetSeconds(duration)
                        self.duration = CGFloat(seconds)
                        self.track_time = timeFormatted(Int(seconds))
                    }
                    else
                    {
                        self.duration = 0
                        self.track_time = "00:00"
                    }
                }
                else
                {
                    self.duration = 0
                    self.track_time = "00:00"
                }
                
                if trackDetails.title != nil
                {
                    self.name = trackDetails.title!
                }
                
                if trackDetails.artist != nil
                {
                    self.artist  = trackDetails.artist!
                }
                
                if trackDetails.albumTitle != nil
                {
                    self.albumName = trackDetails.albumTitle!
                }
                
                //cell.lblTime.text = self.timeString(trackDetails.playbackDuration)
                if trackDetails.artwork != nil
                {
                    if let img = trackDetails.artwork!.imageWithSize(CGSizeMake(1024.0, 1024.0))
                    {
                        self.trackImage = img
                    }
                }
                
                /*
                 let metadataList = playerItem.asset.commonMetadata
                 
                 for item in metadataList
                 {
                 
                 if item.commonKey == "title"
                 {
                 self.name = item.stringValue!
                 }
                 else if item.commonKey == "artist"
                 {
                 self.artist = item.stringValue!
                 }
                 else if item.commonKey == "albumName"
                 {
                 self.albumName = item.stringValue!
                 }
                 else if item.commonKey == "artwork"
                 {
                 if let image = UIImage(data: item.value as! NSData)
                 {
                 self.trackImage = image
                 }
                 }
                 }
                 */
                
//                self.track_sample_url = ""
//                self.track_full_url = ""
//                self.track_url = ""
//                self.track_play_url = nil
            }
        }
    }
    
    init(trackJSON : JSON?)
    {
        super.init()
        /*
         {
         "album_url" : "https:\/\/s3-us-west-2.amazonaws.com\/devdisctopia-audio\/Quantum Supply\/Bless\/cover.jpg",
         "total" : 3.38,
         "purchasedTrackURL" : "http:\/\/devdisctopia-audio.s3-us-west-2.amazonaws.com\/Quantum%20Supply\/BLESS\/Quantum%20Supply%20-%20BLESS%20-%2001%20AMEN%20AMEN%20(Opening%20Prayer)%20ft%20MABKC.mp3?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1471353631&Signature=QYcmuokso3xvcwwJPSbdxthVmro%3D",
         "user_image" : "",
         "smapleTrackURL" : "http:\/\/devdisctopia-audio.s3-us-west-2.amazonaws.com\/Quantum%20Supply\/BLESS\/sample\/Quantum%20Supply%20-%20BLESS%20-%2001%20AMEN%20AMEN%20(Opening%20Prayer)%20ft%20MABKC.mp3?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1471353631&Signature=r5WigsQqLgGe9P0HaJwYDnzj9mg%3D",
         "album_image" : "Quantum Supply\/Bless\/cover.jpg",
         "duration" : "00:04:59.0160000",
         "orderNumber" : "20160527130",
         "track_url" : "http:\/\/devdisctopia-audio.s3-us-west-2.amazonaws.com\/Quantum%20Supply\/BLESS\/Quantum%20Supply%20-%20BLESS%20-%2001%20AMEN%20AMEN%20(Opening%20Prayer)%20ft%20MABKC.wav?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1471353631&Signature=bFT7uThwW7RTmNv1%2Fqz5DcUF3SI%3D",
         "album_Name" : "BLESS",
         "user_url" : "",
         "albumId" : 30,
         "artistName" : "Diddy",
         "quantity" : 1,
         "saveInfo" : true,
         "email" : "diddy@disctopia.com",
         "trackName" : "Amen Amen",
         "unitPrice" : 2,
         "orderDate" : "2016-05-27T06:28:30.04",
         "trackId" : 221,
         "orderId" : 130,
         "userId" : "398f4085-c280-4084-aa49-6e4aebde4e12"
         },
         
         
         OR
         {
         "purchasedTrackURL" : "http:\/\/devdisctopia-audio.s3-us-west-2.amazonaws.com\/Quantum%20Supply\/EUPHOBIA\/Quantum%20Supply%20-%20EUPHOBIA%20-%2003%20You%20Know.mp3?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1471356558&Signature=305aVtJrS4NpYZS2wGYrfs36xTI%3D",
         "year" : "2016-02-01T00:00:00",
         "smapleTrackURL" : "http:\/\/devdisctopia-audio.s3-us-west-2.amazonaws.com\/Quantum%20Supply\/EUPHOBIA\/sample\/Quantum%20Supply%20-%20EUPHOBIA%20-%2003%20You%20Know.mp3?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1471356557&Signature=0Q8MjWh%2BkXJoGssVixYIwMLTjog%3D",
         "description" : null,
         "trackFileName" : "Quantum Supply - EUPHOBIA - 03 You Know.wav",
         "user_image" : null,
         "modifiedDate1" : "2016-02-01T18:16:29.257",
         "modifiedDate" : "2016-02-01T18:16:29.257",
         "coverName" : "EUPHOBIA",
         "trackName" : "You Know",
         "user_url" : "",
         "album_image" : "Quantum Supply\/EUPHOBIA\/cover.jpg",
         "album_price" : 4,
         "trackId" : 220,
         "mp3ConvertedDate" : "2016-05-25T09:00:03.55",
         "errorMessage" : "",
         "profileUrl" : null,
         "albumId" : 29,
         "albumId1" : 29,
         "track_url" : "http:\/\/devdisctopia-audio.s3-us-west-2.amazonaws.com\/Quantum%20Supply\/EUPHOBIA\/Quantum%20Supply%20-%20EUPHOBIA%20-%2003%20You%20Know.wav?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1471356557&Signature=s9XmZBJzlDWhLmWmY8CnOCXM8xQ%3D",
         "duration" : "00:03:46.4610000",
         "album_url" : "https:\/\/s3-us-west-2.amazonaws.com\/devdisctopia-audio\/Quantum Supply\/EUPHOBIA\/cover.jpg",
         "tags" : null,
         "number" : 3,
         "isFreeTrack" : false,
         "createdDate" : "2016-02-01T18:16:29.257",
         "artistName" : "Quantum Supply",
         "track_price" : 2,
         "isMp3Converted" : 1,
         "createdDate1" : "2016-02-01T18:16:29.257",
         "userId" : "0e01112b-86c3-459f-a8a3-b49ee4f87fda",
         "isPurchased" : 0
         }
         */
        
        if trackJSON != nil
        {
            if (trackJSON!["isFavorite"] != nil)
            {
                self.isFavorite = trackJSON!["isFavorite"].stringValue
            }
            else
            {
                self.isFavorite = "0"
            }
            
            self.trackId = trackJSON!["trackId"].stringValue
            if (trackJSON!["trackName"] != nil)
            {
                self.name = trackJSON!["trackName"].stringValue
            }
            else
            {
                self.name = trackJSON!["name"].stringValue
            }
            
            if (trackJSON!["tierStem"] != nil)
            {
                self.tierStem = trackJSON!["tierStem"].stringValue
            }
            else
            {
                self.tierStem = "0"
            }
            
            if (trackJSON!["iosPrice"] != nil)
            {
                self.track_price = trackJSON!["iosPrice"].stringValue
            }
            else
            {
                if (trackJSON!["track_price"] != nil)
                {
                    self.track_price = trackJSON!["track_price"].stringValue
                    
                }
                else
                {
                    self.track_price = "0"
                }
            }

            self.imageURL = trackJSON!["album_url"].stringValue
            self.track_url = trackJSON!["track_url"].stringValue
            self.track_sample_url = trackJSON!["smapleTrackURL"].stringValue
            self.track_full_url = trackJSON!["purchasedTrackURL"].stringValue
            
            self.albumName = trackJSON!["coverName"].stringValue
            self.albumURL = trackJSON!["album_url"].stringValue
            self.albumId = trackJSON!["albumId"].stringValue
            
            self.artist = trackJSON!["artistName"].stringValue
            
            //self.track_price = trackJSON!["track_price"].stringValue
            self.isFreeTrack = trackJSON!["isFreeTrack"].stringValue
            self.isPurchased = trackJSON!["isPurchased"].stringValue
            
            
            var duration = trackJSON!["duration"].stringValue
            
            if (self.albumName.characters.count == 0)
            {
                self.albumName = trackJSON!["coverName"].stringValue
            }
            
            self.imageURL = self.imageURL.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            if (self.imageURL.characters.count > 0)
            {
                Alamofire.request(.GET, self.imageURL)
                    .responseImage { response in
                        // BaseVC.sharedInstance.DLog(response)
                        
                        //BaseVC.sharedInstance.DLog(response.request)
                        // BaseVC.sharedInstance.DLog(response.response)
                        // BaseVC.sharedInstance.DLog(response.result)
                        
                        if let image = response.result.value {
                            //BaseVC.sharedInstance.DLog("image downloaded: \(image)")
                            self.trackImage = image
                        }
                }
            }

            
            if duration.characters.count > 0
            {
                //"00:04:00.6970000",
                let durationArray = duration.componentsSeparatedByString(".")
                if durationArray.count > 0
                {
                    if let timeSrting = durationArray[0] as? String
                    {
                        let timeArray = timeSrting.componentsSeparatedByString(":")
                        if timeArray.count > 2
                        {
                            let min = timeArray[1]
                            let secound = timeArray[2]
                            duration = "\(min):\(secound)"
                            self.track_time = duration
                            self.duration  = CGFloat(Int(min)! * 60 + Int(secound)!)
                        }
                    }
                }
            }
            
            self.isLocal = "0"
            self.updateTrackURLWithDownload(false)
            BaseVC.sharedInstance.DLog("track_play_url = \(self.track_play_url?.absoluteString)")
        }
        else
        {
            self.trackId = ""
            self.track_sample_url = ""
            self.track_full_url = ""
            self.track_url = ""
            self.track_play_url = nil
        }
    }
    
    func updateTrackURLWithDownload(needDownload:Bool)
    {
        if (self.isLocal == "0")
        {
            let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
            let destinationUrl = documentsUrl.URLByAppendingPathComponent("\(self.trackId!).mp3")
            DLog("playMusic destinationUrl \(destinationUrl)")
            
            var local_trackURL = ""
            if NSFileManager().fileExistsAtPath(destinationUrl.path!)
            {
                local_trackURL = destinationUrl.path!
            }
            
            /*
             4) Artist can play full song (.mp3 with streaming) even if they have not purchased it - CORRECT - BUT ONLY if it is a FREE track, PAID tracks must play sample unless there are paid for...
             
             5) Artist can play full song (.mp3, local downloaded) if they have purchased it  - CORRECT
             
             6) Fan can play sample song (30 sec, .mp3 song with streaming) even if they have not purchased it - CORRECT - if it is a PAID track only
             
             7) Fan can play full song (.mp3 locally downloaded) if they have purchased it  - CORRECT or if it is a FREE track
             */
            
            let saveResult1 : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.userProfileInfo)
            let userTypeStr = saveResult1.arrayValue[0][kAPIUserType].stringValue
            var isArtist = false
            
            if userTypeStr == "2" // Artist User
            {
                isArtist = true
            }
            
            if (self.isPurchased == "1")
            {
                if (local_trackURL.characters.count > 0)
                {
                    // Local Downloaded song
                    self.track_play_url = NSURL(fileURLWithPath: local_trackURL)
                }
                else
                {
                    if (self.track_full_url.characters.count > 0)
                    {
                        self.track_download_url = self.track_full_url.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                        self.track_play_url = NSURL(string:self.track_download_url )
                    }
                    else
                    {
                        // WavFull file
                        self.track_download_url = self.track_url!.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                        self.track_play_url = NSURL(string:self.track_download_url )
                    }
                    // and Download song
                    DLog("Download Track \(self.trackId!) from isPurchased = 1")
                    //
                    if needDownload
                    {
                        print("Download Track \(self.trackId!) from isPurchased = 1")
                        startDownload(self)
                    }
                }
            }
            else
            {
                
                if (self.isFreeTrack == "true")
                {
                    if (local_trackURL.characters.count > 0)
                    {
                        // Local Downloaded song
                        self.track_play_url = NSURL(fileURLWithPath: local_trackURL)
                    }
                    else
                    {
                        if (self.track_full_url.characters.count > 0)
                        {
                            self.track_download_url = self.track_full_url.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                            self.track_play_url = NSURL(string:self.track_download_url )
                        }
                        else
                        {
                            self.track_download_url = self.track_url!.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                            self.track_play_url = NSURL(string:self.track_download_url )
                        }
                        // and Download Track
                        DLog("Download Track \(self.trackId!) from isFreeTrack = true")
                        if needDownload
                        {
                            print("2 Download Track \(self.trackId!) from isPurchased = 1")
                            
                         
                            
                            startDownload(self)
                        }
                    }
                }
                else
                {
                    //self.isFreeTrack == "false" and  self.isPurchased == "0" Is it possible  ? if yes then what should we do ?
                    
                    if (isArtist) // Artist User
                    {
                        // Paid Track Only
                        if (self.track_full_url.characters.count > 0)
                        {
                            self.track_download_url = self.track_full_url.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                            self.track_play_url = NSURL(string:self.track_download_url )
                        }
                        else
                        {
                            // self.track_download_url = self.track_url!.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                            //self.track_play_url = NSURL(string:self.track_download_url )
                            self.track_play_url = NSURL(string:self.track_url!.stringByReplacingOccurrencesOfString("\\/", withString: "/"))
                        }
                        
                        
                    }
                    else  // Fan User
                    {
                        
                        // Paid Track Only
                        if (self.track_sample_url.characters.count > 0)
                        {
                            //self.track_download_url = self.track_sample_url.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                            //self.track_play_url = NSURL(string:self.track_download_url )
                            self.track_play_url = NSURL(string:self.track_sample_url.stringByReplacingOccurrencesOfString("\\/", withString: "/"))
                        }
                        else
                        {
                            // self.track_download_url = self.track_url!.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                            //self.track_play_url = NSURL(string:self.track_download_url )
                            self.track_play_url = NSURL(string:self.track_url!.stringByReplacingOccurrencesOfString("\\/", withString: "/"))
                        }
                    }
                }
            }
            
            

          /*  if (self.imageURL.characters.count > 0)
            //            if (isArtist) // Artist User
            //            {
            //
            //
            //
            //            }
            //            else  // Fan User
            //            {
            //
            //
            //            }
            /*
             if (self.isPurchased == "1")
             {
             
             purchasedTrackURL  (Download from full mp3 url)
             }
             
             
             */
            
            //            if (self.isFreeTrack == "true")
            //            {
            //                if (local_trackURL.characters.count > 0)
            //                {
            //                    // Local Downloaded song
            //                    self.track_play_url = NSURL(fileURLWithPath: local_trackURL)
            //                }
            //                else
            //                {
            //                    if (self.track_full_url.characters.count > 0)
            //                    {
            //                        self.track_download_url = self.track_full_url.stringByReplacingOccurrencesOfString("\\/", withString: "/")
            //                        self.track_play_url = NSURL(string:self.track_download_url )
            //                    }
            //                    else
            //                    {
            //                        self.track_download_url = self.track_url!.stringByReplacingOccurrencesOfString("\\/", withString: "/")
            //                        self.track_play_url = NSURL(string:self.track_download_url )
            //                    }
            //                    // and Download Track
            //                    DLog("Download Track \(self.trackId)")
            //                    startDownload(self)
            //                }
            //            }
            //            else
            //            {
            //                //self.isFreeTrack == "false" and  self.isPurchased == "0" Is it possible  ? if yes then what should we do ?
            //            }
            
            if (self.imageURL.characters.count > 0)
            {
                Alamofire.request(.GET, self.imageURL)
                    .responseImage { response in
                        // BaseVC.sharedInstance.DLog(response)
                        
                        //BaseVC.sharedInstance.DLog(response.request)
                        // BaseVC.sharedInstance.DLog(response.response)
                        // BaseVC.sharedInstance.DLog(response.result)
                        
                        if let image = response.result.value {
                            //BaseVC.sharedInstance.DLog("image downloaded: \(image)")
                            self.trackImage = image
                        }
                }
            }
           */
            if (self.track_play_url != nil)
            {
                /*
                 let playerItem = AVPlayerItem(URL:self.track_play_url!)
                 
                 let playerAsset = playerItem.asset
                 
                 if (playerAsset.isKindOfClass(AVURLAsset))
                 {
                 if let URLAsset = playerAsset as? AVURLAsset
                 {
                 if let URLStr = URLAsset.URL as? NSURL
                 {
                 DLog("\(URLStr.absoluteString)")
                 }
                 }
                 }
                 DLog("Track playerItem = \(playerItem)")
                 */
            }
        }
    }
    
}

func timeFormatted(totalSeconds: Int) -> String {
    let seconds: Int = totalSeconds % 60
    let minutes: Int = (totalSeconds / 60) % 60
    let hours: Int = totalSeconds / 3600
    if hours <= 0
    {
        return String(format: "%02d:%02d",minutes, seconds)
    }
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

class Download: NSObject {
    
    var url: String
    var isDownloading = false
    var progress: Float = 0.0
    var track : Track
    var downloadTask: NSURLSessionDownloadTask?
    var resumeData: NSData?
    
    init(track: Track) {
        self.track = track
        self.url = track.track_url!
    }
}
// MARK: - NSURLSessionDelegate

extension PlayerBaseVC: NSURLSessionDelegate
{
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler()
                })
            }
        }
    }
}

// MARK: - NSURLSessionDownloadDelegate
extension PlayerBaseVC: NSURLSessionDownloadDelegate
{
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        BaseVC.sharedInstance.DLog("didFinishDownloadingToURL location = \(location.absoluteString)")
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        //{
        // Any Large Task
        
        // 1
        if (downloadTask.taskDescription != nil)
        {
            if let originalURL =  downloadTask.taskDescription ,//downloadTask.originalRequest?.URL?.absoluteString,
                destinationURL = localFilePathForUrl(originalURL) {
                
                if let freeDiskSpace = DiskStatus.MBFormatter(DiskStatus.freeDiskSpaceInBytes) as? String
                {
                    
                    BaseVC.sharedInstance.DLog("destinationURL = \(destinationURL) \n\n\n ### freeDiskSpace = \(Int(Float(freeDiskSpace.stringByReplacingOccurrencesOfString(",", withString: ""))!))")
                    
                    if Int(Float(freeDiskSpace.stringByReplacingOccurrencesOfString(",", withString: ""))!) > 10
                    {
                        
                        // Delete file
                        if (NSFileManager().fileExistsAtPath(destinationURL.path!))
                        {
                            let fileManager = NSFileManager.defaultManager()
                            do {
                                try fileManager.removeItemAtPath(destinationURL.path!)
                            } catch {
                                print("### Failed to remove file \(destinationURL.path!) with Error", error as! NSError)
                            }
                        }
                        
                        // Copy File from Temp Folder
                        let fileManager = NSFileManager.defaultManager()
                        do {
                            try fileManager.moveItemAtURL(location, toURL: destinationURL)
                            //try fileManager.copyItemAtURL(location, toURL: destinationURL)
                            DLog("Success to moveItemAtURL file from \(location.path!) to \(destinationURL.path!)")
                            
                            let getPath = destinationURL.lastPathComponent!.componentsSeparatedByString(".")
                            appDelegate.trackDownloadDictionary.removeObjectForKey(getPath)
                    
                        } catch {
                            print("Failed to moveItemAtURL file from \(location.path!) to \(destinationURL.path!)  with Error", error as! NSError)
                        }
                        
                        //                            // Delete file
                        //                            if (!NSFileManager().fileExistsAtPath(location.path!))
                        //                            {
                        //                                let fileManager = NSFileManager.defaultManager()
                        //                                do {
                        //                                    try fileManager.removeItemAtPath(location.path!)
                        //                                } catch {
                        //                                    print("Failed to remove file \(location.path!)  with Error", error as! NSError)
                        //                                }
                        //                            }
                        
                        
                        /*
                         
                         // 2
                         let fileManager = NSFileManager.defaultManager()
                         do {
                         try fileManager.removeItemAtURL(destinationURL)
                         } catch {
                         // Non-fatal: file probably doesn't exist
                         }
                         
                         //if fileManager.fileExistsAtPath(location.absoluteString)
                         //{
                         do {
                         try fileManager.copyItemAtURL(location, toURL: destinationURL)
                         } catch {
                         // Non-fatal: file probably doesn't exist
                         }
                         
                         do {
                         try fileManager.removeItemAtURL(location)
                         } catch {
                         // Non-fatal: file probably doesn't exist
                         }
                         //}
                         
                         //                    do {
                         //                       try fileManager.copyItemAtURL(location, toURL: destinationTrackURL)
                         //                    } catch let error as NSError {
                         //                        BaseVC.sharedInstance.DLog("Could not copy file to disk: \(error.localizedDescription)")
                         //
                         }
                         */
                    }
                    
                }
            }
            
          
        }
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        DLog("URLSession bytesWritten = \(bytesWritten)")
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        //{
        
        // 1
        if let downloadUrl = downloadTask.originalRequest?.URL?.absoluteString,
            download = self.activeDownloads[downloadUrl] {
            // 2
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            
            print(download.progress)
            
            // 3
            let totalSize = NSByteCountFormatter.stringFromByteCount(totalBytesExpectedToWrite, countStyle: NSByteCountFormatterCountStyle.Binary)
            // 4
            if let trackIndex = trackIndexForDownloadTask(downloadTask)
            {
                /*
                 dispatch_async(dispatch_get_main_queue(), {
                 
                 //self.DLog(String(format: "%.1f%% of %@",  download.progress * 100, totalSize))
                 // trackCell.progressView.progress = download.progress
                 // trackCell.progressLabel.text =
                 })*/
            }
        }
        //}
    }
   
}

