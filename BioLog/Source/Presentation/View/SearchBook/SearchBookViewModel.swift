//
//  SearchBookViewModel.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol SearchBookViewModelAble {
    
    // Input
    var cancel: AnyObserver<Void> { get }
    var searchedTitle: AnyObserver<String> { get }
    var selectedBook: AnyObserver<BookDTO> { get }
    
    // Output
    var books: Driver<[BookDTO]> { get }
}

final class SearchBookViewModel: SearchBookViewModelAble {
    
    private let disposeBag = DisposeBag()
    
    private let searchedTitleSubject = PublishSubject<String>()
    private let cancelSubject = PublishSubject<Void>()
    private let selectedBookSubject = PublishSubject<BookDTO>()
    
    private let booksSubject = PublishSubject<[BookDTO]>()
    
    init(categoryUseCase: CategoryUseCase, bookUseCase: BookUseCase, action: SearchBookActionAble, scheduler: SchedulerType = MainScheduler.instance) {
        cancelSubject
            .subscribe { _ in
                action.cancel()
            }.disposed(by: disposeBag)
        
        searchedTitleSubject
            .debounce(.milliseconds(300), scheduler: scheduler)
            .distinctUntilChanged()
            .flatMapLatest { text in
                return bookUseCase.searchBooksFromNetwork(with: text)
                    .asObservable()
                    .retry(2)
                    .catchAndReturn([])
            }
            .bind(to: booksSubject)
            .disposed(by: disposeBag)
        
        selectedBookSubject
            .flatMap { book in
                return bookUseCase.save(with: book)
            }
            .flatMap { book -> Observable<(BookDTO, CategoryDTO)> in
                let category = categoryUseCase.saveCategory(book.categoryName, book).asObservable()
                
                return Observable.zip(Observable.of(book), category)
            }
            .map { book, category in
                return CompleteBook(detail: book, category: category, characters: [])
            }.bind { completeBook in
                action.selected(completeBook)
            }.disposed(by: disposeBag)
    }
    
    var cancel: AnyObserver<Void> {
        cancelSubject.asObserver()
    }
    
    var searchedTitle: AnyObserver<String> {
        searchedTitleSubject.asObserver()
    }
    
    var selectedBook: AnyObserver<BookDTO> {
        selectedBookSubject.asObserver()
    }
    
    var books: Driver<[BookDTO]> {
        booksSubject.asDriver(onErrorJustReturn: [])
    }
}
