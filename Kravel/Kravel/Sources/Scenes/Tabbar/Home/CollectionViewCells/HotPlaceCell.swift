//
//  HotPlaceCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/05.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class HotPlaceCell: UICollectionViewCell {
    static let identifier = "HotPlaceCell"
    
    // MARK: - 장소 이름 라벨 설정
    @IBOutlet weak var locationNameLabel: UILabel!
    
    var location: String? {
        didSet {
            locationNameLabel.text = location
            locationNameLabel.sizeToFit()
        }
    }
    
    // MARK: - 태그 CollectionView 설정
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            tagCollectionView.dataSource = self
            if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                layout.minimumInteritemSpacing = 3
                layout.minimumLineSpacing = 3
                layout.sectionInset = .zero
            }
        }
    }
    
    var tags: [String] = ["기생충", "박소담", "이선균"] {
        didSet {
            tagCollectionView.reloadData()
        }
    }
    
    // MARK: - 포토리뷰 개수 라벨
    @IBOutlet weak var photoReviewCountLabel: UILabel!
    
    var photoCount: Int? {
        didSet {
            photoReviewCountLabel.text = "포토리뷰 \(photoCount!)개"
            photoReviewCountLabel.sizeToFit()
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension HotPlaceCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        tagCell.tagTitle = "#\(tags[indexPath.row])"
        return tagCell
    }
}
