//
//  BookUseCase.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol BookUseCase {
    func searchBooksFromNetwork(with title: String) -> Single<[BookDTO]>
    func save(with book: BookDTO) -> Single<BookDTO>
    func fetchNewBooks() -> Single<[BookDTO]>
    func fetchReadingBooks() -> Single<[BookDTO]>
    func searchLocalBooks(with title: String) -> Single<[BookDTO]>
    func delete(with book: BookDTO) -> Completable
    func fetchBooksBySegmentType(_ type: BookShelfType) -> Single<[BookDTO]>
}

final class BookUseCaseImpl: BookUseCase {
    
    private var firstFetch = false
    private let repo: BookRepository
    private let disposeBag = DisposeBag()
    
    internal var cachedReadingBooks: [BookDTO] = []
    
    init(repo: BookRepository) {
        self.repo = repo
    }
    
    func searchLocalBooks(with title: String) -> Single<[BookDTO]> {
        return Single.create { [weak self] observer in
            guard let self = self else {
                observer(.failure(NSError(domain: "BookUseCase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            let cachedBooks = self.cachedReadingBooks
            
            if title.isEmpty {
                observer(.success(cachedBooks))
            } else {
                let isChosungCheck = HanguelChecker.isChosung(word: title)
                
                let filtered = cachedBooks.filter { book in
                    if isChosungCheck {
                        return book.title.contains(title) || HanguelChecker.chosungCheck(word: book.title).contains(title)
                    } else {
                        return book.title.contains(title)
                    }
                }
                
                observer(.success(filtered))
            }
            return Disposables.create()
        }
    }
    
    func fetchBooksBySegmentType(_ type: BookShelfType) -> RxSwift.Single<[BookDTO]> {
        var result: [BookDTO] = []
        switch type {
        case .all:
            result = cachedReadingBooks
        case .reading:
            result = cachedReadingBooks.filter { !$0.isBookmarked }
        case .bookmared:
            result = cachedReadingBooks.filter { $0.isBookmarked }
        }
        
        return Observable.just(result).asSingle()
    }
    
    func searchBooksFromNetwork(with title: String) -> Single<[BookDTO]> {
        return repo.findBooks(byTitle: title)
    }
    
    func save(with book: BookDTO) -> Single<BookDTO> {
        return repo.save(with: book)
            .flatMapLatest { [weak self] savedBook -> Single<BookDTO> in
                guard let self else { return .just(savedBook) }
                return self.reloadCache().map { _ in savedBook }
            }
            .asSingle()
    }
    
    func fetchReadingBooks() -> Single<[BookDTO]> {

        if cachedReadingBooks.isEmpty && !firstFetch {
            return reloadCache()
        }
        
        return Observable.of(cachedReadingBooks).asSingle()
    }
    
    func fetchNewBooks() -> Single<[BookDTO]> {
        return repo.fetchNewBooks()
    }
    
    func delete(with book: BookDTO) -> Completable {
        return repo.delete(with: book)
            .do (onCompleted: { [weak self] in
                if let index = self?.cachedReadingBooks.firstIndex(where: { $0.isbn == book.isbn }) {
                    // 해당 인덱스의 요소를 제거합니다.
                    self?.cachedReadingBooks.remove(at: index)
                    NotificationCenter.default.post(name: Notification.Name("RefreshMainViewData"), object: nil)
                }
            })
    }
    
    internal func setCachedReadingBooks(_ books: [BookDTO]) {
        cachedReadingBooks = books
    }
    
//    internal func fetchReadingBooksFromCache() -> [BookDTO] {
//        return cachedReadingBooks
//    }
    
    @discardableResult
    private func reloadCache() -> Single<[BookDTO]> {
        return repo.fetchReadingBooks()
            .do(onSuccess: { [weak self] books in
                self?.firstFetch = true
                self?.cachedReadingBooks = books
                NotificationCenter.default.post(name: Notification.Name("RefreshMainViewData"), object: nil)
            })
    }
}
