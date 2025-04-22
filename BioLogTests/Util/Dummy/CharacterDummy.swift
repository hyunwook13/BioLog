//
//  CharacterDummy.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/22/25.
//

import Foundation

@testable import BioLog

struct CharacterDummy {
    static let saveDummy = [
        CharacterDTO(
            age: "28",
            name: "Alice",
            sex: "F",
            uuid: UUID().uuidString,
            labor: "Engineer",
            image: nil,
            createdAt: Date(timeIntervalSince1970: 1_678_000_000),
            notes: [NoteDummy.testNotes.first!],
            original: nil
        ),
        CharacterDTO(
            age: "35",
            name: "Bob",
            sex: "M",
            uuid: UUID().uuidString,
            labor: "Detective",
            image: nil,
            createdAt: Date(timeIntervalSince1970: 1_679_000_000),
            notes: [NoteDummy.testNotes.first!],
            original: nil
        ),
        CharacterDTO(
            age: "22",
            name: "Catherine",
            sex: "F",
            uuid: UUID().uuidString,
            labor: "Student",
            image: nil,
            createdAt: Date(),
            notes: [NoteDummy.testNotes.first!],
            original: nil
        )
    ]
}
