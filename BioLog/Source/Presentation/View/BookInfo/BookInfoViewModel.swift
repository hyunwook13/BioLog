//
//  BookInfoViewModel.swift
//  BioLog
//
//  Created by 이현욱 on 3/7/25.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources

protocol BookInfoViewModelAble {
    // Input
    var viewWillAppear: AnyObserver<Void> { get }
    var addCharacter: AnyObserver<Void> { get }
//    var addNote: AnyObserver<Void> { get }
    var selectedCharacter: AnyObserver<CharacterDTO> { get }
//    var selectedNote: AnyObserver<NoteDTO> { get }
    var delete: AnyObserver<Void> { get }
    
    var result: Driver<[InfoSection]> { get }
}

final class BookInfoViewModel: BookInfoViewModelAble {
    private let disposeBag = DisposeBag()
    private let characterUseCase: CharactersUseCase
    private let noteUseCase: NoteUseCase
    private let bookUseCase: BookUseCase
    
    private let viewWillAppearSubject = PublishSubject<Void>()
    private let deleteSubject = PublishSubject<Void>()
//    private let addNoteSubject = PublishSubject<Void>()
    private let addCharacterSubject = PublishSubject<Void>()
    private let characterEditCellSubject = PublishSubject<CharacterDTO>()
//    private let noteEditCellSubject = PublishSubject<NoteDTO>()
    
    private let bookSubject: BehaviorSubject<CompleteBook>
    private let charactersSubject = BehaviorSubject<[CharacterDTO]>(value: []) // Add characters subject
//    private let notesSubject = BehaviorSubject<[NoteDTO]>(value: [])
    
    private let actionSubject = PublishSubject<Void>()
    
    // Modify to include character use case
    init(book: CompleteBook,
         bookUseCase: BookUseCase,
         characterUseCase: CharactersUseCase,
         noteUseCase: NoteUseCase,
         actions: BookInfoAction) {
        self.bookSubject = BehaviorSubject<CompleteBook>(value: book)
        self.characterUseCase = characterUseCase
        self.noteUseCase = noteUseCase
        self.bookUseCase = bookUseCase
        
        characterEditCellSubject
            .bind {
                actions.pushCharacter($0)
            }.disposed(by: disposeBag)
        
        // Handle viewWillAppear to fetch characters
        viewWillAppearSubject
            .withLatestFrom(bookSubject)
            .map { $0.detail.isbn }
            .flatMap { isbn in
                characterUseCase.execute(isbn: isbn).asObservable()
            }
            .bind(to: charactersSubject)
            .disposed(by: disposeBag)
        // Character 추가 구독
        
        addCharacterSubject
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
//            .filter { $0 == .character }
            .withLatestFrom(bookSubject)  { (type: $0, book: $1) }
            .withUnretained(self)
            .flatMap { params -> Single<CharacterDTO> in
                let dto = CharacterDTO(age: "", name: "", sex: "", labor: "")
                return characterUseCase.add(with: dto, book: book.detail)
            }
            .withLatestFrom(charactersSubject) { (newChar, existingChars) -> [CharacterDTO] in
                [newChar] + existingChars
            }
            .bind(to: charactersSubject)
            .disposed(by: disposeBag)
        
        // Note 추가 구독
//        addNoteSubject
//            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
////            .filter { $0 == .note }
//            .withLatestFrom(bookSubject)  { (type: $0, book: $1) }
//            .withUnretained(self)
//            .flatMap { params -> Single<NoteDTO> in
//                let dto = NoteDTO(context: "", page: "", uuid: UUID().uuidString)
//                return noteUseCase.add(with: dto, book: book.detail)
//            }
//            .withLatestFrom(notesSubject) { (newNote, existingNotes) -> [NoteDTO] in
//                [newNote] + existingNotes
//            }
//            .bind(to: notesSubject)
//            .disposed(by: disposeBag)
        

        
//        noteEditCellSubject
//            .bind {
//                actions.pushWithNote($0)
//            }.disposed(by: disposeBag)
        
        deleteSubject
            .flatMap { _ -> Observable<Void> in
                return bookUseCase.delete(with: book.detail)
                    .andThen(Observable.just(()))
            }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.actionSubject.onNext(())
            }, onError: { error in
                print("❌ VM 에러: \(error)")
            }, onCompleted: {
                print("🎉 VM에서 완료받음")
                
            })
            .disposed(by: disposeBag)
        
        actionSubject
            .bind {
                actions.pop()
            }.disposed(by: disposeBag)
    }
    
    deinit {
        print("BookInfoViewModel deinit")
    }
    
    // Input
//    var addNote: AnyObserver<Void> {
//        addNoteSubject.asObserver()
//    }
    
    var addCharacter: AnyObserver<Void> {
        addCharacterSubject.asObserver()
    }
    
    var viewWillAppear: AnyObserver<Void> {
        viewWillAppearSubject.asObserver()
    }
    
    var selectedCharacter: AnyObserver<CharacterDTO> {
        characterEditCellSubject.asObserver()
    }
    
//    var selectedNote: AnyObserver<NoteDTO> {
//        noteEditCellSubject.asObserver()
//    }
    
    var delete: AnyObserver<Void> {
        deleteSubject.asObserver()
    }
    
    var result: Driver<[InfoSection]> {
        Observable.combineLatest(bookSubject, charactersSubject)
            .map { book, characters in
                return [
                    InfoSection(
                        title: "Book Info",
                        types: [.bookInfo(book)]
                    ),
                    InfoSection(
                        title: "Characters",
                        types: characters.map { .characters($0) } + [.characters(.empty)]
                    )
//                    InfoSection(
//                        title: "Notes",
//                        types: notes.map { .notes($0) } + [.notes(.empty)]
//                    )
                ]
            }
            .asDriver(onErrorJustReturn: [])
    }
}
