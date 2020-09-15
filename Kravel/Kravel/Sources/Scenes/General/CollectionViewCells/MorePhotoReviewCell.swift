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
    
    var indexPath: IndexPath?
    var delegate: CellButtonDelegate?
    
    // MARK: - 포토 리뷰 이미지 설정
    @IBOutlet weak var photoReviewImageView: UIImageView! {
        didSet {
            photoReviewImageView.layer.cornerRadius = photoReviewImageView.frame.width / 20
            photoReviewImageView.clipsToBounds = true
        }
    }
    
    // MARK: - 하트 버튼
    @IBOutlet weak var heartButton: UIButton!
    
    var isLike: Bool? {
        didSet {
            guard let isLike = self.isLike else { return }
            let heartImage = isLike ? UIImage(named: ImageKey.btnLike) : UIImage(named: ImageKey.btnLikeUnclick)
            heartButton.setImage(heartImage, for: .normal)
        }
    }
    
    @IBAction func like(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        delegate?.clickHeart(at: indexPath)
    }
    
    // MARK: - 좋아요 개수 표시 Label 설정
    @IBOutlet weak var likeCountLabel: UILabel! {
        didSet {
            likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var likeCountWidthConstraint: NSLayoutConstraint?
    
    var likeCount: Int? {
        didSet {
            guard let likeCount = self.likeCount else { return }
            likeCountLabel.text = "\(likeCount)"
            likeCountWidthConstraint = likeCountLabel.widthAnchor.constraint(equalToConstant: likeCountLabel.intrinsicContentSize.width)
            likeCountWidthConstraint?.isActive = true
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
            tagCollectionView.delegate = self
        }
    }
    
    var tags: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tagCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        indexPath = nil
        placeName = nil
        photoReviewImageView.image = nil
        isLike = nil
        likeCountWidthConstraint?.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setNameLabelTopConstraint()
    }
}

extension MorePhotoReviewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        tagCell.tagTitle = "#\(tags[indexPath.row])"
        return tagCell
    }
}

extension MorePhotoReviewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tempLabel = UILabel()
        tempLabel.text = tags[indexPath.row]
        return CGSize(width: tempLabel.intrinsicContentSize.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
