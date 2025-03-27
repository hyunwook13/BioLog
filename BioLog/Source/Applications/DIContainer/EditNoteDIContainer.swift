//
//  EditNoteDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 4/15/25.
//

import Foundation
import UIKit

final class EditNoteDIContainer {
    
    let usecase: NoteUseCase
    let note: NoteDTO
    
    init(note: NoteDTO, usecase: NoteUseCase) {
        self.usecase = usecase
        self.note = note
    }
    
    func makeEditNoteViewController(action: EditNoteAction) -> EditNoteViewController {
        let viewModel = makeEditNoteViewModel(action: action)
        return EditNoteViewController(viewModel)
    }
    
    func makeEditNoteViewModel(action: EditNoteAction) -> EditNoteViewModel {
        return EditNoteViewModel(note: note, usecase: usecase, action: action)
    }
    
    func makeEditNoteCoordinator(nav: UINavigationController) -> EditNoteCoordinator {
        return EditNoteCoordinator(nav: nav, container: self)
    }
}


