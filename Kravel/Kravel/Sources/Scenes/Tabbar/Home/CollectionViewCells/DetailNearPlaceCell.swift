//
//  DetailNearPlaceCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/19.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class DetailNearPlaceCell: UICollectionViewCell {
    static let identifier = "DetailNearPlaceCell"
    
    // MARK: - 장소 이미지 설정
    @IBOutlet weak var placeImageView: UIImageView!
    
    // MARK: - 장소 이름 설정
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var placeName: String? {
        didSet {
            placeNameLabel.text = placeName
            placeNameLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var placeNameLabelTopConstraint: NSLayoutConstraint!
    
    private func setNameLabelTopConstraint() {
        placeNameLabelTopConstraint.constant = self.frame.height / 19.76
    }
    
    // MARK: - 태그 CollectionView 설정
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            tagCollectionView.dataSource = self
            if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                layout.minimumInteritemSpacing = 5
                layout.minimumLineSpacing = 5
            }
        }
    }
    
    var tags: [String] = [] {
        didSet {
            tagCollectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewCell Override
    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.image = nil
        placeName = nil
        tags = []
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setNameLabelTopConstraint()
    }
}

extension DetailNearPlaceCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        tagCell.tagTitle = "#\(tags[indexPath.row])"
        return tagCell
    }
}

