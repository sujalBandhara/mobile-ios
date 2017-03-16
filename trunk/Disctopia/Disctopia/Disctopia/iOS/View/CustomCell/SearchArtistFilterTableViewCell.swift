//
//  SearchArtistFilterTableViewCell.swift
//  Disctopia
//
//  Created by Damini on 05/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class SearchArtistFilterTableViewCell: UITableViewCell
{
    @IBOutlet var artistImage: UIImageView!

    @IBOutlet var lblAlbums: UILabel!
    @IBOutlet var lblArtistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.artistImage.layer.cornerRadius = 5.0
        self.artistImage.layer.masksToBounds = true
        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
