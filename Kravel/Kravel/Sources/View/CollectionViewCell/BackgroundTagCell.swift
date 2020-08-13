//
//  BackgroundTagCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/13.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class BackgroundTagCell: UICollectionViewCell {
    static let nibName = "BackgroundTagCell"
    static let identifier = "BackgroundTagCell"
    
    // MARK: - 태그 라벨 설정
    @IBOutlet weak var tagLabel: UILabel!
    
    var tagTitle: String? {
        didSet {
            tagLabel.text = tagTitle
            tagLabel.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
