//
//  PhotoReviewView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/29.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class PhotoReviewView: UIView {
    static let nibName = "PhotoReviewView"
    var view: UIView!
    
    // MARK: - 포토 리뷰 Delegate
    var delegate: PhotoReviewViewDelegate?
    
    // 포토리뷰 작성하기
    @IBAction func writePhotoReview(_ sender: Any) {
        delegate?.clickWriteButton()
    }
    
    // MARK: - Photo Review 보여주는 CollectionView 설정
    @IBOutlet weak var photoReviewCollectionView: UICollectionView! {
        didSet {
            photoReviewCollectionView.register(PhotoReviewCell.self, forCellWithReuseIdentifier: PhotoReviewCell.identifier)
        }
    }
    
    @IBOutlet weak var photoReviewCollectionViewLeadingConstraint: NSLayoutConstraint!
    
    var photoReviewCollectionViewDelegate: UICollectionViewDelegate? {
        didSet {
            photoReviewCollectionView.delegate = photoReviewCollectionViewDelegate
        }
    }
    
    var photoReviewCollectionViewDataSource: UICollectionViewDataSource? {
        didSet {
            photoReviewCollectionView.dataSource = photoReviewCollectionViewDataSource
        }
    }
    
    // CollectionView Height 그림에 맞게 설정
    @IBOutlet weak var photoReviewCollectionViewHeightConstraint: NSLayoutConstraint!
    
    func calculateCollectionViewHeight() {
        let horizontal_inset = photoReviewCollectionView.frame.width / 23.44
        let cellWidth = (photoReviewCollectionView.frame.width - horizontal_inset*2 - 4*2) / 3
        photoReviewCollectionViewHeightConstraint.constant = cellWidth * 2 + 4
    }
    
    // MARK: - Title Label 설정
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // 일반 설정
    var title: String? {
        didSet {
            titleLabel.text = title
            let size = titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            titleLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    // Attribute에 맞춤 설정
    var attributeTitle: NSMutableAttributedString? {
        didSet {
            titleLabel.attributedText = attributeTitle
            let size = titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            titleLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
     
    // MARK: - UIView Override 부분
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }

    private func loadXib() {
        self.view = loadXib(from: PhotoReviewView.nibName)
        self.view.frame = self.bounds
        self.addSubview(view)
        self.bringSubviewToFront(view)
    }
}
