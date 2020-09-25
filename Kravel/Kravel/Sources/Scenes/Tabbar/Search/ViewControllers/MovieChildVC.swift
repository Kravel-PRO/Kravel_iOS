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
    
    private var mediaDTO: [MediaDTO] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMedia()
    }
}

extension MovieChildVC {
    // MARK: - Media 요청 API
    private func requestMedia() {
        let mediaRequestParameter = GetListParameter(size: 100, search: nil, page: nil)
        
        NetworkHandler.shared.requestAPI(apiCategory: .getMedia(mediaRequestParameter)) { result in
            switch result {
            case .success(let mediaResult):
                guard let medias = mediaResult as? [MediaDTO] else { return }
                self.mediaDTO = medias
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
            case .requestErr: break
            case .serverErr: print("ServerErr")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.parent?.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

extension MovieChildVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaDTO.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        searchCell.profile = mediaDTO[indexPath.row].title
        searchCell.year = "\(mediaDTO[indexPath.row].year)"
        searchCell.profileImageView.setImage(with: mediaDTO[indexPath.row].imageUrl ?? "")
        
        searchCell.profileImageView.layer.cornerRadius = searchCell.frame.width/2
        searchCell.clipsToBounds = true
        return searchCell
    }
}

extension MovieChildVC: UICollectionViewDelegateFlowLayout {
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

extension MovieChildVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchVC_parent = self.parent as? SearchVC else { return }
        guard let detail_contentVC = self.storyboard?.instantiateViewController(identifier: ContentDetailVC.identifier) as? ContentDetailVC else { return }
        detail_contentVC.category = .media
        detail_contentVC.id = mediaDTO[indexPath.row].mediaId
        detail_contentVC.hidesBottomBarWhenPushed = true
        searchVC_parent.navigationController?.pushViewController(detail_contentVC, animated: true)
    }
}
