//
//  BookUseCase.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol BookUseCaseAble {
    func search(title: String) -> Single<[BookDTO]>
    func save(with book: BookDTO) -> Single<BookDTO>
    func fetchNewBooks() -> Single<[BookDTO]>
    func fetchReadingBooks() -> Single<[BookDTO]>
 }

final class BookUseCase: BookUseCaseAble {
    private let repo: BookRepository
    
    init(repo: BookRepository) {
        self.repo = repo
    }
    
    func search(title: String) -> Single<[BookDTO]> {
        return repo.findBooks(byTitle: title)
    }
    
    func save(with book: BookDTO) -> Single<BookDTO> {
        return repo.save(with: book).asSingle()
    }
    
    func fetchNewBooks() -> Single<[BookDTO]> {
        return repo.fetchNewBooks()
    }
    
    func fetchReadingBooks() -> Single<[BookDTO]> {
        return repo.fetchNewBooks()
    }
}
