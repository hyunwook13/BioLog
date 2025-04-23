//
//  EditNoteViewModel.swift
//  BioLog
//
//  Created by 이현욱 on 4/15/25.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

protocol EditNoteAction {
    func pop()
}

struct EditNoteActionAble: EditNoteAction {
    let popHandler: () -> Void
    
    func pop() {
        popHandler()
    }
}

protocol EditNoteViewModelAble {
    var context: AnyObserver<String> { get }
    var page: AnyObserver<String> { get }
    
    var save: AnyObserver<Void> { get }
}

class EditNoteViewModel: EditNoteViewModelAble {
    
    private let disposeBag = DisposeBag()
    
    private let contextSubject = PublishSubject<String>()
    private let pageSubject = PublishSubject<String>()
    private let saveSubject = PublishSubject<Void>()
    
    private let actionSubject = PublishSubject<Void>()
    
    
    // 초기화 메서드
    init(note: NoteDTO, usecase: NoteUseCase, action: EditNoteAction, scheduler: SchedulerType = MainScheduler.instance) {
        
        let noteStream = Observable.combineLatest(contextSubject, pageSubject)
        
        actionSubject
            .bind {
                action.pop()
            }.disposed(by: disposeBag)
        
        saveSubject
            .throttle(.seconds(1), latest: false, scheduler: scheduler)
            .withLatestFrom(noteStream)
            .flatMap { context, page -> Observable<Void> in
                let noteDTO = NoteDTO(context: context, page: page, uuid: note.uuid)
                return usecase.updateNote(with: noteDTO)
                    .andThen(Observable.just(()))
            }
            .asObservable()
            .subscribe({ completed in
                switch completed {
                case .next(_) :
                    self.actionSubject.onNext(())
                case .completed:
                    return
                case .error(let error):
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    var context: RxSwift.AnyObserver<String> {
        contextSubject.asObserver()
    }
    
    var page: RxSwift.AnyObserver<String> {
        pageSubject.asObserver()
    }
    
    var save: RxSwift.AnyObserver<Void> {
        saveSubject.asObserver()
    }
}
