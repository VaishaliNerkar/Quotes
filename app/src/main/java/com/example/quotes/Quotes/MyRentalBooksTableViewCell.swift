//
//  MyRentalBooksTableViewCell.swift
//  BookMyBook
//
//  Created by Mac on 21/09/18.
//  Copyright © 2018 Mansionly Macbook 1. All rights reserved.
//

import UIKit

class MyRentalBooksTableViewCell: UITableViewCell {
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imgBook: UIImageView!
    @IBOutlet var lblBookName: UILabel!
    @IBOutlet var lblAuthorName: UILabel!
    
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblIssueOn: UILabel!
    @IBOutlet var lblReturnOn: UILabel!
    
    @IBOutlet var btnReIssue: UIButton!
    @IBOutlet var btnReturn: UIButton!
    
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var lblOTP: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellContents(_ userRentedBookListObj: UserRentedBookList){
        
        self.lblBookName.text = userRentedBookListObj.productName
        self.lblAuthorName.text = BY + userRentedBookListObj.author
        self.lblStatus.text = userRentedBookListObj.status
        self.lblIssueOn.text = userRentedBookListObj.bookDeliveredToCustomerOndateTime != "" ? userRentedBookListObj.bookDeliveredToCustomerOndateTime : NA
        self.lblReturnOn.text = userRentedBookListObj.returnedDateTime != "" ? userRentedBookListObj.returnedDateTime : NA
        
        self.imgBook.setImageFromURl(stringImageUrl: userRentedBookListObj.imageUrl)
        
        if userRentedBookListObj.status == STATUS_PENDING {
            self.stackViewButtons.isHidden = true
            self.lblOTP.isHidden = false
            self.lblOTP.text = OTP + userRentedBookListObj.otp
        }
        else if userRentedBookListObj.status == STATUS_RENTED || userRentedBookListObj.status == STATUS_REISSUE {
            self.stackViewButtons.isHidden = false
            self.lblOTP.isHidden = true
        }
        else {
            self.stackViewButtons.isHidden = true
            self.lblOTP.isHidden = true
        }
        
    }
    
}
