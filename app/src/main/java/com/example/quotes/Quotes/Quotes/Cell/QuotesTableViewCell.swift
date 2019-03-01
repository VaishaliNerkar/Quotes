//
//  QuotesTableViewCell.swift
//  CustomerApp
//
//  Created by Prassana  on 27/12/17.
//  Copyright © 2017 Essensys-09. All rights reserved.
//

import UIKit

class QuotesTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lblReceivedData: UILabel!
    
    @IBOutlet weak var btnDownload: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
