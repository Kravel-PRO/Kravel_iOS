//
//  PlacePopupViewDelegate.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/05.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

protocol PlacePopupViewDelegate {
    func clickPhotoButton()
    func clickScrapButton()
    func clickPhotoReview(at indexPath: IndexPath, placeId: Int, selectedReviewId: Int?)
}
