//
//  MyPhotoReviewVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/24.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MyPhotoReviewVC: UIViewController {
    static let identifier = "MyPhotoReviewVC"
    
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
    
    // MARK: - 리프레쉬
    private func setRefresh() {
        let refreshControl = UIRefreshControl()
        photoReviewCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    @objc func reloadData() {
        requestMyPhotoReview()
    }
    
    // MARK: - 포토리뷰 CollectionView 설정
    @IBOutlet weak var photoReviewCollectionView: UICollectionView! {
        didSet {
            photoReviewCollectionView.dataSource = self
            photoReviewCollectionView.delegate = self
        }
    }
    
    // MARK: - 포토리뷰 데이터 설정
    var photoReviewData: [ReviewInform] = []
    
    // MARK: - 포토리뷰 없을 때, 화면 설정
    var noPhotoReviewView: UIView = {
        let tempView = UIView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.isHidden = true
        return tempView
    }()
    
    var noPhotoReviewStackView: UIStackView = {
        let tempView = UIStackView()
        tempView.alignment = .center
        tempView.distribution = .fill
        tempView.axis = .vertical
        tempView.spacing = 16
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        let noPhotoReviewImage = UIImageView(image: UIImage(named: ImageKey.icNoPhotoEmpty))
        noPhotoReviewImage.contentMode = .scaleAspectFill
        noPhotoReviewImage.translatesAutoresizingMaskIntoConstraints = false
        
        let noPhotoReviewLabel = UILabel()
        noPhotoReviewLabel.numberOfLines = 0
        noPhotoReviewLabel.font = UIFont.systemFont(ofSize: 16)
        noPhotoReviewLabel.textColor = .veryLightPink
        noPhotoReviewLabel.textAlignment = .center
        noPhotoReviewLabel.text = "포토 리뷰를 올리고\n나만의 여행 앨범을 꾸며봐요!".localized
        noPhotoReviewLabel.sizeToFit()
        
        tempView.addArrangedSubview(noPhotoReviewImage)
        tempView.addArrangedSubview(noPhotoReviewLabel)
        return tempView
    }()
    
    // 포토리뷰 데이터가 없을 때, 표시하는 View 초기화
    private func setNoPhotoReviewView() {
        self.view.addSubview(noPhotoReviewView)
        noPhotoReviewView.addSubview(noPhotoReviewStackView)
    }
    
    // 포토리뷰 데이터가 없을 때, View Layout 초기화
    private func setNoPhotoReviewViewLayout() {
        NSLayoutConstraint.activate([
            noPhotoReviewView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            noPhotoReviewView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            noPhotoReviewView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            noPhotoReviewView.heightAnchor.constraint(equalTo: self.view.widthAnchor),
            noPhotoReviewStackView.centerXAnchor.constraint(equalTo: noPhotoReviewView.centerXAnchor),
            noPhotoReviewStackView.centerYAnchor.constraint(equalTo: noPhotoReviewView.centerYAnchor),
            noPhotoReviewStackView.arrangedSubviews[0].widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.21),
            noPhotoReviewStackView.arrangedSubviews[0].heightAnchor.constraint(equalTo: noPhotoReviewStackView.arrangedSubviews[0].widthAnchor, multiplier: 1.05)
        ])
    }

    // MARK: - UIViewController viewDidLoad() 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setRefresh()
        showLoadingLottie()
        setNoPhotoReviewView()
        if isEmptyPhotoReview() { print("Empty View") }
    }
    
    private func isEmptyPhotoReview() -> Bool {
        if photoReviewData.count == 0 {
            noPhotoReviewView.isHidden = false
            photoReviewCollectionView.isHidden = true
            return true
        } else {
            noPhotoReviewView.isHidden = true
            photoReviewCollectionView.isHidden = false
            return false
        }
    }
    
    // MARK: - UIViewController viewWillAppear() 부분
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
        requestMyPhotoReview()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "내".localized + " " + "포토 리뷰".localized
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)]
    }
    
    // MARK: - UIViewController viewWillLayoutSubviews() 부분
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setNoPhotoReviewViewLayout()
    }
}

extension MyPhotoReviewVC {
    // MARK: - 내 포토리뷰 요청 API
    private func requestMyPhotoReview() {
        let getReviewParameter = GetReviewParameter(page: 0, size: 100, sort: "createdDate,desc")
        
        NetworkHandler.shared.requestAPI(apiCategory: .getMyPhotoReview(getReviewParameter)) { result in
            switch result {
            case .success(let reviewData):
                guard let reviewData = reviewData as? APISortableResponseData<ReviewInform> else { return }
                self.photoReviewData = reviewData.content
                DispatchQueue.main.async {
                    self.photoReviewCollectionView.refreshControl?.endRefreshing()
                    self.stopLottieAnimation()
                    if self.isEmptyPhotoReview() { print("Empty") }
                    self.photoReviewCollectionView.reloadData()
                }
            case .requestErr:
                print("request Err")
            case .serverErr:
                print("server Err")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                networkFailPopupVC.completionHandler = { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    private func requestDeletePhotoReview(reviewId: Int, at indexPath: IndexPath) {
        NetworkHandler.shared.requestAPI(apiCategory: .deletePlaceReview(reviewId: reviewId)) { result in
            switch result {
            case .success(let deleteResult):
                DispatchQueue.main.async {
                    self.stopLottieAnimation()
                    self.photoReviewData.remove(at: indexPath.row)
                    self.photoReviewCollectionView.deleteItems(at: [indexPath])
                }
            case .requestErr: return
            case .serverErr:
                print("게시글 삭제 실패의 로직")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                networkFailPopupVC.completionHandler = { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

extension MyPhotoReviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReviewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let myPhotoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPhotoReviewCell.identifier, for: indexPath) as? MyPhotoReviewCell else { return UICollectionViewCell() }
        myPhotoReviewCell.delegate = self
        myPhotoReviewCell.indexPath = indexPath
        
        myPhotoReviewCell.photoReviewImageView.setImage(with: photoReviewData[indexPath.row].imageUrl ?? "")
        myPhotoReviewCell.locationName = photoReviewData[indexPath.row].place?.title
        myPhotoReviewCell.likeCount = photoReviewData[indexPath.row].likeCount
        myPhotoReviewCell.date = photoReviewData[indexPath.row].createdDate
        return myPhotoReviewCell
    }
}

extension MyPhotoReviewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.width + 59
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension MyPhotoReviewVC: CellButtonDelegate {
    func click(at indexPath: IndexPath) {
        if let reviewId = photoReviewData[indexPath.row].reviewId {
            guard let deletePopup = UIStoryboard(name: "TwoButtonPopup", bundle: nil).instantiateViewController(withIdentifier: TwoButtonPopupVC.identifier) as? TwoButtonPopupVC else { return }
            deletePopup.modalPresentationStyle = .overFullScreen
            deletePopup.popupCategory = .deleteReview
            deletePopup.completion = {
                self.showLoadingLottie()
                self.requestDeletePhotoReview(reviewId: reviewId, at: indexPath)
            }
            
            self.present(deletePopup, animated: false, completion: nil)
        }
    }
}
