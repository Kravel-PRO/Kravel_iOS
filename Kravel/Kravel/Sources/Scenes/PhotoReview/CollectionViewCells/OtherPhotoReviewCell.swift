//
//  OtherPhotoReviewCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/29.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class OtherPhotoReviewCell: UICollectionViewCell {
    static let identifier = "OtherPhotoReviewCell"
    
    var indexPath: IndexPath?
    var delegate: CellButtonDelegate?
    
    // MARK: - 포토리뷰 이미지 설정
    @IBOutlet weak var photoReviewImageView: UIImageView!
    
    // MARK: - 포토리뷰 날짜 설정
    @IBOutlet weak var dateLabel: UILabel!
    
    var date: String? {
        didSet {
            dateLabel.text = date
        }
    }
    
    // MARK: - 좋아요 버튼
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func like(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        delegate?.click(at: indexPath)
    }
    
    // MARK: - 좋아요 개수 Label 설정
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var likeCount: Int? {
        didSet {
            likeCountLabel.text = "\(likeCount!)"
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
