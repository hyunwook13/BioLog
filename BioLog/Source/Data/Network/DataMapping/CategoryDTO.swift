//
//  CategoryDTO.swift
//  BioLog
//
//  Created by 이현욱 on 4/14/25.
//

import Foundation
import CoreData

struct CategoryDTO: Codable, Equatable {
    
    let name: String
    let uuid: String
    var original: Category?
    
    init(name: String, uuid: String = UUID().uuidString, original: Category? = nil) {
        self.name = name
        self.uuid = uuid
        self.original = original
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case uuid
    }
    
    static var empty: Self {
        return CategoryDTO(name: "")
    }
}

extension CategoryDTO: CoreDataConvertible {
    func toCoreDataObject(in context: NSManagedObjectContext) -> Category {
        let desc = NSEntityDescription.entity(forEntityName: "Category", in: context)!
        let category = Category(entity: desc, insertInto: context)
        category.name = self.name
        category.uuid = self.uuid
        return category
    }
}

extension Category {
    func toDTO() -> CategoryDTO {
        return CategoryDTO(
            name: self.name!,
            uuid: self.uuid!,
            original: self
        )
    }
}


