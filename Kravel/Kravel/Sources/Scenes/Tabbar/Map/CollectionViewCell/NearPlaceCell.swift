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
    
    @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!
    
    // Name Label AutoLayout 초기 설정 ==> 화면에 맞게
    private func setNameLabelLayout() {
        nameLabelTopConstraint.constant = self.frame.height / 14.6
    }
    
    // MARK: - 태그 CollectionView 설정
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            tagCollectionView.dataSource = self
            tagCollectionView.showsHorizontalScrollIndicator = false
            if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 3
                layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        }
    }
    
    var tags: [String] = [] {
        didSet {
            tagCollectionView.reloadData()
        }
    }
    
    // MARK: - 장소 라벨
    @IBOutlet weak var locationLabel: UILabel!
    
    var location: String? {
        didSet {
            locationLabel.text = location
            locationLabel.sizeToFit()
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override func awakeFromNib() {
        super.awakeFromNib()
        setNameLabelLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.image = nil
    }
}

extension NearPlaceCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        tagCell.layer.cornerRadius = tagCell.frame.width / 7.27
        tagCell.clipsToBounds = true
        tagCell.tagTitle = "#\(tags[indexPath.row])"
        return tagCell
    }
}
