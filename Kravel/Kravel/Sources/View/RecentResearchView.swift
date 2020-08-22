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
            recentResearchTableView.reloadData()
        }
    }
    
    // MARK: - 최근 검색어 TableView 설정
    var recentResearchTableView: UITableView = {
        let recentResearchTableView = UITableView()
        recentResearchTableView.translatesAutoresizingMaskIntoConstraints = false
        recentResearchTableView.register(RecentResearchCell.self, forCellReuseIdentifier: RecentResearchCell.identifier)
        return recentResearchTableView
    }()
    
    private func setRecentResearchTableView() {
        recentResearchTableView.dataSource = self
        recentResearchTableView.delegate = self
        self.addSubview(recentResearchTableView)
    }
    
    private func setTableViewConstraint() {
        NSLayoutConstraint.activate([
            recentResearchTableView.topAnchor.constraint(equalTo: topMarginView.bottomAnchor),
            recentResearchTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recentResearchTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            recentResearchTableView.heightAnchor.constraint(equalToConstant: 200)
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
        recentResearchCell.researchText = recentResearchs[indexPath.row].term
        return recentResearchCell
    }
}

extension RecentResearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
