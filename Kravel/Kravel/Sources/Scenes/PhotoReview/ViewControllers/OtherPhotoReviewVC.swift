//
//  OtherPhotoReviewVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/29.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class OtherPhotoReviewVC: UIViewController {
    static let identifier = "OtherPhotoReviewVC"

    // MARK: - 포토리뷰 CollectionView 설정
    @IBOutlet weak var photoReviewCollectionView: UICollectionView! {
        didSet {
            photoReviewCollectionView.dataSource = self
            photoReviewCollectionView.delegate = self
        }
    }
    
    var photoReviewDatas: [String] = ["호텔 세느장", "윤재 집", "윤재네 국밥"]
    
    var photoReviewIsLike: [Bool] = [false, false, false]
    
    // MARK: - UIViewController viewDidLoad() Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIViewController viewWillAppear() Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationItem.title = "포토 리뷰"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        let rightButtonItem = UIBarButtonItem(image: UIImage(named: ImageKey.icWrite), style: .done, target: self, action: #selector(writePhotoReview(_:)))
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func writePhotoReview(_ sender: Any) {
        guard let photoReviewUploadVC = UIStoryboard(name: "PhotoReviewUpload", bundle: nil).instantiateViewController(withIdentifier: PhotoReviewUploadVC.identifier) as? PhotoReviewUploadVC else { return }
        self.navigationController?.pushViewController(photoReviewUploadVC, animated: true)
    }
}

extension OtherPhotoReviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReviewDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let otherPhotoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherPhotoReviewCell.identifier, for: indexPath) as? OtherPhotoReviewCell else { return UICollectionViewCell() }
        
        otherPhotoReviewCell.indexPath = indexPath
        otherPhotoReviewCell.likeCount = 99
        otherPhotoReviewCell.indexPath = indexPath
        otherPhotoReviewCell.delegate = self
        return otherPhotoReviewCell
    }
}

extension OtherPhotoReviewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.frame.width + 39
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension OtherPhotoReviewVC: CellButtonDelegate {
    func click(at indexPath: IndexPath) {
        guard let otherCell = photoReviewCollectionView.cellForItem(at: indexPath) as? OtherPhotoReviewCell else { return }
        photoReviewIsLike[indexPath.row] = !photoReviewIsLike[indexPath.row]
        
        let btnImage = photoReviewIsLike[indexPath.row] ? UIImage(named: ImageKey.btnLike) : UIImage(named: ImageKey.btnLikeUnclick)
        otherCell.likeButton.setImage(btnImage, for: .normal)
    }
}
