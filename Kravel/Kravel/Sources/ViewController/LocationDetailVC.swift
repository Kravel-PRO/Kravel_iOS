//
//  LocationDetailVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class LocationDetailVC: UIViewController {
    // MARK: - 뒤로 가기 버튼 설정
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    
    private func setBackButtonConstraint() {
        backButtonTopConstraint.constant = self.view.safeAreaInsets.top
    }
    
    @IBAction func dismissView(_ sender: Any) {
        print("dismiss")
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
            tagCollectionView.delegate = self
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
    @IBOutlet weak var photoReviewView: PhotoReviewView!
    
    // MARK: - 위치 정보 나타내는 뷰 설정
    @IBOutlet weak var subLocationView: SubLocationView!
    
    // MARK: - ViewController Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setBackButtonConstraint()
    }
}

extension LocationDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return makeTagCell(collectionView, indexPath)
    }
    
    private func makeTagCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> BackgroundTagCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundTagCell.identifier, for: indexPath) as? BackgroundTagCell else { return BackgroundTagCell() }
        tagCell.tagTitle = "#\(placeTags[indexPath.row])"
        tagCell.layer.cornerRadius = tagCell.frame.width / 7.22
        tagCell.clipsToBounds = true
        return tagCell
    }
}

extension LocationDetailVC: UICollectionViewDelegate {
    
}
