//
//  RecentResearchView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/22.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

protocol SearchAble {}

class RecentResearchView: UIView {
    static let nibName = "RecentResearchView"
    
    var view: UIView!
    
    var originalHeight: CGFloat?
    
    // MARK: - Label 표시를 위한 View
    @IBOutlet weak var topMarginView: UIView!
    
    // MARK: - Data가 없는 경우 표시하는 화면
    @IBOutlet weak var labelView: UIView!
    
    // MARK: - 최근 검색어 모델
    var recentResearchs: [RecentResearchTerm] = []
    
    private func isEmptyResearch() -> Bool {
        if recentResearchs.count == 0 {
            topMarginView.isHidden = true
            recentResearchTableView.isHidden = true
            labelView.isHidden = false
            self.view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            return true
        } else {
            topMarginView.isHidden = false
            recentResearchTableView.isHidden = false
            labelView.isHidden = true
            self.view.backgroundColor = .white
            return false
        }
    }

    // 최근 검색어에 새로운 데이터 추가
    // 뷰 업데이트
    func reloadRecentResearchs(_ recentResearchs: [RecentResearchTerm]) {
        self.recentResearchs = recentResearchs
        animateTablewViewHeight()
        recentResearchTableView.reloadData()
        if isEmptyResearch() { print("Empty") }
        else { print("notEmpty") }
    }
    
    // 최근 검색어에 Model 추가
    // 최근 검색어 TableView Animation
    func add(recentResearch: RecentResearchTerm) {
        recentResearchs.append(recentResearch)
        recentResearchTableView.reloadData()
        animateTablewViewHeight()
        if isEmptyResearch() { print("Empty") }
        else { print("notEmpty") }
    }
    
    private func isOverTableViewHeight() -> Bool {
        guard let originalHeight = self.originalHeight else { return false }
        if CGFloat(recentResearchs.count) * tableViewEachRowHeight > originalHeight - topMarginView.frame.height { return true }
        return false
    }
    
    // TableView Row의 수에 따라 Height 조절
    private func animateTablewViewHeight() {
        guard let originalHeight = self.originalHeight else { return }
        if isOverTableViewHeight() {
            recentResearchTableViewHeight.constant = originalHeight - topMarginView.frame.height
            recentResearchTableView.isScrollEnabled = true
        } else {
            recentResearchTableViewHeight.constant = CGFloat(recentResearchs.count) * tableViewEachRowHeight
            recentResearchTableView.isScrollEnabled = false
        }
    }
    
    // MARK: - 최근 검색어 TableView 설정
    var recentResearchTableView: UITableView = {
        let recentResearchTableView = UITableView()
        recentResearchTableView.translatesAutoresizingMaskIntoConstraints = false
        recentResearchTableView.separatorInset = .zero
        recentResearchTableView.contentInsetAdjustmentBehavior = .automatic
        recentResearchTableView.register(RecentResearchCell.self, forCellReuseIdentifier: RecentResearchCell.identifier)
        return recentResearchTableView
    }()
    
    // Tablew View 한 Row당 높이
    private let tableViewEachRowHeight: CGFloat = 52
    
    // RecentTableView Height Constraint
    var recentResearchTableViewHeight: NSLayoutConstraint!
    
    private func setRecentResearchTableView() {
        recentResearchTableView.dataSource = self
        recentResearchTableView.delegate = self
        self.addSubview(recentResearchTableView)
    }
    
    private func setTableViewConstraint() {
        recentResearchTableViewHeight = recentResearchTableView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            recentResearchTableView.topAnchor.constraint(equalTo: topMarginView.bottomAnchor),
            recentResearchTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recentResearchTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            recentResearchTableViewHeight
        ])
    }
    
    // MARK: - UIView Override 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setRecentResearchTableView()
        setTableViewConstraint()
        animateTablewViewHeight()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        setRecentResearchTableView()
        setTableViewConstraint()
        animateTablewViewHeight()
    }
    
    private func loadXib() {
        self.view = loadXib(from: RecentResearchView.nibName)
        self.view.frame = self.bounds
        self.addSubview(view)
        self.bringSubviewToFront(view)
    }
}

extension RecentResearchView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentResearchs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recentResearchCell = tableView.dequeueReusableCell(withIdentifier: RecentResearchCell.identifier) as? RecentResearchCell else { return UITableViewCell() }
        recentResearchCell.researchText = recentResearchs[recentResearchs.count - indexPath.row - 1].term
        recentResearchCell.cellButtonDelegate = self
        recentResearchCell.indexPath = indexPath
        return recentResearchCell
    }
}

extension RecentResearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewEachRowHeight
    }
}

extension RecentResearchView: CellButtonDelegate {
    // TableView 안의 삭제 버튼 클릭했을 때,
    // 1. 해당 모델 삭제
    // 2. 해당 Row 뒤의 Models index 전부 수정해주기
    // 3. 해당 TableView Row 삭제
    func click(at indexPath: IndexPath) {
        if CoreDataManager.shared.delete(at: recentResearchs.count - indexPath.row - 1, request: RecentResearchTerm.fetchRequest()) {
            recentResearchs.remove(at: recentResearchs.count - indexPath.row - 1)
            if isEmptyResearch() { print("empty") }
            else { print("notEmpty") }
            
            // 최근 검색어 index 재정렬시켜주기
            for index in recentResearchs.count - indexPath.row..<recentResearchs.count {
                let curIndex = recentResearchs[index].index
                if CoreDataManager.shared.updateIndex(at: curIndex, to: curIndex-1, request: RecentResearchTerm.fetchRequest()) {
                    print("Success Update")
                }
            }
            
            recentResearchTableView.beginUpdates()
            recentResearchTableView.deleteRows(at: [indexPath], with: .fade)
            recentResearchTableView.endUpdates()
            animateTablewViewHeight()
            
            // 삭제된 Cell의 뒷 순서 셀 가져와서 indexPath 설정
            for index in indexPath.row..<recentResearchs.count {
                guard let cell = recentResearchTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? RecentResearchCell else { return }
                cell.indexPath = IndexPath(row: index, section: 0)
            }
            
            // SearchVC에 삭제되고 마지막 Index 알려주기
            NotificationCenter.default.post(name: .deleteResearchTerm, object: nil, userInfo: ["index": recentResearchs.count-1])
        }
    }
}
