//
//  MovieChildVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MovieChildVC: UIViewController {
    static let identifier = "MovieChildVC"
    
    private lazy var itemSpacing: CGFloat = self.view.frame.width / 21
    private lazy var horizonInset: CGFloat = self.view.frame.width / 23
    
    private let movie: [String] = ["호텔 델루나", "슬기로운 의사생활", "이태원 클라쓰", "기생충", "검색어를 입력해..", "도깨비", "킹덤", "응답하라 1997", "더킹(영원의 군주)"]
    
    @IBOutlet weak var movieCollectionView: UICollectionView! {
        didSet {
            movieCollectionView.dataSource = self
            movieCollectionView.delegate = self
            movieCollectionView.showsVerticalScrollIndicator = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension MovieChildVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        searchCell.profile = movie[indexPath.row]
        return searchCell
    }
}

extension MovieChildVC: UICollectionViewDelegate {
    
}

extension MovieChildVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-2*itemSpacing-2*horizonInset)/3, height: collectionView.frame.height / 3.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: horizonInset, bottom: 0, right: horizonInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
