//
//  NearByAttractionView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/25.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class NearByAttractionView: UIView {
    static let nibName = "NearbyAttractionView"
    
    var view: UIView!

    // MARK: - 주변 관광지 CollectionView 설정
    @IBOutlet weak var nearByAttractionCollectionView: UICollectionView! {
        didSet {
            nearByAttractionCollectionView.dataSource = self
            nearByAttractionCollectionView.delegate = self
            nearByAttractionCollectionView.register(NearByAttractionCell.self, forCellWithReuseIdentifier: NearByAttractionCell.identifier)
        }
    }
    
    // MARK: - 주변 관광지 데이터 설정
    var nearByAttractions: [String] = ["남산", "경복궁", "종묘"] {
        didSet {
            nearByAttractionCollectionView.reloadData()
        }
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
        self.view = loadXib(from: NearByAttractionView.nibName)
        self.view.frame = self.bounds
        self.addSubview(view)
        self.bringSubviewToFront(view)
    }
}

extension NearByAttractionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearByAttractions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nearByAttractionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByAttractionCell.identifier, for: indexPath) as? NearByAttractionCell else { return UICollectionViewCell() }
        nearByAttractionCell.nearByAttractionImage = UIImage(named: "bitmap_0")
        nearByAttractionCell.nearByAttractionName = nearByAttractions[indexPath.row]
        nearByAttractionCell.layer.cornerRadius = nearByAttractionCell.frame.width / 2
        nearByAttractionCell.clipsToBounds = true
        return nearByAttractionCell
    }
}

extension NearByAttractionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * 0.82
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
