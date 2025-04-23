//
//  PreviewViewModel.swift
//  BioLog
//
//  Created by 이현욱 on 4/14/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol PreviewViewModelAble {
    var book: CompleteBook { get }
    
    var save: AnyObserver<Void> { get }
}

final class PreviewViewModel: PreviewViewModelAble {
    internal let book: CompleteBook
    private let disposeBag = DisposeBag()

    let saveSubject = PublishSubject<Void>()
    
    init(book: CompleteBook, usecase: BookUseCase) {
        self.book = book
        
        saveSubject
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind {
//                let _ = usecase.save(with: book)
            }.disposed(by: disposeBag)
    }
    
    var save: RxSwift.AnyObserver<Void> {
        saveSubject.asObserver()
    }
}
