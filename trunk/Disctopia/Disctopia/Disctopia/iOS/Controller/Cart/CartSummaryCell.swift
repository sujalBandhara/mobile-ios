//
//  CartSummaryCell.swift
//  Disctopia
//
//  Created by Mitesh on 09/09/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class CartSummaryCell: UITableViewCell
{
    @IBOutlet var lblTrackTitle: UILabel!
    @IBOutlet var btnRemove: UIButton!
    //@IBOutlet var lblDescriptionAmount: UILabel!
    @IBOutlet var imgTrack: UIImageView!
    
    @IBOutlet var btnBuyTrack: UIButton!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    
    @IBOutlet var btnPurchase: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnRemove.exclusiveTouch = true
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
