//
//  SearchTrackFilterTableViewCell.swift
//  Disctopia
//
//  Created by Damini on 05/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class SearchTrackFilterTableViewCell: UITableViewCell {

    
    @IBOutlet var lblTrackTitle: UILabel!
    @IBOutlet var lblArtistName: UILabel!
    @IBOutlet var lblTags: UILabel!
    @IBOutlet var trackImage: UIImageView!
    @IBOutlet var btnAdd: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.trackImage.layer.cornerRadius = 5.0
        self.trackImage.layer.masksToBounds = true
        
        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
