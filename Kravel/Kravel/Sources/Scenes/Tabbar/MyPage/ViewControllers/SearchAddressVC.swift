//
//  SearchAddressVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/01.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SearchAddressVC: UIViewController {
    static let identifier = "SearchAddressVC"

    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let mapSearch = NaverSearchParameter(query: "수지", display: 5, start: nil, sort: nil)
        NetworkHandler.shared.requestAPI(apiCategory: .searchAddressNaver(mapSearch)) { result in
            print("Hi")
        }
    }
    
    // MARK: - UIViewController viewWillAppear Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationItem.title = "주소 찾기"
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}
