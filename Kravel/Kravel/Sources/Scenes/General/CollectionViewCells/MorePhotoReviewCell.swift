//
//  MorePhotoReviewCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/19.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MorePhotoReviewCell: UICollectionViewCell {
    static let identifier = "MorePhotoReviewCell"
    
    // MARK: - 포토 리뷰 이미지 설정
    @IBOutlet weak var photoReviewImageView: UIImageView! {
        didSet {
            photoReviewImageView.layer.cornerRadius = photoReviewImageView.frame.width / 20
            photoReviewImageView.clipsToBounds = true
        }
    }
    
    var photoReviewImage: UIImage? {
        didSet {
            photoReviewImageView.image = photoReviewImage
        }
    }
    
    // MARK: - 장소 이름 Label 설정
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var placeName: String? {
        didSet {
            placeNameLabel.text = placeName
            placeNameLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var placeNameLabelTopConstraint: NSLayoutConstraint!
    
    private func setNameLabelTopConstraint() {
        placeNameLabelTopConstraint.constant = self.frame.height / 30.57
    }
    
    // MARK: - 장소 태그 CollectionView 설정
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            tagCollectionView.dataSource = self
            if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                layout.minimumInteritemSpacing = 1
                layout.minimumLineSpacing = 1
                layout.sectionInset = .zero
            }
        }
    }
    
    var tags: [String] = ["호텔 델루나", "여진구", "피오"] {
        didSet {
            tagCollectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setNameLabelTopConstraint()
    }
}

extension MorePhotoReviewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        tagCell.tagTitle = "#\(tags[indexPath.row])"
        return tagCell
    }
}
