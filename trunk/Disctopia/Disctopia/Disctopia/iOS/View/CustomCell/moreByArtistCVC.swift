//
//  moreByArtistCVC.swift
//  Disctopia
//
//  Created by Mitesh on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class moreByArtistCVC: UICollectionViewCell
{

    @IBOutlet weak var imgMoreArtist: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgMoreArtist.layer.cornerRadius = 5.0
        self.imgMoreArtist.layer.masksToBounds = true

        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }
}
