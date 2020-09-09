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
    
    enum RequestType {
        case hot
        case place(id: Int)
    }
    
    var requestType: RequestType?
    var selectedPhotoReviewID: Int?

    // MARK: - 포토리뷰 CollectionView 설정
    @IBOutlet weak var photoReviewCollectionView: UICollectionView! {
        didSet {
            photoReviewCollectionView.dataSource = self
            photoReviewCollectionView.delegate = self
        }
    }
    
    var photoReviewData: [ReviewInform] = []
    
    // MARK: - UIViewController viewDidLoad() Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIViewController viewWillAppear() Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
        requestByAPI()
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

extension OtherPhotoReviewVC {
    // MARK: - API 요청 분기 처리
    private func requestByAPI() {
        switch requestType {
        case .hot: break
        case .place(let id):
            requestPlacePhotoReview(of: id)
        case .none: break
        }
    }
    
    // MARK: - 장소의 포토리뷰 가져오기 API 요청
    private func requestPlacePhotoReview(of placeID: Int) {
        let getPlaceReviewParameter = GetReviewOfPlaceParameter(latitude: nil, longitude: nil, like_count: nil)
        APICostants.placeID = "\(placeID)"
        
        NetworkHandler.shared.requestAPI(apiCategory: .getPlaceReview(getPlaceReviewParameter)) { result in
            switch result {
            case .success(let placeReviewData):
                guard let placeReviewData = placeReviewData as? APISortableResponseData<ReviewInform> else { return }
                DispatchQueue.main.async {
                    self.photoReviewData = placeReviewData.content
                    self.photoReviewCollectionView.reloadData()
                    
                    guard let selectedPhotoReviewID = self.selectedPhotoReviewID else { return }
                    for index in 0..<self.photoReviewData.count {
                        if selectedPhotoReviewID == self.photoReviewData[index].reviewId {
                            self.photoReviewCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredVertically, animated: false)
                            break
                        }
                    }
                }
            case .requestErr(let error):
                print(error)
                DispatchQueue.main.async {
                    self.photoReviewData = []
                }
            case .serverErr: print("Server Err")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

extension OtherPhotoReviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReviewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let otherPhotoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherPhotoReviewCell.identifier, for: indexPath) as? OtherPhotoReviewCell else { return UICollectionViewCell() }
        
        otherPhotoReviewCell.indexPath = indexPath
        
        otherPhotoReviewCell.likeCount = photoReviewData[indexPath.row].likeCount
        otherPhotoReviewCell.photoReviewImageView.setImage(with: photoReviewData[indexPath.row].imageURl)
        otherPhotoReviewCell.date = "2020.08.24"
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
        print(otherCell)
//        photoReviewIsLike[indexPath.row] = !photoReviewIsLike[indexPath.row]
        
//        let btnImage = photoReviewIsLike[indexPath.row] ? UIImage(named: ImageKey.btnLike) : UIImage(named: ImageKey.btnLikeUnclick)
//        otherCell.likeButton.setImage(btnImage, for: .normal)
    }
}
