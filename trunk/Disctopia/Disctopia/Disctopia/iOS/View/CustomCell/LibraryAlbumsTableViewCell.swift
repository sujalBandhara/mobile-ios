//
//  LibraryAlbumsTableViewCell.swift
//  Disctopia
//
//  Created by Damini on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class LibraryAlbumsTableViewCell: UITableViewCell {

    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var lblCoverName: UILabel!
    @IBOutlet var lblArtistName: UILabel!
    @IBOutlet var lblTags: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.coverImage.layer.cornerRadius = 5.0
        self.coverImage.layer.masksToBounds = true
        
        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
