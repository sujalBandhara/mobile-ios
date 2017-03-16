//
//  SearchAlbumsFilterTableViewCell.swift
//  Disctopia
//
//  Created by Damini on 05/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class SearchAlbumsFilterTableViewCell: UITableViewCell {

    @IBOutlet var albumImage: UIImageView!
    @IBOutlet var lblTags: UILabel!
    @IBOutlet var lblAlbumTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.albumImage.layer.cornerRadius = 5.0
        self.albumImage.layer.masksToBounds = true
        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
