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
    
    private var photoReviewData: [ReviewInform] = []
    
    // MARK: - UIViewController Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
        requestPhotoReview()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "새로운 포토 리뷰"
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)]
    }
}

extension MorePhotoReviewVC {
    // MARK: - 포토리뷰 API 통신
    private func requestPhotoReview() {
        let getReviewParameter = GetReviewParameter(page: 0, size: nil, sort: nil)
        NetworkHandler.shared.requestAPI(apiCategory: .getReview(getReviewParameter)) { result in
            switch result {
            case .success(let getReviewResult):
                guard let getReviewResult = getReviewResult as? APISortableResponseData<ReviewInform> else { return }
                self.photoReviewData = getReviewResult.content
                DispatchQueue.main.async {
                    self.morePhotoReviewCollectionView.reloadData()
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .serverErr:
                print("ServerError")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

extension MorePhotoReviewVC: CellButtonDelegate {
    func clickHeart(at indexPath: IndexPath) {
        print(indexPath)
    }
}

extension MorePhotoReviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReviewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MorePhotoReviewCell.identifier, for: indexPath) as? MorePhotoReviewCell else { return UICollectionViewCell() }
        photoReviewCell.delegate = self
        photoReviewCell.indexPath = indexPath
        
        photoReviewCell.photoReviewImageView.setImage(with: photoReviewData[indexPath.row].imageUrl ?? "")
        photoReviewCell.isLike = photoReviewData[indexPath.row].like
        photoReviewCell.likeCount = photoReviewData[indexPath.row].likeCount
        photoReviewCell.placeName = photoReviewData[indexPath.row].placeTitle
        photoReviewCell.tags = photoReviewData[indexPath.row].tags?.split(separator: " ").map(String.init)
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
        return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
