//
//  LocalSongPlayer.swift
//  Disctopia
//
//  Created by Mitesh on 28/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import SwiftyJSON
import AlamofireImage
class LocalSongPlayer: BaseVC,UIGestureRecognizerDelegate
{
    var minimisePlayerObj:PlayerBaseVC?
    var  isLocal: String = ""
    var currTrackIndex : Int = 0
    var trackArrayPlayer:[JSON] = []
    var isFromMinimisePlayer : Bool = false
    var isShuffle = false
    var sliderValue:Float = 0.0
    var trackDurationInSecond:CGFloat = 0
    var btnPlaySelected = false
    @IBOutlet var overlayImage: UIImageView!
    // MARK: - LifeCycle Method -
    class var sharedPlayerInstance1: LocalSongPlayer
    {
        struct Static
        {
            static let instance = LocalSongPlayer.instantiateFromStoryboard()
        }
        return Static.instance
    }
    
    class func instantiateFromStoryboard() -> LocalSongPlayer
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! LocalSongPlayer
    }
    
    override func viewWillAppear(animated: Bool)
    {
        blurBackGround()
        
        if (appDelegate.minimizePlayerView != nil)
        {
            if let minimizeView = appDelegate.window?.viewWithTag(666) as? PlayerBaseVC
            {
                self.minimisePlayerObj = minimizeView
                minimizeView.removeFromSuperview()
                //minimizeView.hidden = true
            }
        }
        
        if let aPlayderView =  self.view.viewWithTag(555) as? PlayerBaseVC
        {
            appDelegate.playerView = aPlayderView
        }
        
        super.viewWillAppear(animated)
        self.setupPlayer()
    }
   
    func blurBackGround()
    {
//        let image = UIImage(named: "download.jpeg")!
//        let sepiaImage = image.af_imageFiltered(withCoreImageFilter: "CISepiaTone")
//        let blurredImage = image.af_imageFiltered(withCoreImageFilter: "CIGuassianBlue",parameters: ["inputRadius": 25])
//        let blurEffect = UIBlurEffect(style: .Light)
//        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//        blurredEffectView.frame = view.bounds
//        self.view.addSubview(blurredEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
    }
    
    func setupPlayer()
    {
        self.navigationController?.navigationBarHidden = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                        {
                           // Any Large Task
                            
                            dispatch_async(dispatch_get_main_queue(),
                            {
                               // Update UI in Main thread
                                // your function here
                                if appDelegate.playerView != nil
                                {
                                    appDelegate.playerView.isLocal = LocalSongPlayer.sharedPlayerInstance1.isLocal
                                    appDelegate.playerView.currTrackIndex = LocalSongPlayer.sharedPlayerInstance1.currTrackIndex
                                    
                                    
                                    
                                    appDelegate.playerView.parentVC = self
                                    if (self.isFromMinimisePlayer == false)
                                    {
                                        
                                    }
                                    else
                                    {
                                        self.isFromMinimisePlayer = false
                                    }
                                    appDelegate.playerView.seekSlider.value = self.sliderValue
                                    appDelegate.playerView.trackDurationInSecond = self.trackDurationInSecond
                                    appDelegate.playerView.btnPlay.selected = self.btnPlaySelected
                                    appDelegate.playerView.isShuffle = self.isShuffle
                                    
                                     appDelegate.playerView.reloadArray()
                                    //appDelegate.playerView.addTracksToPlayer()
                                   // appDelegate.playerView.onPlayClick(nil)
                                }

                            });
                        }
    }

    func closeLocalSongView()
    {
    
    }
  /*
    @IBAction func onClosePlayerClick(sender: UIButton)
    {
        
        NSNotificationCenter.defaultCenter().postNotificationName("basePlayer", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("playerContainerId", object: nil)
        
        if playerView.isLocal == "0"
        {
            if (playerView.trackArrayPlayer.count > playerView.currTrackIndex)
            {
                var dictTrackDetails = /**/playerView.trackArrayPlayer[/**/playerView.currTrackIndex].dictionaryValue
                let trackId = dictTrackDetails["trackId"]?.stringValue
                appDelegate.currentSongId = trackId!
            }
        }
        else
        {
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
*/
/*    // MARK: - Outlet -
    @IBOutlet weak var viewPlayer: UIView!
    
    @IBOutlet weak var btnshuffle: UIButton!
    @IBOutlet weak var btnDrag: UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
      
    // var audioPlayer:AVAudioPlayer = AVvarioPlayer()
    
     
    override func viewDidLoad()
    {
        self.syncPlayerFromSelf()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewPlayer.layer.cornerRadius = 3.0
        aExpandedPlayerVC.getDocumentsDirectory()
       
        //self.setProgressPerc(0.0)
    }
    
    func syncPlayerFromSelf()
    {
        //aExpandedPlayerVC.pauseTime = self.pauseTime
        //aExpandedPlayerVC.isLocal = self.isLocal
        //aExpandedPlayerVC.trackObjArray = self.trackObjArray
        //aExpandedPlayerVC.currTrackIndex = self.currTrackIndex
        //aExpandedPlayerVC.trackDurationInSecond = self.trackDurationInSecond
        //aExpandedPlayerVC.pauseTime = self.pauseTime
        //aExpandedPlayerVC.timer = self.timer

        aExpandedPlayerVC.lblTrackTitle = self.lblTrackTitle
        aExpandedPlayerVC.lblArtistTitle = self.lblArtistTitle
        aExpandedPlayerVC.lblTrackCurrentTime = self.lblTrackCurrentTime
        aExpandedPlayerVC.lblTrackEndTime = self.lblTrackEndTime
        aExpandedPlayerVC.imgArtwork = self.imgArtwork

        aExpandedPlayerVC.btnPlay = self.btnPlay
        aExpandedPlayerVC.seekSlider = self.seekSlider
        aExpandedPlayerVC.addSongClick = self.addSongClick
        aExpandedPlayerVC.btnPurchase = self.btnPurchase
    }
    
    func syncPlayerFromSingleton()
    {
        self.isLocal = aExpandedPlayerVC.isLocal
        if /**/self.isLocal == "0"
        {
            if (aExpandedPlayerVC.trackObjArray.count > aExpandedPlayerVC.currTrackIndex && aExpandedPlayerVC.currTrackIndex > 0)
            {
                self.trackObjArray = aExpandedPlayerVC.trackObjArray
                self.currTrackIndex = aExpandedPlayerVC.currTrackIndex
                self.trackDurationInSecond = aExpandedPlayerVC.trackDurationInSecond
                
                let trackObj = trackObjArray[aExpandedPlayerVC.currTrackIndex]
                //var dictTrackDetails = /**/self.trackArrayPlayer[/**/self.currTrackIndex].dictionaryValue
                let trackName = trackObj.name
                let artistName = trackObj.albumName
                if self.lblTrackTitle != nil
                {
                    /**/self.lblTrackTitle.text = trackName
                }
                
                if self.lblArtistTitle != nil
                {
                    /**/self.lblArtistTitle.text = artistName
                }
            }
        }
        else
        {
            if (aExpandedPlayerVC.trackObjArray.count > aExpandedPlayerVC.currTrackIndex && aExpandedPlayerVC.currTrackIndex > 0)
            {
                self.trackObjArray = aExpandedPlayerVC.trackObjArray
                self.currTrackIndex = aExpandedPlayerVC.currTrackIndex
                self.trackDurationInSecond = aExpandedPlayerVC.trackDurationInSecond
                
                self.lblTrackTitle.text = aExpandedPlayerVC.lblTrackTitle.text
                /**/self.lblArtistTitle.text =  aExpandedPlayerVC.lblArtistTitle.text
            }
            
        }
        
        if aExpandedPlayerVC.seekSlider != nil
        {
            self.seekSlider = aExpandedPlayerVC.seekSlider
        }
        if aExpandedPlayerVC.btnPlay != nil
        {
            self.btnPlay = aExpandedPlayerVC.btnPlay
        }
        if aExpandedPlayerVC.pauseTime != nil
        {
            self.pauseTime = aExpandedPlayerVC.pauseTime
        }
        if aExpandedPlayerVC.timer != nil
        {
            self.timer = aExpandedPlayerVC.timer
            aExpandedPlayerVC.startTrackProgress()
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        syncPlayerFromSelf()
        super.viewWillAppear(animated)

        aExpandedPlayerVC.seekSlider.setThumbImage(UIImage(named: "green_slider_bar"), forState: UIControlState.Normal)
        aExpandedPlayerVC.seekSlider.setMaximumTrackImage(UIImage(named: "seekbar_grey.png"), forState: UIControlState.Normal)
        aExpandedPlayerVC.seekSlider.setMinimumTrackImage(UIImage(named: "seekbar_color.png"), forState: UIControlState.Normal)
        aExpandedPlayerVC.seekSlider.setThumbImage(UIImage(named: "green_slider_bar"), forState: UIControlState.Highlighted)
        aExpandedPlayerVC.pauseTime = 0
        /**/aExpandedPlayerVC.lblTrackCurrentTime.text = "00:00"
        self.navigationController?.navigationBarHidden = true
        if /**/aExpandedPlayerVC.isLocal == "0"
        {
            aExpandedPlayerVC.addSongClick.hidden = false
            aExpandedPlayerVC.btnPurchase.hidden = true
            //self.originalTrackArray = /**/self.trackArrayPlayer
            /**/aExpandedPlayerVC.startDownloadingUrls()
        }
        else
        {
            aExpandedPlayerVC.addSongClick.hidden = true
            aExpandedPlayerVC.btnPurchase.hidden = true
           // /**/self.arrTrackList = NSMutableArray()
            for i in 0 ..< appDelegate.arrMediaItems.count
            {
                let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                dict.setObject("1", forKey: "isLocal")
                dict.setObject(appDelegate.arrMediaItems[i], forKey: "trackInfo")
               // /**/self.arrTrackList.addObject(dict)
            }
           // /**/self.originalArrTrackList = /**/self.arrTrackList
        }
       // currentQueueToShuffle(isShuffle)
        aExpandedPlayerVC.btnPlay.selected = false
        aExpandedPlayerVC.onPlayClick(nil)
        //self.view.bringSubviewToFront(aExpandedPlayerVC.seekSlider)
    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        //audioPlayer.stop()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Queue shuffle -
    private func currentQueueToShuffle(shuffle: Bool)
    {
        if aExpandedPlayerVC.isLocal == "0"
        {
            serverSongShuffle(shuffle)
        }
        else
        {
            localSongShuffle(shuffle)
        }
    }
    
    func serverSongShuffle(shuffle: Bool)
    {
//        if shuffle
//        {
//            if /**/self.trackArrayPlayer.count > 1
//            {
//                let currentTrack = /**/self.currentServerTrack()
//                self.shuffle()
//                for newCurrentIndex in 0  ..< /**/self.trackArrayPlayer.count
//                {
//                    if currentTrack == /**/self.trackArrayPlayer[newCurrentIndex].dictionaryValue
//                    {
//                        /**/self.currTrackIndex = newCurrentIndex
//                        break
//                    }
//                }
//            }
//        }
//        else
//        {
//            if /**/self.originalTrackArray.count > 1
//            {
//                let currentTrack = /**/self.currentServerTrack()
//                for newCurrentIndex in 0  ..< /**/self.originalTrackArray.count
//                {
//                    if currentTrack == /**/self.originalTrackArray[newCurrentIndex].dictionaryValue
//                    {
//                        /**/self.currTrackIndex = newCurrentIndex
//                        break
//                    }
//                }
//                /**/self.trackArrayPlayer = /**/self.originalTrackArray
//            }
//           
//        }
    }
    func shuffle()
    {
        var list = Array(/**/aExpandedPlayerVC.trackArrayPlayer)
        BaseVC.sharedInstance.DLog("list:\(list)")
        list.shuffleInPlace()
        BaseVC.sharedInstance.DLog("list shuffleInPlace: \(list)")
        /**/aExpandedPlayerVC.trackArrayPlayer =  list
    }
    
    func localSongShuffle(shuffle: Bool)
    {
//        if shuffle
//        {
//            if /**/self.arrTrackList.count > 1
//            {
//                if let currentTrack = /**/self.currentTrack()
//                {
//                    /**/self.arrTrackList.shuffle()
//                    for var newCurrentIndex = 0 ; newCurrentIndex < /**/self.arrTrackList.count ; newCurrentIndex += 1
//                    {
//                        if currentTrack == /**/self.arrTrackList[newCurrentIndex] as! NSMutableDictionary
//                        {
//                            /**/self.currTrackIndex = newCurrentIndex
//                            break
//                        }
//                    }
//                }
//            }
//        }
//        else
//        {
//            if /**/self.originalArrTrackList.count > 1
//            {
//                if let currentTrack = /**/self.currentTrack()
//                {
//                    for var newCurrentIndex = 0 ; newCurrentIndex < /**/self.originalArrTrackList.count ; newCurrentIndex += 1
//                    {
//                        if currentTrack == /**/self.originalArrTrackList[newCurrentIndex] as! NSMutableDictionary
//                        {
//                            /**/self.currTrackIndex = newCurrentIndex
//                            break
//                        }
//                    }
//                }
//                /**/self.arrTrackList = /**/self.originalArrTrackList
//            }
//            else
//            {
//                /**/self.arrTrackList = []
//            }
//        }

    }
   
    
    
    //MARK: - Button Action -
    @IBAction func onFavouriteClick(sender: UIButton)
    {
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
        if (aExpandedPlayerVC.trackArrayPlayer.count > aExpandedPlayerVC.currTrackIndex)
        {
            
            var dictTrackDetails = /**/aExpandedPlayerVC.trackArrayPlayer[/**/aExpandedPlayerVC.currTrackIndex].dictionaryValue
            let trackId = dictTrackDetails["trackId"]?.stringValue
            let vc : AddTrackVC = storyboard!.instantiateViewControllerWithIdentifier("AddTrackVC") as! AddTrackVC
            vc.selectedTrackId = trackId!
            //herbDetails.herb = selectedHerb
            vc.modalPresentationStyle = .CurrentContext
            vc.transitioningDelegate = self
            //        vc.view.backgroundColor = .None
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnPurchaseAction(sender: AnyObject)
    {
        
    }
    
    @IBAction func onShuffleClick(sender: UIButton)
    {
        if /**/aExpandedPlayerVC.isRepeatTrack == 0
        {
            btnRepeat.setImage(UIImage.init(named: "green_repeat.png"), forState: .Normal)
            /**/aExpandedPlayerVC.isRepeatTrack = 1
        }
        else if /**/aExpandedPlayerVC.isRepeatTrack == 1
        {
            btnRepeat.setImage(UIImage.init(named: "green_repeat_one.png"), forState: .Normal)
            /**/aExpandedPlayerVC.isRepeatTrack = 2
        }
        else
        {
            btnRepeat.setImage(UIImage.init(named: "grey_repeat.png"), forState: .Normal)
            /**/aExpandedPlayerVC.isRepeatTrack = 0
        }
    }
    
    @IBAction func onCrossFadeClick(sender: UIButton)
    {
        if /**/aExpandedPlayerVC.isShuffle
        {
            /**/aExpandedPlayerVC.isShuffle = false
            btnshuffle.setImage(UIImage.init(named: "grey_crossfade"), forState: .Normal)
            currentQueueToShuffle(/**/aExpandedPlayerVC.isShuffle)
        }
        else
        {
            /**/aExpandedPlayerVC.isShuffle = true
            btnshuffle.setImage(UIImage.init(named: "green_crossfade"), forState: .Normal)
            currentQueueToShuffle(/**/aExpandedPlayerVC.isShuffle)
        }
    }
   
 */
}

// MARK: - UIViewControllerTransitioningDelegate -
extension LocalSongPlayer: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning?
    {
        if (appDelegate.playerView.addSongClick.superview != nil)
        {
            /**/appDelegate.playerView.transition.originFrame = appDelegate.playerView.addSongClick.superview!.convertRect(appDelegate.playerView.addSongClick!.frame, toView: nil)
        }
            /**/appDelegate.playerView.transition.presenting = true
            
            return /**/appDelegate.playerView.transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        /**/appDelegate.playerView.transition.presenting = false
        return /**/appDelegate.playerView.transition
    }
}

// MARK: - shuffleInPlace -
extension MutableCollectionType where Index == Int
{
    mutating func shuffleInPlace()
    {
        if count < 2 { return }
        for i in 0..<count - 1
        {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
extension NSMutableArray
{
    func shuffle()
    {
        for index in 0..<self.count {
            let random = Int(arc4random_uniform(UInt32(index)))
            if random != index {
                swap(&self[index], &self[random])
            }
        }
    }
}
 
/*
 {
 "album_Name" : "Black Future",
 "orderDate" : "2016-06-06T07:53:22.357",
 "trackId" : 210,
 "albumId" : 28,
 "track_url" : "http:\/\/devdisctopia-audio.s3-us-west-2.amazonaws.com\/Dutch\/BlackFuture\/Let%20Me%20At%20Em.wav?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1470046814&Signature=RJ3Nmz6JGCCvxYCZlXW5FOQAM28%3D",
 "unitPrice" : 10,
 "duration" : "00:04:00.6970000",
 "album_url" : "https:\/\/s3-us-west-2.amazonaws.com\/devdisctopia-audio\/Dutch\/BlackFuture\/blackFuture.jpg",
 "total" : 14.73,
 "email" : "diddy@disctopia.com",
 "user_image" : "Diddy\/Diddy_14665057404846163.jpg",
 "artistName" : "Diddy",
 "orderNumber" : "20160606277",
 "saveInfo" : true,
 "trackName" : "Let Me At Em",
 "orderId" : 277,
 "userId" : "398f4085-c280-4084-aa49-6e4aebde4e12",
 "user_url" : "https:\/\/s3-us-west-2.amazonaws.com\/devdisctopia-audio\/Diddy\/Diddy_14665057404846163.jpg",
 "quantity" : 1,
 "album_image" : "Dutch\/BlackFuture\/blackFuture.jpg"
 }
 */
//ttp://stackoverflow.com/questions/27540068/download-file-path-with-nsfilemanager