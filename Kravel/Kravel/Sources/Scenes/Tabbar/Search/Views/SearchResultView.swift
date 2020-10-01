//
//  SearchResultView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/08.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SearchResultView: UIView {
    static let nibName = "SearchResultView"
    
    var view: UIView!
    var delegate: SearchResultViewDelegate?
    
    // MARK: - 화면 Layout 크기 설정
    private lazy var itemSpacing: CGFloat = self.view.frame.width / 21
    private lazy var horizonInset: CGFloat = self.view.frame.width / 23
    
    // MARK: - 윗 부분 설정해주는 화면
    @IBOutlet weak var topMarginView: UIView!
    @IBOutlet weak var resultDescriptionLabel: UILabel!
    @IBOutlet weak var resultEmptyLabel: UILabel!
    
    // MARK: - 검색 결과가 없는 경우 화면
    @IBOutlet weak var emptyResultView: UIView! {
        didSet {
            emptyResultView.isHidden = true
        }
    }
    
    // MARK: - 검색 결과 보여주는 CollectionView 설정
    lazy var searchResultCollectionView: UICollectionView = {
        let searchResultCollectionView = UICollectionView(frame: CGRect(x: 0, y: topMarginView.frame.maxY, width: self.frame.width, height: self.frame.height - topMarginView.frame.height), collectionViewLayout: makeCollectionViewLayout())
        searchResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchResultCollectionView.register(K_SearchResultCell.self, forCellWithReuseIdentifier: K_SearchResultCell.identifier)
        searchResultCollectionView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.25)
        searchResultCollectionView.isHidden = true
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.delegate = self
        return searchResultCollectionView
    }()
    
    private func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (self.view.frame.width - 2*horizonInset - 2*itemSpacing) / 3
        let height = width*1.3
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 25, left: horizonInset, bottom: 25, right: horizonInset)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = 23
        return layout
    }
    
    private func setResultCollectionViewLayout() {
        NSLayoutConstraint.activate([
            searchResultCollectionView.topAnchor.constraint(equalTo: topMarginView.bottomAnchor),
            searchResultCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchResultCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchResultCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setResultCollectionView() {
        self.addSubview(searchResultCollectionView)
        
        if let layout = searchResultCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (searchResultCollectionView.frame.width - 2*horizonInset - 2*itemSpacing) / 3
            let height = width*1.3
            layout.itemSize = CGSize(width: width, height: height)
            layout.sectionInset = UIEdgeInsets(top: 25, left: horizonInset, bottom: 25, right: horizonInset)
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = itemSpacing
            layout.minimumLineSpacing = 23
        }
    }
    
    // MAKR: - 검색 결과 설정하는 데이터
    var searchResult: [SearchAble] = [] {
        didSet {
            setVisible(by: searchResult.isEmpty)
            searchResultCollectionView.reloadData()
        }
    }
    
    var searchResultDTO: SearchResultDTO? {
        didSet {
            var searchTotal: [SearchAble] = []
            searchResultDTO?.celebrities.forEach { searchTotal.append($0) }
            searchResultDTO?.medias.forEach { searchTotal.append($0) }
            searchResult = searchTotal
        }
    }
    
    func setVisible(by isEmpty: Bool) {
        if isEmpty {
            emptyResultView.isHidden = false
            searchResultCollectionView.isHidden = true
        } else {
            emptyResultView.isHidden = true
            searchResultCollectionView.isHidden = false
        }
    }
    
    // MARK: - UIView Override 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setResultCollectionView()
        setResultCollectionViewLayout()
        setLabelByLanguage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        setResultCollectionView()
        setResultCollectionViewLayout()
        setLabelByLanguage()
    }
    
    private func loadXib() {
        self.view = loadXib(from: SearchResultView.nibName)
        self.view.frame = self.bounds
        self.addSubview(view)
        self.bringSubviewToFront(view)
    }
    
    func setLabelByLanguage() {
        resultEmptyLabel.text = "검색 결과가 없습니다.\n검색어를 다시 한 번 확인해주세요.".localized
        resultDescriptionLabel.text = "검색 결과".localized
    }
}

extension SearchResultView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchResultCell = collectionView.dequeueReusableCell(withReuseIdentifier: K_SearchResultCell.identifier, for: indexPath) as? K_SearchResultCell else { return UICollectionViewCell() }
        
        if let media = searchResult[indexPath.row] as? MediaDTO {
            searchResultCell.searchImageView.setImage(with: media.imageUrl ?? "")
            searchResultCell.name = media.title
            if let year = media.year {
                searchResultCell.year = year
            } else {
                searchResultCell.year = ""
            }
        }
        
        if let celeb = searchResult[indexPath.row] as? CelebrityDTO {
            searchResultCell.searchImageView.setImage(with: celeb.imageUrl ?? "")
            searchResultCell.name = celeb.celebrityName
        }
        return searchResultCell
    }
}

extension SearchResultView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.click(searchData: searchResult[indexPath.row])
    }
}
