//
//  ContentDetailVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/15.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class ContentDetailVC: UIViewController {
    static let identifier = "ContentDetailVC"
    
    @IBOutlet weak var thumbnail_imageView: UIImageView!
    
    
    // MARK: - 연예인/드라마 별 Label 지정
    @IBOutlet weak var introduceLabel: UILabel! {
        willSet {
            guard let informStr = self.informStr, let name = self.name else { return }
            newValue.attributedText = createAttributeString(of: informStr, highlightPart: name)
            newValue.sizeToFit()
            newValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    var informStr: String?
    
    var category: KCategory? {
        didSet {
            guard let category = category else { return }
            guard let name = self.name else { return }
            switch category {
            case .talent: informStr = "\(name)가\n다녀간 곳은 어딜까요?"
            case .move: informStr = "\(name)\n촬영지가 어딜까요?"
            }
        }
    }
    
    var name: String?
    
    // MARK: - CollectionView 설정
    @IBOutlet weak var placeCollectionView: UICollectionView! {
        didSet {
            placeCollectionView.dataSource = self
            placeCollectionView.delegate = self
        }
    }
    
    @IBOutlet weak var placeCV_height_Constarint: NSLayoutConstraint!
    
    lazy var horinzontal_inset: CGFloat = placeCollectionView.frame.width / 23
    lazy var item_Spacing: CGFloat = placeCollectionView.frame.width / 54
    lazy var cell_Width: CGFloat = (placeCollectionView.frame.width-2*horinzontal_inset-item_Spacing) / 2
    lazy var cell_height: CGFloat = cell_Width * (159/169)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    
    // MARK: - View Auto Layout 설정
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLabelHeight()
        setCollectionViewHeight()
    }
    
    private func setLabelHeight() {
        let size = introduceLabel.sizeThatFits(CGSize(width: self.view.frame.width, height: 100))
        introduceLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    private func setCollectionViewHeight() {
        placeCV_height_Constarint.constant = cell_height * 3 + 16 * 2
    }
    
    // MARK: - Set Navigation
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        self.setTransparentNav()
    }
    
    private func createAttributeString(of str: String, highlightPart: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: str, attributes: [.foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0), .font: UIFont.systemFont(ofSize: 24)])
        attributeString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: (str as NSString).range(of: highlightPart))
        return attributeString
    }
}


extension ContentDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let placeCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCell.identifier, for: indexPath) as? PlaceCell else { return UICollectionViewCell() }
        placeCell.placeImage = UIImage(named: "bitmap_1")
        placeCell.tags = ["낭만적", "바람이부는", "상쾌한"]
        placeCell.placeName = "여기는 어디?"
        return placeCell
    }
}

extension ContentDetailVC: UICollectionViewDelegate {
    
}

extension ContentDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-2*horinzontal_inset-item_Spacing) / 2
        let height = width * (159/169)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: horinzontal_inset, bottom: 0, right: horinzontal_inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return item_Spacing
    }
}
