//
//  NewPlaylistVC.swift
//  Disctopia
//
//  Created by Damini on 01/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewPlaylistVC: BaseVC
{

    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var txtPlaylistName: UITextField!
    var newPlayListId:String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        btnCancel.layer.borderWidth = 1
        
        btnCreate.layer.borderColor = UIColor.whiteColor().CGColor
        btnCreate.layer.borderWidth = 1
        
        btnCreate.exclusiveTouch = true
        btnCancel.exclusiveTouch = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnCancelTapped(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
        //self.pushToViewControllerIfNotExistWithClassName("PlaylistVC", animated: false)
    }
    
    @IBAction func btnCreateTapped(sender: AnyObject)
    {
//        dispatch_async(dispatch_get_main_queue())
//        {
//            self.showLoader()
//        }
        if txtPlaylistName.text! != ""
        {
            appDelegate.newPlaylist = txtPlaylistName.text!
            self.CreatePlayListAPI(txtPlaylistName.text!)
        }
        else
        {
            self.DAlert(ALERT_TITLE, message: "Please enter playlist name", action: ALERT_OK, sender: self)
        }
    }

    // MARK: - create Playlist API
    func CreatePlayListAPI(playListName : String)
    {
        var param = Dictionary<String, String>()
        
        param["PlayListName"] = playListName
        
        API.CreatePlayList(param , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                dispatch_async(dispatch_get_main_queue())
                {
                    self.showLoader()
                    self.getAllPlayList(playListName)
                }
            }
        }
    }
    
    
    func getAllPlayList(playListName : String)
    {
        let param = Dictionary<String, String>()
        
       // param["PlayListName"] = playListName
        
        API.getPlaylistDetails(param , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### getPlayList API Response: \(result)")
                let aTempArray = result.arrayValue
                for aDict in aTempArray
                {
                   if aDict["playlistname"].stringValue == playListName
                   {
                    self.newPlayListId =  aDict["playlistId"].stringValue
                    //print("\(self.newPlayListId)")
                    BaseVC.sharedInstance.DLog("#### getPlayList API Response: \(result)")
                    
                    self.dismissViewControllerAnimated(true, completion: {
                        let vc = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("AddNewPlaylistVC") as! AddNewPlaylistVC
                        if(self.newPlayListId != "")
                        {
                            vc.newPlayListId = self.newPlayListId
                            vc.newPlayListName = aDict["playlistname"].stringValue
                            //self.pushToViewControllerIfNotExistWithClassName("AddNewPlaylistVC", animated: false)
                            self.pushToViewControllerIfNotExistWithClassObj(vc, animated: true)
                        }
                        // self.pushToViewControllerIfNotExistWithClassName("AllTrackVC", animated: false)
                        
                    })
                    
                    appDelegate.isFromNewPlaylist = true
                    
                    
                    }
                }
                
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
