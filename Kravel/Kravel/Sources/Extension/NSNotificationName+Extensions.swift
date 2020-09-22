//
//  NSNotificationName+Extensions.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/23.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let deleteResearchTerm = NSNotification.Name("deleteResearchTerm")
    static let dismissDetailView = NSNotification.Name("dismissDetailView")
    static let selectAddress = NSNotification.Name("selectAddress")
    static let dismissAuthorPopupView = NSNotification.Name("dismissAuthorPopupView")
    static let completeAttraction = NSNotification.Name("completeAttraction")
    static let changeLanguage = NSNotification.Name("changeLanguage")
    static let completeUpload = NSNotification.Name("completeUpload")
}
