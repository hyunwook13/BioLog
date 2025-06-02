//
//  PreviewViewModel.swift
//  BioLog
//
//  Created by 이현욱 on 4/14/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol BookmarkUseCase{
    func save(with: BookDTO) -> Single<BookmarkDTO>
}
protocol PreviewViewModelAble {
    var book: CompleteBook { get }
    
    var save: AnyObserver<Void> { get }
    var error: AnyObserver<Error?> {get}
}

final class PreviewViewModel: PreviewViewModelAble {
    internal let book: CompleteBook
    private let disposeBag = DisposeBag()

    let saveSubject = PublishSubject<Void>()
    let errorSubject = PublishSubject<Error?>()
    
    init(book: CompleteBook, bookUseCase: BookUseCase/*, bookmarkUseCase: BookmarkUseCase*/) {
        self.book = book
        
        
        
//        saveSubject
//            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
//            .flatMapLatest { _ -> Single<BookDTO> in
//                return bookUseCase.save(with: book.detail)
//            }.subscribe(onNext: { _ in
//                self.errorSubject.onNext(nil)
//            }, onError: {
//                self.errorSubject.onNext($0)
//                self.refresh()
//            }).disposed(by: disposeBag)
        
        
//            .bind {
////                let _ = usecase.save(with: book)
//            }.disposed(by: disposeBag)
        
//            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
////            .filter { $0 == .character }
//            .withLatestFrom(bookSubject)  { (type: $0, book: $1) }
//            .withUnretained(self)
//            .flatMap { params -> Single<CharacterDTO> in
//                let dto = CharacterDTO(age: "", name: "", sex: "", labor: "")
//                return characterUseCase.add(with: dto, book: book.detail)
//            }
//            .withLatestFrom(charactersSubject) { (newChar, existingChars) -> [CharacterDTO] in
//                [newChar] + existingChars
//            }
//            .bind(to: charactersSubject)
//            .disposed(by: disposeBag)
    }
    
    func refresh() {
        
    }
    
    var save: RxSwift.AnyObserver<Void> {
        saveSubject.asObserver()
    }
    
    var error: AnyObserver<Error?> {
        errorSubject.asObserver()
    }
}
