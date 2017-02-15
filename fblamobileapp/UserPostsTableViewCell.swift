//
//  UserPostsTableViewCell.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/14/17.
// 
//

import UIKit

class UserPostsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.alpha = 0
        self.priceLabel.alpha = 0
        self.postImageView.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
