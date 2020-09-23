//
//  MorePlaceVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/23.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MorePlaceVC: UIViewController {
    static let identifier = "MorePlaceVC"
    
    var category: KCategory?
    var id: Int?
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    private var loadingView: UIActivityIndicatorView?
    
    private func showLoadingLottie() {
        loadingView = UIActivityIndicatorView(style: .large)
        self.view.addSubview(loadingView!)
        loadingView?.center = self.view.center
        loadingView?.startAnimating()
    }
    
    private func stopLottieAnimation() {
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    // MARK: - 리프레쉬 Scroll
    private func setRefresh() {
        let refreshControl = UIRefreshControl()
        morePlaceCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    @objc func reloadData() {
        requestData()
    }

    // MARK: - 장소 더보기 CollectionView
    @IBOutlet weak var morePlaceCollectionView: UICollectionView! {
        didSet {
            morePlaceCollectionView.delegate = self
            morePlaceCollectionView.dataSource = self
        }
    }
    
    private var placeData: [PlaceContentInform] = []
    
    // MARK: - UIViewController viewDidLoad Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setRefresh()
        showLoadingLottie()
        requestData()
    }
    
    // MARK: - UIViewController viewWillAppear Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        let backImage = UIImage(named: ImageKey.back)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "장소 더 보기".localized
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension MorePlaceVC {
    // MARK: - ID에 따라 요청
    private func requestData() {
        guard let category = self.category,
              let id = self.id else { return }
        
        switch category {
        case .celeb:
            requestCeleb(id: id)
        case .media:
            requestMedia(id: id)
        }
    }
    
    // MARK: - 셀럽 장소 더보기 API 요청
    private func requestCeleb(id: Int) {
        let getReviewParameter = GetReviewParameter(page: 0, size: 20, sort: nil)
        
        NetworkHandler.shared.requestAPI(apiCategory: .getCelebOfID(getReviewParameter, id: id)) { result in
            switch result {
            case .success(let celebResult):
                guard let celebDetail = celebResult as? CelebrityDetailDTO else { return }
                self.placeData = celebDetail.places
                DispatchQueue.main.async {
                    self.stopLottieAnimation()
                    self.morePlaceCollectionView.refreshControl?.endRefreshing()
                    self.morePlaceCollectionView.reloadData()
                }
            case .requestErr(let error): print(error)
            case .serverErr: print("Server Error")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - 미디어 장소 더보기 API 요청
    private func requestMedia(id: Int) {
        let getReviewParameter = GetReviewParameter(page: 0, size: 20, sort: nil)
        
        NetworkHandler.shared.requestAPI(apiCategory: .getMediaOfID(getReviewParameter, id: id)) { result in
            switch result {
            case .success(let mediaResult):
                guard let mediaDetail = mediaResult as? MediaDetailDTO else { return }
                self.placeData = mediaDetail.places ?? []
                DispatchQueue.main.async {
                    self.morePlaceCollectionView.reloadData()
                }
            case .requestErr(let error): print(error)
            case .serverErr: print("Server Error")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}


extension MorePlaceVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let placeCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCell.identifier, for: indexPath) as? PlaceCell else { return UICollectionViewCell() }
        placeCell.placeImageView.setImage(with: placeData[indexPath.row].imageUrl ?? "")
        placeCell.placeName = placeData[indexPath.row].title
        if let tags = placeData[indexPath.row].tags {
            placeCell.tags = tags.split(separator: ",").map(String.init)
        } else {
            placeCell.tags = []
        }
        return placeCell
    }
}

extension MorePlaceVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let placeDetailVC = UIStoryboard(name: "LocationDetail", bundle: nil).instantiateViewController(withIdentifier: LocationDetailVC.identifier) as? LocationDetailVC else { return }
        placeDetailVC.placeID = placeData[indexPath.row].placeId
        self.navigationController?.pushViewController(placeDetailVC, animated: true)
    }
}

extension MorePlaceVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let place_Cell_Width = (collectionView.frame.width - 16 * 2 - 7)/2
        let place_Cell_Height = place_Cell_Width / 168 * 159
        return CGSize(width: place_Cell_Width, height: place_Cell_Height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
