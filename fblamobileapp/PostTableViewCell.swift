//
//  PostTableViewCell.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/9/17.
//
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

        // Configure the view for the selected state
    }

}
