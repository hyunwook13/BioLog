//
//  ChartViewModelTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/22/25.
//

import XCTest
import RxSwift
import RxTest
@testable import BioLog

final class ChartViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockCategoryUseCase: MockCategoryUseCaseImpl!
    var mockCharactersUseCase: MockCharacterUseCaseImpl!
    var mockBookUseCase: MockBookUseCaseImpl!
    var mockNoteUseCase: MockNoteUseCase!
    var sut: ChartViewModel!
 
    override func setUp() {
        mockBookUseCase = MockBookUseCaseImpl()
        mockNoteUseCase = MockNoteUseCase()
        mockCharactersUseCase = MockCharacterUseCaseImpl()
        mockCategoryUseCase = MockCategoryUseCaseImpl()
        
        func pop() {
            
        }
        
        sut = ChartViewModel(
            bookUseCase: mockBookUseCase,
            noteUseCase: mockNoteUseCase,
            charactersUseCase: mockCharactersUseCase,
            categoryUseCase: mockCategoryUseCase,
            action: ChartActionAble(popHandler: pop)
        )
    }
    

    
    func test() {
        sut.viewWillAppear.onNext(())
        sut.dismiss.onNext(())
    }
}
