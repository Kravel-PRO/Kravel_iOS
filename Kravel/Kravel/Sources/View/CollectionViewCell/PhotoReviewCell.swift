//
//  PhotoReviewCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/21.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class PhotoReviewCell: UICollectionViewCell {
    static let identifier = "PhotoReviewCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoImage: UIImage? {
        didSet {
            photoImageView.image = photoImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}
