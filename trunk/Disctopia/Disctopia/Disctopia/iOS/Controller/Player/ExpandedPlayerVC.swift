//
//  ExpandedPlayerVC.swift
//  Disctopia
//
//  Created by Hardik Shekhat on 30/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//
/*
    Progress Bar :
        Max Range : 1.0 and Min Range : 0.01
 */
import UIKit
import AVFoundation
import MediaPlayer

class ExpandedPlayerVC: BaseVC,UIGestureRecognizerDelegate
{
    
    @IBOutlet weak var lblTrackTitle: UILabel!
    @IBOutlet weak var lblArtistTitle: UILabel!
    
    @IBOutlet weak var lblTrackCurrentTime: UILabel!
    @IBOutlet weak var lblTrackEndTime: UILabel!
    
    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var viewPlayer: UIView!
    
    @IBOutlet weak var btnDrag: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var addSongClick: UIButton!
    
    @IBOutlet var progressBar: YLProgressBar!
    
    var isRepeatTrack : Int = 0 //0 = No Repeat , 1 = Repeat All , 2 = Repeat One.
    var arrTrackList : NSMutableArray = [["fileName":"03","extensionName":"m4a","isLocal":"0"],["fileName":"02","extensionName":"mp3","isLocal":"0"],["fileName":"01","extensionName":"mp3","isLocal":"0"],["fileName":"04","extensionName":"m4a","isLocal":"0"]] //["1.mp3","2.mp3","3.m4a"]
    
    var isLocal : String = ""
    var currTrackIndex : Int = 0
    var pauseTime : NSTimeInterval!
    
    var trackDurationInSecond : CGFloat = 0
    
    var timer:NSTimer? = NSTimer()
   // var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    var audioPlayer = AVAudioPlayer()
    let transition = PopAnimator()
    
    class var sharedPlayerInstance: ExpandedPlayerVC
    {
        struct Static
        {
            static let instance = ExpandedPlayerVC.instantiateFromStoryboard()
        }
        return Static.instance
    }
    
