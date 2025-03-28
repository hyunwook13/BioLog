//
//  CharacterDTO.swift
//  BioLog
//
//  Created by 이현욱 on 3/11/25.
//

import Foundation
import CoreData

struct CharacterDTO: Equatable {
    var age: String
    var name: String
    var sex: String
    var uuid: String = UUID().uuidString
    var labor: String
    var image: Data?
    var createdAt: Date = Date()
    var notes: [NoteDTO] = []
    
    var original: BookCharacter?
}

extension CharacterDTO: CoreDataConvertible {
    static let empty = CharacterDTO(age: "", name: "아무도_만들지_않을_만한_이름", sex: "", uuid: UUID().uuidString, labor: "")
    
    func toCoreDataObject(in context: NSManagedObjectContext) -> BookCharacter {
        let desc = NSEntityDescription.entity(forEntityName: "BookCharacter", in: context)!
        let character = BookCharacter(entity: desc, insertInto: context)
        character.age = self.age
        character.name = self.name
        character.sex = self.sex
        character.labor = self.labor
        character.uuid = self.uuid
        character.createdAt = self.createdAt
        return character
    }
}

extension BookCharacter {
    func toDTO() -> CharacterDTO {
        let notes = self.note?.allObjects as? [Note]
        
        return CharacterDTO(
            age: self.age ?? "",
            name: self.name ?? "",
            sex: self.sex ?? "",
            uuid: self.uuid!,
            labor: self.labor ?? "",
            image: self.image,
            createdAt: self.createdAt ?? Date(),
            notes: notes?.map { $0.toDTO() } ?? [],
            original: self
        )
    }
}
