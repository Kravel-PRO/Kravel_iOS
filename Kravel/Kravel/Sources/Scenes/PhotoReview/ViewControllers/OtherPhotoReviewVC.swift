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
        case place(id: Int)
        case celeb(id: Int)
        case media(id: Int)
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
    
    // 포토리뷰 데이터 가져온 후, Completion Handler
    lazy var photoReviewHandler: ((NetworkResult<Codable>) -> Void) = { result in
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
    
    // MARK: - UIViewController viewDidLoad() Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLabelByLanguage()
    }
    
    private func setLabelByLanguage() {
        self.navigationItem.title = "포토 리뷰".localized
    }
    
    // MARK: - UIViewController viewWillAppear() Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
        requestByAPI()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        let backImage = UIImage(named: ImageKey.back)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        switch requestType {
        case .place:
            let rightButtonItem = UIBarButtonItem(image: UIImage(named: ImageKey.icWrite), style: .done, target: self, action: #selector(writePhotoReview(_:)))
            self.navigationItem.rightBarButtonItem = rightButtonItem
        default: break
        }
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
        case .place(let id):
            requestPlacePhotoReview(of: id)
        case .celeb(let id):
            requestCelebPhotoReview(id: id)
        case .media(let id):
            requestMediaPhotoReview(id: id)
        case .none: break
        }
    }
}

extension OtherPhotoReviewVC {
    // MARK: - 장소의 포토리뷰 가져오기 API 요청
    private func requestPlacePhotoReview(of placeID: Int) {
        let getPlaceReviewParameter = GetReviewParameter(page: 0, size: 100, sort: "createdDate,desc")
        APICostants.placeID = "\(placeID)"
        NetworkHandler.shared.requestAPI(apiCategory: .getPlaceReview(getPlaceReviewParameter), completion: photoReviewHandler)
    }
    
    private func requestCelebPhotoReview(id: Int) {
        let getReviewParameter = GetReviewParameter(page: nil, size: nil, sort: nil)
        NetworkHandler.shared.requestAPI(apiCategory: .getReviewOfCeleb(getReviewParameter, id: id), completion: photoReviewHandler)
    }
    
    private func requestMediaPhotoReview(id: Int) {
        let getReviewParameter = GetReviewParameter(page: nil, size: nil, sort: nil)
        NetworkHandler.shared.requestAPI(apiCategory: .getReviewOfMedia(getReviewParameter, id: id), completion: photoReviewHandler)
    }
    
    private func requestLike(currentLike: Bool, placeId: Int, reviewId: Int, completion: @escaping (NetworkResult<Codable>) -> Void) {
        let likeParameter = LikeParameter(like: currentLike)
        
        NetworkHandler.shared.requestAPI(apiCategory: .like(likeParameter, placeId: placeId, reviewId: reviewId), completion: completion)
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
        otherPhotoReviewCell.photoReviewImageView.setImage(with: photoReviewData[indexPath.row].imageUrl ?? "")
        otherPhotoReviewCell.date = photoReviewData[indexPath.row].createdDate
        otherPhotoReviewCell.isLike = photoReviewData[indexPath.row].like
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
    func clickHeart(at indexPath: IndexPath) {
        guard let like = photoReviewData[indexPath.row].like,
            let reviewId = photoReviewData[indexPath.row].reviewId,
            let placeId = photoReviewData[indexPath.row].place?.placeId,
            let otherCell = photoReviewCollectionView.cellForItem(at: indexPath) as? OtherPhotoReviewCell
            else { return }
        
        requestLike(currentLike: !like, placeId: placeId, reviewId: reviewId) { result in
            switch result {
            case .success(let likeResult):
                guard let likeResult = likeResult as? Int,
                    let likeCount = self.photoReviewData[indexPath.row].likeCount
                    else { return }
                
                // 좋아요 결과 반영됨 false -> true 반영
                if likeResult != -1 {
                    otherCell.isLike = true
                    otherCell.likeCount = likeCount + 1
                    self.photoReviewData[indexPath.row].like = true
                    self.photoReviewData[indexPath.row].likeCount = likeCount + 1
                }
                // 좋아요 결과 반영됨 true -> false 반영
                else {
                    otherCell.isLike = false
                    otherCell.likeCount = likeCount - 1
                    self.photoReviewData[indexPath.row].like = false
                    self.photoReviewData[indexPath.row].likeCount = likeCount - 1
                }
            case .requestErr(let error):
                print(error)
            case .serverErr:
                print("Server Err")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}