    class func instantiateFromStoryboard() -> ExpandedPlayerVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! ExpandedPlayerVC
    }
    
    //MARK: - UIView Life Cycle -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewPlayer.layer.cornerRadius = 3.0
        self.getDocumentsDirectory()
        
        self.initFlatRainbowProgressBar()
        self.setProgressPerc(0.0)
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        pauseTime = 0
        self.navigationController?.navigationBarHidden = true
        
        if isLocal == "0"
        {
            self.arrTrackList.removeAllObjects()
            
            arrTrackList = [["fileName":"03","extensionName":"m4a","isLocal":"0"],["fileName":"02","extensionName":"mp3","isLocal":"0"],["fileName":"01","extensionName":"mp3","isLocal":"0"],["fileName":"04","extensionName":"m4a","isLocal":"0"]] //["1.mp3","2.mp3","3.m4a"]
            copySongIntoDocumentDirectory()
        }
        else
        {
            self.arrTrackList = NSMutableArray()
            
            for i in 0 ..< appDelegate.arrMediaItems.count
            {
                let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                
                dict.setObject("1", forKey: "isLocal")
                
                dict.setObject(appDelegate.arrMediaItems[i], forKey: "trackInfo")
                
                self.arrTrackList.addObject(dict)
            }
        }
        btnDrag.frame = CGRectMake((progressBar.frame.origin.x - (btnDrag.frame.size.width/2)), progressBar.frame.origin.y, btnDrag.frame.size.width, btnDrag.frame.size.height)
       
        btnPlay.selected = false
        self.onPlayClick(nil)
        
        let longPress = UIPanGestureRecognizer(target: self, action: #selector(ExpandedPlayerVC.handlePanGesture(_:)))
        
        //btnDrag.addGestureRecognizer(longPress)
    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
//      appDelegate.audioPlayer.stop()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handlePanGesture(recognizer: UIPanGestureRecognizer)
    {
        if recognizer.state == .Ended || recognizer.state == .Changed
        {
//            if timer != nil
//            {
//                timer!.invalidate()
//                timer = nil
//              appDelegate.audioPlayer.stop()
//            }
            
            let draggedButton: UIView = recognizer.view!
            let translation: CGPoint = recognizer.translationInView(progressBar!)
            var newButtonFrame: CGRect = draggedButton.frame
            
            //BaseVC.sharedInstance.DLog("translation \(translation)")
            
            newButtonFrame.origin.x += translation.x
            
            //For Set Drag Button Frame in Minus of ProgressBar
            if newButtonFrame.origin.x < (progressBar.frame.origin.x - newButtonFrame.size.width/2)
            {
                newButtonFrame.origin.x = progressBar.frame.origin.x - newButtonFrame.size.width/2
            }
            else if newButtonFrame.origin.x + newButtonFrame.size.width >= (progressBar.frame.size.width + newButtonFrame.size.width/2)//Set Drag Button Frame in Plus of ProgressBar Width
            {
                newButtonFrame.origin.x = progressBar.frame.size.width - newButtonFrame.size.width/2
            }
            
            let xPoints: CGFloat = newButtonFrame.origin.x
            let velocityX: CGFloat = recognizer.velocityInView(draggedButton).x
            var duration: NSTimeInterval = Double(xPoints / velocityX)
//            var offScreenCenter: CGPoint = moveView.center
//            offScreenCenter.x += xPoints
            
            //Set Progress According to Drag Button
            let progress : CGFloat = CGFloat((newButtonFrame.origin.x + newButtonFrame.size.width/2) * 0.01) / (progressBar.frame.size.width/100)
            self.setProgress(progress, animated: true)

            UIView.animateWithDuration(0.5, animations:
            {
                draggedButton.frame = newButtonFrame

            })

            let trackCurrentTime : CGFloat = (progress * trackDurationInSecond) / CGFloat(audioPlayer.currentTime * 100)
            
//          appDelegate.audioPlayer.currentTime = Double(trackCurrentTime)
//            self.lblTrackCurrentTime.text = timeFormatted(Int(audioPlayer.currentTime))

            //BaseVC.sharedInstance.DLog("draggedButton \(draggedButton)")
            recognizer.setTranslation(CGPointZero, inView: progressBar!)
            
//            if recognizer.state == .Ended
//            {
//              appDelegate.audioPlayer.play()
//                self.startTrackProgress()
//            }
        }
    }
    func copySongIntoDocumentDirectory()
    {
        for dict in arrTrackList
        {
            let fileName : String = dict["fileName"] as! String
            let extensionName : String = dict["extensionName"] as! String
            
            if let path = NSBundle.mainBundle().pathForResource(fileName, ofType:extensionName)
            {
                var destPath = (self.getDocumentsDirectory() as NSString).stringByAppendingPathComponent("/SongList")
                
                let fileMgr = NSFileManager.defaultManager()
                
                if !fileMgr.fileExistsAtPath(destPath)
                {
                    do
                    {
                        try NSFileManager.defaultManager().createDirectoryAtPath(destPath, withIntermediateDirectories: false, attributes: nil)
                    }
                    catch let error as NSError
                    {
                        NSLog("\(error.localizedDescription)")
                    }
                }
                
                destPath = destPath.stringByAppendingPathComponent("/\(fileName).\(extensionName)")
                
                do
                {
                    if !fileMgr.fileExistsAtPath(destPath)
                    {
                        try fileMgr.copyItemAtPath(path, toPath: destPath)
                    }
                }
                catch let error as NSError
                {
                    NSLog("\(error.localizedDescription)")
                }
            }
            else
            {
                BaseVC.sharedInstance.DLog("Not Exists File")
            }
        }
        
        let destPath = (self.getDocumentsDirectory() as NSString).stringByAppendingPathComponent("/SongList")
        
        do
        {
            let url : NSURL = NSURL.fileURLWithPath(destPath, isDirectory: true)
            
            var arr : NSArray = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(url, includingPropertiesForKeys: [NSURLLocalizedNameKey], options: .SkipsHiddenFiles)
            
            arrTrackList = NSMutableArray.init(array: arr)
            
            self.arrTrackList.removeAllObjects()
            
            if arr.count > 0
            {
                arr = arr.valueForKeyPath("lastPathComponent") as! NSArray
                
                for i in 0 ..< arr.count
                {
                    let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                    
                    dict.setObject("0", forKey: "isLocal")
                    
                    dict.setObject(arr[i], forKey: "trackInfo")
                    
                    self.arrTrackList.addObject(dict)
                }
            }
            
        }
        catch let error as NSError
        {
            NSLog("\(error.localizedDescription)")
        }
        
    }
    
    // MARK: - Track Progress View -
    func initFlatRainbowProgressBar()
    {
        let tintColors: [AnyObject] = [UIColor(red: 107 / 255.0, green: 191 / 255.0, blue: 113 / 255.0, alpha: 1.0),
                                       UIColor(red: 161 / 255.0, green: 200 / 255.0, blue: 117 / 255.0, alpha: 1.0)]
        self.progressBar.type = .Flat
        self.progressBar.progressTintColors = tintColors
        self.progressBar.backgroundColor = UIColor.init(red: 220/255, green: 221/255, blue: 223/255, alpha: 1.0)
        self.progressBar.hideStripes = true
        self.progressBar.hideTrack = true
        self.progressBar.behavior = .Default
        self.progressBar.setProgress(0.0, animated: false)
    }
    
    func setProgressPerc(per:CGFloat)
    {
        self.setProgress(per, animated: true)
    }
    
    func setProgress(progress: CGFloat, animated: Bool)
    {
        progressBar.setProgress(progress, animated: animated)
    }
    
    // called every time interval from the timer
    func timerAction()
    {
        /*
            For E.g. Song Duration : 344 Second. Then We have to progress 0.01 out of 1.0 when 10% song completed.
            So, When 3.44(10% of 344) second song completed then we have to show progress 0.01.
            And 6.88(3.44 * 2) then show progress 0.02 (0.01 * 2)
         
            Calculation for progress = (songCurrentTime * 0.01) / (Total Song Duration/100)
        */
        let progress : CGFloat = CGFloat(audioPlayer.currentTime * 0.01) / (trackDurationInSecond/100)
        
        self.setProgress(progress, animated: true)
        
        let xPoint  = (self.progressBar.frame.size.width * progress ) / 1;
        
        btnDrag.frame = CGRectMake(xPoint - (btnDrag.frame.size.width/2) , btnDrag.frame.origin.y, btnDrag.frame.size.width, btnDrag.frame.size.height)
        
//        BaseVC.sharedInstance.DLog("audioPlayer.currentTime : \(audioPlayer.currentTime)   mod : \(progress)     xPoint  :  \(btnDrag.frame.origin.x)")
        self.lblTrackCurrentTime.text = timeFormatted(Int(audioPlayer.currentTime))
        
        if CGFloat(audioPlayer.currentTime) == 0
        {
            timer!.invalidate()
            btnDrag.frame = CGRectMake(-(btnDrag.frame.size.width/2), btnDrag.frame.origin.y, btnDrag.frame.size.width, btnDrag.frame.size.height)
            pauseTime = nil
            self.lblTrackCurrentTime.text = "00:00"
            self.lblTrackEndTime.text = "00:00"
            
            //0 = No Repeat , 1 = Repeat All , 2 = Repeat One.
            if isRepeatTrack == 0
            {
                if currTrackIndex >= arrTrackList.count-1
                {
                    btnPlay.selected = false
                }
                else
                {
                    onNextTrackClick(nil)
                }
            }
            else if isRepeatTrack == 1
            {
                onNextTrackClick(nil)
            }
            else if isRepeatTrack == 2
            {
                playMusic()
            }
        }
    }
    
    func startTrackProgress()
    {
        // start the progress
        //timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
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
//                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc : AddTrackVC = storyboard.instantiateViewControllerWithIdentifier("AddTrackVC") as! AddTrackVC
//        vc.transitioningDelegate = self
//                let navigationController = UINavigationController(rootViewController: vc)
//                navigationController.modalPresentationStyle = .OverCurrentContext
//                self.presentViewController(navigationController, animated: true, completion: nil)
        
        let vc : AddTrackVC = storyboard!.instantiateViewControllerWithIdentifier("AddTrackVC") as! AddTrackVC
        //herbDetails.herb = selectedHerb
        vc.modalPresentationStyle = .CurrentContext
        vc.transitioningDelegate = self
//        vc.view.backgroundColor = .None
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func onShuffleClick(sender: UIButton)
    {
        if isRepeatTrack == 0
        {
            btnRepeat.setImage(UIImage.init(named: "green_repeat.png"), forState: .Normal)
            isRepeatTrack = 1
        }
        else if isRepeatTrack == 1
        {
            btnRepeat.setImage(UIImage.init(named: "green_repeat_one.png"), forState: .Normal)
            isRepeatTrack = 2
        }
        else
        {
            btnRepeat.setImage(UIImage.init(named: "grey_repeat.png"), forState: .Normal)
            isRepeatTrack = 0
        }
    }
    
    @IBAction func onCrossFadeClick(sender: UIButton)
    {
        
    }
    
    @IBAction func onClosePlayerClick(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onPlayClick(sender: UIButton?)
    {
        if !btnPlay.selected
        {
            playMusic()
        }
        else
        {
            appDelegate.audioPlayer!.stop()
            timer!.invalidate()
            pauseTime = audioPlayer.currentTime
            btnPlay.selected = false
        }
    }
    
    @IBAction func onNextTrackClick(sender: AnyObject?)
    {
        if currTrackIndex >= arrTrackList.count-1
        {
            currTrackIndex = 0
        }
        else
        {
            currTrackIndex += 1;
        }
        pauseTime = nil
        playMusic()
    }
    
    @IBAction func onPreviousTrackClick(sender: UIButton)
    {
        if currTrackIndex <= 0
        {
            currTrackIndex = arrTrackList.count-1
        }
        else
        {
            currTrackIndex -= 1;
        }
        
        pauseTime = nil
        playMusic()
    }
    
    func playMusic()
    {
        if timer != nil
        {
            timer!.invalidate()
        }
        btnPlay.selected = true
        
        let dict:NSMutableDictionary = self.arrTrackList[currTrackIndex] as! NSMutableDictionary

        var passMusicFileURL: NSURL?
        let fileManager = NSFileManager.defaultManager()

        //if dict["isLocal"]?.stringValue == "0"
        if dict["isLocal"] as! String == "0"
        {
            let wayToFile = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
            
            if let documentPath: NSURL = wayToFile.first
            {
                var musicFile = documentPath.URLByAppendingPathComponent("SongList")
                
                let nameOfFile = arrTrackList[currTrackIndex]["trackInfo"] as! String;
                musicFile = musicFile.URLByAppendingPathComponent(nameOfFile)
                //            BaseVC.sharedInstance.DLog(musicFile)
                passMusicFileURL = musicFile
            }
        }
        else
        {
            
            let trackDetails : MPMediaItem = dict["trackInfo"] as! MPMediaItem

            passMusicFileURL = trackDetails.valueForProperty( MPMediaItemPropertyAssetURL ) as? NSURL
            if trackDetails.title != nil
            {
                self.lblTrackTitle.text = trackDetails.title!
            }
            
            if trackDetails.artist != nil
            {
                self.lblArtistTitle.text  = trackDetails.artist!
            }
            
            if trackDetails.albumTitle != nil
            {
                //self.albumName = trackDetails.albumTitle!
            }
            //cell.lblTime.text = self.timeString(trackDetails.playbackDuration)
            if trackDetails.artwork != nil
            {
                if let image = trackDetails.artwork?.imageWithSize(CGSizeMake(1024.0, 1024.0))
                {
                    self.imgArtwork.image = image
                }
                else
                {
                    self.imgArtwork.image = UIImage(named: DEFAULT_IMAGE)
                }
            }
            else
            {
                self.imgArtwork.image = UIImage(named: DEFAULT_IMAGE)
            }

            //passMusicFileURL = appDelegate.mediaItem.valueForProperty( MPMediaItemPropertyAssetURL ) as? NSURL
        }
        
        if passMusicFileURL != nil
        {
            let playerItem = AVPlayerItem(URL: passMusicFileURL!)
            
            let duration : CMTime = playerItem.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            BaseVC.sharedInstance.DLog("duration \(seconds)");
            
            trackDurationInSecond = CGFloat(seconds)
            self.lblTrackEndTime.text = timeFormatted(Int(seconds))
            
            do
            {
                appDelegate.audioPlayer = try AVAudioPlayer(contentsOfURL:passMusicFileURL!)
                appDelegate.audioPlayer!.prepareToPlay()
                appDelegate.audioPlayer!.volume = 1.0
                if pauseTime != nil
                {
                    BaseVC.sharedInstance.DLog("audioPlayer.currentTime \(audioPlayer.currentTime)")
                    appDelegate.audioPlayer!.currentTime = pauseTime
                }
                
                //appDelegate.audioPlayer!.play()
                self.startTrackProgress()
            }
            catch
            {
                BaseVC.sharedInstance.DLog("Error getting the audio file")
            }
        }
        else
        {
             self.lblTrackEndTime.text = "0:00"
        }
       
        /*
        let metadataList = playerItem.asset.commonMetadata
        for item in metadataList
        {
            if item.commonKey == "title"
            {
                self.lblTrackTitle.text = item.stringValue
            }
            if item.commonKey == "artist"
            {
                self.lblArtistTitle.text = item.stringValue
            }
            if item.commonKey == "artwork"
            {
                if let image = UIImage(data: item.value as! NSData)
                {
                    imgArtwork.image = image
                }
            }
        }
        */
        
    }
    func getItem( songId: NSNumber ) -> MPMediaItem {
        
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        var items: [MPMediaItem] = query.items! as [MPMediaItem]
        
        return items[items.count - 1]
        
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
    
        /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

// MARK: - UIViewControllerTransitioningDelegate -
extension ExpandedPlayerVC: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            
            if (addSongClick.superview != nil)
            {
                transition.originFrame = addSongClick.superview!.convertRect(addSongClick!.frame, toView: nil)
            }
            transition.presenting = true
            
            return transition
            
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
}
