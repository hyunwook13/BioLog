//
//  SearchBookUseCase.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol SearchBookUseCaseAble {
    func search(title: String) -> Observable<[BookDTO]>
}

final class BookUseCase: SearchBookUseCaseAble {
    private let repo: BookRepositoryAble
    
    init(repo: BookRepositoryAble) {
        self.repo = repo
    }
    
    func search(title: String) -> Observable<[BookDTO]> {
        return repo.findBooks(byTitle: title)
    }
}
