//
//  BookRepositoryImpl.swift
//  BioLog
//
//  Created by 이현욱 on 3/7/25.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

final class BookRepositoryImpl: BookRepository {
    
    private let client: Client
    private let storage: StorageAble
    
    init(client: Client, storage: StorageAble) {
        self.client = client
        self.storage = storage
    }
    
    func findBooks(byTitle title: String) -> Single<[BookDTO]> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            // 취소 가능한 Task를 생성
            let task = Task {
                do {
                    let endpoint: Endpoint<BookResponse> = BookAPI.searchBooks(title: title).typedEndpoint()
                    let books = try await self.client.request(with: endpoint)
                    
                    // 실제 데이터를 반환
                    single(.success(books.item))
                } catch {
                    single(.failure(error))
                }
            }
            
            // Task를 취소할 수 있는 Disposable 반환
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func save(with book: BookDTO) -> Observable<BookDTO> {
        storage.create(book)
            .map { $0.toDTO() }
    }
    
    func fetchNewBooks() -> Single<[BookDTO]> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            // 취소 가능한 Task를 생성
            let task = Task {
                do {
                    let endpoint: Endpoint<BookResponse> = BookAPI.fetchNewBooks.typedEndpoint()
                    let books = try await self.client.request(with: endpoint)
                    
                    // 실제 데이터를 반환
                    single(.success(books.item))
                } catch {
                    single(.failure(error))
                }
            }
            
            // Task를 취소할 수 있는 Disposable 반환
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func fetchReadingBooks() -> Single<[BookDTO]> {
        storage.fetch(Book.self, predicate: nil, sortDescriptors: nil)
            .map { $0.map { $0.toDTO() } }
            .asSingle()
    }
    
    func delete(with book: BookDTO) -> Completable {
        return storage.fetch(Book.self, predicate: NSPredicate(format: "isbn == %@", book.isbn), sortDescriptors: nil)
            .compactMap { $0.first }
//            .withUnretained(self)
            .flatMap { [weak self] fetchedBook -> Completable in
                guard let self = self else {
                    return Completable.error(NSError(domain: "BookRepository", code: -1, userInfo: nil))
                }
                
                return storage.delete(with: fetchedBook)
            }.asCompletable()
        
    }
    
    private func makeCategories(with data: String) -> [CategoryDTO] {
        let categories = data.split(separator: " ")
        
        var result = [CategoryDTO]()
        
        for category in categories {
            result.append(CategoryDTO(name: String(category)))
        }
        
        return result
    }
}
