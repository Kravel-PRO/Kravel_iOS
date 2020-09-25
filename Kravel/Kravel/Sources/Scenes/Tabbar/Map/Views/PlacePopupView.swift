//
//  PlacePopupView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/29.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class PlacePopupView: UIView {
    static let nibName = "PlacePopupView"
    
    enum PopupViewState {
        case notShow
        case halfShow
        case almostShow
        case allShow
    }
    
    var showingState: PopupViewState?
    
    var delegate: PlacePopupViewDelegate?
    
    // MARK: - 전체 뷰 관리
    var view: UIView! {
        didSet {
            view.setCornerRadius(self.frame.width / 25)
        }
    }
    
    // MARK: - 팝업 뷰 Indicator 부분 설정
    @IBOutlet weak var indicatorView: UIView! {
        didSet {
            indicatorView.layer.cornerRadius = indicatorView.frame.width / 18
        }
    }
    
    // MARK: - 장소 ID
    var placeId: Int?
    
    // MARK: - 장소 Image View 설정
    @IBOutlet weak var placeImageView: UIImageView! {
        didSet {
            placeImageView.layer.cornerRadius = placeImageView.frame.width / 23
            placeImageView.clipsToBounds = true
        }
    }
    
    var placeImage: UIImage? {
        didSet {
            placeImageView.image = placeImage
        }
    }
    
    // MARK: - 장소 이름 Label 설정
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var placeName: String? {
        didSet {
            placeNameLabel.text = placeName
            placeNameLabel.sizeToFit()
        }
    }
    
    // MARK: - 장소별 태그 설정
    @IBOutlet weak var placeTagCollectionView: UICollectionView! {
        didSet {
            placeTagCollectionView.dataSource = self
            placeTagCollectionView.showsHorizontalScrollIndicator = false
            placeTagCollectionView.showsVerticalScrollIndicator = false
            placeTagCollectionView.register(BackgroundTagCell.self, forCellWithReuseIdentifier: BackgroundTagCell.identifier)
            if let layout = placeTagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                layout.minimumLineSpacing = 4
            }
        }
    }
    
    var placeTags: [String] = [] {
        didSet {
            placeTagCollectionView.reloadData()
        }
    }
    
    // MARK: - 장소 위치 Label 설정
    @IBOutlet weak var placeLocationLabel: UILabel!
    
    var placeLocation: String? {
        didSet {
            placeLocationLabel.text = placeLocation
            placeLocationLabel.sizeToFit()
        }
    }
    
    // MARK: - 카메라 버튼, 하트 버튼 StackView 설정
    @IBOutlet weak var buttonStackContainerView: UIView! {
        didSet {
            buttonStackContainerView.layer.cornerRadius = buttonStackContainerView.frame.width / 20
            buttonStackContainerView.clipsToBounds = true
            buttonStackContainerView.layer.borderWidth = 1
            buttonStackContainerView.layer.borderColor = UIColor.veryLightPink.cgColor
        }
    }
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBAction func clickPhoto(_ sender: Any) {
        delegate?.clickPhotoButton(placeId: placeId)
    }
    
    @IBAction func clickScrap(_ sender: Any) {
        delegate?.clickScrapButton()
    }
    
    // StackView 사이 나누는 화면
    private var buttonDivideView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .veryLightPink
        return view
    }()
    
    private func setDivideViewLayout() {
        NSLayoutConstraint.activate([
            buttonDivideView.centerXAnchor.constraint(equalTo: buttonStackContainerView.centerXAnchor),
            buttonDivideView.centerYAnchor.constraint(equalTo: buttonStackContainerView.centerYAnchor),
            buttonDivideView.widthAnchor.constraint(equalToConstant: 1),
            buttonDivideView.heightAnchor.constraint(equalTo: buttonStackContainerView.heightAnchor, multiplier: 0.48)
        ])
    }
    
    // MARK: - 사진 리뷰 View을 담는 Container View 설정
    @IBOutlet weak var photoReviewContainerView: PhotoReviewView! {
        didSet {
            setPhotoReviewLabel()
            photoReviewContainerView.delegate = self
            photoReviewContainerView.photoReviewCollectionViewDelegate = self
            photoReviewContainerView.photoReviewCollectionViewDataSource = self
        }
    }
    
    @IBOutlet weak var photoReviewHeightConstraint: NSLayoutConstraint!
    
    var photoReviewData: [ReviewInform] = [] {
        didSet {
            self.photoReviewContainerView.photoReviewCollectionView.reloadData()
            self.setPhotoReviewViewLayout()
        }
    }
    
    private func setPhotoReviewViewLayout() {
        let defaultHeight: CGFloat = 48
        let horizontalSpacing = view.frame.width / 23.44
        let cellHeight: CGFloat = (self.frame.width - horizontalSpacing*2 - 4*2) / 3
        if photoReviewData.count == 0 {
            photoReviewHeightConstraint.constant = defaultHeight + 35 + 75
            photoReviewContainerView.photoReviewEmptyView.isHidden = false
            photoReviewContainerView.photoReviewCollectionView.isHidden = true
        } else if photoReviewData.count <= 3 {
            photoReviewHeightConstraint.constant = defaultHeight + cellHeight + 16
            photoReviewContainerView.photoReviewEmptyView.isHidden = true
            photoReviewContainerView.photoReviewCollectionView.isHidden = false
        } else {
            photoReviewHeightConstraint.constant = defaultHeight + 2 * cellHeight + 16
            photoReviewContainerView.photoReviewEmptyView.isHidden = true
            photoReviewContainerView.photoReviewCollectionView.isHidden = false
        }
    }
    
    private func setPhotoReviewLabel() {
        let photoReviewAttributeText = "포토 리뷰".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)])
        photoReviewContainerView.attributeTitle = photoReviewAttributeText
    }
    
    // MARK: - 장소 위치를 나타내는 View을 담는 Container View 설정
    @IBOutlet weak var subLocationContainerView: SubLocationView!
    
    // MARK: - 주변 관광지 나타내는 View을 담는 Container View 설정
    @IBOutlet weak var nearByAttractionContainerView: NearByAttractionView!
    @IBOutlet weak var nearByAttractionHeightConstraint: NSLayoutConstraint!
    
    @objc func setNearAttraction(_ notification: NSNotification) {
        guard let isEmpty = notification.userInfo?["isEmpty"] as? Bool else { return }
        
        DispatchQueue.main.async {
            if isEmpty {
                self.nearByAttractionHeightConstraint.constant = 52
            } else {
                self.nearByAttractionHeightConstraint.constant = self.nearByAttractionContainerView.nearByAttractionCollectionView.frame.height + 52
            }
        }
    }
    
    // MARK: - Main ScrollView 설정
    @IBOutlet weak var contentScrollView: UIScrollView! {
        didSet {
            contentScrollView.isScrollEnabled = false
        }
    }
    
    func setEnableScroll(_ isScroll: Bool) {
        contentScrollView.isScrollEnabled = isScroll
    }
        
    // MARK: - UIView Override 부분
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setLabelByLanguage()
        buttonStackContainerView.addSubview(buttonDivideView)
        setDivideViewLayout()
        photoReviewContainerView.calculateCollectionViewHeight()
        NotificationCenter.default.addObserver(self, selector: #selector(setNearAttraction(_:)), name: .completeAttraction, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        setLabelByLanguage()
        buttonStackContainerView.addSubview(buttonDivideView)
        setDivideViewLayout()
        photoReviewContainerView.calculateCollectionViewHeight()
        NotificationCenter.default.addObserver(self, selector: #selector(setNearAttraction(_:)), name: .completeAttraction, object: nil)
    }
    
    private func loadXib() {
        self.view = loadXib(from: PlacePopupView.nibName)
        self.view.frame = self.bounds
        self.addSubview(view)
        self.bringSubviewToFront(view)
        view.isUserInteractionEnabled = true
    }
    
    func setLabelByLanguage() {
        subLocationContainerView.setLabelByLanguage()
        photoReviewContainerView.title = "포토 리뷰".localized
        nearByAttractionContainerView.titleLabel.text = "주변 관광지".localized
    }
}

