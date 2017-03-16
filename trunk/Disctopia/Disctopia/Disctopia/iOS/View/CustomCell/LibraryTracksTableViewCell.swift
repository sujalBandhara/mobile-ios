//
//  LibraryTracksTableViewCell.swift
//  Disctopia
//
//  Created by Damini on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import AlamofireImage

class LibraryTracksTableViewCell: UITableViewCell
{
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var lblTrackTitle: UILabel!
    @IBOutlet var lblArtist: UILabel!
    @IBOutlet var lblTrackId: UILabel!
    
    //@IBOutlet var lblTrackPrice: UILabel!
    @IBOutlet var btnFavourite: UIButton!
    
    //@IBOutlet var btnTrackPrice: UIButton!
    @IBOutlet var lblTime: UILabel!
    
    @IBOutlet var btnPlus: UIButton!
    
    @IBOutlet weak var trackLeading: NSLayoutConstraint!
    @IBOutlet weak var trackViewWidth: NSLayoutConstraint!

    @IBOutlet weak var trackTitleView: UIView!
    @IBOutlet weak var PlayButtonView: UIView!
    
    
    @IBOutlet var btnDownload: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        //btnTrackPrice.exclusiveTouch = true
        btnPlus.exclusiveTouch = true

        self.btnPlay.layer.cornerRadius = 5.0
        self.btnPlay.layer.masksToBounds = true
        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
        
//        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
//        dispatch_after(dispatchTime, dispatch_get_main_queue(),
//        {
//            self.contentView.setNeedsUpdateConstraints()
//            self.contentView.updateConstraintsIfNeeded()
//            self.contentView.setNeedsLayout()
//            self.contentView.layoutIfNeeded()
//            
//            self.setNeedsUpdateConstraints()
//            self.updateConstraintsIfNeeded()
//            self.setNeedsLayout()
//            self.layoutIfNeeded()
//
//        });
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
