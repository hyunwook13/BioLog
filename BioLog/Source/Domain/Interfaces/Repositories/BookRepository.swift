//
//  BookRepository.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

import RxSwift
import RxCocoa

enum BookError: Error {
    case searchFailed(Error)
}

protocol BookRepositoryAble {
    func findBooks(byTitle title: String) -> Single<[BookDTO]>
//    func save(with book: BookDTO) -> Observable<[BookDTO]>
}

final class BookRepository: BookRepositoryAble {
    private let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func findBooks(byTitle title: String) -> Single<[BookDTO]> {
        // 캐싱 사용하기
        // 내가 보기엔 텍스트가 출력이 안되는 이유는 DISPOSEBALGE 반환하고 나서 아에 스트림이 죽어버려서 그런거 가틈
        // 그냥 옵저버블
        
//        Task {
//            do {
//                let endpoint: Endpoint<[BookDTO]> = BookAPI.searchBooks(title: title).typedEndpoint()
//                let books: [BookDTO] = try await self.client.requestWithXML(with: endpoint)
////                return Observable.of(books)  이런식으로 진행해야 할 듯
//                print(books )
//                single(.success(books))
//            } catch {
//                return
//            }
//        }
        
        
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            Task {
                do {
                    let endpoint: Endpoint<[XMLItem]> = BookAPI.searchBooks(title: title).typedEndpoint()
                    let books: [XMLItem] = try await self.client.requestWithXML(with: endpoint)
                    print("books:", books)
                    single(.success([]))
                } catch {
                    single(.failure(BookError.searchFailed(error)))
                }
            }
            return Disposables.create()
        }
    }
    
//    func save(with book: BookDTO) -> Observable<[BookDTO]> {
//        
//    }
    
    
}
