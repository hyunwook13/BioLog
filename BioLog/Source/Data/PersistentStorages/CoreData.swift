//
//  CoreData.swift
//  BioLog
//
//  Created by 이현욱 on 2/28/25.
//

import Foundation
import CoreData

import RxSwift
import RxCocoa

protocol StorageAble { }

final class CoreData: StorageAble {
    static let shared = CoreData()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HaloGlow")
        container.loadPersistentStores { a, error in
            if let error {
                fatalError("❌ Failed to load persistent store: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
//                resetCoreData()
    }
    
    @discardableResult
    func create<T: NSManagedObject>(_ entityType: T.Type, configure: @escaping (T) -> Void) -> Observable<T> {
        return Observable.create { observer in
            // ✅ 옵셔널 바인딩을 사용하여 안전하게 엔티티 생성
            let entity = T(context: self.viewContext)
            
            configure(entity) // ✅ 엔티티 설정
            
            do {
                try self.viewContext.save() // ✅ 저장 수행
                observer.onNext(entity) // ✅ 성공적으로 생성된 객체 반환
                observer.onCompleted()
            } catch {
                observer.onError(error) // ❌ 저장 실패 시 에러 전달
            }
            
            return Disposables.create()
        }
    }
    
    func fetch<T: NSManagedObject>(_ entityType: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> Observable<[T]> {
        return Observable.create { observer in
            let request = NSFetchRequest<T>(entityName: String(describing: entityType))
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            do {
                let tasks = try self.viewContext.fetch(request)
//                print(tasks)
                observer.onNext(tasks) // ✅ UI 업데이트 가능
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
