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
//    func save(with book: BookDTO) -> Observable<[BookDTO]>
}

final class BookUseCase: BookUseCaseAble {
    private let repo: BookRepositoryAble
    
    init(repo: BookRepositoryAble) {
        self.repo = repo
    }
    
    func search(title: String) -> Single<[BookDTO]> {
        return repo.findBooks(byTitle: title)
    }
    
//    func save(with book: BookDTO) -> Observable<[BookDTO]> {
//        return repo.save(with: book)
//    }
}
