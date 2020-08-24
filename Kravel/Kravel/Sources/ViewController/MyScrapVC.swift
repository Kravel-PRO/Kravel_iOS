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
    
    var scrapDatas: [String] = ["여기", "스크랩", "정보에욤", "받아가세요", "알겠죠?"]
    
    var tags: [[String]] = [["태그", "했나?"], ["여기", "아이유"], ["저긴", "유명한"], ["안녕", "좋네"], ["제주도", "청정"]]
    
    // MARK: - UIViewController Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "스크랩"
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}

extension MyScrapVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scrapDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let myScrapCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyScrapCell.identifier, for: indexPath) as? MyScrapCell else { return UICollectionViewCell() }
        myScrapCell.scrapImage = UIImage(named: "bitmap_0")
        myScrapCell.scrapText = scrapDatas[indexPath.row]
        myScrapCell.tags = tags[indexPath.row]
        return myScrapCell
    }
}

extension MyScrapVC: UICollectionViewDelegate {
    
}

extension MyScrapVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 9 - 16*2) / 2
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
        return 9
    }
}
