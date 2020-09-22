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
    
    private var talentDTO: [CelebrityDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        requestCeleb()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestCeleb()
    }
}

extension TalentChildVC {
    // MARK: - Celebrity 요청 API
    private func requestCeleb() {
        let celebRequestParameter = GetListParameter(size: nil, search: nil, page: nil)
        
        NetworkHandler.shared.requestAPI(apiCategory: .getCeleb(celebRequestParameter)) { result in
            switch result {
            case .success(let celebResult):
                guard let celebrities = celebResult as? [CelebrityDTO] else { return }
                self.talentDTO = celebrities
                print(celebrities)
                DispatchQueue.main.async {
                    self.talentCollectionView.reloadData()
                }
            case .requestErr: break
            case .serverErr: print("Server Err")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.parent?.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

extension TalentChildVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return talentDTO.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        searchCell.profile = talentDTO[indexPath.row].celebrityName
        searchCell.profileImageView.setImage(with: talentDTO[indexPath.row].imageUrl ?? "")
        searchCell.yearLabel.text = nil
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
        return UIEdgeInsets(top: 25, left: horizonInset, bottom: 25, right: horizonInset)
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
        detail_contentVC.category = .celeb
        detail_contentVC.id = talentDTO[indexPath.row].celebrityId
        detail_contentVC.hidesBottomBarWhenPushed = true
        searchVC_parent.navigationController?.pushViewController(detail_contentVC, animated: true)
    }
}
