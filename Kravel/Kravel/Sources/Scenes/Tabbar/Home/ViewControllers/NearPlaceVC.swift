//
//  NearPlaceVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/19.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import CoreLocation

class NearPlaceVC: UIViewController {
    static let identifier = "NearPlaceVC"
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    private var loadingView: UIActivityIndicatorView?
    
    private func showLoadingLottie() {
        loadingView = UIActivityIndicatorView(style: .large)
        self.view.addSubview(loadingView!)
        loadingView?.center = self.view.center
        loadingView?.startAnimating()
    }
    
    func stopLottieAnimation() {
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    // MARK: - 리프레쉬
    private func setRefresh() {
        let refreshControl = UIRefreshControl()
        nearPlaceCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    @objc func reloadData() {
        if let currentLocation = self.currentLocation {
            requestPlaceData(lat: currentLocation.latitude, lng: currentLocation.longitude)
        }
    }
    
    // MARK: - 가까운 장소 표시 CollectionView
    @IBOutlet weak var nearPlaceCollectionView: UICollectionView! {
        didSet {
            nearPlaceCollectionView.dataSource = self
            nearPlaceCollectionView.delegate = self
        }
    }
    
    var currentLocation: CLLocationCoordinate2D?
    var nearPlaceData: [PlaceContentInform] = []
      
    // MARK: - UIViewController viewDidLoad Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showLoadingLottie()
        setRefresh()
        if let currentLocation = self.currentLocation {
            requestPlaceData(lat: currentLocation.latitude, lng: currentLocation.longitude)
        }
    }

    // MARK: - UIViewController viewWillAppear Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "나와 가까운 Kravel"
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let backImage = UIImage(named: ImageKey.back)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
}

extension NearPlaceVC {
    // MARK: - 장소 데이터 API 요청
    private func requestPlaceData(lat: Double, lng: Double) {
        // FIXME: - 현재 내 위치 기준으로 요청할 수 있게 해야함
        let getPlaceParameter = GetPlaceParameter(latitude: lat, longitude: lng, page: nil, size: 100, review_count: nil, sort: nil)
        NetworkHandler.shared.requestAPI(apiCategory: .getPlace(getPlaceParameter)) { result in
            switch result {
            case .success(let getPlaceResult):
                guard let getPlaceResult = getPlaceResult as? APISortableResponseData<PlaceContentInform> else { return }
                self.nearPlaceData = getPlaceResult.content
                DispatchQueue.main.async {
                    self.stopLottieAnimation()
                    self.nearPlaceCollectionView.refreshControl?.endRefreshing()
                    self.nearPlaceCollectionView.reloadData()
                }
            // FIXME: 요청 에러 있을 시 에러 처리 필요
            case .requestErr(let errorMessage):
                print(errorMessage)
            // FIXME: 서버 에러 있을 시 에러 처리 필요
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

extension NearPlaceVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearPlaceData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nearPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailNearPlaceCell.identifier, for: indexPath) as? DetailNearPlaceCell else { return UICollectionViewCell() }
        nearPlaceCell.layer.borderWidth = 1
        nearPlaceCell.layer.borderColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0).cgColor
        nearPlaceCell.layer.cornerRadius = nearPlaceCell.frame.width / 68.6
        nearPlaceCell.clipsToBounds = true
        
        nearPlaceCell.placeImageView.setImage(with: nearPlaceData[indexPath.row].imageUrl ?? "")
        nearPlaceCell.placeName = nearPlaceData[indexPath.row].title
        if let tags = nearPlaceData[indexPath.row].tags {
            nearPlaceCell.tags = tags.split(separator: ",").map(String.init)
        } else {
            nearPlaceCell.tags = []
        }
        
        return nearPlaceCell
    }
}

extension NearPlaceVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let locationDetailVC = UIStoryboard(name: "LocationDetail", bundle: nil).instantiateViewController(withIdentifier: LocationDetailVC.identifier) as? LocationDetailVC else { return }
        locationDetailVC.placeID = nearPlaceData[indexPath.row].placeId
        self.navigationController?.pushViewController(locationDetailVC, animated: true)
    }
}

extension NearPlaceVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 16*2
        let height = width * 0.75
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
