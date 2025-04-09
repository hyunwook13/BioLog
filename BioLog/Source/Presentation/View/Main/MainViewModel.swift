//
//  MainViewModel.swift
//  BioLog
//
//  Created by 이현욱 on 2/26/25.
//

import Foundation


import RxSwift
import RxCocoa
import RxDataSources

struct Section {
    let title: String
    var books: [SectionItem]
}

enum SectionItem {
    case savedBooks([CompleteBook])    // 배열 전체를 담는 케이스
    case recommendedBook(CompleteBook) // 개별 책 한 권씩 처리
}

extension Section: SectionModelType {
    typealias Item = SectionItem
    
    init(original: Section, items: [SectionItem]) {
        self = original
        self.books = items
    }
    
    var items: [SectionItem] {
        return books
    }
}

protocol MainViewModelAble {
    var add: AnyObserver<Void> { get }
    var chart: AnyObserver<Void> { get }
    var viewWillAppear: AnyObserver<Void> { get }
    var selectReadingBook: AnyObserver<CompleteBook> { get }
    var selectNewBook: AnyObserver<CompleteBook> { get }
    
    var newBooks: Driver<[CompleteBook]> { get }
    var readingBooks: Driver<[CompleteBook]> { get }
    var book: Driver<[Section]> { get }
}

final class MainViewModel: MainViewModelAble {
    private let booksChangedSubject = PublishSubject<Void>()
    private let usecase: BookUseCase
    private let disposeBag = DisposeBag()
    
    private let addSubject = PublishSubject<Void>()
    private let chartSubject = PublishSubject<Void>()
    private let viewWillAppearSubject = PublishSubject<Void>()
    private let selectReadingBookSubject = PublishSubject<CompleteBook>()
    private let selectNewBookSubject = PublishSubject<CompleteBook>()
    
    private let newBooksSubject = PublishSubject<[CompleteBook]>()
    private let readingBooksSubject = PublishSubject<[CompleteBook]>()
    
    init(usecase: BookUseCase, actions: MainActionAble) {
        self.usecase = usecase
        registerObserver()
        
        addSubject
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                actions.add()
            }.disposed(by: disposeBag)
        
        selectReadingBookSubject
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe { book in
                actions.selectedReadingBook(with: book)
            }.disposed(by: disposeBag)
        
        selectNewBookSubject
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe { book in
                actions.selectedNewBook(with: book)
            }.disposed(by: disposeBag)
        
        chartSubject
            .bind {
                actions.chart()
            }.disposed(by: disposeBag)
        
        Observable.merge(viewWillAppearSubject, booksChangedSubject)
//            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ -> Observable<[BookDTO]> in
                guard let self = self else { return .just([]) }
                return self.usecase.fetchReadingBooks()
                    .asObservable()
                    .retry(2)
                    .catch { _ in .just([]) }
            }
            .map { books in
                return books.map {
                    return CompleteBook(
                        detail: $0,
                        category: $0.category,
                        characters: $0.characters
                    )
                }
            }
            .subscribe(readingBooksSubject)
            .disposed(by: disposeBag)
        
        Observable.merge(viewWillAppearSubject, booksChangedSubject)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .flatMap { [weak self] _ -> Single<[BookDTO]> in
                guard let self = self else { return .just([]) }
                return self.usecase.fetchNewBooks()
                    .catch { _ in .just([]) }
            }
            .map { books in
                return books.map {
                    return CompleteBook(detail: $0, category: $0.category, characters: $0.characters)
                }
            }
            .subscribe(newBooksSubject)
            .disposed(by: disposeBag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var add: AnyObserver<Void> {
        addSubject.asObserver()
    }
    
    var chart: AnyObserver<Void> {
        chartSubject.asObserver()
    }
    
    var viewWillAppear: AnyObserver<Void> {
        viewWillAppearSubject.asObserver()
    }
    
    var selectReadingBook: AnyObserver<CompleteBook> {
        selectReadingBookSubject.asObserver()
    }
    
    var selectNewBook: AnyObserver<CompleteBook> {
        selectNewBookSubject.asObserver()
    }
    
    var newBooks: Driver<[CompleteBook]> {
        newBooksSubject.asDriver(onErrorJustReturn: [])
    }
    
    var readingBooks: Driver<[CompleteBook]> {
        readingBooksSubject.asDriver(onErrorJustReturn: [])
    }
    
    var book: Driver<[Section]> {
        Observable.combineLatest(readingBooksSubject, newBooksSubject)
            .map { (readingBooks, newBooks) in
                return [
                    Section(title: "저장된 책", books: [.savedBooks(readingBooks)]),
                    Section(title: "따끈따끈 신간 도서", books: newBooks.map { .recommendedBook($0)} )
                ]
            }.asDriver(onErrorJustReturn: [])
    }
}

extension MainViewModel {
    private func registerObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshData),
            name: Notification.Name("RefreshMainViewData"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshData),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc func refreshData() {
        booksChangedSubject.onNext(())
    }
}
