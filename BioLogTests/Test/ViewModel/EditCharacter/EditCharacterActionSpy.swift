//
//  EditCharacterActionSpy.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/22/25.
//

import Foundation

@testable import BioLog

@testable import BioLog

enum EditCharacterActionCall: Equatable {
    case addImage
    case editNote
}

class EditCharacterActionSpy: EditCharacterActionAble {
    private(set) var callHistory: [EditCharacterActionCall] = []
    var passedNote: NoteDTO!
    
    func addImage() {
        callHistory.append(.addImage)
    }
    
    func editNote(_ note: BioLog.NoteDTO) {
        callHistory.append(.editNote)
        self.passedNote = note
    }
    
    
}
