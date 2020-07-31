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
    
    // MARK: - Photo Review 보여주는 CollectionView 설정
    @IBOutlet weak var photoReviewCollectionView: UICollectionView! {
        didSet {
            photoReviewCollectionView.register(PhotoReviewCell.self, forCellWithReuseIdentifier: PhotoReviewCell.identifier)
        }
    }
    
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
    
    // MARK: - Title Label 설정
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            let size = titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
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
