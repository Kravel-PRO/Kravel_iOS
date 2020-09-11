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
    
    var isLike: Bool? {
        didSet {
            guard let isLike = self.isLike else { return }
            let heartImage = isLike ? UIImage(named: ImageKey.btnLike) : UIImage(named: ImageKey.btnLikeUnclick)
            likeButton.setImage(heartImage, for: .normal)
        }
    }
    
    // Delegate에 전달
    @IBAction func like(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        delegate?.clickHeart(at: indexPath)
    }
    
    // MARK: - 좋아요 개수 Label 설정
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var likeCount: Int? {
        didSet {
            likeCountLabel.text = "\(likeCount ?? 0)"
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
        delegate = nil
        date = nil
        photoReviewImageView.image = nil
        likeCount = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
