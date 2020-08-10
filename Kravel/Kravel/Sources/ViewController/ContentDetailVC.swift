//
//  ContentDetailVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/15.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class ContentDetailVC: UIViewController {
    static let identifier = "ContentDetailVC"
    
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
        willSet {
            guard let informStr = self.informStr, let name = self.name else { return }
            newValue.attributedText = createAttributeString(of: informStr, highlightPart: name)
            newValue.sizeToFit()
            newValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var informStr: String?
    var name: String?
    var category: KCategory? {
        didSet {
            guard let category = category else { return }
            guard let name = self.name else { return }
            switch category {
            case .talent: informStr = "\(name)가\n다녀간 곳은 어딜까요?"
            case .move: informStr = "\(name)\n촬영지가 어딜까요?"
            }
        }
    }
    
    // MARK: - 포토리뷰 View 설정
    @IBOutlet weak var photoReviewLabel: UILabel! {
        didSet {
            photoReviewLabel.attributedText = "인기 많은 포토 리뷰".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 18)], of: "포토 리뷰")
            photoReviewLabel.sizeToFit()
            photoReviewLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Button 설정
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.layer.borderColor = UIColor.veryLightPink.cgColor
            moreButton.layer.borderWidth = 1
            moreButton.layer.cornerRadius = moreButton.frame.width / 15
        }
    }
    
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
    
    lazy var photo_Item_Spacing: CGFloat = photoReviewView.frame.width / 75
    lazy var photo_Cell_Width: CGFloat = (photoReviewView.frame.width-2*horizontal_inset-2*photo_Item_Spacing) / 3
    
    // MARK: - View 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    // MARK: - View Auto Layout 설정
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLabelHeight()
        setCollectionViewHeight()
    }
    
    private func setLabelHeight() {
        let size = introduceLabel.sizeThatFits(CGSize(width: self.view.frame.width, height: 100))
        introduceLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
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

extension ContentDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == placeCollectionView { return createPlaceCell(of: collectionView, at: indexPath) }
        else { return createPhotoReviewCell(of: collectionView, at: indexPath) }
    }
    
    private func createPlaceCell(of collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let placeCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCell.identifier, for: indexPath) as? PlaceCell else { return UICollectionViewCell() }
        placeCell.placeImage = UIImage(named: "IMG_1136")
        placeCell.tags = ["낭만적", "바람이부는", "상쾌한"]
        placeCell.placeName = "여기는 어디?"
        return placeCell
    }
    
    private func createPhotoReviewCell(of collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReviewCell.identifier, for: indexPath) as? PhotoReviewCell else { return UICollectionViewCell() }
        photoReviewCell.photoImage = UIImage(named: "bitmap_0")
        return photoReviewCell
    }
}

extension ContentDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == placeCollectionView { return CGSize(width: place_Cell_Width, height: place_Cell_Height) }
        else { return CGSize(width: photo_Cell_Width, height: photo_Cell_Width) }
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
        else { return photo_Item_Spacing }
    }
}
