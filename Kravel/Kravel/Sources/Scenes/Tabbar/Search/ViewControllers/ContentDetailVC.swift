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
            // 썸네일 설정
            thumbnail_imageView.setImage(with: celebDetailDTO.celebrity.imageUrl ?? "")
            
            // Label 설정 -> 높이 Constraint 계산해서 적용
            let introduceText = "\(celebDetailDTO.celebrity.celebrityName ?? "")가\n다녀간 곳은 어딜까요?"
            introduceLabel.attributedText = createAttributeString(of: introduceText, highlightPart: celebDetailDTO.celebrity.imageUrl ?? "")
            setLabelHeight()
            
            // 관련 장소 설정
            self.places = celebDetailDTO.places
            setPlaceCVHeight()
            placeCollectionView.reloadData()
        case .media:
            guard let mediaDetailDTO = categoryDetailDTO as? MediaDetailDTO else { return }
            // 썸네일 이미지 설정
            thumbnail_imageView.setImage(with: mediaDetailDTO.media.imageUrl ?? "")
            
            // Label 설정 -> 높이 Constraint 계산해서 적용
            let introduceText = "\(mediaDetailDTO.media.title)\n촬영지가 어딜까요?"
            introduceLabel.attributedText = createAttributeString(of: introduceText, highlightPart: mediaDetailDTO.media.title)
            setLabelHeight()
            
            // 관련 장소 설정
            self.places = mediaDetailDTO.places ?? []
            setPlaceCVHeight()
            placeCollectionView.reloadData()
        }
    }
    
    // MARK: - 뒤로가기 버튼 설정
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    
    private func setBackButton() {
        backButton.setImage(UIImage(named: ImageKey.navBackWhtie), for: .normal)
        backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
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
    @IBOutlet weak var introduceLabel: UILabel!
    
    @IBOutlet weak var introduceLabelHeightConstraint: NSLayoutConstraint!
    
    private func setLabelHeight() {
        introduceLabelHeightConstraint.constant = introduceLabel.intrinsicContentSize.height
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
        if places.count == 0 {
            placeCV_height_Constarint.constant = 0
            moreButtonStackView.arrangedSubviews[1].isHidden = true
        } else if places.count <= 2 {
            placeCV_height_Constarint.constant = place_Cell_Height
            moreButtonStackView.arrangedSubviews[1].isHidden = true
        } else if places.count <= 4 {
            placeCV_height_Constarint.constant = place_Cell_Height * 2 + 4
            moreButtonStackView.arrangedSubviews[1].isHidden = true
        } else if places.count <= 6 {
            placeCV_height_Constarint.constant = place_Cell_Height * 3 + 4 * 2
            moreButtonStackView.arrangedSubviews[1].isHidden = true
        } else {
            placeCV_height_Constarint.constant = place_Cell_Height * 3 + 4 * 2
            moreButtonStackView.arrangedSubviews[1].isHidden = false
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
    
    @IBOutlet weak var moreButtonStackView: UIStackView! {
        didSet {
            moreButtonStackView.arrangedSubviews[1].isHidden = true
        }
    }
    
    @IBOutlet weak var moreButtonConatinerView: UIView!
    
    // MARK: - 포토리뷰 뷰 설정
    @IBOutlet weak var photoReviewView: PhotoReviewView! {
        didSet {
            setPhotoReviewLabel()
            photoReviewView.writeButton.isHidden = true
            photoReviewView.photoReviewCollectionViewDataSource = self
            photoReviewView.photoReviewCollectionViewDelegate = self
        }
    }
    
    var photoReviewData: [ReviewInform] = []
    
    // 포토 리뷰 데이터 받았을 때 Handler
    lazy var photoReviewHandler: ((NetworkResult<Codable>) -> Void) = { result in
        switch result {
        case .success(let getReviewResult):
            guard let getReviewResult = getReviewResult as? APISortableResponseData<ReviewInform> else { return }
            self.photoReviewData = getReviewResult.content
            DispatchQueue.main.async {
                self.photoReviewView.photoReviewCollectionView.reloadData()
                self.setPhotoReviewViewLayout()
            }
        case .requestErr(let error): print(error)
        case .serverErr: print("Server Err")
        case .networkFail:
            guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
            networkFailPopupVC.modalPresentationStyle = .overFullScreen
            self.present(networkFailPopupVC, animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var photoReviewViewHeightConstraint: NSLayoutConstraint!
    
    private func setPhotoReviewLabel() {
        let photoReviewAttributeText = "인기 많은 포토 리뷰".makeAttributedText([.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)])
        photoReviewAttributeText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], range: ("인기 많은 포토 리뷰" as NSString).range(of: "포토 리뷰"))
        photoReviewView.attributeTitle = photoReviewAttributeText
    }
    
    private func setPhotoReviewViewLayout() {
        let defaultHeight: CGFloat = 48
        let horizontalSpacing = view.frame.width / 23.44
        let cellHeight: CGFloat = (photoReviewView.frame.width - horizontalSpacing*2 - 4*2) / 3
        if photoReviewData.count == 0 { photoReviewViewHeightConstraint.constant = defaultHeight }
        else if photoReviewData.count <= 3 { photoReviewViewHeightConstraint.constant = defaultHeight + cellHeight }
        else { photoReviewViewHeightConstraint.constant = defaultHeight + 2 * cellHeight }
    }
    
    lazy var photo_Cell_Width: CGFloat = (photoReviewView.frame.width-2*horizontal_inset-2*4) / 3
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackButton()
        setLabelByLanguage()
    }
    
    private func setLabelByLanguage() {
        let attributePhotoReview = ("인기 많은".localized + " " + "포토 리뷰".localized).makeAttributedText([.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)])
        attributePhotoReview.addAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], range: ("인기 많은".localized + " " + "포토 리뷰".localized as NSString).range(of: "포토 리뷰".localized))
        photoReviewView.attributeTitle = attributePhotoReview
        
        moreButton.setTitle("더 보기".localized, for: .normal)
    }
    
    // MARK: - UIViewController viewWillApeear 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
        setNav()
    }
    
    // MARK: - UIViewController viewWillLayoutSubviews 설정
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func setCollectionViewHeight() {
        placeCV_height_Constarint.constant = place_Cell_Height * 3 + 16 * 2
    }
    
    // MARK: - Set Navigation
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.topItem?.title = ""
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        backButtonTopConstraint.constant = window.safeAreaInsets.top
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
        case .celeb:
            print("여기서 요청")
            requestCeleb(id: id)
            requestCelebPhotoReview(id: id)
        case .media:
            requestMedia(id: id)
            requestMediaPhotoReview(id: id)
        }
    }
    
    // MARK: - 유명인 API 요청
    private func requestCeleb(id: Int) {
        NetworkHandler.shared.requestAPI(apiCategory: .getCelebOfID(id)) { result in
            switch result {
            case .success(let celebResult):
                guard let celebDetail = celebResult as? CelebrityDetailDTO else { return }
                self.categoryDetailDTO = celebDetail
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
    
    // MARK: - 유명인 관련 리뷰 데이터 API 요청
    private func requestCelebPhotoReview(id: Int) {
        //        let getReviewParameter = GetReviewParameter(page: nil, size: nil, sort: nil)
        let getReviewParameter = GetReviewParameter(page: 0, size: 6, sort: "reviewLikes-count,desc")
        NetworkHandler.shared.requestAPI(apiCategory: .getReviewOfCeleb(getReviewParameter, id: id), completion: photoReviewHandler)
    }
    
    // MARK: - 미디어 관련 리뷰 데이터 API 요청
    private func requestMediaPhotoReview(id: Int) {
        //        let getReviewParameter = GetReviewParameter(page: nil, size: nil, sort: nil)
        let getReviewParameter = GetReviewParameter(page: 0, size: 6, sort: "reviewLikes-count,desc")
        NetworkHandler.shared.requestAPI(apiCategory: .getReviewOfMedia(getReviewParameter, id: id), completion: photoReviewHandler)
    }
}

extension ContentDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == placeCollectionView { return places.count }
        else { return photoReviewData.count }
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
        photoReviewCell.photoImageView.setImage(with: photoReviewData[indexPath.row].imageUrl ?? "")
        if indexPath.row == 5 { photoReviewCell.addMoreView() }
        return photoReviewCell
    }
}

