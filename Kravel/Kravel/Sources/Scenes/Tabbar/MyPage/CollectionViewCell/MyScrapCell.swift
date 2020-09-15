//
//  MyScrapCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/24.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MyScrapCell: UICollectionViewCell {
    static let identifier = "MyScrapCell"
    
    // MARK: - 스크랩 이미지 설정
    @IBOutlet weak var scrapImageView: UIImageView! {
        didSet {
            scrapImageView.layer.cornerRadius = scrapImageView.frame.width / 20
            scrapImageView.clipsToBounds = true
        }
    }
    
    var scrapImage: UIImage? {
        didSet {
            scrapImageView.image = scrapImage
        }
    }
    
    // MARK: - 스크랩 라벨 설정
    @IBOutlet weak var scrapLabel: UILabel!
    
    var scrapText: String? {
        didSet {
            scrapLabel.text = scrapText
            scrapLabel.sizeToFit()
        }
    }
    
    // MARK: - 태그 CollectionView 설정
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension MyScrapCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        tagCell.tagTitle = "#\(tags[indexPath.row])"
        return tagCell
    }
}

extension MyScrapCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        tempLabel.text = tags[indexPath.row]
        tempLabel.sizeToFit()
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
