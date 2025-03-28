//
//  BookmarkDTO.swift
//  BioLog
//
//  Created by 이현욱 on 4/14/25.
//

import Foundation

struct BookmarkDTO: Codable, Equatable {
    var uuid: String = UUID().uuidString
    var isBookMarked: Bool = false
    var dateAdded: Date = Date()
//    let book: BookDTO
}
