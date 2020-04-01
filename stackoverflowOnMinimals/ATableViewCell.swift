//
//  ATableViewCell.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/30/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

class ATableViewCell: UITableViewCell {

    @IBOutlet weak var qaText: UILabel!
    @IBOutlet weak var qaAuthor: UILabel!
    
    @IBOutlet weak var literalView: UIView!
    @IBOutlet weak var literal: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        literalView.layer.cornerRadius = 25
        view.layer.cornerRadius = 8
        qaText.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
