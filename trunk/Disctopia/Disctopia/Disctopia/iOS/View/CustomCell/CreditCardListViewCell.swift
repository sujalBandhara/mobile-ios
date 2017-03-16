//
//  CreditCardListViewCell.swift
//  Disctopia
//
//  Created by Brijesh shiroya on 8/2/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class CreditCardListViewCell: UITableViewCell {

    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblCreditCardName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
