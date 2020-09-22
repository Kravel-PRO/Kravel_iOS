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
    
    @IBOutlet weak var placeImageView: UIImageView! {
        didSet {
            placeImageView.clipsToBounds = true
        }
    }
    
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
            tagCollectionView.showsHorizontalScrollIndicator = false
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
    
    // MARK: - 포토리뷰 개수 라벨
    @IBOutlet weak var photoReviewCountLabel: UILabel!
    
    var photoCount: Int? {
        didSet {
            guard let language = UserDefaults.standard.object(forKey: UserDefaultKey.language) as? String else { return }
            var countUnit: String
            if language == "KOR" { countUnit = "개" }
            else { countUnit = "" }
            if let photoCount = self.photoCount { photoReviewCountLabel.text = "포토 리뷰".localized + " \(photoCount)" + countUnit }
            else { photoReviewCountLabel.text = "포토 리뷰".localized + " 0" + countUnit }
            photoReviewCountLabel.sizeToFit()
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tags = []
        location = nil
        photoCount = nil
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

extension HotPlaceCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        tempLabel.text = "#" + "\(tags[indexPath.row])"
        return CGSize(width: tempLabel.intrinsicContentSize.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
