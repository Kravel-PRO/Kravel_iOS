//
//  NearByAttractionView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/25.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class NearByAttractionView: UIView {
    static let nibName = "NearbyAttractionView"
    
    var view: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - 주변 관광지 CollectionView 설정
    @IBOutlet weak var nearByAttractionCollectionView: UICollectionView! {
        didSet {
            nearByAttractionCollectionView.dataSource = self
            nearByAttractionCollectionView.delegate = self
            nearByAttractionCollectionView.register(NearByAttractionCell.self, forCellWithReuseIdentifier: NearByAttractionCell.identifier)
        }
    }
    
    // MARK: - 주변 관광지 데이터 설정
    var nearByAttractions: [KoreaTourist] = []
    var tempTouristDic: [String: String]?
    var crtElementType: KoreaTouristResponseKey?
    
    // MARK: - UIView Override 부분
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setLabelByLanguage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        setLabelByLanguage()
    }
    
    private func loadXib() {
        self.view = loadXib(from: NearByAttractionView.nibName)
        self.view.frame = self.bounds
        self.addSubview(view)
        self.bringSubviewToFront(view)
    }
    
    private func setLabelByLanguage() {
        titleLabel.text = "주변 관광지".localized
    }
    
    func requestTouristAPI(mapX: Double, mapY: Double) {
        nearByAttractions = []
        
        let touristParameter = KoreaTouristParameter(pageNo: 1, mapX: mapX , mapY: mapY)
        var url: String
        let urlQuery: String = "\(KoreaTouristParameterKey.serviceKey.rawValue)=\(touristParameter.serviceKey)&\(KoreaTouristParameterKey.mobileOS.rawValue)=\(touristParameter.mobileOS)&\(KoreaTouristParameterKey.mobileApp.rawValue)=\(touristParameter.mobileApp)&\(KoreaTouristParameterKey.mapX.rawValue)=\(touristParameter.mapX)&\(KoreaTouristParameterKey.mapY.rawValue)=\(touristParameter.mapY)&\(KoreaTouristParameterKey.radius.rawValue)=\(touristParameter.radius)&\(KoreaTouristParameterKey.pageNo.rawValue)=\(touristParameter.pageNo)&\(KoreaTouristParameterKey.numberOfRows)=\(touristParameter.numberOfRows)&\(KoreaTouristParameterKey.arrange)=\(touristParameter.arrange)&\(KoreaTouristParameterKey.listYN.rawValue)=\(touristParameter.listYN)"
                
        guard let language = UserDefaults.standard.object(forKey: UserDefaultKey.language) as? String else { return }
        
        if language == "KOR" {
            url = APICostants.koreaTouristURL + urlQuery
        } else {
            url = APICostants.engTouristURL + urlQuery
        }
        
        guard let castingURL = URL(string: url) else { return }
        let xmlParser = XMLParser(contentsOf: castingURL)
        xmlParser?.delegate = self
        xmlParser?.parse()
        
        DispatchQueue.main.async {
            self.nearByAttractionCollectionView.reloadData()
            NotificationCenter.default.post(name: .completeAttraction, object: nil
                , userInfo: ["isEmpty": self.nearByAttractions.isEmpty])
        }
    }
}

// MARK: - XML Parsing을 위한 작업
extension NearByAttractionView: XMLParserDelegate {
    // MARK: XML 데이터 파싱을 시작했을 때
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        guard let touristKey = KoreaTouristResponseKey.init(rawValue: elementName) else {
            print("없는 키 값입니다 \(elementName)")
            return
        }

        switch touristKey {
        case .item:
            tempTouristDic = [:]
        default:
            crtElementType = touristKey
        }
    }
    
    // MARK: - XML 태그를 시작했을 때
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard tempTouristDic != nil,
            let crtElementType = self.crtElementType else { return }
        tempTouristDic?.updateValue(string, forKey: crtElementType.rawValue)
    }
    
    // MARK: - XML 데이터 파싱이 끝났을 때
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let touristKey = KoreaTouristResponseKey.init(rawValue: elementName),
            let tempTouristDic = self.tempTouristDic else {
            print("없는 키 입니다 \(elementName)")
            return
        }
        
        switch touristKey {
        case .item:
            var touristItem = KoreaTourist(addr1: "", addr2: "", firstimage: "", firstimage2: "", mapx: 0, mapy: 0, title: "")
            
            guard let addr1 = tempTouristDic[KoreaTouristResponseKey.addr1.rawValue],
                let addr2 = tempTouristDic[KoreaTouristResponseKey.addr2.rawValue],
                let firstimage = tempTouristDic[KoreaTouristResponseKey.firstimage.rawValue],
                let firstimage2 = tempTouristDic[KoreaTouristResponseKey.firstimage2.rawValue],
                let mapx = tempTouristDic[KoreaTouristResponseKey.mapx.rawValue],
                let castingMapx = Double(mapx),
                let mapy = tempTouristDic[KoreaTouristResponseKey.mapx.rawValue],
                let castingMapy = Double(mapy),
                let title = tempTouristDic[KoreaTouristResponseKey.title.rawValue] else { return }
            
            touristItem.addr1 = addr1
            touristItem.addr2 = addr2
            touristItem.firstimage = firstimage
            touristItem.firstimage2 = firstimage2
            touristItem.mapx = castingMapx
            touristItem.mapy = castingMapy
            touristItem.title = title
            
            self.nearByAttractions.append(touristItem)
            self.tempTouristDic = nil
        default: return
        }
        
        crtElementType = nil
    }
}

extension NearByAttractionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearByAttractions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nearByAttractionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByAttractionCell.identifier, for: indexPath) as? NearByAttractionCell else { return UICollectionViewCell() }
        nearByAttractionCell.nearByAttractionImageView.setImage(with: nearByAttractions[indexPath.row].firstimage2)
        nearByAttractionCell.nearByAttractionName = nearByAttractions[indexPath.row].title
        nearByAttractionCell.layer.cornerRadius = nearByAttractionCell.frame.width / 2
        nearByAttractionCell.clipsToBounds = true
        return nearByAttractionCell
    }
}

extension NearByAttractionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 116, height: 116)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
