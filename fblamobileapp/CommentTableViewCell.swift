//
//  CommentTableViewCell.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/27/17.
//  Copyright © 2017 Gabe Zimbric. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
