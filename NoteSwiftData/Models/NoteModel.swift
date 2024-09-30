//
//  NoteModel.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 18/9/24.
//

import Foundation
import SwiftData

@Model
class NoteModel {
    @Attribute(.unique) var id: String
    var content: String
    var createdAt: Date
    
    /// Cuando defines la relación como opcional ([Tags]?), SwiftData lo interpreta como una relación que puede o no existir.
    /// Sin embargo, cuando la defines como no opcional ([Tags]), estás indicando que siempre debe haber una relación válida con uno o más Tags.
    /// Si usas una relación no opcional, debes asegurarte de que la propiedad tags siempre tenga un valor, aunque sea  []
    @Relationship(inverse: \TagModel.notes) var tags: [TagModel]?
    
    init(id: String, content: String, createdAt: Date, tags: [TagModel]) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.tags = tags
    }
}

extension NoteModel {
    var toNote: Note {
        Note(
            id: id,
            content: content,
            createAt: createdAt
        )
    }
}


struct Note: Identifiable {
    let id: String
    let content: String
    let createAt: Date
}
