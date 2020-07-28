//
//  NearPlaceCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/28.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class NearPlaceCell: UICollectionViewCell {
    static let identifier = "NearPlaceCell"
    
    // MARK: - 장소 이미지 설정
    @IBOutlet weak var placeImageView: UIImageView!
    
    var placeImage: UIImage? {
        didSet {
            placeImageView.image = placeImage
        }
    }
    
    // MARK: - 장소 이름 설정
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var placeName: String? {
        didSet {
            placeNameLabel.text = placeName
            placeNameLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var nameLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!
    
    // Name Label AutoLayout 초기 설정 ==> 화면에 맞게
    private func setNameLabelLayout() {
        nameLabelLeadingConstraint.constant = self.frame.width / 15.5
        nameLabelTopConstraint.constant = self.frame.height / 14.6
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setNameLabelLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.image = nil
    }
}
