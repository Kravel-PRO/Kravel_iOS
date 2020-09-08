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
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    var placeName: String? {
        didSet {
            placeLabel.text = placeName
        }
    }
    
    var tags: [String]? {
        didSet {
            if let tags = self.tags {
                var mutable_tags = tags
                for index in 0..<tags.count { mutable_tags[index] = "#" + tags[index] }
                tagLabel.text = mutable_tags.joined(separator: " ")
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
