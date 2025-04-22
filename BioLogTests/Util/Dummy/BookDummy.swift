//
//  Dummy.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/8/25.
//

import Foundation

@testable import BioLog

struct BookDummy {
    static let testBooks = [
        BookDTO(title: "테스트 책 1", author: "작가 1", pubDate: "20230101", description: "설명 1", isbn: "1234567890", cover: "cover1.jpg", categoryName: "소설", publisher: "출판사 1", customerReviewRank: 5),
        BookDTO(title: "테스트 책 2", author: "작가 2", pubDate: "20230202", description: "설명 2", isbn: "0987654321", cover: "cover2.jpg", categoryName: "과학", publisher: "출판사 2", customerReviewRank: 4),
        BookDTO(title: "테스트 책 3", author: "작가 3", pubDate: "20230303", description: "설명 3", isbn: "1122334455", cover: "cover3.jpg", categoryName: "역사", publisher: "출판사 3", customerReviewRank: 3)
    ]

    static let bookmarkedBooks = [
        BookDTO(title: "북마크된 책 1", author: "북마크 작가 1", pubDate: "20230101", description: "북마크 설명 1", isbn: "1234567890", cover: "bookmark_cover1.jpg", categoryName: "소설", publisher: "북마크 출판사 1", customerReviewRank: 5, isBookmarked: true),
        BookDTO(title: "북마크된 책 2", author: "북마크 작가 2", pubDate: "20230202", description: "북마크 설명 2", isbn: "0987654321", cover: "bookmark_cover2.jpg", categoryName: "과학", publisher: "북마크 출판사 2", customerReviewRank: 4, isBookmarked: true),
        BookDTO(title: "북마크된 책 3", author: "북마크 작가 3", pubDate: "20230303", description: "북마크 설명 3", isbn: "1122334455", cover: "bookmark_cover3.jpg", categoryName: "역사", publisher: "북마크 출판사 3", customerReviewRank: 3, isBookmarked: true)
    ]
    
    // 읽는중과 동일
    static let savedBooks = [
        BookDTO(title: "저장된 책 1", author: "저장 작가 1", pubDate: "20230101", description: "저장 설명 1", isbn: "1234567890", cover: "saved_cover1.jpg", categoryName: "소설", publisher: "저장 출판사 1", customerReviewRank: 5),
        BookDTO(title: "저장된 책 2", author: "저장 작가 2", pubDate: "20230202", description: "저장 설명 2", isbn: "0987654321", cover: "saved_cover2.jpg", categoryName: "과학", publisher: "저장 출판사 2", customerReviewRank: 4),
        BookDTO(title: "저장된 책 3", author: "저장 작가 3", pubDate: "20230303", description: "저장 설명 3", isbn: "1122334455", cover: "saved_cover3.jpg", categoryName: "역사", publisher: "저장 출판사 3", customerReviewRank: 3)
    ]
    
    static let cachedBooks = [
        BookDTO(title: "캐시 책 1", author: "캐시 작가 1", pubDate: "20230401", description: "캐시 설명 1", isbn: "1111222233", cover: "cache_cover1.jpg", categoryName: "소설", publisher: "캐시 출판사 1", customerReviewRank: 5),
        BookDTO(title: "캐시 책 2", author: "캐시 작가 2", pubDate: "20230402", description: "캐시 설명 2", isbn: "4444555566", cover: "cache_cover2.jpg", categoryName: "에세이", publisher: "캐시 출판사 2", customerReviewRank: 4),
        BookDTO(title: "캐시 책 3", author: "캐시 작가 3", pubDate: "20230403", description: "캐시 설명 3", isbn: "7777888899", cover: "cache_cover3.jpg", categoryName: "자기계발", publisher: "캐시 출판사 3", customerReviewRank: 3)
    ]
    
    static let searchedBooks = [
        BookDTO(title: "검색 결과 책 1", author: "검색 작가 1", pubDate: "20230501", description: "검색 설명 1", isbn: "1122334455", cover: "search_cover1.jpg", categoryName: "소설", publisher: "검색 출판사 1", customerReviewRank: 4),
        BookDTO(title: "검색 결과 책 2", author: "검색 작가 2", pubDate: "20230502", description: "검색 설명 2", isbn: "6677889900", cover: "search_cover2.jpg", categoryName: "역사", publisher: "검색 출판사 2", customerReviewRank: 5),
        BookDTO(title: "검색 결과 책 3", author: "검색 작가 3", pubDate: "20230503", description: "검색 설명 3", isbn: "1234567890", cover: "search_cover3.jpg", categoryName: "과학", publisher: "검색 출판사 3", customerReviewRank: 3)
    ]
    
    static let newBooks = [
        BookDTO(title: "신간 책 1", author: "신간 작가 1", pubDate: "20250401", description: "신간 설명 1", isbn: "1111111111", cover: "new_cover1.jpg", categoryName: "소설", publisher: "신간 출판사 1", customerReviewRank: 5),
        BookDTO(title: "신간 책 2", author: "신간 작가 2", pubDate: "20250402", description: "신간 설명 2", isbn: "2222222222", cover: "new_cover2.jpg", categoryName: "과학", publisher: "신간 출판사 2", customerReviewRank: 4)
    ]
    
    static let sampleBooks = [
        BookDTO(title: "스위프트 프로그래밍", author: "홍길동", pubDate: "20230101", description: "스위프트 언어를 배우는 기초 도서", isbn: "9788900000001", cover: "https://example.com/swift.jpg", categoryName: "프로그래밍", publisher: "샘플 출판사 1", customerReviewRank: 5),
        BookDTO(title: "RxSwift 마스터하기", author: "김개발", pubDate: "20220505", description: "RxSwift를 활용한 비동기 프로그래밍", isbn: "9788900000002", cover: "https://example.com/rxswift.jpg", categoryName: "프로그래밍", publisher: "샘플 출판사 2", customerReviewRank: 4),
        BookDTO(title: "iOS 앱 개발의 정석 + 스위프트", author: "이모바일", pubDate: "20210610", description: "iOS 앱 개발을 위한 종합 가이드", isbn: "9788900000003", cover: "https://example.com/ios.jpg", categoryName: "모바일", publisher: "샘플 출판사 3", customerReviewRank: 5),
        BookDTO(title: "SwiftUI 실전 프로젝트", author: "박UI", pubDate: "20230101", description: "SwiftUI를 활용한 모던 UI 개발", isbn: "9788900000004", cover: "https://example.com/swiftui.jpg", categoryName: "프로그래밍", publisher: "샘플 출판사 4", customerReviewRank: 5),
        BookDTO(title: "코어데이터 + 스위프트 완벽 가이드", author: "정데이터", pubDate: "20220505", description: "iOS 앱에서 코어데이터 활용하기", isbn: "9788900000005", cover: "https://example.com/coredata.jpg", categoryName: "데이터베이스", publisher: "샘플 출판사 5", customerReviewRank: 4)
    ]
    
}
