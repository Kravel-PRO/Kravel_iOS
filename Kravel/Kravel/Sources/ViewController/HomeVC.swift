//
//  HomeVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/13.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - 제일 위 Title View 설정
    @IBOutlet weak var titleStackView: UIStackView!
    
    // Title Label 설정
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            let attributeTitle = "색다른 여행을 만들어 줄\nKravel 장소가\n준비되어 있어요!".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 24), .foregroundColor: UIColor.white])
            attributeTitle.addAttributes([.font: UIFont(name: "AppleSDGothicNeo-Light", size: 24.0)!], range: ("색다른 여행을 만들어 줄\nKravel 장소가\n준비되어 있어요!" as NSString).range(of: "색다른 여행을 만들어 줄"))
            titleLabel.attributedText = attributeTitle
            titleLabel.sizeToFit()
        }
    }
    
    // 나와 가까운 Kravel 소개 Label
    @IBOutlet weak var closerLabel: UILabel! {
        didSet {
            let attributeTitle = "나와 가까운 Kravel".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white])
            attributeTitle.addAttributes([.font: UIFont.systemFont(ofSize: 18)], range: ("나와 가까운 Kravel" as NSString).range(of: "Kravel"))
            closerLabel.attributedText = attributeTitle
            closerLabel.sizeToFit()
        }
    }
    
    // 더 보기 버튼 이미지, Label 위치 변경
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.transform = CGAffineTransform(scaleX: -1, y: 1)
            moreButton.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
            moreButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    // 가까운 장소 CollectionView 설정
    private let nearPlaces: [String] = ["유나네 집", "호준이네 집", "우리 집", "정재네 집", "수연이네 집"]
    private let nearPlaceImage: [String] = []
    
    @IBOutlet weak var nearPlaceCollectionView: UICollectionView! {
        didSet {
            nearPlaceCollectionView.dataSource = self
            nearPlaceCollectionView.delegate = self
        }
    }
    
    // MARK: - 인기 있는 장소 설정
    @IBOutlet weak var hotPlaceLabel: UILabel! {
        didSet {
            let attributeHotPlaceText = "요즘 여기가 인기 있어요!".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 18)])
            attributeHotPlaceText.addAttributes([.font: UIFont.systemFont(ofSize: 18)], range: ("요즘 여기가 인기 있어요!" as NSString).range(of: "요즘 여기가"))
            hotPlaceLabel.attributedText = attributeHotPlaceText
            hotPlaceLabel.sizeToFit()
        }
    }
    
    // 인기있는 장소 CollectionView 설정
    private var hotPlaces: [String] = ["세림픽 돼지고기 집", "세림픽 요거트 집", "세림픽 커피집", "세림픽 소고기 집"]
    
    @IBOutlet weak var hotPlaceCollectionViewHeightConstraint: NSLayoutConstraint!
    
    func setHotPlaceCollectionViewHeight() {
        let horizontalSpacing = view.frame.width / 23.44
        let lineSpacing: CGFloat = 12
        let cellWidth = hotPlaceCollectionView.frame.width - 2*horizontalSpacing
        let cellHeight = cellWidth * 0.46
        hotPlaceCollectionViewHeightConstraint.constant = cellHeight * CGFloat(hotPlaces.count) + lineSpacing * CGFloat((hotPlaces.count-1))
    }
    
    @IBOutlet weak var hotPlaceCollectionView: UICollectionView! {
        didSet {
            hotPlaceCollectionView.dataSource = self
            hotPlaceCollectionView.delegate = self
        }
    }
    
    // MARK: - ViewController Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setHotPlaceCollectionViewHeight()
    }
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == nearPlaceCollectionView { return nearPlaces.count }
        else { return hotPlaces.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == nearPlaceCollectionView { return makeNearPlaceCell(collectionView, indexPath) }
        else { return makeHotPlaceCell(collectionView, indexPath) }
    }
    
    private func makeNearPlaceCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> HomeNearPlaceCell {
        guard let homeNearPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeNearPlaceCell.identifier, for: indexPath) as? HomeNearPlaceCell else { return HomeNearPlaceCell() }
        homeNearPlaceCell.placeName = nearPlaces[indexPath.row]
        homeNearPlaceCell.layer.cornerRadius = homeNearPlaceCell.frame.width / 15.9
        homeNearPlaceCell.clipsToBounds = true
        return homeNearPlaceCell
    }
    
    private func makeHotPlaceCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> HotPlaceCell {
        guard let hotPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotPlaceCell.identifier, for: indexPath) as? HotPlaceCell else { return HotPlaceCell() }
        hotPlaceCell.layer.cornerRadius = hotPlaceCell.frame.width / 17.15
        hotPlaceCell.clipsToBounds = true
        return hotPlaceCell
    }
}

extension HomeVC: UICollectionViewDelegate {
    
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == nearPlaceCollectionView {
            let width = collectionView.frame.height * 0.9
            return CGSize(width: width, height: collectionView.frame.height)
        } else {
            let horizontalSpacing = view.frame.width / 23.44
            let cellWidth = collectionView.frame.width - 2*horizontalSpacing
            let cellHeight = cellWidth * 0.46
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizontalSpacing = view.frame.width / 23.44
        return UIEdgeInsets(top: 0, left: horizontalSpacing, bottom: 0, right: horizontalSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


