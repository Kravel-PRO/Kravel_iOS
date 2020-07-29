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
//        guard let view = Bundle.main.loadNibNamed(SubLocationView.nibName, owner: self, options: nil)?.first as? UIView else { return }
//        view.frame = self.bounds
//        self.view = view
//        self.addSubview(view)
        
        self.view = loadXib(from: PhotoReviewView.nibName)
        self.view.frame = self.bounds
        self.addSubview(view)
    }
}
