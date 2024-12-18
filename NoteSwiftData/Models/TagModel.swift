//
//  TagModel.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 18/9/24.
//

import Foundation
import SwiftData

@Model
class TagModel {
    @Attribute(.unique) var id: String
    var name: String
    
//        .nullify: Al eliminar un Tag, las referencias en las Notes se pondrán a nil, pero las Notes no se eliminarán.
//        .cascade: Al eliminar un Tag, las Notes relacionadas también se eliminarán. (No es lo que quieres en este caso).
//        .deny: Impide la eliminación de un Tag si está asociado a alguna Note.
//        .Manual: Es la opción que estamos aplicando, donde eliminas manualmente el Tag de los arrays tags de las Notes antes de borrarlo.
    @Relationship(deleteRule: .nullify) var notes: [NoteModel]?
    @Attribute(.ephemeral) var isChecked = false
    
    init(id: String, name: String, isChecked: Bool = false) {
        self.id = id
        self.name = name
        self.isChecked = isChecked
    }
}


struct Tag: Identifiable {
    let id: String
    let name: String
    var isChecked: Bool
    let notes: [Note]?
    
    init(
        id: String,
        name: String,
        isChecked: Bool = false,
        notes: [Note]? = []
    ) {
        self.id = id
        self.name = name
        self.notes = notes
        self.isChecked = isChecked
    }
    
    mutating func toogleCkeck() {
        self.isChecked.toggle()
    }
}
