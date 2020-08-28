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
    
    // MARK: - 포토리뷰 CollectionView 설정
    @IBOutlet weak var photoReviewCollectionView: UICollectionView! {
        didSet {
            photoReviewCollectionView.dataSource = self
            photoReviewCollectionView.delegate = self
        }
    }
    
    // MARK: - 포토리뷰 데이터 설정
    var photoReviewDatas: [String] = ["호텔 세느장", "그 밖에 더 있다", "여긴 어딜까?"]
    
    // MARK: - 포토리뷰 없을 때, 화면 설정
    var noPhotoReviewView: UIView = {
        let tempView = UIView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
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
        noPhotoReviewLabel.text = "포토 리뷰를 올리고\n나만의 여행 앨범을 꾸며봐요!"
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
        setNoPhotoReviewView()
        if isEmptyPhotoReview() { print("Empty View") }
    }
    
    private func isEmptyPhotoReview() -> Bool {
        if photoReviewDatas.count == 0 {
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
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "내 포토리뷰"
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

extension MyPhotoReviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReviewDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let myPhotoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPhotoReviewCell.identifier, for: indexPath) as? MyPhotoReviewCell else { return UICollectionViewCell() }
        myPhotoReviewCell.locationName = photoReviewDatas[indexPath.row]
        myPhotoReviewCell.likeCount = 99
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
