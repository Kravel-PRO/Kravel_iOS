//
//  MorePhotoReviewVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/19.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MorePhotoReviewVC: UIViewController {
    static let identifier = "MorePhotoReviewVC"
    
    // MARK: - CollectionView 설정
    @IBOutlet weak var morePhotoReviewCollectionView: UICollectionView! {
        didSet {
            morePhotoReviewCollectionView.dataSource = self
            morePhotoReviewCollectionView.delegate = self
        }
    }
    
    private var photoReviewDatas: [String] = ["호텔 세느장", "우각로", "호준이 집", "여기가 명소", "유나 집"]
    
    // MARK: - UIViewController Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "새로운 포토 리뷰"
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}

extension MorePhotoReviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReviewDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MorePhotoReviewCell.identifier, for: indexPath) as? MorePhotoReviewCell else { return UICollectionViewCell() }
        photoReviewCell.photoReviewImage = UIImage(named: "yuna2")
        photoReviewCell.placeName = photoReviewDatas[indexPath.row]
        return photoReviewCell
    }
}

extension MorePhotoReviewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16*2 - 8) / 2
        let height = width * 1.28
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
