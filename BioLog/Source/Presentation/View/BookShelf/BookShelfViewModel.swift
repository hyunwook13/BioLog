//
//  BookShelfViewModel.swift
//  BioLog
//
//  Created by 이현욱 on 3/24/25.
//

import UIKit

import RxSwift
import RxCocoa



protocol BookShelfViewModelAble {
    var selectedIndex: AnyObserver<Int> { get }
    var searchBookTitle: AnyObserver<String> { get }
    var selectedBook: AnyObserver<BookDTO> { get }
    var viewWillAppear: AnyObserver<Void> { get }
    
    var searchedBook: Driver<[BookDTO]> { get }
}

enum BookShelfType: Int {
    case all = 0
    case reading = 1
    case bookmared = 2
}

final class BookShelfViewModel: BookShelfViewModelAble {
    
    private let disposeBag = DisposeBag()
    
    private let selectedIndexSubject = PublishSubject<Int>()
    private let searchBookTitleSubject = PublishSubject<String>()
    private let selectedBookSubject = PublishSubject<BookDTO>()
    private let viewWillAppearSubject = PublishSubject<Void>()
    private let searchedBookRelay = PublishRelay<[BookDTO]>()
    
    init(usecase: BookUseCase, action: BookShelfActionAble) {
        Observable.combineLatest(viewWillAppearSubject.startWith(()), searchBookTitleSubject)
            .flatMap { _, title in
                return usecase.searchLocalBooks(with: title)
            }
            .subscribe { [weak self] books in
                self?.searchedBookRelay.accept(books)
            }.disposed(by: disposeBag)
        
        selectedIndexSubject
            .map { return BookShelfType(rawValue: $0)! }
            .flatMap { type in
                usecase.fetchBooksBySegmentType(type)
            }.bind(to: searchedBookRelay)
            .disposed(by: disposeBag)
        
        selectedBookSubject
            .bind {
                action.pushWithBook(book: $0)
            }.disposed(by: disposeBag)
    }
    
    var selectedIndex: RxSwift.AnyObserver<Int> {
        return selectedIndexSubject.asObserver()
    }
    
    var searchBookTitle: RxSwift.AnyObserver<String> {
        return searchBookTitleSubject.asObserver()
    }
    
    var selectedBook: AnyObserver<BookDTO> {
        return selectedBookSubject.asObserver()
    }
    
    var viewWillAppear: AnyObserver<Void> {
        return viewWillAppearSubject.asObserver()
    }
    
    var searchedBook: Driver<[BookDTO]> {
        return searchedBookRelay.asDriver(onErrorJustReturn: [])
    }
}
