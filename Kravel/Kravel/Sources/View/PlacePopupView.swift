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
    
    var view: UIView! {
        didSet {
            view.setCornerRadius(self.frame.width / 25)
        }
    }
    
    func addGestureInXib(_ gesture: UIGestureRecognizer) {
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - 팝업 뷰 Indicator 부분 설정
    @IBOutlet weak var indicatorView: UIView! {
        didSet {
            indicatorView.layer.cornerRadius = indicatorView.frame.width / 18
        }
    }
    
    // MARK: - 장소 Image View 설정
    @IBOutlet weak var placeImageView: UIImageView!
    
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
    
    // MARK: - 장소 위치 Label 설정
    @IBOutlet weak var placeLocationLabel: UILabel!
    
    var placeLocation: String? {
        didSet {
            placeNameLabel.text = placeLocation
            placeNameLabel.sizeToFit()
        }
    }
    
    // MARK: - 카메라 버튼, 하트 버튼 StackView 설정
    @IBOutlet weak var buttonStackContainerView: UIView! {
        didSet {
            buttonStackContainerView.layer.cornerRadius = buttonStackContainerView.frame.width / 20
            buttonStackContainerView.clipsToBounds = false
            buttonStackContainerView.layer.borderWidth = 1
            buttonStackContainerView.layer.borderColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0).cgColor
        }
    }
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    // MARK: - 사진 리뷰 View을 담는 Container View 설정
    @IBOutlet weak var photoReviewContainerView: PhotoReviewView!
    
    // MARK: - 장소 위치를 나타내는 View을 담는 Container View 설정
    @IBOutlet weak var SubLocationContainerView: SubLocationView!
    
    // MARK: - Main ScrollView 설정
    @IBOutlet weak var contentScrollView: UIScrollView! {
        didSet {
            contentScrollView.isUserInteractionEnabled = false
            contentScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        }
    }
    
    func setEnableScroll(_ isScroll: Bool) {
        contentScrollView.isScrollEnabled = isScroll
    }
    
    private func calculateInset() {
        
    }
        
    // MARK: - UIView Override 부분
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    private func loadXib() {
        self.view = loadXib(from: PlacePopupView.nibName)
        self.view.frame = self.bounds
        self.addSubview(view)
        self.bringSubviewToFront(view)
        view.isUserInteractionEnabled = true
    }
}
