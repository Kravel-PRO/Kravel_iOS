//
//  String+Extensions.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/09.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

extension String {
    // MARK: - 포맷 확인
    func isEmailFormat() -> Bool {
        let emailPattern: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let regex = try? NSRegularExpression(pattern: emailPattern, options: [])
        let matchNumber = regex?.numberOfMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
        return matchNumber != 0
    }
    
    // MARK: - Attribute 관련 메소드
    func makeAttributedText(_ attributes: [NSAttributedString.Key: Any] = [:],
                            of range: String? = nil) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        if let range = range { attributedString.addAttributes(attributes, range: (self as NSString).range(of: range)) }
        else { attributedString.addAttributes(attributes, range: (self as NSString).range(of: self)) }
        return attributedString
    }
    
    var localized: String {
        return CustomLocalize.localize(key: self)
    }
}

struct CustomLocalize {
    enum LocalKey: String {
        case authorCamera = "카메라"
        case authorPhotography = "사진 촬영"
        case authorLocation = "위치 정보"
        case authorLocationMessage = "GPS 이용 및 지도 검색"
        
        case authorCameraTitle = "앱 접근 권한 허용"
        case authorCameraMessage = "서비스를 이용하기 위해\n아래와 같은 권한을 허용해주세요."
        case allowed = "허용"
        case notAllowed = "허용 안함"
        
        func localize() -> String {
            guard let language = UserDefaults.standard.object(forKey: UserDefaultKey.language) as? String else { return self.rawValue }
            switch self {
            case .authorCamera:
                if language == "KOR" { return "카메라" }
                else { return "Camera" }
            case .authorPhotography:
                if language == "KOR" { return "사진 촬영" }
                else { return "Photography" }
            case .authorCameraTitle:
                if language == "KOR" { return "앱 접근 권한 허용" }
                else { return "Allow access to app" }
            case .authorCameraMessage:
                if language == "KOR" { return "서비스를 이용하기 위해\n아래와 같은 권한을 허용해주세요." }
                else { return "Please allow the following rights\nto use the service." }
            case .allowed:
                if language == "KOR" { return "허용" }
                else { return "Allowed" }
            case .notAllowed:
                if language == "KOR" { return "허용 안함" }
                else { return "Not Allowed" }
            case .authorLocation:
                if language == "KOR" { return "위치 정보" }
                else { return "Location Information" }
            case .authorLocationMessage:
                if language == "KOR" { return "GPS 이용 및 지도 검색" }
                else { return "Use GPS and Map Search" }
            }
        }
    }
    
    static func localize(key: String) -> String {
        guard let localKey = LocalKey(rawValue: key) else {
            print("이넘으로 안바뀜")
            return key }
        return localKey.localize()
    }
}
