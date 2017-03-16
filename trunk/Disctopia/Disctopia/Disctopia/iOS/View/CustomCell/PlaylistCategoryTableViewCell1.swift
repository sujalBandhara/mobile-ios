//
//  PlaylistCategoryTableViewCell1.swift
//  Disctopia
//
//  Created by Damini on 12/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class PlaylistCategoryTableViewCell1: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }

    @IBAction func btnPlaylistOptionTapped(sender: AnyObject)
    {
        BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("PlaylistOptionListVC", animated: true)
    }
    
    @IBAction func btnPlaylistView(sender: AnyObject)
    {
        BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("Playlist1VC", animated: true)  
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
