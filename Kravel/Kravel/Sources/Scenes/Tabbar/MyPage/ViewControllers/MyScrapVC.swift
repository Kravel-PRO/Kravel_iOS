//
//  MyScrapVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/24.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MyScrapVC: UIViewController {
    static let identifier = "MyScrapVC"

    // MARK: - 스크랩 CollectionView 설정
    @IBOutlet weak var scrapCollectionView: UICollectionView! {
        didSet {
            scrapCollectionView.dataSource = self
            scrapCollectionView.delegate = self
        }
    }
    
    // MARK: - 스크랩 데이터 설정
    var scrapData: [PlaceContentInform] = []
    
    // MARK: - 스크랩 데이터 없을 때 뷰
    var noScrapView: UIView = {
        let tempView = UIView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    var noScrapStackView: UIStackView = {
        let tempView = UIStackView()
        tempView.alignment = .center
        tempView.distribution = .fill
        tempView.axis = .vertical
        tempView.spacing = 16
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        let noScrapImage = UIImageView(image: UIImage(named: ImageKey.icNoScrap))
        noScrapImage.contentMode = .scaleAspectFill
        noScrapImage.translatesAutoresizingMaskIntoConstraints = false
        
        let noScrapLabel = UILabel()
        noScrapLabel.numberOfLines = 0
        noScrapLabel.font = UIFont.systemFont(ofSize: 16)
        noScrapLabel.textColor = .veryLightPink
        noScrapLabel.textAlignment = .center
        noScrapLabel.text = "아직 스크랩 한 장소가 없어요.\n가고 싶은 장소를 스크랩해보세요!"
        noScrapLabel.sizeToFit()
        
        tempView.addArrangedSubview(noScrapImage)
        tempView.addArrangedSubview(noScrapLabel)
        return tempView
    }()
    
    // 스크랩 된 데이터가 없을 때, 표시하는 View 초기화
    private func setNoScrapView() {
        self.view.addSubview(noScrapView)
        noScrapView.addSubview(noScrapStackView)
    }
    
    // 스크랩 된 데이터 없을 때, View Layout 초기화
    private func setNoScrapViewLayout() {
        NSLayoutConstraint.activate([
            noScrapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            noScrapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            noScrapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            noScrapView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.86),
            noScrapStackView.centerXAnchor.constraint(equalTo: noScrapView.centerXAnchor),
            noScrapStackView.centerYAnchor.constraint(equalTo: noScrapView.centerYAnchor),
            noScrapStackView.arrangedSubviews[0].widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2),
            noScrapStackView.arrangedSubviews[0].heightAnchor.constraint(equalTo: noScrapStackView.arrangedSubviews[0].widthAnchor, multiplier: 0.8)
        ])
    }
    
    // MARK: - UIViewController viewDidLoad() 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNoScrapView()
        if isEmptyScrap() { print("EmptyView") }
    }
    
    private func isEmptyScrap() -> Bool {
        if scrapData.count == 0 {
            noScrapView.isHidden = false
            scrapCollectionView.isHidden = true
            return true
        } else {
            noScrapView.isHidden = true
            scrapCollectionView.isHidden = false
            return false
        }
    }
    
    // MARK: - UIViewController viewWillAppear() 부분
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
        requestMyScrap()
    }
    
    private func setNav() {
        let backImage = UIImage(named: ImageKey.back)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "스크랩".localized
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)]
    }
    
    // MARK: - UIViewController viewWillLayoutSubviews() 부분
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setNoScrapViewLayout()
    }
}

extension MyScrapVC {
    // MARK: - 내 스크랩 요청하는 API
    private func requestMyScrap() {
        let getScrapParameter = GetReviewParameter(page: nil, size: nil, sort: nil)
        
        NetworkHandler.shared.requestAPI(apiCategory: .getMyScrap(getScrapParameter)) { result in
            switch result {
            case .success(let placeData):
                guard let placeData = placeData as? APISortableResponseData<PlaceContentInform> else { return }
                self.scrapData = placeData.content
                DispatchQueue.main.async {
                    if self.isEmptyScrap() { print("empty") }
                    self.scrapCollectionView.reloadData()
                }
            case .requestErr:
                print("request Err")
            case .serverErr:
                print("server Err")
            case .networkFail:
                print("NetworkFail")
            }
        }
    }
}

extension MyScrapVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scrapData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let myScrapCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyScrapCell.identifier, for: indexPath) as? MyScrapCell else { return UICollectionViewCell() }
        myScrapCell.scrapImageView.setImage(with: scrapData[indexPath.row].imageUrl ?? "")
        myScrapCell.scrapText = scrapData[indexPath.row].title
        if let tags = scrapData[indexPath.row].tags?.split(separator: " ").map(String.init) {
            myScrapCell.tags = tags
        } else {
            myScrapCell.tags = []
        }
        return myScrapCell
    }
}

extension MyScrapVC: UICollectionViewDelegate {
    
}

extension MyScrapVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 8 - 16*2) / 2
        let height = width * 0.92
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
