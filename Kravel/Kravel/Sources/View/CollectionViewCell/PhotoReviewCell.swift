//
//  PhotoReviewCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/21.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class PhotoReviewCell: UICollectionViewCell {
    static let identifier = "PhotoReviewCell"
    
    // MARK: - 포토 리뷰 이미지 설정
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var photoImage: UIImage? {
        didSet {
            photoImageView.image = photoImage
        }
    }
    
    var indexPath: IndexPath?
    
    // MARK: - 더보기 뷰 설정
    var moreView: UIView?
    
    // MARK: - UICollectionViewCell Override 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setInitView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        moreView?.removeFromSuperview()
        moreView = nil
    }
    
    private func setInitView() {
        photoImageView.frame = self.bounds
        self.contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func addMoreView() {
        moreView = UIView()
        moreView?.translatesAutoresizingMaskIntoConstraints = false
        moreView?.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.85)
        guard let moreView = self.moreView else { return }
        self.contentView.addSubview(moreView)
        NSLayoutConstraint.activate([
            moreView.topAnchor.constraint(equalTo: self.topAnchor),
            moreView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            moreView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            moreView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let moreLabel = UILabel()
        moreLabel.translatesAutoresizingMaskIntoConstraints = false
        moreLabel.textColor = .white
        moreLabel.font = UIFont.systemFont(ofSize: 15)
        moreLabel.text = "더 보기"
        moreLabel.sizeToFit()
        moreView.addSubview(moreLabel)
        NSLayoutConstraint.activate([
            moreLabel.centerXAnchor.constraint(equalTo: moreView.centerXAnchor),
            moreLabel.centerYAnchor.constraint(equalTo: moreView.centerYAnchor)
        ])
    }
}
