//
//  EditCharacterAction.swift
//  BioLog
//
//  Created by 이현욱 on 4/24/25.
//

import Foundation

protocol EditCharacterActionAble {
    func addImage()
    func editNote(_ note: NoteDTO)
}

struct EditCharacterAction: EditCharacterActionAble {

    let addHandler: () -> Void
    let editNoteHandler: (NoteDTO) -> Void
    
    func addImage() {
        addHandler()
    }
    
    func editNote(_ note: NoteDTO) {
        editNoteHandler(note)
    }
}
