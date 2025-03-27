//
//  ChartDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 4/17/25.
//

import UIKit

@available(iOS 16.0, *)
final class ChartDIContainer {
    let bookUseCase: BookUseCase
    let noteUseCase: NoteUseCase
    let charactersUseCase: CharactersUseCase
    let categoryUseCase: CategoryUseCase
    
    init(bookUseCase: BookUseCase, noteUseCase: NoteUseCase, charactersUseCase: CharactersUseCase, categoryUseCase: CategoryUseCase) {
        self.bookUseCase = bookUseCase
        self.noteUseCase = noteUseCase
        self.charactersUseCase = charactersUseCase
        self.categoryUseCase = categoryUseCase
    }
    
    func makeChartViewController(action: ChartActionAble) -> ChartViewController {
        let vm = makeChartViewModel(action: action)
        return ChartViewController(vm)
    }
    
    func makeChartViewModel(action: ChartActionAble) -> ChartViewModel {
        return ChartViewModel(bookUseCase: bookUseCase, noteUseCase: noteUseCase, charactersUseCase: charactersUseCase, categoryUseCase: categoryUseCase, action: action)
    }
    
    func makeChartCoordinator(nav: UINavigationController) -> ChartCoordinator {
        return ChartCoordinator(nav: nav, container: self)
    }
}
