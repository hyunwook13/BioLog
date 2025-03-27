//
//  EditCharacterDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 3/24/25.
//

import UIKit

final class EditCharacterDIContainer {
    
    let character: CharacterDTO
    let charactersUseCase: CharactersUseCase
    let noteUseCase: NoteUseCase
    
    init(_ character: CharacterDTO, noteUseCase: NoteUseCase, _ charactersUseCase: CharactersUseCase) {
        self.character = character
        self.charactersUseCase = charactersUseCase
        self.noteUseCase = noteUseCase
    }
    
    func makeEditCharacterViewController(action: EditCharacterActionAble) -> EditCharacterViewController {
        let vm = makeEditCharacterViewModel(actions: action)
        return EditCharacterViewController(vm: vm)
    }
    
    func makeEditCharacterViewModel(actions: EditCharacterActionAble) -> EditCharacterViewModel {
        return EditCharacterViewModel(character, charactersUseCase, noteUseCase: noteUseCase, action: actions)
    }
    
    func makeEditCharacterCoordinator(nav: UINavigationController) -> EditCharacterCoordinator {
        return EditCharacterCoordinator(nav: nav, container: self)
    }
    
    func makeEditNoteDIContainer(note: NoteDTO) -> EditNoteDIContainer {
        return EditNoteDIContainer(note: note, usecase: noteUseCase)
    }
}
