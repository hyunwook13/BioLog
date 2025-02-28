//
//  BookRepositoryImpl.swift
//  BioLog
//
//  Created by 이현욱 on 3/7/25.
//

import Foundation

import RxSwift
import RxCocoa

final class BookRepositoryImpl: BookRepository {
    private let client: Client
    private let storage: CoreData
    
    init(client: Client, storage: CoreData = CoreData.shared) {
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
                    single(.failure(BookError.searchFailed(error)))
                }
            }
            
            // Task를 취소할 수 있는 Disposable 반환
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func save(with book: BookDTO) -> Observable<BookDTO> {
        let cdbook = storage.create(Book.self) { object in
            object.book_description = book.description
            object.author = book.author
            object.title = book.title
            object.id = UUID().uuidString
            object.isbn = book.isbn
            object.cover = book.cover
            object.pubDate = book.pubDate
        }
        
        return cdbook.map { $0.toDTO() }
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
                    single(.failure(BookError.searchFailed(error)))
                }
            }
            
            // Task를 취소할 수 있는 Disposable 반환
            return Disposables.create {
                task.cancel()
            }
            
        }
    }
    
    func fetchReadingBooks() -> Single<[BookDTO]> {
        storage.fetch(Book.self)
            .map { $0.map { $0.toDTO() } }
            .asSingle()
    }
}
