//
//  BagRangeTableViewCell.swift
//  b-mon-yoyaku
//
//  Created by akinov on 2018/03/05.
//  Copyright © 2018年 akinov. All rights reserved.
//

import UIKit

class BagRangeTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
