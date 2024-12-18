//
//  NoteHandler.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 3/11/24.
//

import Foundation
import SwiftData

protocol DataNoteHandler {
    func newNote(_ note: Note) async throws
    func getAllNotes() async throws -> [Note]
    func delete(note: Note) async throws
}

@ModelActor
actor NoteHandler: DataNoteHandler {
    @MainActor
    init(modelContainer: ModelContainer, mainActor _: Bool) {
        let modelContext = modelContainer.mainContext
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
    }
    
    func newNote(_ note: Note) async throws {
        let noteModel = NoteModel(
            id: note.id,
            content: note.content,
            createdAt: note.createAt,
            tags: []
        )
        
        modelContext.insert(noteModel)
        try modelContext.save()
    }
    
    func getAllNotes() async throws -> [Note] {
        let notesModel = try modelContext.fetch(FetchDescriptor<NoteModel>())
        return notesModel.map { Note(id: $0.id, content: $0.content, createAt: $0.createdAt) }
    }
    
    func delete(note: Note) async throws {
        let noteModel = try modelContext
            .fetch(FetchDescriptor<NoteModel>())
            .first(where: { $0.id == note.id })
        
        guard let noteModel else { return }
        
        modelContext.delete(noteModel)
        try modelContext.save()
    }
}
