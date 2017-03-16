//
//  ExploreCategoryCollectionViewCell.swift
//  Disctopia
//
//  Created by Damini on 14/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class ExploreCategoryCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var lblCoverName: UILabel!
    @IBOutlet var lblArtistName: UILabel!
    @IBOutlet var lblTags: UILabel!
    @IBOutlet var lblE: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.coverImage.layer.cornerRadius = 5.0
        self.coverImage.layer.masksToBounds = true
        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }
}
