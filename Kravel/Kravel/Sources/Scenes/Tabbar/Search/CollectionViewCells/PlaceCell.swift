//
//  PlaceCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/20.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class PlaceCell: UICollectionViewCell {
    static let identifier = "PlaceCell"
    
    @IBOutlet weak var placeImageView: UIImageView! {
        didSet {
            placeImageView.layer.cornerRadius = placeImageView.frame.width / 20
            placeImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    var placeName: String? {
        didSet {
            placeLabel.text = placeName
        }
    }
    
    var tags: String? {
        didSet {
            if let tags = self.tags {
                tagLabel.text = tags.split(separator: " ").map({ "#" + String($0) }).joined(separator: " ")
                tagLabel.sizeToFit()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.image = nil
        placeName = nil
        tags = nil
    }
}
