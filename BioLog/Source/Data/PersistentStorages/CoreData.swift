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

protocol StorageAble {
    func save() throws
    func create<T: CoreDataConvertible>(_ dto: T) -> Observable<T.CoreDataType>
    func fetch<T: NSManagedObject>(_ entityType: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Observable<[T]>
    func delete(with object: NSManagedObject) -> Completable
    func update<T: NSManagedObject>(_ object: T) -> Completable
}

// 1. DTO와 NSManagedObject 간의 매핑을 위한 프로토콜 정의
protocol CoreDataConvertible {
    associatedtype CoreDataType: NSManagedObject
    
    func toCoreDataObject(in context: NSManagedObjectContext) -> CoreDataType
}

final class CoreData: StorageAble {
    
    let mainContext: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer?
    
    init(mainContext: NSManagedObjectContext, container: NSPersistentContainer? = nil) {
        self.mainContext = mainContext
        self.persistentContainer = container
//        mainContext.refreshAllObjects()
//        observeChanges()
        //        resetCoreData()
//                fetchEveryBookCharacter()
//        insertThousandRecords()
    }
    
    // 3. 제네릭 메서드 확장
    func create<T: CoreDataConvertible>(_ dto: T) -> Observable<T.CoreDataType> {
        let entity = dto.toCoreDataObject(in: mainContext)
        do {
            try save()
        } catch {
            return Observable.error(error)
        }
        
        return Observable.just(entity)
    }
    
    func fetch<T: NSManagedObject>(_ entityType: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> Observable<[T]> {
        return Observable.create { observer in
            let request = NSFetchRequest<T>(entityName: String(describing: entityType))
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            do {
                let tasks = try self.mainContext.fetch(request)
//                print("task: ", tasks)
                observer.onNext(tasks) // ✅ UI 업데이트 가능
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func save() throws {
        // 컨텍스트 저장 확인
        if mainContext.hasChanges {
            do {
                try mainContext.save()
                NotificationCenter.default.post(name: Notification.Name("RefreshMainViewData"), object: nil)
                print("✅ 관계를 포함한 객체 저장 성공")
            } catch {
                print("❌ 객체 저장 실패: \(error)")
                throw error
            }
        }
    }
    
    @discardableResult
    func delete(with object: NSManagedObject) -> Completable {
        return Completable.create { completable in
            do {
                self.mainContext.delete(object)
                try self.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    @discardableResult
    func update<T: NSManagedObject>(_ object: T) -> Completable {
        return Completable.create { observer in
            do {
                try self.save()
                self.fetchEveryBookCharacter()
                print("✅ 객체 업데이트 성공")
                observer(.completed)
            } catch {
                print("❌ 객체 업데이트 실패: \(error)")
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    private func resetCoreData() {
        let entities = persistentContainer?.managedObjectModel.entities
        entities?.compactMap { $0.name }.forEach { entityName in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try persistentContainer?.viewContext.execute(deleteRequest)
            } catch {
                print("❌ Failed to reset Core Data: \(error)")
            }
        }
    }
    
    private func fetchEveryBookCharacter() {
        //                 BookCharacter 엔티티를 패치하는 예시 코드
        let request = NSFetchRequest<BookCharacter>(entityName: "BookCharacter")
        do {
            let characters = try mainContext.fetch(request)
            print("패치된 BookCharacter 수: \(characters.count)")
            for character in characters {
                print("character 시작")
                print("이름: \(character.name ?? "이름 없음")")
                print("나이: \(character.age ?? "나이 없음")")
                print("성별: \(character.sex ?? "성별 정보 없음")")
                if let book = character.book {
                    print("연관된 책: \(book.title ?? "제목 없음") (ISBN: \(book.isbn ?? "ISBN 없음"))")
                } else {
                    print("연관된 책 없음")
                }
                if let uuid = character.uuid {
                    print("UUID: \(uuid)")
                }
                print("character 끝")
            }
        } catch {
            print("BookCharacter 패치 실패: \(error)")
        }
    }
    
    func insertThousandRecords() {
        persistentContainer?.performBackgroundTask { context in
            let start = Date()
            
            for i in 1...10000 {
                let bookDTO = CharacterDTO.empty
                let entity = BookCharacter(context: context)
                entity.uuid = bookDTO.uuid
//                entity.title = "Item \(i)"
//                entity.timestamp = Date()
                // 필요한 속성들 설정
            }

            do {
                print("들어가긴횄어?")
                try context.save()
                let end = Date()
                print("✅ 1,000개 저장 완료 (\(end.timeIntervalSince(start))초)")
            } catch {
                print("❌ 저장 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func observeChanges()  {
        NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextObjectsDidChange,
            object: mainContext,
            queue: .main
        ) { _ in
            NotificationCenter.default.post(name: Notification.Name("RefreshMainViewData"), object: nil)
        }
    }
}
