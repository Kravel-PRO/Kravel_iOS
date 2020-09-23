//
//  SearchCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    static let identifier = "SearchCell"
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.width/2
            profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var profile: String? {
        didSet {
            profileLabel.text = profile
            profileLabel.sizeToFit()
        }
    }
    
    var year: String? {
        didSet {
            yearLabel.text = year
            yearLabel.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
