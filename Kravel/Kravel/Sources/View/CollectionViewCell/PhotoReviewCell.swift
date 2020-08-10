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
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var photoImage: UIImage? {
        didSet {
            photoImageView.image = photoImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.frame = self.bounds
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}
