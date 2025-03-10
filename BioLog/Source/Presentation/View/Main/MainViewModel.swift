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
    case savedBooks([BookDTO])    // 배열 전체를 담는 케이스
    case recommendedBook(BookDTO) // 개별 책 한 권씩 처리
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
    var viewWillAppear: AnyObserver<Void> { get }
    var selectBook: AnyObserver<BookDTO> { get }
    
    var newBooks: Driver<[BookDTO]> { get }
    var readingBooks: Driver<[BookDTO]> { get }
    var book: Driver<[Section]> { get }
    
    func refreshData()
}

final class MainViewModel: MainViewModelAble {
    
    private let disposeBag = DisposeBag()
    
    private let addSubject = PublishSubject<Void>()
    private let viewWillAppearSubject = PublishSubject<Void>()
    private let selectBookSubject = PublishSubject<BookDTO>()
    
    private let newBooksSubject = PublishSubject<[BookDTO]>()
    private let readingBooksSubject = PublishSubject<[BookDTO]>()
    
    private let booksChangedSubject = PublishSubject<Void>()
    private let usecase: BookUseCaseAble
    
    init(usecase: BookUseCaseAble, actions: MainAction) {
        self.usecase = usecase
        registerObserver()
        
        addSubject
            .subscribe { _ in
                actions.add()
            }.disposed(by: disposeBag)

        selectBookSubject
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe { book in
                actions.selectedBook(book)
            }.disposed(by: disposeBag)
        
        Observable.merge(viewWillAppearSubject, booksChangedSubject)
            .flatMap { [weak self] _ -> Single<[BookDTO]> in
                guard let self = self else { return .just([]) }
                return self.usecase.fetchReadingBooks()
            }
            .subscribe { [weak self] books in
                guard let self = self else { return }
                self.readingBooksSubject.onNext(books)
            }.disposed(by: disposeBag)
        
        Observable.merge(viewWillAppearSubject, booksChangedSubject)
            .flatMap { [weak self] _ -> Single<[BookDTO]> in
                guard let self = self else { return .just([]) }
                return self.usecase.fetchNewBooks()
            }
            .subscribe { [weak self] books in
                guard let self = self else { return }
                self.newBooksSubject.onNext(books)
            }.disposed(by: disposeBag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var add: AnyObserver<Void> {
        addSubject.asObserver()
    }
    
    var viewWillAppear: AnyObserver<Void> {
        viewWillAppearSubject.asObserver()
    }
    
    var selectBook: AnyObserver<BookDTO> {
        selectBookSubject.asObserver()
    }
    
    var newBooks: Driver<[BookDTO]> {
        newBooksSubject.asDriver(onErrorJustReturn: [])
    }
    
    var readingBooks: Driver<[BookDTO]> {
        readingBooksSubject.asDriver(onErrorJustReturn: [])
    }
    
    var book: RxCocoa.Driver<[Section]> {
        Observable.combineLatest(readingBooksSubject, newBooksSubject)
            .map { (readingBooks, newBooks) in
                print(readingBooks)
                return [
                    Section(title: "저장된 책", books: [.savedBooks(readingBooks)]),
                    Section(title: "따끈따끈 신간 도서", books: newBooks.map { .recommendedBook($0)} )
                ]
            }.asDriver(onErrorJustReturn: [])
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshData),
            name: Notification.Name("RefreshMainViewData"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCoreDataChanges),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
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
    
    @objc private func handleCoreDataChanges(notification: Notification) {
//        guard let userInfo = notification.userInfo else { return }
//        
//        let changedEntities = [
//            NSInsertedObjectsKey,
//            NSUpdatedObjectsKey,
//            NSDeletedObjectsKey
//        ].flatMap { (userInfo[$0] as? Set<NSManagedObject>)?.compactMap { $0 as? Book } ?? [] }
//        
//        if !changedEntities.isEmpty {
//            refreshData()
//        }
    }
    

}
