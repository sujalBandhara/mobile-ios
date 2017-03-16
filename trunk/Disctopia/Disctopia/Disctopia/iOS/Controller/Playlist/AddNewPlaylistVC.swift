//
//  AddNewPlaylistVC.swift
//  Disctopia
//
//  Created by Damini on 19/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddNewPlaylistVC: BaseVC ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    var playlistDictionary : NSMutableDictionary = NSMutableDictionary()
    var trackArr : NSMutableArray = NSMutableArray()
    var trackDictionary : NSMutableDictionary = NSMutableDictionary()
    
    var trackListArray : [JSON] = []
    //var trackListArray : NSMutableArray = NSMutableArray()

    @IBOutlet var footerView: UIView!
    @IBOutlet var lblNewPlaylistTitle: UILabel!
    @IBOutlet var lblNumberOfTrack: UILabel!
    @IBOutlet var btnPlaylistDelete: UIButton!
    
    @IBOutlet weak var txtPlaylistName: UITextField!
    
    @IBOutlet weak var txtWidthOfName: NSLayoutConstraint!
    var aSelectedTrackArray : [JSON] = []
    var newPlayListId:String = ""
    var newPlayListName:String = ""
    var playlistname = ""
    
    var cellNumber = 10
    
    
    @IBOutlet var playlisTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlisTableView.editing = true
       txtPlaylistName.delegate = self
      
        // self.playlisTableView.editing = true
       // let longpress = UILongPressGestureRecognizer(target: self, action: #selector(AddNewPlaylistVC.longPressGestureRecognized(_:)))
       // playlisTableView.addGestureRecognizer(longpress)
        
        // Do any additional setup after loading the view.
        
    }
    func getWidth(text: String) -> CGFloat
    {
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let width = getWidth(textField.text!)
        if UIScreen.mainScreen().bounds.width - 55 > width
        {
            txtWidthOfName.constant = 0.0
            if width > txtWidthOfName.constant
            {
                txtWidthOfName.constant = width
            }
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear AddNewPlaylistVC")
        
        if appDelegate.isFromNewPlaylist == false
        {
            self.getAllTrackByPlaylistIdAPI()
            //   lblNewPlaylistTitle.attributedText = "\(appDelegate.selectedPlaylistId["playlistname"]!.stringValue)   X"
            //  lblNewPlaylistTitle.sizeToFit()
            
            self.newPlayListId = appDelegate.selectedPlaylistId["playlistId"]!.stringValue
            
            let string = "\(appDelegate.selectedPlaylistId["playlistname"]!.stringValue)  X" as NSString
            playlistname = "\(appDelegate.selectedPlaylistId["playlistname"]!.stringValue)"
            
            txtPlaylistName.text = playlistname
//            let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(19.0)])
//            
//            let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(19.0)]
//            
//            // Part of string to be bold
//            
//            attributedString.addAttributes(boldFontAttribute, range: string.rangeOfString("  X"))
//            lblNewPlaylistTitle.attributedText = attributedString
            
        }
        else
        {
            self.getAllTrackByPlaylistIdAPIForNewPlayList()
            let string = "\(self.newPlayListName)  X" as NSString
            playlistname = "\(self.newPlayListName)"
            txtPlaylistName.text = playlistname

//            let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(19.0)])
//            let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(19.0)]
//            // Part of string to be bold
//            attributedString.addAttributes(boldFontAttribute, range: string.rangeOfString("  X"))
//            lblNewPlaylistTitle.attributedText = attributedString
            
          
            appDelegate.isFromNewPlaylist = false
        }
        
        if txtPlaylistName.text == "Disctopia Favs"
        {
            txtPlaylistName.enabled = false
            btnPlaylistDelete.hidden = true
        }
        else
        {
            txtPlaylistName.enabled = true
            btnPlaylistDelete.hidden = false
        }
        
        if let playlistname = txtPlaylistName.text
        {
            txtWidthOfName.constant = 0.0
            let width = getWidth(playlistname)
            if width > txtWidthOfName.constant
            {
                txtWidthOfName.constant = width
            }
            self.view.layoutIfNeeded()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddNewPlaylistVC.deleteTrack(_:)), name: "deleteTrack", object: nil)//to delete single track while editind a playlist from AddNewPlaylistTableViewCell button click
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear AddNewPlaylistVC")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear AddNewPlaylistVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear AddNewPlaylistVC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func UpdatePlaylist()
    {
        if self.txtPlaylistName.text != ""
        {
        
        var param = Dictionary<String, String>()
        param["PlayListId"] = self.newPlayListId
        param["PlayListName"] = self.txtPlaylistName.text
        DLog("param = \(param)")
        API.UpdatePlaylist(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                self.DLog("Response for UpdatePlaylist = \(result)")
            }
        }
        }
    }
    func setTrackIndexForPlayList(PlayListTrackId:String,DisplayOrder:String)
    {
            var param = Dictionary<String, String>()
            param["PlayListTrackId"] = PlayListTrackId
            param["DisplayOrder"] = DisplayOrder
            API.setTrackIndexForPlayList(param, aViewController: self)
            { (result: JSON) in
                if ( result != nil )
                {
                    self.DLog("Response for setTrackIndexForPlayList = \(result)")
                }
            }
        
    }
    
    //MARK: - getAllTrackByPlaylistIdAPI For Explore
    func getAllTrackByPlaylistIdAPI()
    {
        
        var param = Dictionary<String, String>()
    
       
        param["playlistId"] = appDelegate.selectedPlaylistId["playlistId"]!.stringValue

        DLog("param = \(param)")
        API.GetAllTrackByPlayListId(param, aViewController: self) { (result: JSON) in
            
            if ( result != nil )
            {
                self.trackListArray.removeAll()
                
                self.DLog("Response for getAllTrackByPlaylistIdAPI = \(result)")
                self.trackListArray = result.arrayValue
                
                /*var tempArray : [JSON] = []
                
                tempArray = result.arrayValue
                
                self.trackListArray.removeAllObjects()
                
                for i in 0..<tempArray.count
                {
                    let json : JSON = tempArray[i]
                    
                    let dict : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                    
                    dict.setObject(json["code"].stringValue, forKey: "code")
                    dict.setObject(json["id"].stringValue, forKey: "id")
                    dict.setObject(json["currency"].stringValue, forKey: "currency")
                    dict.setObject(json["name"].stringValue, forKey: "name")
                    
                    self.trackListArray.addObject(dict)
                }*/
                
                self.DLog("trackListArray  count = \(self.trackListArray.count)")
                self.playlisTableView.reloadData()
//                self.lblNumberOfTrack.text = "\(self.trackListArray.count) Tracks"
//                self.lblNumberOfTrack.sizeToFit()
                //self.fillTrackDic()

            
//            
//                    {
//                        "album_url" : "https:\/\/s3-us-west-2.amazonaws.com\/disctopia-audio\/OG Ron C & The Chopstars\/Twenty88(ChoppedNotSlopped)\/twenty88 PurpCover.jpg",
//                        "purchasedTrackURL" : "http:\/\/disctopia-audio.s3-us-west-2.amazonaws.com\/OG%20Ron%20C%20%26%20The%20Chopstars\/Twenty88(ChoppedNotSlopped)\/3._ON_THE_WAY_CHOPPED_NOT_SLOPPED.mp3?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1477392928&Signature=sOv3A6g0LJKsPqlNHxGJZgSnG4c%3D",
//                        "album_image" : "OG Ron C & The Chopstars\/Twenty88(ChoppedNotSlopped)\/twenty88 PurpCover.jpg",
//                        "tags" : null,
//                        "smapleTrackURL" : "http:\/\/disctopia-audio.s3-us-west-2.amazonaws.com\/OG%20Ron%20C%20%26%20The%20Chopstars\/Twenty88(ChoppedNotSlopped)\/sample\/3._ON_THE_WAY_CHOPPED_NOT_SLOPPED.mp3?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1477392928&Signature=F%2Bw8WVTwwY811iOdBMf68MMLaz4%3D",
//                        "duration" : "00:05:05.2410000",
//                        "coverName" : "Twenty88 (Chopped Not Slopped)",
//                        "playlistId" : 89,
//                        "isMp3Converted" : true,
//                        "albumId1" : 52,
//                        "user_image" : "OG Ron C & The Chopstars\/14601.jpg",
//                        "isFreeTrack" : true,
//                        "track_url" : "http:\/\/disctopia-audio.s3-us-west-2.amazonaws.com\/OG%20Ron%20C%20%26%20The%20Chopstars\/Twenty88(ChoppedNotSlopped)\/3._ON_THE_WAY_CHOPPED_NOT_SLOPPED.wav?AWSAccessKeyId=AKIAI2NPBJZYSPWZB3NA&Expires=1477392928&Signature=KbXXGncEj4qCO0RUUbwKOvH2eog%3D",
//                        "playlisttrackid" : 856,
//                        "artistName" : "OG Ron C & The Chopstars",
//                        "albumId" : 52,
//                        "user_url" : "https:\/\/s3-us-west-2.amazonaws.com\/disctopia-audio\/OG Ron C & The Chopstars\/14601.jpg",
//                        "year" : "2016-06-05T00:00:00",
//                        "number" : 3,
//                        "isPurchased" : 0,
//                        "album_price" : 0,
//                        "modifiedDate" : "2016-06-05T00:28:08.983",
//                        "profileUrl" : "OG Ron C & The Chopstars\/14601.jpg",
//                        "trackName" : "On The Way (Chopped Not Slopped)",
//                        "trackFileName" : "3._ON_THE_WAY_CHOPPED_NOT_SLOPPED.wav",
//                        "isFavorite" : 0,
//                        "trackId" : 387,
//                        "mp3ConvertedDate" : "2016-06-05T00:30:24.287",
//                        "track_price" : 0,
//                        "userId" : "917947e8-62dd-4b54-b067-f1dfcd3ff8b7"
//                }

            
            }
        }
    }

    func getAllTrackByPlaylistIdAPIForNewPlayList()
    {
        var param = Dictionary<String, String>()
        param["playlistId"] = self.newPlayListId
        DLog("param = \(param)")
        API.GetAllTrackByPlayListId(param, aViewController: self) { (result: JSON) in
            
            if ( result != nil )
            {
                self.trackListArray.removeAll()
                
                self.DLog("Response for getAllTrackByPlaylistIdAPI = \(result)")
                
                self.trackListArray = result.arrayValue
                
                self.DLog("trackListArray  count = \(self.trackListArray.count)")
                self.playlisTableView.reloadData()
                
            }
        }
    }
 
   
    //getPlayList API For Playlist
    func getPlayListAPI()
    {
        API.getPlaylist(nil , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### getPlayList API Response: \(result)")
                self.playlistDictionary = NSMutableDictionary(dictionary: result["playlistDict"].dictionaryObject!)
                self.playlisTableView.reloadData()
            }
        }
    }
    //MARK: - DeletePlayListAPI -
    func DeletePlayListAPI()
    {
        var param = Dictionary<String, String>()
        param["PlayListId"] =  appDelegate.selectedPlaylistId["playlistId"]!.stringValue
        
        API.DeletePlayList(param , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### DeletePlayList API Response: \(result)")
                
                //BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("PlaylistDeletedVC", animated: true)
                
               //  NSNotificationCenter.defaultCenter().postNotificationName("deletePlaylistClicked\(appDelegate.selectedPlaylistId["playlistId"]!.stringValue)", object: self.btnPlaylistDelete)
                //self.pushToViewControllerIfNotExistWithClassName("PlaylistVC", animated: true)
                appDelegate.newPlaylistId = "0"
                self.popToSelf(self)
                appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
                
                //                self.presenting = false
                //                self.cycleFromViewController(self, toViewController: self.parentViewController!)
            }
        }
    }

    //MARK: - Action -
    
    @IBAction func btnDeletePlaylist(sender: AnyObject)
    {
        let optionVC = storyboard!.instantiateViewControllerWithIdentifier("deleteYesNoViewController") as! deleteYesNoViewController
        optionVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(optionVC)
        self.addSubview(optionVC.view, toView: self.view)
        
        //   self.deletePlaylistFrame = (notification.object?.frame)!
        
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
    
    @IBAction func btnAddNewTrack(sender: AnyObject)
    {
        //appDelegate.pagingMenuController.moveToMenuPage(0, animated: true)
        //self.popToRootViewControllerAnimated(true)
       // self.pushToViewControllerIfNotExistWithClassName("MenuVC", animated: true)
        //appDelegate.loadFirstViewController("MenuVC")
        let vc = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("AllTrackVC") as! AllTrackVC
        vc.newPlayListId = self.newPlayListId
         appDelegate.isFromNewPlaylist = true
        self.pushToViewControllerIfNotExistWithClassObj(vc, animated: true)
        
        //self.popToSelf(sender)
       // appDelegate.pagingMenuController.moveToMenuPage(0, animated: true)
        
    }
    
    @IBAction func btnDone(sender: AnyObject)
    {
        self.UpdatePlaylist()
        
        NSNotificationCenter.defaultCenter().postNotificationName("removePlaylistSettingMenu", object: nil)

        
        
        //self.pushToViewControllerIfNotExistWithClassName("MenuVC", animated: true)
        appDelegate.newPlaylistId =  self.newPlayListId
        self.popToSelf(sender)
        self.popToSelf(sender)
        appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
      
        // self.popToRootViewController()
       //appDelegate.loadViewController()
       // self.popToViewControllerWithClass("PlaylistVC", animated: true)
     //   self.pushToViewControllerIfNotExistWithClassName("PlaylistVC", animated: true)
     //   appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
        dispatch_async(dispatch_get_main_queue())
        {
            self.DLog("Playlist added .....")
            /*
            * Created Date:  19 Jan 2017 s
            * Updated Date:
            * Ticket No: Playlist name should be edit
            * Description :
            * Logic:
             reloadPlaylist method called start the edit playlist file
            */
           appDelegate.playlistVC.reloadPlaylist()
          // NSNotificationCenter.defaultCenter().postNotificationName("reloadPlaylist", object: nil)
        }
    }
    
    @IBAction func closeClicked (sender : AnyObject)
    {
        let indexToDelete : NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let trackListDict = self.trackListArray[indexToDelete.row].dictionaryValue
        
        var param = Dictionary<String, String>()
        param["PlayListTrackId"] =  trackListDict["playlisttrackid"]!.stringValue//appDelegate.selectedTrackDict["playlisttrackid"]!.stringValue
        
        
        API.DeleteSongInPlayList(param) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### DeleteSongInPlayList API Response: \(result)")
                //BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("PlaylistTrackDeletedViewController", animated: true)
                
                BaseVC.sharedInstance.DLog("DeleteSongInPlayList called")
                NSNotificationCenter.defaultCenter().postNotificationName("deleteTrack", object: nil)
                
                self.trackListArray.removeAtIndex(sender.tag)
                //self.trackListArray.removeObjectAtIndex(sender.tag)
                //self.playlisTableView.deleteRowsAtIndexPaths([indexToDelete], withRowAnimation: .None)
                self.playlisTableView.reloadData()
                
               // self.lblNumberOfTrack.text = "\(self.trackListArray.count) Tracks"
            }
        }
    }
    
    //MARK: - Animation -
    
    func deleteTrack (notification:NSNotification)
    {
        let deleteTrackVC = storyboard!.instantiateViewControllerWithIdentifier("PlaylistTrackDeletedViewController") as! PlaylistTrackDeletedViewController
        deleteTrackVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(deleteTrackVC)
        self.addSubview(deleteTrackVC.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionNone, animations: { _ in
            
            deleteTrackVC.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
        })
    }
    
    // MARK: - TableView Methods -
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackListArray.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if trackListArray.count > 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewPlaylistCell", forIndexPath: indexPath) as! AddNewPlaylistTableViewCell
            let trackListDict = self.trackListArray[indexPath.row].dictionaryValue
            DLog(" trackListDict =\(trackListDict)")
            
            cell.lblArtistName.text = trackListDict["artistName"]!.stringValue//as? String//data[indexPath.row]
            cell.lblTrackTitle.text = trackListDict["trackName"]!.stringValue//as? String//type[indexPath.row]
            let imageUrl = trackListDict["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: cell.trackImage)
            }
            else
            {
                cell.trackImage.image = UIImage(named: DEFAULT_IMAGE)
            }

            cell.btnClose.addTarget(self, action: #selector(AddNewPlaylistVC.closeClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.btnClose.tag = indexPath.row
            cell.lblTrackTitle.sizeToFit()
            cell.lblArtistName.sizeToFit()
            cell.trackListDict = trackListDict
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewPlaylistCell", forIndexPath: indexPath) as! AddNewPlaylistTableViewCell
            cell.lblArtistName.text = "Artist"
            cell.lblTrackTitle.text = "Track"
            return cell
        }
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
    {
        let itemToMove = trackListArray[fromIndexPath.row]
        
        let playlistTrackIdStr = itemToMove["playlisttrackid"].stringValue
        
            let displayOrder = String( toIndexPath.row + 1)
            self.setTrackIndexForPlayList(playlistTrackIdStr, DisplayOrder:displayOrder)
        
        
//        trackListArray.removeAtIndex(fromIndexPath.row)
//        trackListArray.insert(itemToMove, atIndex: toIndexPath.row)
       
//        let itemToMove2 = trackArr[fromIndexPath.row]
//        trackArr.removeObjectAtIndex(fromIndexPath.row)
//        trackArr.insertObject(itemToMove2, atIndex: toIndexPath.row)
//        self.updateTrack()


    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.None
    }
     func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
