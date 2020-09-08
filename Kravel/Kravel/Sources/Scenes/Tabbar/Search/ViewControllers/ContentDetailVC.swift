//
//  ContentDetailVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/15.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

protocol CategoryAble { }

class ContentDetailVC: UIViewController {
    static let identifier = "ContentDetailVC"
    
    var category: KCategory?
    var id: Int?
    var categoryDetailDTO: CategoryAble?
    var places: [PlaceContentInform] = []
    
    private func appearDetailData() {
        guard let category = self.category else { return }
        switch category {
        case .celeb:
            guard let celebDetailDTO = categoryDetailDTO as? CelebrityDetailDTO else { return }
        case .media:
            guard let mediaDetailDTO = categoryDetailDTO as? MediaDetailDTO else { return }
            // 썸네일 이미지 설정
            thumbnail_imageView.setImage(with: mediaDetailDTO.imageUrl ?? "")
            
            // Label 설정 -> 높이 Constraint 계산해서 적용
            let introduceText = "\(mediaDetailDTO.title)\n촬영지가 어딜까요?"
            introduceLabel.attributedText = createAttributeString(of: introduceText, highlightPart: mediaDetailDTO.title)
            setLabelHeight()
            
            // 관련 장소 설정
            self.places = mediaDetailDTO.places ?? []
            placeCollectionView.reloadData()
            setPlaceCVHeight()
        }
    }
    
    // MARK: - Thumnail Image 설정
    @IBOutlet weak var thumbnail_Back_View: UIView!
    @IBOutlet weak var thumbnail_imageView: UIImageView! {
        didSet {
            setGradientLayer()
        }
    }
    
    var thumnail_Gradient_Layer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.5]
        return gradientLayer
    }()
    
    private func setGradientLayer() {
        thumnail_Gradient_Layer.frame = thumbnail_Back_View.bounds
        thumbnail_Back_View.layer.addSublayer(thumnail_Gradient_Layer)
    }
    
    // MARK: - 연예인/드라마 별 Label 지정
    @IBOutlet weak var introduceLabel: UILabel! {
        didSet {
            introduceLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK: - 장소 CollectionView 설정
    @IBOutlet weak var placeCollectionView: UICollectionView! {
        didSet {
            placeCollectionView.dataSource = self
            placeCollectionView.delegate = self
        }
    }
    
    @IBOutlet weak var placeCV_height_Constarint: NSLayoutConstraint!
    
    lazy var horizontal_inset: CGFloat = placeCollectionView.frame.width / 23
    lazy var place_item_Spacing: CGFloat = placeCollectionView.frame.width / 54
    lazy var place_Cell_Width: CGFloat = (placeCollectionView.frame.width-2*horizontal_inset-place_item_Spacing) / 2
    lazy var place_Cell_Height: CGFloat = place_Cell_Width * (159/169)
    
    private func setPlaceCVHeight() {
        if places.count <= 2 {
            placeCV_height_Constarint.constant = place_Cell_Height
            moreButtonConatinerView.isHidden = true
        } else if places.count <= 4 {
            placeCV_height_Constarint.constant = place_Cell_Height * 2
            moreButtonConatinerView.isHidden = true
        } else if places.count <= 6 {
            placeCV_height_Constarint.constant = place_Cell_Height * 3
            moreButtonConatinerView.isHidden = true
        } else {
            placeCV_height_Constarint.constant = place_Cell_Height * 3
            moreButtonConatinerView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Button 설정
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.layer.borderColor = UIColor.veryLightPink.cgColor
            moreButton.layer.borderWidth = 1
            moreButton.layer.cornerRadius = moreButton.frame.width / 15
        }
    }
    
    @IBOutlet weak var moreButtonConatinerView: UIView!
    
    // MARK: - 포토리뷰 뷰 설정
    @IBOutlet weak var photoReviewView: PhotoReviewView! {
        didSet {
            setPhotoReviewLabel()
            photoReviewView.photoReviewCollectionViewDataSource = self
            photoReviewView.photoReviewCollectionViewDelegate = self
        }
    }
    
    private func setPhotoReviewLabel() {
        let photoReviewAttributeText = "인기 많은 포토 리뷰".makeAttributedText([.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)])
        photoReviewAttributeText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], range: ("인기 많은 포토 리뷰" as NSString).range(of: "포토 리뷰"))
        photoReviewView.attributeTitle = photoReviewAttributeText
    }
    
    lazy var photo_Cell_Width: CGFloat = (photoReviewView.frame.width-2*horizontal_inset-2*4) / 3
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestData()
    }
    
    // MARK: - UIViewController viewWillApeear 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    // MARK: - UIViewController viewWillLayoutSubviews 설정
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func setLabelHeight() {
        introduceLabel.heightAnchor.constraint(equalToConstant: introduceLabel.intrinsicContentSize.height).isActive = true
    }
    
    private func setCollectionViewHeight() {
        placeCV_height_Constarint.constant = place_Cell_Height * 3 + 16 * 2
    }
    
    // MARK: - Set Navigation
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        self.setTransparentNav()
    }
    
    private func createAttributeString(of str: String, highlightPart: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: str, attributes: [.foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0), .font: UIFont.systemFont(ofSize: 24)])
        attributeString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: (str as NSString).range(of: highlightPart))
        return attributeString
    }
}

