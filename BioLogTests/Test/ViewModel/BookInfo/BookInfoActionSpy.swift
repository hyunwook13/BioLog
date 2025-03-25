//
//  BookInfoActionSpy.swift
//  Pods
//
//  Created by 이현욱 on 4/22/25.
//

import Foundation

@testable import BioLog

// Spy for BookInfoAction
enum BookInfoActionCall: Equatable {
    case pushCharacter(CharacterDTO)
    case pop
}
class BookInfoActionSpy: BookInfoAction {
    private(set) var callHistory: [BookInfoActionCall] = []
    var passedCharacter: CharacterDTO!

    func pushCharacter(_ character: BioLog.CharacterDTO) {
        passedCharacter = character
        callHistory.append(.pushCharacter(character))
    }
    
    func pop() {
        callHistory.append(.pop)
    }
}
