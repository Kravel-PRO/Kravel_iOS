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
    @IBOutlet weak var nameLabel: UILabel!
    
    var name: String? = "여기"
    
    @IBOutlet weak var myPhotoReviewLabel: UILabel!
    @IBOutlet weak var myScrapLabel: UILabel!
    
    // MARK: - 내 포토 리뷰 / 스크랩 뷰 설정
    @IBAction func goMyPhotoReview(_ sender: Any) {
        guard let myPhotoReviewVC = UIStoryboard(name: "MyPhotoReview", bundle: nil).instantiateViewController(withIdentifier: MyPhotoReviewVC.identifier) as? MyPhotoReviewVC else { return }
        myPhotoReviewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myPhotoReviewVC, animated: true)
    }
    
    @IBAction func goMyScrap(_ sender: Any) {
        guard let myScrapVC = UIStoryboard(name: "MyScrap", bundle: nil).instantiateViewController(withIdentifier: MyScrapVC.identifier) as? MyScrapVC else { return }
        myScrapVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myScrapVC, animated: true)
    }
    
    // MARK: - Menu 화면 설정
    @IBOutlet weak var menuTableView: UITableView! {
        didSet {
            menuTableView.dataSource = self
            menuTableView.delegate = self
            menuTableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        }
    }
    
    // MARK: - UIViewController viewDidLoad() Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLabelByLanguage()
    }
    
    private func setLabelByLanguage() {
        guard let language = UserDefaults.standard.object(forKey: UserDefaultKey.language) as? String,
            let name = self.name else { return }
        if language == "KOR" {
            nameLabel.text = "\(name)님의 여행을 함께해요!\nKravel과 당신의 여행을 특별하게 \n만들어보세요."
        } else {
            nameLabel.text = "Let's go on \(name)'s trip together!\nMake your trip special\nwith Kravel."
        }
        
        myPhotoReviewLabel.text = "내".localized + " " + "포토 리뷰".localized
        myPhotoReviewLabel.sizeToFit()
        
        myScrapLabel.text = "스크랩".localized
        myScrapLabel.sizeToFit()
    }
    
    // MARK: - UIViewController viewWillAppear() Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UIViewController viewDidDisappear() Override 설정
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UIViewController viewWillLayoutSubviews() Override 설정
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews() Override 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension MyPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageMenu.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myPageCell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell") as? MyPageCell else { return UITableViewCell() }
        myPageCell.menuName = MyPageMenu(rawValue: indexPath.row)?.getMenuLabel()
        myPageCell.separatorInset = .zero
        
        guard let menuImageName = MyPageMenu(rawValue: indexPath.row)?.getImageName() else { return UITableViewCell() }
        myPageCell.menuImage = UIImage(named: menuImageName)
        return myPageCell
    }
}

extension MyPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedMenu = MyPageMenu(rawValue: indexPath.row) else { return }
        switch selectedMenu {
        case .editMyInform:
            goEditMyInformVC(navTitle: selectedMenu.getMenuLabel())
        case .editMyPW:
            goEditPasswordVC(navTitle: selectedMenu.getMenuLabel())
        case .setLanguage:
            goSetLanguageVC(navTitle: selectedMenu.getMenuLabel())
        case .report:
            goReportVC(navTitle: selectedMenu.getMenuLabel())
        case .logout:
            presentLogoutAlertView()
        }
        
        menuTableView.deselectRow(at: indexPath, animated: false)
    }
    
    // 내 정보 수정 화면으로 이동
    private func goEditMyInformVC(navTitle: String) {
         guard let changeInfoVC = UIStoryboard(name: "ChangeInfo", bundle: nil).instantiateViewController(withIdentifier: ChangeInfoVC.identifier) as? ChangeInfoVC else { return }
        changeInfoVC.naviTitle = navTitle
        changeInfoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(changeInfoVC, animated: true)
    }
    
    // 비밀번호 변경 화면으로 이동
    private func goEditPasswordVC(navTitle: String) {
        guard let editPasswordVC = UIStoryboard(name: "EditPassword", bundle: nil).instantiateViewController(withIdentifier: EditPasswordVC.identifier) as? EditPasswordVC else { return }
        editPasswordVC.naviTitle = navTitle
        editPasswordVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editPasswordVC, animated: true)
    }
    
    // 언어 설정 화면으로 이동
    private func goSetLanguageVC(navTitle: String) {
        guard let setLanguageVC = UIStoryboard(name: "SetLanguage", bundle: nil).instantiateViewController(identifier: SetLanguageVC.identifier) as? SetLanguageVC else { return }
        setLanguageVC.navTitle = navTitle
        setLanguageVC.completeButtonText = "Complete"
        setLanguageVC.complete = { [weak self] language in
            self?.navigationController?.popViewController(animated: true)
        }
        setLanguageVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(setLanguageVC, animated: true)
    }
    
    // 제보하기 화면으로 이동
    private func goReportVC(navTitle: String) {
        guard let reportVC = UIStoryboard(name: "Report", bundle: nil).instantiateViewController(identifier: ReportVC.identifier) as? ReportVC else { return }
        reportVC.hidesBottomBarWhenPushed = true
        reportVC.navTitle = navTitle
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
    
    // 로그아웃 선택
    private func presentLogoutAlertView() {
        guard let logout = UIStoryboard(name: "LogoutPopup", bundle: nil).instantiateViewController(withIdentifier: LogoutPopupVC.identifier) as? LogoutPopupVC else { return }
        logout.modalPresentationStyle = .overFullScreen
        self.present(logout, animated: false, completion: nil)
    }
}
