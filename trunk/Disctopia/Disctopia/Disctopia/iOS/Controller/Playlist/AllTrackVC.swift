//
//  AllTrackVC.swift
//  Disctopia
//
//  Created by Brijesh shiroya on 10/7/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import MediaPlayer

class AllTrackVC: BaseVC,UITextFieldDelegate {

    var aTracksVC: LibraryTracksViewController? = nil
    var albumId:String = "23"
    var isLocal :  String = "0"
    var selectedTrackArray:NSMutableArray = NSMutableArray()
    var selectedArrayString:String = ""
    var trackDictArray : [JSON] = []
     var aTrack : Track?
    
    @IBOutlet var btnDone: UIButton!

    @IBOutlet var containerBottomLayout: NSLayoutConstraint!
    
    var newPlayListId:String = ""
    var trackArray:[JSON] = []
   
    //MARK: - View LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.albumId = appDelegate.selectedAlbumId
            self.btnDone.hidden = true
            if self.aTracksVC != nil
            {
                self.aTracksVC?.trackBy = TrackBy.AllTrack
                self.aTracksVC!.setTrackData(self.albumId, isLocal: self.isLocal,isFromEditPlaylist: true)
            }
   //     })
                    // Any Large Task
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setArrayData), name: "selectedTrackData", object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.selectedTrackArray.removeAllObjects()
        self.selectedArrayString.removeAll()
        trackDictArray.removeAll()
        
        if (appDelegate.playerView != nil)
        {
            if appDelegate.playerView.hidden == true
            {
                self.containerBottomLayout.constant = 0
            }
            else
            {
                self.containerBottomLayout.constant = 50
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions -

    func setArrayData(notification:NSNotification)
    {
        self.selectedTrackArray = notification.userInfo!["array"] as! NSMutableArray
        if(selectedTrackArray.count > 0)
        {
            self.btnDone.hidden = false
         //   print(self.selectedTrackArray)
            
            let trackIdArray:NSMutableArray = NSMutableArray()
            if(selectedTrackArray.count > 0)
            {
                for dic in selectedTrackArray
                {
                    trackIdArray.addObject(dic["trackId"]!!.stringValue)
                }
            }
            selectedArrayString = trackIdArray.componentsJoinedByString(",")
        }
        else
        {
            self.btnDone.hidden = true

        }
    }
    
    @IBAction func OnCrossClick(sender: AnyObject)
    {
        self.popViewController(2)
    }
    
    @IBAction func OnDoneClick(sender: AnyObject)
    {
        AddMutipleSongInPlayListAPI()
        
       // print("----- Done Tapped -----")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "AllTrack")
        {
            if let tracksVC = segue.destinationViewController as? LibraryTracksViewController
            {
                self.aTracksVC = tracksVC
                self.aTracksVC!.trackBy = TrackBy.Album
            }
        }
    }
    
    func AddMutipleSongInPlayListAPI()
    {
        var param = Dictionary<String, String>()
        let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
        if saveResult != nil
        {
            param["sessiontoken"] = appDelegate.appToken
            param["PlayListId"] =  self.newPlayListId
            param["Tracks"] = selectedArrayString
            
            //print("selected Track = \(selectedArrayString)")
        }
        
        DLog("param = \(param)")
        API.AddMutipleSongInPlayList(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                
                self.trackArray = result.arrayValue
                appDelegate.isFromNewPlaylist = true
                self.addSongInDownload()
                // let vc = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("AddNewPlaylistVC") as!AddNewPlaylistVC
                //vc.aSelectedTrackArray = self.trackDictArray
                self.popToRootViewController()
                // self.pushToViewControllerIfNotExistWithClassName("AddNewPlaylistVC", animated: true)
                if(result["message"].stringValue == "Songs added into playList successfully.")
                {
               
                }
               // self.trackDictArray = result.arrayValue
            }
        }
    }
    func addSongInDownload()
    {
        for i in 0 ..< trackArray.count
        {
            let tempdic = self.trackArray[i].dictionaryObject
            let trackObj = Track(trackJSON: JSON(tempdic!))
            trackObj.updateTrackURLWithDownload(true)
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
