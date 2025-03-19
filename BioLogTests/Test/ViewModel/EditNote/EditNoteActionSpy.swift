//
//  EditNoteActionSpy.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/22/25.
//

import Foundation

@testable import BioLog

enum EditNoteActionCall: Equatable {
    case pop
}

class EditNoteActionSpy: EditNoteAction {
    private(set) var callHistory: [EditNoteActionCall] = []
    
    func pop() {
        callHistory.append(.pop)
    }
}
