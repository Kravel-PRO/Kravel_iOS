//
//  CategoryTabbar.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

protocol PagingTabbarDelegate {
    func scrollToIndex(to index: Int)
}

class CategoryTabbar: UIView {
    static let nibName = "CategoryTabbar"
    
    private var view: UIView!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView! {
        didSet {
            categoryCollectionView.contentInsetAdjustmentBehavior = .never
            categoryCollectionView.dataSource = self
            categoryCollectionView.delegate = self
            categoryCollectionView.register(UINib(nibName: CategoryCell.nibName, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
            categoryCollectionView.showsHorizontalScrollIndicator = false
            categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
        }
    }
    
    var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .grapefruit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var indicatorLeadingConstaraint: NSLayoutConstraint!
    
    var delegate: PagingTabbarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        view.addSubview(indicatorView)
        setConstraint()
        categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        view.addSubview(indicatorView)
        setConstraint()
        categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
    }
    
    private func loadXib() {
        guard let view = Bundle.main.loadNibNamed(CategoryTabbar.nibName, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.view = view
        self.addSubview(view)
    }
    
    private func setConstraint() {
        indicatorLeadingConstaraint = indicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: categoryCollectionView.frame.width/2),
            indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicatorLeadingConstaraint
        ])
    }
    
    func scroll(to index: Int) {
        categoryCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: [])
    }
}

extension CategoryTabbar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return KCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        guard let category = KCategory(rawValue: indexPath.row) else { return UICollectionViewCell() }
        categoryCell.category = category.getCategoryString()
        return categoryCell
    }
}

extension CategoryTabbar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.scrollToIndex(to: indexPath.row)
//        indicatorLeadingConstaraint.constant = CGFloat(indexPath.row) * collectionView.frame.width/2
//        UIView.animate(withDuration: 0.2) {
//            self.layoutIfNeeded()
//        }
    }
}

extension CategoryTabbar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.5, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
