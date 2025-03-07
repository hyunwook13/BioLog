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
    
    init(usecase: BookUseCaseAble, action: SearchBookAction) {
        cancelSubject
            .subscribe { _ in
                action.cancel()
            }.disposed(by: disposeBag)
        
        searchedTitleSubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { text in
                usecase.search(title: text)
            }
            .subscribe(onNext: { books in
                self.booksSubject.onNext(books)
            }, onError: { error in
                self.booksSubject.onError(error)
            })
            .disposed(by: disposeBag)
        
        selectedBookSubject
            .flatMap {
                usecase.save(with: $0)
            }.subscribe {
                action.selected($0)
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
