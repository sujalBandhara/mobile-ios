//
//  HelpTableViewCell.swift
//  Disctopia
//
//  Created by Trainee02 on 26/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class HelpTableViewCell: UITableViewCell {

    
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var lblQuestion: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
