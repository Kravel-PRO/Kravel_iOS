//
//  MyPhotoReviewCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/29.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MyPhotoReviewCell: UICollectionViewCell {
    static let identifier = "MyPhotoReviewCell"
    
    var delegate: CellButtonDelegate?
    var indexPath: IndexPath?
    
    // MARK: - 포토리뷰 이미지 설정
    @IBOutlet weak var photoReviewImageView: UIImageView!
    
    var photoReviewImage: UIImage? {
        didSet {
            photoReviewImageView.image = photoReviewImage
        }
    }
    
    // MARK: - 장소 이름 라벨 설정
    @IBOutlet weak var locationNameLabel: UILabel!
    
    var locationName: String? {
        didSet {
            locationNameLabel.text = locationName
            locationNameLabel.sizeToFit()
        }
    }
    
    // MARK: - 포토리뷰 작성일 라벨 설정
    @IBOutlet weak var dateLabel: UILabel!
    
    var date: String? {
        didSet {
            if let date = self.date {
                dateLabel.text = date
                dateLabel.sizeToFit()
            }
        }
    }
    
    // MARK: - 좋아요 수 라벨 설정
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var likeCount: Int? {
        didSet {
            likeCountLabel.text = "\(likeCount!)"
            likeCountLabel.sizeToFit()
        }
    }
    
    // MARK: - 삭제하는 로직
    @IBAction func deleteItem(_ sender: Any) {
        if let indexPath = self.indexPath { delegate?.click(at: indexPath) }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
    }
}
