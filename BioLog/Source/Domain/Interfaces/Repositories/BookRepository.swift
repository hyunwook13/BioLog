//
//  BookRepository.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol BookRepository {
    func findBooks(byTitle title: String) -> Single<[BookDTO]>
    func save(with book: BookDTO) -> Observable<BookDTO>
    func fetchNewBooks() -> Single<[BookDTO]>
    func fetchReadingBooks() -> Single<[BookDTO]>
    func delete(with book: BookDTO) -> Completable
}
