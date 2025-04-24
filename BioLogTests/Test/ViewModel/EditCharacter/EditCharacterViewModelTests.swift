//
//  EditCharacterViewModelTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/22/25.
//

import XCTest
import RxSwift
import RxTest
@testable import BioLog

final class EditCharacterViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockNoteUseCase: MockNoteUseCase!
    var mockCharactersUseCase: MockCharacterUseCaseImpl!
    var sut: EditCharacterViewModel!
    var spy: EditCharacterActionSpy!
    
    let dummy = CharacterDummy.saveDummy.first!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockNoteUseCase = MockNoteUseCase()
        mockCharactersUseCase = MockCharacterUseCaseImpl()
        spy = EditCharacterActionSpy()
        
        sut = EditCharacterViewModel(
            dummy,
            mockCharactersUseCase,
            noteUseCase: mockNoteUseCase,
            action: spy
        )
    }
    
    // MARK: –– 1) addImage가 action.addImage()를 호출하는지
    func test_addImage_triggersActionAddImage() {
        // when
        sut.addImage.onNext(())
        
        // then
        XCTAssertEqual(spy.callHistory, [.addImage])
    }
    
    // MARK: –– 2) selectedNote가 action.editNote(_:)를 호출하는지
    func test_selectedNote_triggersActionEditNote() {
        // given
        let note = NoteDTO(context: "c", page: "p", uuid: "U1")
        
        // when
        sut.selectedNote.onNext(note)
        
        // then
        XCTAssertEqual(spy.callHistory, [.editNote])
        XCTAssertEqual(spy.passedNote, note)
    }
    
    // MARK: –– 3) addNote가 새로운 NoteDTO를 notesSubject에 추가하는지
    func test_addNote_appendsNewNote() {
        // given
        let newNote = NoteDTO(context: "ctx", page: "pg", uuid: "ID123")
        mockNoteUseCase.stubbedAddResult = .just(newNote)
        
        // initial state
        XCTAssertEqual(sut.notesSubject.value, dummy.notes)
        
        // when
        sut.addNote.onNext(())
        
        // then
        // Single.just은 동기 방출이므로, 즉시 notesSubject가 갱신됩니다
        let expected = [newNote] + dummy.notes
        XCTAssertEqual(sut.notesSubject.value, expected)
    }
    
    // MARK: –– 4) save를 호출하면 updateCharacter가 호출되는지 (변경 없는 경우)
    func test_save_withoutFieldChanges_callsUpdateCharacter() {
        // when
        sut.save.onNext(())
        
        // then
        XCTAssertTrue(mockCharactersUseCase.isCalled)
        XCTAssertEqual(mockCharactersUseCase.lastCalledCharacter, dummy)
    }

    // MARK: –– 5) save 호출 전 name/sex/age/labor를 변경했을 때, updateCharacter에 반영되는지
    func test_save_withFieldChanges_callsUpdateCharacterWithUpdatedValues() {
        // given
        let newName  = "Charlie"
        let newSex   = "M"
        let newAge   = "35"
        let newJob   = "Writer"
        
        // when
        sut.name.onNext(newName)
        sut.sex.onNext(newSex)
        sut.age.onNext(newAge)
        sut.labor.onNext(newJob)
        sut.save.onNext(())
        
        // then
        XCTAssertTrue(mockCharactersUseCase.isCalled)
        let updated = mockCharactersUseCase.lastCalledCharacter
        XCTAssertEqual(updated?.name,  newName)
        XCTAssertEqual(updated?.sex,   newSex)
        XCTAssertEqual(updated?.age,   newAge)
        XCTAssertEqual(updated?.labor, newJob)
    }
}
