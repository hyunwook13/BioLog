//
//  NoteDummy.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation

@testable import BioLog

struct NoteDummy {
    static let testNotes = [
        NoteDTO(context: "테스트 내용", page: "페이지 1", createdAt: Date(), uuid: UUID().uuidString),
        NoteDTO(context: "다른 테스트 내용", page: "페이지 2", createdAt: Date(), uuid: UUID().uuidString),
        NoteDTO(context: "여기에 내용이 들어갑니다.", page: "페이지 3", createdAt: Date(), uuid: UUID().uuidString)
    ]

    static let savedNotes = [
        NoteDTO(context: "저장된 내용", page: "페이지 4", createdAt: Date(), uuid: UUID().uuidString),
        NoteDTO(context: "다른 저장된 내용", page: "페이지 5", createdAt: Date(), uuid: UUID().uuidString),
        NoteDTO(context: "여기에 저장된 내용이 들어갑니다.", page: "페이지 6", createdAt: Date(), uuid: UUID().uuidString)
    ]
}
