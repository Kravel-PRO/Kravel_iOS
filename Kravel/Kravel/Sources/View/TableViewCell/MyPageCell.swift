//
//  MyPageCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/22.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MyPageCell: UITableViewCell {
    static let identifier = ""

    @IBOutlet weak var menuLabel: UILabel!
    
    var menu: String? {
        didSet {
            menuLabel.text = menu
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
