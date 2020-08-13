//
//  MyPageVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/21.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MyPageVC: UIViewController {
    
    // MARK: - Name Label 초기 설정
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel! {
        // 임시
        didSet {
            nameLabel.text =
            """
            뭔가 OOO님 어쩌구 하는
            멘트가 하나 있으면 좋겠다.
            """
        }
    }
    
    @IBOutlet weak var nameBottomConstraint: NSLayoutConstraint!
    
    var name: String? = "펭수" {
        didSet {
            if let name = self.name {
                nameLabel.text =
                """
                뭔가 \(name)님 어쩌구 하는
                멘트가 하나 있으면 좋겠다.
                """
                nameLabel.sizeToFit()
            }
        }
    }
    
    private func setNameLayout() {
        nameBottomConstraint.constant = backView.frame.height / 5.41
    }
    
    // MARK: - 내 포토 리뷰 / 스크랩 뷰 설정
    
    
    // MARK: - Menu 화면 설정
    @IBOutlet weak var menuTableView: UITableView! {
        didSet {
            menuTableView.dataSource = self
            menuTableView.delegate = self
            menuTableView.separatorInset = .zero
        }
    }
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private func setTableViewHeightConstraint() {
        tableViewHeightConstraint.constant = menuTableView.frame.width / 6.69 * CGFloat(MyPageMenu.allCases.count)
    }
    
    // MARK: - ViewController Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNameLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setTableViewHeightConstraint()
    }
}

extension MyPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageMenu.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myPageCell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell") as? MyPageCell else { return UITableViewCell() }
        myPageCell.menuName = MyPageMenu(rawValue: indexPath.row)?.getMenuLabel()
        
        guard let menuImageName = MyPageMenu(rawValue: indexPath.row)?.getImageName() else { return UITableViewCell() }
        myPageCell.menuImage = UIImage(named: menuImageName)
        return myPageCell
    }
}

extension MyPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width / 6.69
    }
}
