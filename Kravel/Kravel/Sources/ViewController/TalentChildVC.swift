//
//  TalentChildVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit


class TalentChildVC: UIViewController {
    static let identifier = "TalentChildVC"
    
    private lazy var itemSpacing: CGFloat = self.view.frame.width / 21
    private lazy var horizonInset: CGFloat = self.view.frame.width / 23

    @IBOutlet weak var talentCollectionView: UICollectionView! {
        didSet {
            talentCollectionView.delegate = self
            talentCollectionView.dataSource = self
            talentCollectionView.showsVerticalScrollIndicator = false
        }
    }
    
    private let talent: [String] = ["BTS", "세븐틴", "아이유", "EXO", "레드벨벳", "트와이스", "태연", "오마이걸", "XIA(준수)", "소녀시대", "카라", "이효리"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension TalentChildVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return talent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        searchCell.profile = talent[indexPath.row]
        return searchCell
    }
}

extension TalentChildVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let eachWidth = (collectionView.frame.width-2*itemSpacing-2*horizonInset)/3
        let eachHeight = eachWidth * 1.3
        return CGSize(width: eachWidth, height: eachHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: horizonInset, bottom: 0, right: horizonInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 23
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}

extension TalentChildVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchVC_parent = self.parent as? SearchVC else { return }
        guard let detail_contentVC = self.storyboard?.instantiateViewController(identifier: ContentDetailVC.identifier) as? ContentDetailVC else { return }
        detail_contentVC.name = talent[indexPath.row]
        detail_contentVC.category = .talent
        searchVC_parent.navigationController?.pushViewController(detail_contentVC, animated: true)
    }
}
