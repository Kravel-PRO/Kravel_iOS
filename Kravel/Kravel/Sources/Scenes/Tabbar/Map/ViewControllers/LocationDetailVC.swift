//
//  LocationDetailVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import Lottie

class LocationDetailVC: UIViewController {
    static let identifier = "LocationDetailVC"
    
    // MARK: - 화면 Dismiss 해주는 Pan Gesture
    var panGesture: UIPanGestureRecognizer!
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    private var animationView: AnimationView?
    
    private func showLoadingLottie() {
        animationView = AnimationView(name: "loading")
        animationView?.backgroundColor = .white
        animationView?.contentMode = .scaleAspectFit
        animationView?.frame = self.view.bounds
        animationView?.play()
        
        self.view.addSubview(animationView!)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(removeView), userInfo: nil, repeats: false)
    }
    
    @objc func removeView() {
        animationView?.removeFromSuperview()
        animationView = nil
    }
    
    // MARK: - 전체 Content 나타내는 ScrollView
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    // MARK: - 뒤로 가기 버튼 설정
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    
    private func setBackButtonConstraint() {
        backButtonTopConstraint.constant = self.view.safeAreaInsets.top
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - 장소 이미지 설정
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
    
    // MARK: - 태그 CollectionView 설정
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            tagCollectionView.dataSource = self
            if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                layout.minimumLineSpacing = 4
            }
        }
    }
    
    var placeTags: [String] = ["호텔 델루나", "아이유", "여진구"]
    
    // MARK: - 장소 위치 Label 설정
    @IBOutlet weak var placeLocationLabel: UILabel!
    
    var location: String? {
        didSet {
            placeLocationLabel.text = location
            placeLocationLabel.sizeToFit()
        }
    }
    
    // MARK: - 사진 찍기 / 스크랩 버튼 담는 영역
    @IBOutlet weak var buttonStackContainerView: UIView! {
        didSet {
            buttonStackContainerView.layer.cornerRadius = buttonStackContainerView.frame.width / 20
            buttonStackContainerView.clipsToBounds = true
            buttonStackContainerView.layer.borderWidth = 1
            buttonStackContainerView.layer.borderColor = UIColor.veryLightPink.cgColor
        }
    }
    
    // MARK: - 포토 리뷰 뷰 설정
    @IBOutlet weak var photoReviewView: PhotoReviewView! {
        didSet {
            setPhotoReviewLabel()
            photoReviewView.photoReviewCollectionViewDataSource = self
            photoReviewView.photoReviewCollectionViewDelegate = self
        }
    }
    
    var photoReviewData: [String] = ["아아", "여기 장소", "너무 좋다", "여기도 좋네?", "여기도 와봐", "오 여기도?"]
    
    private func setPhotoReviewLabel() {
        let photoReviewAttributeText = "포토 리뷰".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)])
        photoReviewView.attributeTitle = photoReviewAttributeText
    }
    
    // MARK: - 위치 정보 나타내는 뷰 설정
    @IBOutlet weak var subLocationView: SubLocationView!
    
    // MARK: - 내 주변 관광지 뷰 설정
    @IBOutlet weak var nearByAttractionView: NearByAttractionView!
    
    // MARK: - UIViewController viewDidLoad() Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addGesture()
    }
    
    // MARK: - UIViewController viewWillLayoutSubviews() Override 부분
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setBackButtonConstraint()
    }
    
    // MARK: - UIViewController viewWillAppear() Override 부분
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // FIXME: ViewDidLoad로 네트워크 요청 작업 시, 부르게 수정
        showLoadingLottie()
    }
}

extension LocationDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView { return placeTags.count }
        else { return photoReviewData.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView { return makeTagCell(collectionView, indexPath) }
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
        
        photoReviewCell.photoImage = UIImage(named: "yuna2")
        if indexPath.row == 5 { photoReviewCell.addMoreView() }
        return photoReviewCell
    }
}

extension LocationDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpacing = self.view.frame.width / 23.44
        let cellWidth = (collectionView.frame.width - horizontalSpacing*2 - 4*2) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizontalSpacing = self.view.frame.width / 23.44
        return UIEdgeInsets(top: 0, left: horizontalSpacing, bottom: 0, right: horizontalSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension LocationDetailVC: UICollectionViewDelegate {
}

extension LocationDetailVC: UIGestureRecognizerDelegate {
    // MARK: - 화면 Dismissg하는 Pan Gesture 등록
    func addGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panningView(_:)))
        panGesture.delegate = self
        contentScrollView.addGestureRecognizer(panGesture)
    }
    
    @objc func panningView(_ gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: self.view)
        let changeY: CGFloat = transition.y + self.view.transform.ty
        
        if contentScrollView.contentOffset.y <= 0 {
            self.view.transform = CGAffineTransform(translationX: 0, y: changeY)
            contentScrollView.contentOffset = .zero
        }
        
        if self.view.transform.ty > 0 && contentScrollView.contentOffset.y > 0 {
            self.view.transform = CGAffineTransform(translationX: 0, y: changeY)
            contentScrollView.contentOffset = .zero
        }
        
        if self.view.transform.ty < 0 {
            self.view.transform = .identity
        }
        
        if panGesture.state == .ended && changeY > 100 {
            self.dismiss(animated: false, completion: nil)
            NotificationCenter.default.post(name: .dismissDetailView, object: nil)
        } else if panGesture.state == .ended && changeY <= 100 {
            UIView.animate(withDuration: 0.3) {
                self.view.transform = .identity
            }
        }
        
        gesture.setTranslation(.zero, in: self.view)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
