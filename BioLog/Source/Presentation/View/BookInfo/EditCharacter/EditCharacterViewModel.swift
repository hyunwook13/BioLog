//
//  EditCharacterViewModel.swift
//  BioLog
//
//  Created by 이현욱 on 4/24/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol EditCharacterViewModelAble {
    var character: CharacterDTO { get }
    
    var addNote: AnyObserver<Void> { get }
    var save: AnyObserver<Void> { get }
    var sex: AnyObserver<String> { get }
    var name: AnyObserver<String> { get }
    var labor: AnyObserver<String> { get }
    var age: AnyObserver<String> { get }
    var addImage: AnyObserver<Void> { get }
    var selectedNote: AnyObserver<NoteDTO> { get }
    
    var notes: Driver<[NoteDTO]> { get }
}

final class EditCharacterViewModel: EditCharacterViewModelAble {
    private let disposeBag = DisposeBag()
    private let characterUseCase: CharactersUseCase
    internal let character: CharacterDTO
    
    let selectedNoteSubject = PublishSubject<NoteDTO>()
    let addNoteSubject = PublishSubject<Void>()
    let addImageSubject = PublishSubject<Void>()
    let saveSubject = PublishSubject<Void>()
    let ageSubject = PublishSubject<String>()
    let sexSubject = PublishSubject<String>()
    let laborSubject = PublishSubject<String>()
    let nameSubject = PublishSubject<String>()
    
    let notesSubject: BehaviorRelay<[NoteDTO]>
    
    private let actionSubject = PublishSubject<Void>()
    
    init(
        _ character: CharacterDTO,
        _ charactersUseCase: CharactersUseCase,
        noteUseCase: NoteUseCase,
        action: EditCharacterActionAble
    ) {
        self.character = character
        self.characterUseCase = charactersUseCase
        notesSubject = BehaviorRelay(value: character.notes)
        
        addImageSubject
            .subscribe { _ in
                action.addImage()
            }.disposed(by: disposeBag)
        
        addNoteSubject
            .flatMap { _ in
                let dto = NoteDTO(
                    context: "",
                    page: "",
                    uuid: UUID().uuidString
                )
                return noteUseCase.add(with: dto, character: character)
            }
            .withLatestFrom(notesSubject) { (newNote, existingNotes) -> [NoteDTO] in
                [newNote] + existingNotes
            }
            .bind(to: notesSubject)
            .disposed(by: disposeBag)
        
        // 노트 입력 처리
        selectedNoteSubject
            .subscribe(onNext: { note in
                action.editNote(note)
            })
            .disposed(by: disposeBag)
        
        // 캐릭터 정보 업데이트를 위한 변수들 초기화
        var updatedName: String?
        var updatedSex: String?
        var updatedAge: String?
        var updatedLabor: String?
        
        // 이름 입력 처리
        nameSubject
            .subscribe(onNext: { name in
                updatedName = name.isEmpty ? nil : name
            })
            .disposed(by: disposeBag)
        
        // 성별 입력 처리
        sexSubject
            .subscribe(onNext: { sex in
                updatedSex = sex.isEmpty ? nil : sex
            })
            .disposed(by: disposeBag)
        
        // 나이 입력 처리
        ageSubject
            .subscribe(onNext: { age in
                updatedAge = age.isEmpty ? nil : age
            })
            .disposed(by: disposeBag)
        
        // 직업 입력 처리
        laborSubject
            .subscribe(onNext: { labor in
                updatedLabor = labor.isEmpty ? nil : labor
            })
            .disposed(by: disposeBag)
        
        // 저장 버튼 클릭 처리
        saveSubject
            .throttle(
                .seconds(1),
                latest: false,
                scheduler: MainScheduler.instance
            )
            .withLatestFrom(notesSubject)
            .subscribe(
                onNext: { [weak self] notes in
                    guard let self = self else { return }
                    
                    // 업데이트할 캐릭터 정보 생성
                    var updatedCharacter = self.character
                    
                    // 입력된 값이 있는 필드만 업데이트
                    if let name = updatedName {
                        updatedCharacter.name = name
                    }
                    
                    if let sex = updatedSex {
                        updatedCharacter.sex = sex
                    }
                    
                    if let age = updatedAge {
                        updatedCharacter.age = age
                    }
                    
                    if let labor = updatedLabor {
                        updatedCharacter.labor = labor
                    }
                    
                    //                updatedCharacter.notes = notes
                    
                    // 캐릭터 정보 업데이트 실행
                    self.characterUseCase.updateCharacter(with: updatedCharacter)
                        .subscribe(
                            { observer in
                                switch observer {
                                case .completed:
                                    self.actionSubject.onNext(())
                                    print("캐릭터 정보가 성공적으로 업데이트되었습니다.")
                                case .error(let error):
                                    print(
                                        "캐릭터 정보 업데이트 실패: \(error.localizedDescription)"
                                    )
                                }
                            })
                        .disposed(by: self.disposeBag)
                })
            .disposed(by: disposeBag)
    }
    
    var save: AnyObserver<Void> {
        return saveSubject.asObserver()
    }
    
    var addImage: AnyObserver<Void> {
        return addImageSubject.asObserver()
    }
    
    var addNote: RxSwift.AnyObserver<Void> {
        return addNoteSubject.asObserver()
    }
    
    var sex: RxSwift.AnyObserver<String> {
        return sexSubject.asObserver()
    }
    
    var name: RxSwift.AnyObserver<String> {
        return nameSubject.asObserver()
    }
    
    var labor: RxSwift.AnyObserver<String> {
        return laborSubject.asObserver()
    }
    
    var age: RxSwift.AnyObserver<String> {
        return ageSubject.asObserver()
    }
    
    var selectedNote: AnyObserver<NoteDTO> {
        return selectedNoteSubject.asObserver()
    }
    
    var notes: Driver<[NoteDTO]> {
        return notesSubject.asDriver(onErrorJustReturn: [])
    }
}
