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
        // MARK: - 로그인 화면
        case login = "로그인 하기"
        case signup = "회원가입 하기"
        case mainDescription = "오늘도\nKravel과 함께\n여행을 떠나볼까요?"
        case mainDescriptionPart = "오늘도"
        
        case email = "이메일 계정"
        case pw = "비밀번호"
        case emailTextFeild = "이메일을 입력해주세요."
        case pwTextField = "비밀번호를 입력해주세요."
        
        // MARK: - 회원가입 화면
        case signupDescription = "Kravel과 함께\n색다른\n여행을 떠나볼까요?"
        case pwConfirm = "비밀번호 확인"
        case pwConfirmTextField = "다시 한 번 비밀번호를 입력해주세요."
        case nickname = "닉네임"
        case nicknameTextField = "사용할 닉네임을 7자 이하로 적어주세요."
        case gender = "성별"
        
        case emailValid = "이메일 형식이 옳지 않습니다."
        case pwValid = "6자리 이상 입력해주세요."
        case pwConfirmValid = "비밀번호가 같지 않습니다."
        case nicknameValid = "7자 이하로 입력해주세요."
        
        // MARK: - 성별
        case man = "남자"
        case woman = "여자"
        
        // MARK: - 홈 환영
        case homeWelcom = "당신의 한국 여행을\n더 특별하게,\nKravel만의 장소를 둘러보세요."
        case homeWelcomPart = "Kravel만의 장소를 둘러보세요."
        
        // MARK: - 가까운 곳
        case close = "나와 가까운 Kravel"
        case closepart = "나와 가까운"
        
        // MARK: - 더보기
        case more = "더 보기"
        
        // MARK: - 포토리뷰
        case newPhotoReview = "새로운 포토리뷰"
        case photoReview = "포토리뷰"
        
        // MARK: - 인기 있어요
        case nowadaysPopular = "요즘 여기가 인기 있어요!"
        case popular = "인기 있어요!"
        
        // MARK: - 카메라 POP UP 관련
        case authorCamera = "카메라"
        case authorPhotography = "사진 촬영"
        
        // MARK: - 위치 POP UP 관련
        case authorLocation = "위치 정보"
        case authorLocationMessage = "GPS 이용 및 지도 검색"
        
        // MARK: - 권한 허용 POP UP 관련
        case authorCameraTitle = "앱 접근 권한 허용"
        case authorCameraMessage = "서비스를 이용하기 위해\n아래와 같은 권한을 허용해주세요."
        case allowed = "허용"
        case notAllowed = "허용 안함"
        
        func localize() -> String {
            guard let language = UserDefaults.standard.object(forKey: UserDefaultKey.language) as? String else { return self.rawValue }
            switch self {
            case .login:
                if language == "KOR" { return "로그인 하기" }
                else { return "Log In" }
            case .signup:
                if language == "KOR" { return "회원가입 하기" }
                else { return "Sign Up" }
            case .mainDescription:
                if language == "KOR" { return "오늘도\nKravel과 함께\n여행을 떠나볼까요?" }
                else { return "Shall we go on a trip\nwith Kavel\ntoday?" }
            case .mainDescriptionPart:
                if language == "KOR" { return "오늘도" }
                else { return "Shall we go on a trip" }
            case .email:
                if language == "KOR" { return "이메일 계정" }
                else { return "E-mail" }
            case .pw:
                if language == "KOR" { return "비밀번호" }
                else { return "Password" }
            case .emailTextFeild:
                if language == "KOR" { return "이메일을 입력해주세요." }
                else { return "Please enter your e-mail." }
            case .pwTextField:
                if language == "KOR" { return "비밀번호를 입력해주세요." }
                else { return "Please enter your password." }
            case .signupDescription:
                if language == "KOR" { return "Kravel과 함께\n색다른\n여행을 떠나볼까요?" }
                else { return "Shall we go\non a special trip\nwith Kravel?" }
            case .pwConfirm:
                if language == "KOR" { return "비밀번호 확인" }
                else { return "Confirm Password" }
            case .pwConfirmTextField:
                if language == "KOR" { return "다시 한 번 비밀번호를 입력해주세요." }
                else { return "Please enter the same password again." }
            case .nickname:
                if language == "KOR" { return "닉네임" }
                else { return "Nickname" }
            case .nicknameTextField:
                if language == "KOR" { return "사용할 닉네임을 7자 이하로 적어주세요." }
                else { return "Please enter your nickname." }
            case .gender:
                if language == "KOR" { return "성별" }
                else { return "Gender" }
            case .man:
                if language == "KOR" { return "남자" }
                else { return "Male" }
            case .woman:
                if language == "KOR" { return "여자" }
                else { return "Female" }
            case .homeWelcom:
                if language == "KOR" { return "당신의 한국 여행을\n더 특별하게,\nKravel만의 장소를 둘러보세요." }
                else { return "Places that will make your trip\nto Korea more special.\nThe popular place these days." }
            case .homeWelcomPart:
                if language == "KOR" { return "Kravel만의 장소를 둘러보세요." }
                else { return "The popular place these days" }
            case .close:
                if language == "KOR" { return "나와 가까운 Kravel" }
                else { return "a Kravel close to me" }
            case .closepart:
                if language == "KOR" { return "나와 가까운" }
                else { return "close to me" }
            case .more:
                if language == "KOR" { return "더 보기" }
                else { return "more" }
            case .newPhotoReview:
                if language == "KOR" { return "새로운 포토리뷰" }
                else { return "New PhotoReview" }
            case .photoReview:
                if language == "KOR" { return "포토리뷰" }
                else { return "PhotoReview" }
            case .nowadaysPopular:
                if language == "KOR" { return "요즘 여기가 인기 있어요!" }
                else { return "This place is popular these days!" }
            case .popular:
                if language == "KOR" { return "인기 있어요!" }
                else { return "popular these days!" }
            case .emailValid:
                if language == "KOR" { return "이메일 형식이 옳지 않습니다." }
                else { return "Email format is incorrect." }
            case .pwValid:
                if language == "KOR" { return "6자리 이상 입력해주세요." }
                else { return "Please enter at least 6 characters." }
            case .pwConfirmValid:
                if language == "KOR" { return "비밀번호가 같지 않습니다." }
                else { return "Password is not the same." }
            case .nicknameValid:
                if language == "KOR" { return "7자 이하로 입력해주세요." }
                else { return "Please enter no more than 7 characters." }
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
            return key }
        return localKey.localize()
    }
}
