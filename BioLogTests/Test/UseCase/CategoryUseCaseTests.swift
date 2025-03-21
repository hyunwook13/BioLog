//
//  CategoryUseCaseTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation
import XCTest

import RxSwift
import RxCocoa
import RxTest

@testable import BioLog

final class CategoryUseCaseTests: XCTestCase {
    var sut: CategoryUseCaseImpl!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var mockCategoryRepository: MockCategoryRepositoryImpl!
    
    override func setUp() {
        mockCategoryRepository = MockCategoryRepositoryImpl()
        sut = CategoryUseCaseImpl(mockCategoryRepository)
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        scheduler = nil
        disposeBag = nil
        sut = nil
        mockCategoryRepository = nil
    }
    
    func test_전체_카테고리_조회시_정상적으로_모든_카테고리를_반환한다() {
        let datas = CategoryDummy.savedCategories
        mockCategoryRepository.stubbedAllCategories = .just(datas)
        
        let observer = scheduler.createObserver([CategoryDTO].self)
        
        sut.getAllCategory()
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertTrue(mockCategoryRepository.isCalled)
        XCTAssertEqual(observer.events, [
            .next(0, datas),
            .completed(0)
        ])
    }
    
    func test_카테고리_문자열에서_마지막_카테고리를_잘_파싱하여_저장한다() {
        let data = CategoryDummy.savedCategories.last!
        mockCategoryRepository.stubbedCategories = .just(data)
        
        let observer = scheduler.createObserver(CategoryDTO.self)
        
        sut.saveCategory("국내도서>예술/대중문화>예술/대중문화의 이해>미학/예술이론", BookDTO.empty)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertTrue(mockCategoryRepository.isCalled)
        XCTAssertTrue(observer.events[0].value.element?.name == "미학/예술이론")
        XCTAssertEqual(observer.events, [
            .next(0, data),
            .completed(0)
        ])
    }
}