//    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//        return .None
//    }
//    
//    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
    

//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        return self.footerView
//    }
    
//    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
//    {
//        let movedObject = self.trackListArray[sourceIndexPath.row]
//        trackListArray.removeAtIndex(sourceIndexPath.row)
//        trackListArray.insert(movedObject, atIndex: destinationIndexPath.row)
//        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(data)")
//        self.playlisTableView.reloadData()
//    }
    
//    func updateTrack()
//    {
//        for (index, element) in trackArr.enumerate()
//        {
//            let aDict =  NSMutableDictionary(dictionary: element as! [NSObject : AnyObject])
//            aDict["indexNo"] = String(index)
//            trackArr[index] = aDict
//        }
//        print("after sorting trackArr : \(trackArr)")
//    }

//    func fillTrackDic()
//    {
//        for  i in 0 ..< self.trackListArray.count
//        {
//            let trackListDict = self.trackListArray[i].dictionaryValue
//            let trackId =  trackListDict["playlisttrackid"]!.stringValue
//            let dic:NSMutableDictionary = NSMutableDictionary()
//            dic.setValue(trackId, forKey: "trackId")
//            dic.setValue("\(i)", forKey: "indexNo")
//            dic.setValue(self.newPlayListId, forKey: "playlistId")
//            trackArr.addObject(dic.mutableCopy())
//        }
//        print("trackArr :\(trackArr)")
//    }
    
    
    

    
    //MARK: - Long Press Gesture
    
    var fromIndex = ""
    var toIndex = ""
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer)
    {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(playlisTableView)
        let indexPath = playlisTableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            
            if indexPath != nil
            {
                
                Path.initialIndexPath = indexPath
                let cell = playlisTableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshotOfCell(cell)
                
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                playlisTableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            My.cellIsAnimating = false
                            if My.cellNeedToShow {
                                My.cellNeedToShow = false
                                UIView.animateWithDuration(0.25, animations: { () -> Void in
                                    cell.alpha = 1
                                })
                            } else {
                                cell.hidden = true
                            }
                        }
                })
            }
        case UIGestureRecognizerState.Changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
           
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    //trackListArray.insertObject(trackListArray.removeObjectAtIndex(Path.initialIndexPath!.row), atIndex: indexPath!.row)
                    trackListArray.insert(trackListArray.removeAtIndex(Path.initialIndexPath!.row), atIndex: indexPath!.row)
                    
                    print(" fromIndex  :\(fromIndex)")
                    print(" toIndex:\(toIndex)")
                    
                    
                   
                    playlisTableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                    Path.initialIndexPath = indexPath
                    //playlisTableView.scrollRectToVisible(CGRectMake(0, 0, 320.0, 50), animated: true)
                    
                }
            }
            
        case UIGestureRecognizerState.Ended:
            
            
            //print(" fromIndex  :\(fromIndex)")
            //print(" toIndex:\(toIndex)")

            //updateTrackOrder(fromIndex, toIndex: toIndex)
           
            if Path.initialIndexPath != nil {
                let cell = playlisTableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell.hidden = false
                    cell.alpha = 0.0
                }
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = cell.center
                    My.cellSnapshot!.transform = CGAffineTransformIdentity
                    My.cellSnapshot!.alpha = 0.0
                    cell.alpha = 1.0
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            Path.initialIndexPath = nil
                            My.cellSnapshot!.removeFromSuperview()
                            My.cellSnapshot = nil
                        }
                })
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = playlisTableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell.hidden = false
                    cell.alpha = 0.0
                }
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = cell.center
                    My.cellSnapshot!.transform = CGAffineTransformIdentity
                    My.cellSnapshot!.alpha = 0.0
                    cell.alpha = 1.0
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            Path.initialIndexPath = nil
                            My.cellSnapshot!.removeFromSuperview()
                            My.cellSnapshot = nil
                        }
                })
            }
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
  }
//override func setEditing(editing: Bool, animated: Bool) {
//    super.setEditing(editing, animated: animated)
//    
//    if (editing) {
//        
//        for view in subviews as [UIView] {
//            if view.dynamicType.description().rangeOfString("Reorder") != nil {
//                for subview in view.subviews as [UIImageView] {
//                    if subview.isKindOfClass(UIImageView) {
//                        subview.image = UIImage(named: "yourimage.png")
//                    }
//                }
//            }
//        }
//    }
//}
