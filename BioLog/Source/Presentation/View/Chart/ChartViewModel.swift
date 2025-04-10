//
//  ChartViewModel.swift
//  BioLog
//
//  Created by 이현욱 on 4/15/25.
//

import Foundation

import RxSwift
import RxCocoa

struct ChartData: Identifiable {
    var id: ObjectIdentifier
    let name: String
    var value: Int
}


protocol ChartViewModelAble {
    typealias LogChart = [ChartData]
    var viewWillAppear: AnyObserver<Void> { get }
    var dismiss: AnyObserver<Void> { get }
    
    var datas: Driver<[(title: String, LogChart)]> { get }
}

final class ChartViewModel: ChartViewModelAble {
    
    private let disposeBag = DisposeBag()
    
    private var books = [BookDTO]()
    private var notes = [NoteDTO]()
    private var characters = [CharacterDTO]()
    private var categories: [CategoryDTO] = []
    
    let viewWillAppearSubject = PublishSubject<Void>()
    let dismissSubject = PublishSubject<Void>()
    let datasSubject = PublishSubject<[(title: String, LogChart)]>()
    
    init(bookUseCase: BookUseCase, noteUseCase: NoteUseCase, charactersUseCase: CharactersUseCase, categoryUseCase: CategoryUseCase, action: ChartActionAble) {
        dismissSubject.bind {
            action.popHandler()
        }.disposed(by: disposeBag)
        
        viewWillAppearSubject
            .flatMap {
                Observable.zip(
                    bookUseCase.fetchReadingBooks().asObservable(),
                    noteUseCase.fetchAllNotes().asObservable(),
                    charactersUseCase.fetchAllCharacter().asObservable(),
                    categoryUseCase.getAllCategory().asObservable()
                )
            }
            .do(onNext: { data in
                self.books = data.0
                self.notes = data.1
                self.characters = data.2
                self.categories = data.3
                print("end",Date().timeIntervalSinceReferenceDate,self.characters.count)
                
            })
            .bind { books, notes, characters, categories in
                //                guard let self = self else { return }
                var charts: [(title: String, LogChart)] = []
                charts.append(("주간 데이터", self.makeWeeklyBookData(books)))
                charts.append(("월간 데이터", self.makeMonthlyBookData(books)))
                charts.append(("카테고리별",self.makeChartDataByCategory(categories)))
                
                self.datasSubject.onNext(charts)
                
            }.disposed(by: disposeBag)
    }
    
    var viewWillAppear: AnyObserver<Void> {
        viewWillAppearSubject.asObserver()
    }
    
    var dismiss: AnyObserver<Void> {
        dismissSubject.asObserver()
    }
    
    var datas: Driver<[(title: String, LogChart)]> {
        datasSubject.asDriver(onErrorJustReturn: [])
    }
}

extension ChartViewModel {
    private func makeWeeklyBookData(_ books: [BookDTO]) -> LogChart {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let thisWeekStart = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let lastWeekStart = Calendar.current.date(byAdding: .day, value: -14, to: today)!
        
        let thisWeekBooks = books.filter { dateFormatter.string(from: $0.createdAt) >= dateFormatter.string(from: thisWeekStart) }
        let lastWeekBooks = books.filter { dateFormatter.string(from: $0.createdAt) >= dateFormatter.string(from: lastWeekStart) && dateFormatter.string(from: $0.createdAt) < dateFormatter.string(from: thisWeekStart) }
        
        return [
            ChartData(id: ObjectIdentifier(self), name: "저번주 책", value: lastWeekBooks.count),
            ChartData(id: ObjectIdentifier(self), name: "이번주 책", value: thisWeekBooks.count)
        ]
    }
    
    private func makeMonthlyBookData(_ books: [BookDTO]) -> LogChart {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        let today = Date()
        let thisMonthStart = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: today))!
        let lastMonthStart = Calendar.current.date(byAdding: .month, value: -1, to: thisMonthStart)!
        
        let thisMonthBooks = books.filter { dateFormatter.string(from: $0.createdAt) >= dateFormatter.string(from: thisMonthStart) }
        let lastMonthBooks = books.filter { dateFormatter.string(from: $0.createdAt) >= dateFormatter.string(from: lastMonthStart) && dateFormatter.string(from: $0.createdAt) < dateFormatter.string(from: thisMonthStart) }
        
        return [
            ChartData(id: ObjectIdentifier(self), name: "저번달 책", value: lastMonthBooks.count),
            ChartData(id: ObjectIdentifier(self), name: "이번달 책", value: thisMonthBooks.count)
        ]
    }
    
    private func makeChartDataByCategory(_ categories: [CategoryDTO]) -> LogChart {
        var chartData: LogChart = []
        
        for category in categories {
            if let firstIndex = chartData.firstIndex(where: { $0.name == category.name } ) {
                var temp = chartData[firstIndex]
                temp.value += 1
                chartData[firstIndex] = temp
            } else {
                let data = ChartData(id: ObjectIdentifier(self), name: category.name, value: 1)
                chartData.append(data)
            }
        }
        
        return chartData
    }
}