extension ContentDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == placeCollectionView {
            // 장소 CollectionView 선택한 경우
            guard let placeDetailVC = UIStoryboard(name: "LocationDetail", bundle: nil).instantiateViewController(withIdentifier: LocationDetailVC.identifier) as? LocationDetailVC else { return }
            placeDetailVC.placeID = places[indexPath.row].placeId
            self.navigationController?.pushViewController(placeDetailVC, animated: true)
        } else {
            // 포로리뷰 CollectionView 선택한 경우
            guard let otherPhotoReviewVC = UIStoryboard(name: "OtherPhotoReview", bundle: nil).instantiateViewController(withIdentifier: OtherPhotoReviewVC.identifier) as? OtherPhotoReviewVC else { return }
            
            switch self.category {
            case .celeb:
                guard let id = self.id else { return }
                otherPhotoReviewVC.requestType = .celeb(id: id)
                if indexPath.row != 5 { otherPhotoReviewVC.selectedPhotoReviewID = photoReviewData[indexPath.row].reviewId }
            case .media:
                guard let id = self.id else { return }
                otherPhotoReviewVC.requestType = .media(id: id)
                if indexPath.row != 5 { otherPhotoReviewVC.selectedPhotoReviewID = photoReviewData[indexPath.row].reviewId }
            case .none:
                break
            }
            
            self.navigationController?.pushViewController(otherPhotoReviewVC, animated: true)
        }
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
