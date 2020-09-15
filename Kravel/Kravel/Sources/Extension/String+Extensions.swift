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
        case newPhotoReview = "새로운 포토 리뷰"
        case photoReview = "포토 리뷰"
        
        // MARK: - 인기 있어요
        case nowadaysPopular = "요즘 여기가 인기 있어요!"
        case popular = "인기 있어요!"
        
        // MARK: - 검색 텍스트 필드
        case searchTextField = "연예인, 드라마 등을 검색해주세요."
        
        // MARK: - 검색 카테고리
        case celebrity = "연예인 별"
        case media = "드라마/영화 별"
        
        // MARK: - 카메라 POP UP 관련
        case authorCamera = "카메라"
        case authorPhotography = "사진 촬영"
        
        // MARK: - 위치 POP UP 관련
        case authorLocation = "위치 정보"
        case authorLocationMessage = "GPS 이용 및 지도 검색"
        
        // MARK: - 갤러리 POP UP 관련
        case authorGallery = "사진/파일"
        case authorGalleryMessage = "사진 자동 저장 및 포토리뷰 업로드"
        
        // MARK: - 권한 허용 POP UP 관련
        case authorPopupTitle = "앱 접근 권한 허용"
        case authorPopupMessage = "서비스를 이용하기 위해\n아래와 같은 권한을 허용해주세요."
        case allowed = "허용"
        case notAllowed = "허용 안함"
        
        // MARK: - 카메라 뷰 관련 Button Label
        case gallery = "갤러리"
        case sample = "예시"
        
        // MARK: - 네트워크 연결 POPUP
        case networkFail = "네트워크 연결이 끊겼습니다."
        case networkFailMessage = "네트워크 상태를 확인해주세요.\n문제가 계속되면 잠시 후 다시 시도해주세요."
        case ok = "확인"
        
        // MARK: - 마이페이지
        case my = "내"
        case scrap = "스크랩"
        
        case modifyInfo = "내 정보 수정"
        case modifyPw = "비밀번호 수정"
        case setLanguage = "언어 설정"
        case report = "제보하기"
        case logout = "로그아웃"
        
        // MARK: - 내 정보수정
        case complete = "수정 완료"
        
        // MARK: - 비밀번호 수정
        case checkMyselfPw = "본인 확인을 위해 비밀번호를 입력해주세요."
        case inputModifyPw = "변경할 비밀번호를 입력해주세요."
        
        // MARK: - 장소 디테일 화면
        case location = "위치"
        case attraction = "주변 관광지"
        case publicTranport = "대중교통"
        case bus = "버스"
        case subway = "지하철"
        
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
                if language == "KOR" { return "새로운 포토 리뷰" }
                else { return "New Photo Review" }
            case .photoReview:
                if language == "KOR" { return "포토 리뷰" }
                else { return "Photo Review" }
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
            case .searchTextField:
                if language == "KOR" { return "연예인, 드라마 등을 검색해주세요." }
                else { return "Please enter a search word." }
            case .celebrity:
                if language == "KOR" { return "연예인 별" }
                else { return "Celebrity" }
            case .media:
                if language == "KOR" { return "드라마/영화 별" }
                else { return "Drame/Movie" }
            case .authorCamera:
                if language == "KOR" { return "카메라" }
                else { return "Camera" }
            case .authorGallery:
                if language == "KOR" { return "사진/파일" }
                else { return "Photo/Files" }
            case .authorGalleryMessage:
                if language == "KOR" { return "사진 자동 저장 및 포토리뷰 업로드" }
                else { return "Automatically save photo and Upload a Photo Review" }
            case .authorPhotography:
                if language == "KOR" { return "사진 촬영" }
                else { return "Photography" }
            case .authorPopupTitle:
                if language == "KOR" { return "앱 접근 권한 허용" }
                else { return "Allow access to app" }
            case .authorPopupMessage:
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
            case .gallery:
                if language == "KOR" { return "갤러리" }
                else { return "Gallery" }
            case .sample:
                if language == "KOR" { return "예시" }
                else { return "Sample" }
            case .networkFail:
                if language == "KOR" { return "네트워크 연결이 끊겼습니다." }
                else { return "The network connection has been lost." }
            case .networkFailMessage:
                if language == "KOR" { return "네트워크 상태를 확인해주세요.\n문제가 계속되면 잠시 후 다시 시도해주세요." }
                else { return "Please check the network status.\nIf the problem persists, please try again later." }
            case .ok:
                if language == "KOR" { return "확인" }
                else { return "OK" }
            case .my:
                if language == "KOR" { return "내" }
                else { return "My" }
            case .scrap:
                if language == "KOR" { return "스크랩" }
                else { return "Scrap" }
            case .modifyInfo:
                if language == "KOR" { return "내 정보 수정" }
                else { return "Modify my info" }
            case .modifyPw:
                if language == "KOR" { return "비밀번호 수정" }
                else { return "Modify Password" }
            case .setLanguage:
                if language == "KOR" { return "언어 설정" }
                else { return "Language setting" }
            case .report:
                if language == "KOR" { return "제보하기" }
                else { return "Report" }
            case .logout:
                if language == "KOR" { return "로그아웃" }
                else { return "Log out" }
            case .complete:
                if language == "KOR" { return "수정 완료" }
                else { return "OK" }
            case .checkMyselfPw:
                if language == "KOR" { return "본인 확인을 위해 비밀번호를 입력해주세요." }
                else { return "Please enter your password for identification." }
            case .inputModifyPw:
                if language == "KOR" { return "변경할 비밀번호를 입력해주세요." }
                else { return "OK" }
            case .attraction:
                if language == "KOR" { return "주변 관광지" }
                else { return "Nearby tourist attraction" }
            case .publicTranport:
                if language == "KOR" { return "대중교통" }
                else { return "Public transport" }
            case .bus:
                if language == "KOR" { return "버스" }
                else { return "bus" }
            case .subway:
                if language == "KOR" { return "지하철" }
                else { return "subway" }
            case .location:
                if language == "KOR" { return "위치" }
                else { return "Location" }
            }
        }
    }
    
    static func localize(key: String) -> String {
        guard let localKey = LocalKey(rawValue: key) else {
            return key }
        return localKey.localize()
    }
}
