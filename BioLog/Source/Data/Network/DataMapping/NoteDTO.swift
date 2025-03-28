//
//  NoteDTO.swift
//  BioLog
//
//  Created by 이현욱 on 3/11/25.
//

import Foundation
import CoreData

struct NoteDTO: Equatable {
    var context: String
    var page: String
    var createdAt: Date = Date()
    var uuid: String = UUID().uuidString
    
    var originalObject: Note?
}

extension NoteDTO: CoreDataConvertible {
    static let empty = NoteDTO(context: "아무도_만들지_않을_만한_이름", page: "")
    
    func toCoreDataObject(in context: NSManagedObjectContext) -> Note {
        let desc = NSEntityDescription.entity(forEntityName: "Note", in: context)!
        let note = Note(entity: desc, insertInto: context)
        note.context = self.context
        note.page = self.page
        note.uuid = self.uuid
        note.createdAt = self.createdAt
        return note
    }
}

extension Note {
    func toDTO() -> NoteDTO {
        return NoteDTO(context: self.context ?? "",
                       page: self.page ?? "",
                       createdAt: self.createdAt!,
                       uuid: self.uuid!
        )
    }
}
