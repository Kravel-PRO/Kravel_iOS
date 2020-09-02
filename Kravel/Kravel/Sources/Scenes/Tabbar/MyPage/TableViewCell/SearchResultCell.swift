//
//  SearchResultCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/02.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    static let identifier = "SearchResultCell"
    
    // MARK: - 장소 이름 설정 Label
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var placeNameAttributeText: NSMutableAttributedString? {
        didSet {
            placeNameLabel.attributedText = placeNameAttributeText
            placeNameLabel.sizeToFit()
        }
    }
    
    // MARK: - 장소 주소 설정 Label
    @IBOutlet weak var addressLabel: UILabel!
    
    var addressAttributeText: NSMutableAttributedString? {
        didSet {
            addressLabel.attributedText = addressAttributeText
            addressLabel.sizeToFit()
        }
    }
    
    // MARK: UITableVIewCell Override 설정
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeNameLabel.text = nil
        addressLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
