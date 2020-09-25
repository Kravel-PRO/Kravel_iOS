//
//  SearchVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/13.
//  Copyright © 2020 윤동민. All rights reserved.
//

// FIXME: 이거 최근 검색어 저장하는 로직 지금 문제있음.

import UIKit

protocol RecentResearchCoreDataUsable {
    func saveRecentResearch(term: String, date: Date, index: Int32)
}

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
    
    // MARK: - 뒤로가기 버튼
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.isHidden = true
        }
    }
    
    // 최근 검색 뷰 없앰
    @IBAction func clickBackButton(_ sender: Any) {
        self.view.endEditing(true)
        if searchResultView.superview != nil {
            searchResultView.removeFromSuperview()
        } else {
            backButton.isHidden = true
            recentResearchView.isHidden = true
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // 검색어 내용 검색
    @IBAction func search(_ sender: Any) {
        guard let search = searchTextField.text, search != "" else { return }
        request(searchText: search)
        
        searchText(searchTextField)
    }
    
    // textField 내용 바탕으로 검색 실행
    // 1. Core Data에 해당 검색어 저장
    // 2. 검색 내용 화면에 띄우기
    private func searchText(_ textField: UITextField) {
        textField.resignFirstResponder()
        var curLastIndex: Int32
        if let text = textField.text, text != "" {
            textField.text = ""
            if let lastIndex = self.researchLastIndex {
                // 최근 검색어에 데이터가 있는 경우
                // *** 마지막 인덱스 + 1의 값에 데이터 저장
                curLastIndex = lastIndex + 1
            } else {
                // 최근 검색어에 데이터가 0개인 경우
                // *** 0으로 Index 초기화 최초 데이터 생성 ***
                curLastIndex = 0
            }
            
            // 1. 마지막 Index 저장
            // 2. 해당 text, index로 최근 검색어 생성하고 Core Data에 저장
            // 3. 저장 성공하면 저장된 데이터 불러와서 뷰에 업데이트
            self.researchLastIndex = curLastIndex
            saveRecentResearch(term: text, date: Date(), index: curLastIndex)
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
    lazy var recentResearchView: RecentResearchView = {
        let view = RecentResearchView(frame: CGRect(x: 0, y: searchBarView.frame.maxY, width: self.view.frame.width, height: categoryTabbarView.frame.height + pageCollectionView.frame.height + 16))
        if let tabbar = self.tabBarController?.tabBar {
            view.originalHeight = self.view.frame.height-tabbar.frame.height-searchBarView.frame.height
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private func setRecentResearchView() {
        recentResearchView.delegate = self
        self.view.addSubview(recentResearchView)
    }
    
    private func setRecentViewConstraint() {
        NSLayoutConstraint.activate([
            recentResearchView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            recentResearchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            recentResearchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            recentResearchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    // MARK: - Core Data에서 최근 검색어 가져오기
    private var researchLastIndex: Int32?
    
    // 최근 검색어 Core Data로부터 불러오기
    // 마지막 Index 번호 설정
    private func getRecentResearchTerms() {
        let recentResearhTerms = CoreDataManager.shared.loadFromCoreData(request: RecentResearchTerm.fetchRequest())
        recentResearchView.reloadRecentResearchs(recentResearhTerms)
        
        if let lastIndex = recentResearhTerms.last?.index {
            researchLastIndex = lastIndex
        } else {
            researchLastIndex = nil
        }
    }
    
    // MARK: - 검색 결과  View 설정
    lazy var searchResultView: SearchResultView = {
        let searchResultView = SearchResultView(frame: CGRect(x: 0, y: searchBarView.frame.maxY, width: self.view.frame.width, height: categoryTabbarView.frame.height + pageCollectionView.frame.height + 16))
        searchResultView.delegate = self
        searchResultView.translatesAutoresizingMaskIntoConstraints = false
        return searchResultView
    }()
    
    private func setSearchResultViewLayout() {
        NSLayoutConstraint.activate([
            searchResultView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            searchResultView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchResultView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchResultView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    // MARK: - UIViewController viewDidLoad Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLabelByLanguage()
        setRecentResearchView()
        getRecentResearchTerms()
        addObserver()
        initChildVCs()
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
    
    // MARK: - UIViewController viewWillAppear Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLabelByLanguage() {
        searchTextField.placeholder = "연예인, 드라마 등을 검색해주세요.".localized
        recentResearchView.setLabelByLanguage()
        searchResultView.setLabelByLanguage()
        var index = 0
        categoryTabbarView.categoryCollectionView.visibleCells.forEach { cell in
            guard let categoryCell = cell as? CategoryCell else { return }
            categoryCell.category = KCategory(rawValue: index)?.getCategoryString()
            index += 1
        }
    }
    
    // MARK: - UIViewController viewWillLayoutSubviews Override 설정
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setRecentViewConstraint()
    }
    
    private func removeChildVC() {
        childVCs.forEach { childVC in
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
        childVCs.removeAll()
    }
    
    deinit {
        print("SearchVC Deinit")
        removeChildVC()
    }
}

extension SearchVC {
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguage(_:)), name: .changeLanguage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLastIndex(_:)), name: .deleteResearchTerm, object: nil)
    }
    
    @objc func setLanguage(_ notification: NSNotification) {
        setLabelByLanguage()
    }
    
    @objc func setLastIndex(_ notification: NSNotification) {
        guard let lastIndex = notification.userInfo?["index"] as? Int else { return }
        researchLastIndex = Int32(lastIndex)
    }
}

extension SearchVC {
    // MARK: - 검색 정보 요청하는 API
    private func request(searchText: String) {
        let searchParameter = SearchParameter(search: searchText)
        
        NetworkHandler.shared.requestAPI(apiCategory: .search(searchParameter)) { result in
            switch result {
            case .success(let searchResult):
                guard let searchResultDTO = searchResult as? SearchResultDTO else { return }
                self.searchResultView.searchResultDTO = searchResultDTO
                DispatchQueue.main.async {
                    if self.searchResultView.superview == nil {
                        self.view.addSubview(self.searchResultView)
                        self.setSearchResultViewLayout()
                    }
                }
            case .requestErr(let erorr):
                print(erorr)
            case .serverErr: print("Server Err")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

extension SearchVC: RecentResearchViewDelegate {
    func click(searchTerm: String?) {
        if let searchTerm = searchTerm {
            searchTextField.text = searchTerm
            searchText(self.searchTextField)
            request(searchText: searchTerm)
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        recentResearchView.isHidden = false
        backButton.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 검색 버튼을 눌렀을 때,
    // 1. 키보드 내려가는 액션
    // 2. 검색한 화면으로 API 요청하고 이동하기
    // 3. CoreData에 검색어 저장하기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let search = searchTextField.text, search != "" else { return true }
        request(searchText: search)
        searchText(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension SearchVC: RecentResearchCoreDataUsable {
    func saveRecentResearch(term: String, date: Date, index: Int32) {
        CoreDataManager.shared.saveRecentSearch(term: term, date: date, index: index) { isCompletion in
            if isCompletion {
                guard let lastTerm = CoreDataManager.shared.loadFromCoreData(at: index, request: RecentResearchTerm.fetchRequest()) else {
                    print("가져오기 실패")
                    return
                }
                
                self.recentResearchView.add(recentResearch: lastTerm)
            }
        }
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

extension SearchVC: SearchResultViewDelegate {
    func click(searchData: SearchAble) {
        guard let detail_contentVC = self.storyboard?.instantiateViewController(withIdentifier: ContentDetailVC.identifier) as? ContentDetailVC else { return }
        
        if let mediaData = searchData as? MediaDTO {
            detail_contentVC.category = .media
            detail_contentVC.id = mediaData.mediaId
            detail_contentVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detail_contentVC, animated: true)
            return
        }
        
        if let celebData = searchData as? CelebrityDTO {
            detail_contentVC.category = .celeb
            detail_contentVC.id = celebData.celebrityId
            detail_contentVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detail_contentVC, animated: true)
            return
        }
    }
}
