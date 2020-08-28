//
//  TagCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/05.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    @IBOutlet weak var tagLabel: UILabel!
    
    var tagTitle: String? {
        didSet {
            tagLabel.text = tagTitle
            tagLabel.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
