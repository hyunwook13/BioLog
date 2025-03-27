//
//  MainDiContainer.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

final class MainDiContainer {
    
    // MARK: - Properties
    private let bookUseCase: BookUseCase
    private let categoryUseCase: CategoryUseCase
    private let storage: StorageAble
    
    init(bookUseCase: BookUseCase, categoryUseCase: CategoryUseCase, storage: StorageAble) {
        self.bookUseCase = bookUseCase
        self.categoryUseCase = categoryUseCase
        self.storage = storage
    }

    func makeSearchBookDIContainer() -> SearchBookDIContainer {
        return SearchBookDIContainer(bookUseCase: bookUseCase, categoryUseCase: categoryUseCase)
    }

    func makeMainViewController(_ actions: MainAction) -> MainViewController {
        let vm = makeMainViewModel(actions: actions)
        return MainViewController(vm: vm)
    }

    func makeMainViewModel(actions: MainAction) -> MainViewModelAble {
        return MainViewModel(usecase: bookUseCase, actions: actions)
    }

    func makeBookInfoDIContainer(book: CompleteBook) -> BookInfoDIContainer {
        let characterUseCase = makeCharactersUseCase()
        let noteUseCase = makeNoteUseCase()
        return BookInfoDIContainer(
            book: book,
            bookUseCase: bookUseCase,
            characterUseCase: characterUseCase,
            noteUseCase: noteUseCase
        )
    }

    func makeMainCoordinator(nav: UINavigationController) -> MainCoordinator {
        return MainCoordinator(nav: nav, container: self)
    }
    
    func makePreviewDIContainer(book: CompleteBook) -> PreviewDIContainer {
        return PreviewDIContainer(book: book, bookUseCase: bookUseCase)
    }
    
    @available(iOS 16.0, *)
    func makeChartDIContainer() -> ChartDIContainer {
        let noteUseCase = makeNoteUseCase()
        let charactersUseCase = makeCharactersUseCase()
        return ChartDIContainer(bookUseCase: bookUseCase, noteUseCase: noteUseCase, charactersUseCase: charactersUseCase, categoryUseCase: categoryUseCase)
    }
    
    func makeNoteUseCase() -> NoteUseCase {
        let repo = makeNoteRepository()
        return NoteUseCaseImpl(repository: repo)
    }
    
    func makeCharactersUseCase() -> CharactersUseCase {
        let repo = makeCharacterRepository()
        return CharactersUseCaseImpl(repo: repo)
    }
    
    func makeNoteRepository() -> NoteRepository {
        return NoteRepositoryImpl(storage: storage)
    }
    
    func makeCharacterRepository() -> CharacterRepository {
        return CharacterRepositoryImpl(storage: storage)
    }
}