extension PlacePopupView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == placeTagCollectionView { return placeTags.count }
        else { return photoReviewData.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == placeTagCollectionView { return makeTagCell(collectionView, indexPath) }
        else { return makePhotoReviewCell(collectionView, indexPath) }
    }
    
    private func makeTagCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> BackgroundTagCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundTagCell.identifier, for: indexPath) as? BackgroundTagCell else { return BackgroundTagCell() }
        tagCell.tagTitle = "#\(placeTags[indexPath.row])"
        tagCell.layer.cornerRadius = tagCell.frame.width / 7.22
        tagCell.clipsToBounds = true
        return tagCell
    }
    
    private func makePhotoReviewCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> PhotoReviewCell {
        guard let photoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReviewCell.identifier, for: indexPath) as? PhotoReviewCell else { return PhotoReviewCell() }
        photoReviewCell.photoImageView.setImage(with: photoReviewData[indexPath.row].imageUrl ?? "")
        if indexPath.row == 5 { photoReviewCell.addMoreView() }
        return photoReviewCell
    }
}

extension PlacePopupView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let placeId = self.placeId else { return }
        if indexPath.row != 5 { delegate?.clickPhotoReview(at: indexPath, placeId: placeId, selectedReviewId: photoReviewData[indexPath.row
        ].reviewId) }
        else { delegate?.clickPhotoReview(at: indexPath, placeId: placeId, selectedReviewId: nil) }
    }
}

extension PlacePopupView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpacing = self.frame.width / 23.44
        let cellWidth = (collectionView.frame.width - horizontalSpacing*2 - 4*2) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizontalSpacing = self.frame.width / 23.44
        return UIEdgeInsets(top: 0, left: horizontalSpacing, bottom: 0, right: horizontalSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension PlacePopupView: PhotoReviewViewDelegate {
    func clickWriteButton() {
        if let placeId = self.placeId { delegate?.clickPhotoUpload(at: placeId ) }
    }
}
