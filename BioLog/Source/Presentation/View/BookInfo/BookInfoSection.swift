//
//  BookInfoSection.swift
//  BioLog
//
//  Created by 이현욱 on 4/22/25.
//

import Foundation
import RxDataSources

struct InfoSection: Equatable {
    let title: String
    var types: [PresentType]
    
    // Conform to SectionModelType
    init(original: InfoSection, items: [PresentType]) {
        self = original
        self.types = items
    }
    
    // Add this initializer
    init(title: String, types: [PresentType]) {
        self.title = title
        self.types = types
    }
}

enum PresentType: Equatable {
    case bookInfo(CompleteBook)
//    case notes(NoteDTO)
    case characters(CharacterDTO)
}

enum SectionType {
    case character
    case note
}

extension InfoSection: SectionModelType {
    typealias Item = PresentType
    
    var items: [PresentType] {
        return types
    }
}
