//
//  SearchVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/13.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    // MARK: - Search Bar 부분 설정
    @IBOutlet weak var searchBarView: UIView! {
        didSet {
            searchBarView.layer.cornerRadius = searchBarView.frame.width / 15
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    // MARK: - 밑의 Tabbar 부속 뷰 생성
    var childVCs: [UIViewController] = [] {
        didSet {
            childVCs.forEach { vc in
                // Self의 자식으로 등록
                self.addChild(vc)
                // 자식의 부모로 등록
                vc.didMove(toParent: self)
            }
        }
    }
    
    // MARK: - Category 탭바 설정
    @IBOutlet weak var categoryTabbarView: CategoryTabbar! {
        didSet {
            categoryTabbarView.delegate = self
        }
    }
    
    // MARK: - Category 별 내용 나타내는 CollectionView 설정
    @IBOutlet weak var pageCollectionView: UICollectionView! {
        didSet {
            pageCollectionView.dataSource = self
            pageCollectionView.delegate = self
            pageCollectionView.showsHorizontalScrollIndicator = false
            pageCollectionView.isPagingEnabled = true
        }
    }
    
    // MARK: - 최근 검색어 View 설정
    var recentResearchView: RecentResearchView! = {
        let view = RecentResearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private func setRecentResearchView() {
        self.view.addSubview(recentResearchView)
    }
    
    private func setRecentViewConstraint() {
        NSLayoutConstraint.activate([
            recentResearchView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            recentResearchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            recentResearchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            recentResearchView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Core Data에서 최근 검색어 가져오기
    private var researchLastIndex: Int32?
    
    // 최근 검색어 Core Data로부터 불러오기
    // 마지막 Index 번호 설정
    private func getRecentResearchTerms() {
        let recentResearhTerms = CoreDataManager.shared.loadFromCoreData(request: RecentResearchTerm.fetchRequest())
        recentResearchView.recentResearchs = recentResearhTerms
        if let lastIndex = recentResearhTerms.last?.index {
            researchLastIndex = lastIndex
        } else {
            researchLastIndex = nil
        }
    }
    
    // MARK: - UIViewController Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setRecentResearchView()
        getRecentResearchTerms()
    }
    
    private func createChildVC(by identifier: String) -> UIViewController? {
        return storyboard?.instantiateViewController(identifier: identifier)
    }
    
    private func initChildVCs() {
        guard let talentVC = createChildVC(by: TalentChildVC.identifier) else { return }
        guard let movieVC = createChildVC(by: MovieChildVC.identifier) else { return }
        childVCs = [
            talentVC,
            movieVC
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        initChildVCs()
        pageCollectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setRecentViewConstraint()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeChildVC()
    }
    
    private func removeChildVC() {
        childVCs.forEach { childVC in
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
        childVCs.removeAll()
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        recentResearchView.isHidden = false
    }
    
    // 검색 버튼을 눌렀을 때,
    // 1. 키보드 내려가는 액션
    // 2. 최근 검색어 보여주는 화면 없어지기
    // 3. CoreData에 검색어 저장하기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, text != "" {
            if let lastIndex = self.researchLastIndex {
                self.researchLastIndex = lastIndex + 1
                CoreDataManager.shared.saveRecentSearch(term: text, date: Date(), index: lastIndex+1) { isCompletion in
                    if isCompletion {
                        self.recentResearchView.recentResearchs = CoreDataManager.shared.loadFromCoreData(request: RecentResearchTerm.fetchRequest())
                    }
                }
            } else {
                self.researchLastIndex = 0
                CoreDataManager.shared.saveRecentSearch(term: text, date: Date(), index: 0) { isCompletion in
                    if isCompletion {
                        self.recentResearchView.recentResearchs = CoreDataManager.shared.loadFromCoreData(request: RecentResearchTerm.fetchRequest())
                    }
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return KCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let pagingCell = collectionView.dequeueReusableCell(withReuseIdentifier: PagingViewCell.identifier, for: indexPath) as? PagingViewCell else { return UICollectionViewCell() }
        // 새로운 셀에 view을 등록
        childVCs[indexPath.row].view.frame = collectionView.bounds
        pagingCell.childView = childVCs[indexPath.row].view
        return pagingCell
    }
}

extension SearchVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        categoryTabbarView.indicatorLeadingConstaraint.constant = scrollView.contentOffset.x / 2
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        categoryTabbarView.scroll(to: page)
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
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

extension SearchVC: PagingTabbarDelegate {
    func scrollToIndex(to index: Int) {
        pageCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}
