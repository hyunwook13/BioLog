//
//  ClientTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 3/27/25.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import BioLog

class ClientTests: XCTestCase {
    var sut: Client!
    
    override func setUp() {
        super.setUp()
        sut = ClientImpl(session: MockURLSession())
    }
    
    func test_책검색_요청_성공() async throws {
        // Given
        let searchTitle = "Swift"
        let endpoint: Endpoint<BookResponse> = BookAPI.searchBooks(title: searchTitle).typedEndpoint()
        
        // When
        
        let result = try await sut.request(with: endpoint)
        
                        XCTAssertEqual(result.item.count, 1)
//        Task {
//            do {
//                let result = try await sut.request(with: endpoint)

//            } catch {
//                
//            }
//        }
    }
    
//    func test_책검색_다양한_키워드() {
//        // Given
//        let searchKeywords = ["Swift", "RxSwift", "iOS"]
//        
//        for keyword in searchKeywords {
//            // Given
//            let endpoint = BookAPI.searchBooks(title: keyword)
//            
//            // When
//            _ = try! sut.request(with: endpoint)
//                .toBlocking()
//                .first()!
//                
//            // Then
//            XCTAssertEqual((sut as? MockNetworkClient)?.lastSearchTitle, keyword)
//        }
//    }
}

// MockNetworkClient 확장
//extension MockNetworkClient {
//    func setupResponse(for searchTitle: String, books: [BookDTO]) {
//        let response = BookSearchResponse(items: books)
//        do {
//            let data = try JSONEncoder().encode(response)
//            self.mockResult = .success(data)
//        } catch {
//            self.mockResult = .failure(.encodingError)
//        }
//    }
//}

class NetworkTests: XCTestCase {
    var sut: MockURLSession!
    
    override func setUp() {
        super.setUp()
        sut = MockURLSession()
//        sut.setupDefaultResponses()
    }
    
//    func test_책검색_성공() throws {
//        // Given
//        let searchTitle = "Swift"
//        let endpoint: Endpoint<BookResponse> = BookAPI.searchBooks(title: searchTitle).typedEndpoint()
//        let request = try URLRequest(url: endpoint.url())
//        
//        let expectation = XCTestExpectation(description: "Book search")
//        
//        // When
//        let task = sut.dataTask(with: request) { data, response, error in
//            // Then
//            XCTAssertNotNil(data)
//            XCTAssertNil(error)
//            if let response = response as? HTTPURLResponse {
//                XCTAssertEqual(response.statusCode, 200)
//            }
//            
//            // 응답 데이터 검증
//            if let data = data,
//               let bookResponse = try? JSONDecoder().decode(BookResponse.self, from: data) {
//                XCTAssertFalse(bookResponse.item.isEmpty)
//            }
//            
//            expectation.fulfill()
//        }
//        
//        task.resume()
//        
//        wait(for: [expectation], timeout: 1.0)
//    }
    
//    func test_책검색_실패() {
//        // Given
//        sut.setupSearchFailure()
//        let endpoint = BookAPI.searchBooks(title: "Swift").typedEndpoint()
//        let request = URLRequest(url: endpoint.url!)
//        
//        let expectation = XCTestExpectation(description: "Book search failure")
//        
//        // When
//        let task = sut.dataTask(with: request) { data, response, error in
//            // Then
//            XCTAssertNil(data)
//            XCTAssertNotNil(error)
//            if let response = response as? HTTPURLResponse {
//                XCTAssertEqual(response.statusCode, 400)
//            }
//            
//            expectation.fulfill()
//        }
//        
//        task.resume()
//        
//        wait(for: [expectation], timeout: 1.0)
//    }
}

