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
    
    // MARK: - 검색 예시 보여주는 View
    @IBOutlet weak var exampleView: UIView!
    
    // MARK: - 검색 결과 보여주는 View
    @IBOutlet weak var resultView: UIView! {
        didSet {
            resultView.isHidden = true
        }
    }
    
    // MARK: - 검색 결과 보여주는 TableView
    @IBOutlet weak var searchResultTableView: UITableView! {
        didSet {
            searchResultTableView.dataSource = self
            searchResultTableView.delegate = self
            searchResultTableView.separatorInset = .zero
            searchResultTableView.rowHeight = UITableView.automaticDimension
            searchResultTableView.estimatedRowHeight = 74
            searchResultTableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        }
    }
    
    var searchResult: [DetailPlaceInform] = []
    
    // API 요청을 위한 page
    private var page: Int = 1
    private var isEnd = true
    private var searchQuery: String = ""
    private var isRequestMoreData: Bool = false
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

extension SearchAddressVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SearchAddressVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text, text != "" else { return false }
        page = 1
        isEnd = true
        searchQuery = text
        isRequestMoreData = false
        
        let kakaoAPIParameter = SearchPlaceParameter(query: text, page: page)
        NetworkHandler.shared.requestAPI(apiCategory: .searchPlaceKakao(kakaoAPIParameter)) { result in
            switch result {
            case .success(let locationInform):
                guard let locationInform = locationInform as? SearchPlaceResponseData else { return }
                if !locationInform.meta.is_end {
                    self.page += 1
                    self.isEnd = false
                } else {
                    self.page = 1
                    self.isEnd = true
                }
                
                self.searchResult = locationInform.documents
                // FIXME: 검색 결과 없는 경우 검색 결과 없다는 화면 떠야함
                self.exampleView.isHidden = true
                self.resultView.isHidden = false
                DispatchQueue.main.async {
                    self.searchResultTableView.reloadData()
                    if !self.searchResult.isEmpty { self.searchResultTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false) }
                }
            case .requestErr(let errorMessage):
                // FIXME: 여기 에러 처리 추가
                print(errorMessage)
            case .serverErr:
                // FIXME: 서버 오류 있을 시 에러 처리 추가
                print("Server Error")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? .grapefruit : .veryLightPink
        marginView.layer.borderColor = layerColor.cgColor
    }
}

extension SearchAddressVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchResultCell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier) as? SearchResultCell else { return UITableViewCell() }
        
        let placeNameAttributeText = searchResult[indexPath.row].place_name.makeAttributedText([.foregroundColor: UIColor(white: 39/255, alpha: 1.0), .font: UIFont.systemFont(ofSize: 16)])
        placeNameAttributeText.addAttributes([.foregroundColor: UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)], range: (searchResult[indexPath.row].place_name as NSString).range(of: searchQuery))
        
        let addressAttributeText = searchResult[indexPath.row].address_name.makeAttributedText([.foregroundColor: UIColor.veryLightPink, .font: UIFont.systemFont(ofSize: 14)])
        addressAttributeText.addAttributes([.foregroundColor: UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)], range: (searchResult[indexPath.row].address_name as NSString).range(of: searchQuery))
        
        searchResultCell.placeNameAttributeText = placeNameAttributeText
        searchResultCell.addressAttributeText = addressAttributeText
        searchResultCell.separatorInset = .zero
        return searchResultCell
    }
}

extension SearchAddressVC: UITableViewDelegate {
    // 주소 선택된 경우 이전 뷰에 업데이트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .selectAddress, object: nil, userInfo: ["address": searchResult[indexPath.row].address_name])
        self.navigationController?.popViewController(animated: true)
    }
    
    // TableView 무한 페이지를 위한 코드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let frameHeight = scrollView.frame.height
        let contentOffsetY = scrollView.contentOffset.y
        let scrollViewContentSizeHeight = scrollView.contentSize.height
        
        if scrollViewContentSizeHeight - contentOffsetY < frameHeight { requestNextPage() }
    }
    
    private func requestNextPage() {
        guard !isRequestMoreData, !isEnd else { return }
        isRequestMoreData = true
        
        let searchParameter = SearchPlaceParameter(query: searchQuery, page: page)
        let spinnerView = createSpinnerView()
        self.searchResultTableView.tableFooterView = spinnerView
        
        NetworkHandler.shared.requestAPI(apiCategory: .searchPlaceKakao(searchParameter)) { result in
            DispatchQueue.main.async {
                self.searchResultTableView.tableFooterView = nil
            }
            self.isRequestMoreData = false
            
            switch result {
            case .success(let locationInform):
                guard let locationInform = locationInform as? SearchPlaceResponseData else { return }
                
                if !locationInform.meta.is_end {
                    self.page += 1
                    self.isEnd = false
                } else {
                    self.page = 1
                    self.isEnd = true
                }
                
                self.searchResult.append(contentsOf: locationInform.documents)
                DispatchQueue.main.async {
                    self.searchResultTableView.reloadData()
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .serverErr:
                print("ServerError")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
            
        }
    }
    
    private func createSpinnerView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 52))
        let spinner = UIActivityIndicatorView()
        footerView.addSubview(spinner)
        spinner.center = footerView.center
        spinner.startAnimating()
        return footerView
    }
}
