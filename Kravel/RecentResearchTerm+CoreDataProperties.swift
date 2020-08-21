//
//  RecentResearchTerm+CoreDataProperties.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/22.
//  Copyright © 2020 윤동민. All rights reserved.
//
//

import Foundation
import CoreData


extension RecentResearchTerm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentResearchTerm> {
        return NSFetchRequest<RecentResearchTerm>(entityName: "RecentResearchTerm")
    }

    @NSManaged public var term: String?
    @NSManaged public var date: Date?
    @NSManaged public var index: Int32

}
