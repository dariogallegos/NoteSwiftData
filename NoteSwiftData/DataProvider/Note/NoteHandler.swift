//
//  NoteHandler.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 3/11/24.
//

import Foundation
import SwiftData

@ModelActor
actor NoteHandler {
    @discardableResult
    func newNote(_ note: Note) throws -> PersistentIdentifier {
        let noteModel = NoteModel(
            id: note.id,
            content: note.content,
            createdAt: note.createAt,
            tags: []
        )
        
        modelContext.insert(noteModel)
        try modelContext.save()
        return noteModel.persistentModelID
    }
    
    func getAllNotes() throws -> [Note] {
        let notesModel = try modelContext.fetch(FetchDescriptor<NoteModel>())
        return notesModel.map { Note(id: $0.id, content: $0.content, createAt: $0.createdAt) }
    }
    
    func delete(note: Note) throws {
        let noteModel = try modelContext
            .fetch(FetchDescriptor<NoteModel>())
            .first(where: { $0.id == note.id })
        
        guard let noteModel else { return }
        
        modelContext.delete(noteModel)
        try modelContext.save()
    }
}
