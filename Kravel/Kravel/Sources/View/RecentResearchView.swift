//
//  RecentResearchView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/22.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class RecentResearchView: UIView {
    static let nibName = "RecentResearchView"
    
    var view: UIView!
    
    // MARK: - Label 표시를 위한 View
    @IBOutlet weak var topMarginView: UIView!
    
    // MARK: - 최근 검색어 모델
    var recentResearchs: [RecentResearchTerm] = [] {
        didSet {
            // FIXME: - 나중에 CoreData에서 마지막 데이터만 가져올 수 있게 설정
            // 새롭게 데이터가 추가될 때, 마지막 Index만 추가될 수 있게 설정
            print("set RecentResearch")
            recentResearchTableView.reloadData()
            animateTablewViewHeight()
        }
    }
    
    // 최근 검색어에 추가
    func add(recentResearch: RecentResearchTerm) {
        recentResearchs.append(recentResearch)
        recentResearchTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        animateTablewViewHeight()
    }
    
    private func isOverTableViewHeight() -> Bool {
        if CGFloat(recentResearchs.count) * tableViewEachRowHeight > self.frame.height - topMarginView.frame.height { return true }
        return false
    }
    
    // TableView Row의 수에 따라 Height 조절
    private func animateTablewViewHeight() {
        if isOverTableViewHeight() {
            recentResearchTableViewHeight.constant = self.frame.height - topMarginView.frame.height
        } else {
            recentResearchTableViewHeight.constant = CGFloat(recentResearchs.count) * tableViewEachRowHeight
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
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
        recentResearchTableViewHeight = recentResearchTableView.heightAnchor.constraint(equalToConstant: CGFloat(recentResearchs.count)*tableViewEachRowHeight)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        setRecentResearchTableView()
        setTableViewConstraint()
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
        return recentResearchCell
    }
}

extension RecentResearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewEachRowHeight
    }
}
