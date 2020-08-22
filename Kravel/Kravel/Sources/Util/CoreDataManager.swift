//
//  CoreDataManager.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/21.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import CoreData

enum CoreDataName: String {
    case recentResearch = "RecentResearchTerm"
}

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    // MARK: - 해당 정보를 저장한다
    func saveRecentSearch(term: String, date: Date, index: Int32, completion: @escaping (Bool) -> Void) {
        guard let context = self.context,
            let entity = NSEntityDescription.entity(forEntityName: CoreDataName.recentResearch.rawValue, in: context)
            else { return }
        
        guard let recentTerms = NSManagedObject(entity: entity, insertInto: context) as? RecentResearchTerm else { return }
        recentTerms.term = term
        recentTerms.date = date
        
        do {
            try context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    // MARK: - 저장된 모든 정보를 가져온다
    func loadFromCoreData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        guard let context = self.context else { return [] }
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func delete<T: NSManagedObject>(at index: Int, request: NSFetchRequest<T>) -> Bool {
        request.predicate = NSPredicate(format: "term = %@", NSNumber(value: index))
        
        do {
            if let recentTerms = try context?.fetch(request) {
                if recentTerms.count == 0 { return false }
                context?.delete(recentTerms[0])
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    func removeAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
//        let fetchReqeust = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataName.recentResearch.rawValue)
        
        do {
            if let recentTerms = try context?.fetch(request) {
                recentTerms.forEach { element in
                    context?.delete(element)
                }
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
}
