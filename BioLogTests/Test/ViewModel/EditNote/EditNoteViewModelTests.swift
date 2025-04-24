//
//  EditNoteViewModelTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/21/25.
//

import XCTest
import RxSwift
import RxTest
@testable import BioLog

final class EditNoteViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockUseCase: MockNoteUseCase!
    var sut: EditNoteViewModel!
    var spy: EditNoteActionSpy!
    
    // 초기 NoteDTO
    let originalNote = NoteDTO(context: "orig", page: "1", uuid: UUID().uuidString)
    
    override func setUp() {
        super.setUp()
        scheduler   = TestScheduler(initialClock: 0)
        disposeBag  = DisposeBag()
        mockUseCase = MockNoteUseCase()
        spy = EditNoteActionSpy()
        
        // scheduler 주입 가능하도록 ViewModel init 수정했다고 가정
        sut = EditNoteViewModel(
            note: originalNote,
            usecase: mockUseCase,
            action: spy,
            scheduler: scheduler
        )
    }
    
    func test_save한번_트리거시_updateNote가_한번만_호출되는지() {
        // given: 새로운 context/page
        sut.context.onNext("새 내용")
        sut.page   .onNext("42")
        mockUseCase.stubbedUpdateResult = .empty()
        
        // when: 10ms 에 save 요청, throttle(1s) 뒤 가상 시간을 1010ms 로 이동
        scheduler.scheduleAt(10) { self.sut.save.onNext(()) }
        scheduler.advanceTo(1010)
        
        // then: 한 번만 호출, 전달된 DTO 검증
        XCTAssertTrue(mockUseCase.isCalled)
        XCTAssertEqual(mockUseCase.lastNoteDTO?.context, "새 내용")
        XCTAssertEqual(mockUseCase.lastNoteDTO?.page,    "42")
        XCTAssertEqual(mockUseCase.lastNoteDTO?.uuid,    originalNote.uuid)
    }
    
    func test_withLatestFrom_최신값으로_updateNote_호출되는지() {
        // given: 초기값, 이후 100ms 에 context/page 변경
        sut.context.onNext("X")
        sut.page.onNext("10")
        scheduler.scheduleAt(100) {
            self.sut.context.onNext("Y")
            self.sut.page.onNext("20")
        }
        mockUseCase.stubbedUpdateResult = .empty()
        
        // when: 200ms 에 save 요청, 200+1000 = 1200ms 로 advance
        scheduler.scheduleAt(200) { self.sut.save.onNext(()) }
        scheduler.advanceTo(1200)
        
        // then: 마지막 combineLatest("Y","20") 로 호출되었는지 검증
        XCTAssertTrue(mockUseCase.isCalled)
        XCTAssertEqual(mockUseCase.lastNoteDTO?.context, "Y")
        XCTAssertEqual(mockUseCase.lastNoteDTO?.page,    "20")
    }
    
    func test_저장_실패시_pop액션이_호출되지않는지() {
        // given
        self.mockUseCase.isFailed = true

        scheduler.scheduleAt(10) {
            self.sut.context.onNext("A")
            self.sut.page   .onNext("1")
            self.sut.save   .onNext(())
        }
        // throttle(1s) 끝나는 1010ms까지 가상 시간 진행
        scheduler.advanceTo(1010)

        // then: 실패했으므로 pop()이 호출되지 않아야 함
        XCTAssertEqual(spy.callHistory, [])
    }
    
    func test_save후_1초뒤_pop액션_호출되는지() {
      // given: TestScheduler, ViewModel, Spy 준비 (setUp에서)

//        scheduler.scheduleAt(0) {
            self.mockUseCase.isFailed = false
            self.sut.context.onNext("A")
            self.sut.page.onNext("1")
//        }
      // when: 10ms에 save 트리거
//      scheduler.scheduleAt(10) {

          self.sut.save  .onNext(())
//      }
      // throttle(1s) 끝나는 1010ms까지 가상 시간 진행
//      scheduler.advanceTo(1010)
//        
//        Thread.sleep(forTimeInterval: 1.1)
      // then: action.pop()이 호출됐어야 함
        XCTAssertEqual(spy.callHistory, [.pop])
    }
}
