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
        recentTerms.index = index
        
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
    
    // MARK: - 해당 index 모델 가져온다
    func loadFromCoreData<T: NSManagedObject>(at index: Int32, request: NSFetchRequest<T>) -> T? {
        request.predicate = NSPredicate(format: "index = %@", NSNumber(value: index))
        do {
            if let recentTermAtIndex = try context?.fetch(request) {
                if recentTermAtIndex.count == 0 { return nil }
                return recentTermAtIndex[0]
            }
        } catch {
            print(error)
            return nil
        }
        return nil
    }
    
    // MARK: - 특정 index 번호 삭제
    func delete<T: NSManagedObject>(at index: Int, request: NSFetchRequest<T>) -> Bool {
        request.predicate = NSPredicate(format: "index = %@", NSNumber(value: index))
        
        do {
            if let recentTerms = try context?.fetch(request) {
                if recentTerms.count == 0 { return false }
                context?.delete(recentTerms[0])
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    // MARK: - 해당 타입 전체 삭제
    func removeAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
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
    
    // MARK: - 어떤 index을 가진 객체 index 번호를 바꿔주기
    func updateIndex<T: NSManagedObject>(at index: Int32, to updateIndex: Int32, request: NSFetchRequest<T>) -> Bool {
        request.predicate = NSPredicate(format: "index = %@", NSNumber(value: index))
        
        do {
            if let updatingTerm = try context?.fetch(request) {
                if updatingTerm.count == 0 { return false }
                else { print("매치되는 것이 없음") }
                updatingTerm[0].setValue(updateIndex, forKey: "index")
                try context?.save()
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return false
    }
}