extension ContentDetailVC {
    // MARK: - ID에 따라 요청
    private func requestData() {
        guard let category = self.category
            , let id = self.id else { return }
        
        switch category {
        case .celeb: requestCeleb(id: id)
        case .media: requestMedia(id: id)
        }
    }
    
    // MARK: - 유명인 API 요청
    private func requestCeleb(id: Int) {
        NetworkHandler.shared.requestAPI(apiCategory: .getCelebOfID(id)) { result in
            switch result {
            case .success(let celebResult):
                guard let celebDetail = celebResult as? CelebrityDetailDTO else { return }
                print(celebDetail)
            case .requestErr(let error): print(error)
            case .serverErr: print("Server Error")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - 미디어 API 요청
    private func requestMedia(id: Int) {
        NetworkHandler.shared.requestAPI(apiCategory: .getMediaOfID(id)) { result in
            switch result {
            case .success(let mediaResult):
                guard let mediaDetail = mediaResult as? MediaDetailDTO else { return }
                self.categoryDetailDTO = mediaDetail
                DispatchQueue.main.async {
                    self.appearDetailData()
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

extension ContentDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == placeCollectionView { return places.count }
        // FIXME: 여기 포토리뷰 받아오게 설정
        else { return 6 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == placeCollectionView { return createPlaceCell(of: collectionView, at: indexPath) }
        else { return createPhotoReviewCell(of: collectionView, at: indexPath) }
    }
    
    private func createPlaceCell(of collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let placeCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCell.identifier, for: indexPath) as? PlaceCell else { return UICollectionViewCell() }
        placeCell.placeImageView.setImage(with: places[indexPath.row].imageUrl ?? "")
        placeCell.tags = places[indexPath.row].tags
        placeCell.placeName = places[indexPath.row].title
        return placeCell
    }
    
    private func createPhotoReviewCell(of collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReviewCell.identifier, for: indexPath) as? PhotoReviewCell else { return UICollectionViewCell() }
//        photoReviewCell.photoImage = UIImage(named: "bitmap_0")
        if indexPath.row == 5 { photoReviewCell.addMoreView() }
        return photoReviewCell
    }
}

extension ContentDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == placeCollectionView { return CGSize(width: place_Cell_Width, height: place_Cell_Height) }
        else {
            let cellWidth = (self.view.frame.width - 2*horizontal_inset - 4*2) / 3
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: horizontal_inset, bottom: 0, right: horizontal_inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == placeCollectionView { return 16 }
        else { return 4 }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == placeCollectionView { return place_item_Spacing }
        else { return 4 }
    }
}
