//
//  TableViewCell.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/29/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var id: Int!
    var isSaved = false
    var hasAnswer: Bool!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        questionLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
