//
//  AddNewPlaylistTableViewCell.swift
//  Disctopia
//
//  Created by Damini on 19/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddNewPlaylistTableViewCell: UITableViewCell {

    
    @IBOutlet var lblTrackTitle: UILabel!
    @IBOutlet var lblArtistName: UILabel!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var trackImage: UIImageView!
    
    var trackListDict : [String : JSON]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnClose.exclusiveTouch = true
        showsReorderControl = false

        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }

    @IBAction func btnClose(sender: AnyObject)
    {

        appDelegate.selectedTrackDict = self.trackListDict
        //self.DeleteSongInPlayListAPI()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // API : DeleteSongInPlayList API
    func DeleteSongInPlayListAPI()
    {
        var param = Dictionary<String, String>()
        param["PlayListTrackId"] =  appDelegate.selectedTrackDict["playlisttrackid"]!.stringValue
    
        
        API.DeleteSongInPlayList(param) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### DeleteSongInPlayList API Response: \(result)")
                
                //BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("PlaylistTrackDeletedViewController", animated: true)
                
                BaseVC.sharedInstance.DLog("DeleteSongInPlayList called")
                
                NSNotificationCenter.defaultCenter().postNotificationName("deleteTrack", object: nil)
            }
        }
    }
}
