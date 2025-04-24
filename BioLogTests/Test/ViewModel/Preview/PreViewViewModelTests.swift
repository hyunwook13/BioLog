//
//  PreViewViewModelTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/22/25.
//

import XCTest
import RxSwift
import RxTest
@testable import BioLog

final class PreViewViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockUseCase: MockBookUseCaseImpl!
    var sut: PreviewViewModel!
    var completeBook: CompleteBook!
    
    override func setUp() {
        completeBook = CompleteBook(
            detail: BookDummy.savedBooks.first!,
            category: CategoryDummy.savedCategories.first!,
            characters: []
        )
        mockUseCase = MockBookUseCaseImpl()
            
        sut = PreviewViewModel(book: completeBook, usecase: mockUseCase)
    }
    
    func test() {
        sut.save.onNext(())
    }
}
