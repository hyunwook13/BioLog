//
//  API.swift
//  BioLog
//
//  Created by 이현욱 on 2/26/25.
//

import Foundation

enum BookAPI {
    case searchBooks(title: String)
    case fetchNewBooks
    
    var baseURL: String {
        switch self {
        case .searchBooks, .fetchNewBooks:
            return "http://www.aladin.co.kr/ttb/api/"
        }
    }
}

extension BookAPI {
    func typedEndpoint<R>() -> Endpoint<R> {
        switch self {
        case .searchBooks(let title):
            return Endpoint<R>(
                baseURL: baseURL,
                path: "ItemSearch.aspx",
                method: .get,
                queryParameters: [
                    "ttbkey": Constant.key,
                    "Query": title,
                    "Cover": "MidBig",
                    "QueryType": "Title",
                    "output":"js",
                    "Version":"20131101",
                    "SearchTarget": "All",
                    "SubSearchTarget":"Book"
                ],
                sampleData: """
                {
                    "item": [
                        {
                            "title": "Swift 프로그래밍 마스터",
                            "author": "김은지",
                            "pubDate": "20240301",
                            "description": "Swift 언어의 기초부터 고급 기능까지 상세히 다루는 완벽 가이드",
                            "isbn": "9788901234567",
                            "cover": "http://example.com/book1.jpg",
                            "categoryName": "컴퓨터/IT",
                            "customerReviewRank": 9
                        },
                        {
                            "title": "SwiftUI와 Combine 실전 프로젝트",
                            "author": "박민수",
                            "pubDate": "20240215",
                            "description": "최신 iOS 개발 패러다임을 반영한 실전 프로젝트 가이드",
                            "isbn": "9788901234568",
                            "cover": "http://example.com/book2.jpg",
                            "categoryName": "컴퓨터/IT",
                            "customerReviewRank": 8
                        },
                        {
                            "title": "iOS 앱 개발 완벽 가이드",
                            "author": "이현욱",
                            "pubDate": "20240110",
                            "description": "실무에서 바로 활용할 수 있는 iOS 앱 개발 노하우",
                            "isbn": "9788901234569",
                            "cover": "http://example.com/book3.jpg",
                            "categoryName": "컴퓨터/IT",
                            "customerReviewRank": 9
                        },
                        {
                            "title": "RxSwift 핵심 가이드",
                            "author": "최리액티브",
                            "pubDate": "20240220",
                            "description": "반응형 프로그래밍의 핵심 개념과 실전 응용",
                            "isbn": "9788901234570",
                            "cover": "http://example.com/book4.jpg",
                            "categoryName": "컴퓨터/IT",
                            "customerReviewRank": 8
                        },
                        {
                            "title": "Swift 디자인 패턴",
                            "author": "정아키텍트",
                            "pubDate": "20240125",
                            "description": "Swift로 구현하는 견고한 소프트웨어 설계",
                            "isbn": "9788901234571",
                            "cover": "http://example.com/book5.jpg",
                            "categoryName": "컴퓨터/IT",
                            "customerReviewRank": 9
                        }
                    ]
                }
                """.data(using: .utf8)!
            )
            
        case .fetchNewBooks:
            return Endpoint<R>(
                baseURL: baseURL,
                path: "ItemList.aspx",
                method: .get,
                queryParameters: [
                    "ttbkey": Constant.key,
                    "output":"js",
                    "Cover": "MidBig",
                    "QueryType": "ItemNewAll",
                    "Version":"20131101",
                    "SearchTarget": "Book"
                ],
                sampleData: """
                {
                    "item": [
                        {
                            "title": "미래를 만드는 기술",
                            "author": "김미래",
                            "pubDate": "20240320",
                            "description": "최신 기술 트렌드와 미래 전망을 다룬 책",
                            "isbn": "9788901234572",
                            "cover": "http://example.com/newbook1.jpg",
                            "categoryName": "경제/경영",
                            "customerReviewRank": 9
                        },
                        {
                            "title": "현대 심리학의 이해",
                            "author": "이마음",
                            "pubDate": "20240318",
                            "description": "현대인의 심리를 과학적으로 분석한 연구서",
                            "isbn": "9788901234573",
                            "cover": "http://example.com/newbook2.jpg",
                            "categoryName": "심리학",
                            "customerReviewRank": 8
                        },
                        {
                            "title": "세계 문학 산책",
                            "author": "박문학",
                            "pubDate": "20240315",
                            "description": "세계 각국의 현대 문학 작품을 소개하는 안내서",
                            "isbn": "9788901234574",
                            "cover": "http://example.com/newbook3.jpg",
                            "categoryName": "문학",
                            "customerReviewRank": 9
                        },
                        {
                            "title": "건강한 식사의 과학",
                            "author": "최영양",
                            "pubDate": "20240312",
                            "description": "영양학적 관점에서 바라본 현대인의 식사법",
                            "isbn": "9788901234575",
                            "cover": "http://example.com/newbook4.jpg",
                            "categoryName": "건강",
                            "customerReviewRank": 8
                        },
                        {
                            "title": "디지털 아트의 세계",
                            "author": "정디자인",
                            "pubDate": "20240310",
                            "description": "현대 디지털 아트의 동향과 기법 소개",
                            "isbn": "9788901234576",
                            "cover": "http://example.com/newbook5.jpg",
                            "categoryName": "예술",
                            "customerReviewRank": 9
                        }
                    ]
                }
                """.data(using: .utf8)!
            )
        }
    }
}
