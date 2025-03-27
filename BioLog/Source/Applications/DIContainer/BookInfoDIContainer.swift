//
//  BookInfoDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 3/7/25.
//

import UIKit

final class BookInfoDIContainer {
    private let book: CompleteBook
    private let bookUseCase: BookUseCase
    private let characterUseCase: CharactersUseCase
    private let noteUseCase: NoteUseCase
    
    init(book: CompleteBook, bookUseCase: BookUseCase, characterUseCase: CharactersUseCase, noteUseCase: NoteUseCase) {
        self.bookUseCase = bookUseCase
        self.book = book
        self.characterUseCase = characterUseCase
        self.noteUseCase = noteUseCase
    }
    
    func makeBookInfoViewController(_ actions: BookInfoActionAble) -> BookInfoViewController {
        let vm = makeBookInfoViewModel(actions)
        return BookInfoViewController(viewModel: vm)
    }
    
    func makeBookInfoViewModel(_ actions: BookInfoActionAble) -> BookInfoViewModel {
        return BookInfoViewModel(
            book: book,
            bookUseCase: bookUseCase,
            characterUseCase: characterUseCase,
            noteUseCase: noteUseCase,
            actions: actions
        )
    }
    
    func makeBookInfoCoordinator(nav: UINavigationController) -> BookInfoCoordinator {
        let coordinator = BookInfoCoordinator(nav: nav, container: self)
        return coordinator
    }
    
    func makeEditCharcterDIContainer(character: CharacterDTO) -> EditCharacterDIContainer {
        return EditCharacterDIContainer(character, noteUseCase: noteUseCase, characterUseCase)
    }
    
    func makeCoreData() -> CoreData {
        let stack = BioLogCoreDataStack.shared
        
        return CoreData(mainContext: stack.mainContext, container: stack.persistentContainer)
    }
}
