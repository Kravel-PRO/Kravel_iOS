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

    // MARK: - Text Field Margin View 설정
    @IBOutlet weak var marginView: UIView! {
        didSet {
            marginView.layer.borderColor = UIColor.veryLightPink.cgColor
            marginView.layer.borderWidth = 1
            marginView.layer.cornerRadius = marginView.frame.width / 15
        }
    }
    
    // MARK: - 주소 검색 TextField
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let kakaoParameter = SearchPlaceParameter(query: "아주대", page: 1)
        NetworkHandler.shared.requestAPI(apiCategory: .searchPlaceKakao(kakaoParameter)) { result in
            print("aa")
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

extension SearchAddressVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? .grapefruit : .veryLightPink
        marginView.layer.borderColor = layerColor.cgColor
    }
}
