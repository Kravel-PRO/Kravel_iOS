//
//  PlaceCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/20.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class PlaceCell: UICollectionViewCell {
    static let identifier = "PlaceCell"
    
    @IBOutlet weak var placeImageView: UIImageView! {
        didSet {
            placeImageView.layer.cornerRadius = placeImageView.frame.width / 20
            placeImageView.clipsToBounds = true
        }
    }
    
    // MARK: - 장소 이름 Label 설정
    @IBOutlet weak var placeLabel: UILabel!
    
    var placeName: String? {
        didSet {
            placeLabel.text = placeName
        }
    }
    
    
    // MARK: - Tag 컬렉션 뷰
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            tagCollectionView.showsHorizontalScrollIndicator = false
            tagCollectionView.dataSource = self
            tagCollectionView.delegate = self
        }
    }
    
    var tags: [String] = [] {
        didSet {
            tagCollectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.image = nil
        placeName = nil
        tags = []
    }
}

extension PlaceCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        tagCell.tagTitle = "#\(tags[indexPath.row])"
        return tagCell
    }
}

extension PlaceCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        tempLabel.text = "#\(tags[indexPath.row])"
        return CGSize(width: tempLabel.intrinsicContentSize.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
