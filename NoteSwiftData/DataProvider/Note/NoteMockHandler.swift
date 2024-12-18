//
//  NoteMockHandler.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 4/11/24.
//

import Foundation

final class NoteMockHandler: DataNoteHandler {
    var notes: [Note] = [
        Note(id: UUID().uuidString, content: "Nota de mock 1", createAt: .now),
        Note(id: UUID().uuidString, content: "Nota de mock 2", createAt: .now),
        Note(id: UUID().uuidString, content: "Nota de mock 3", createAt: .now),
        Note(id: UUID().uuidString, content: "Nota de mock 4", createAt: .now)
    ]
    
    func newNote(_ note: Note) async throws {
        notes.append(note)
    }
    
    func getAllNotes() async throws -> [Note] {
        notes
    }
    
    func delete(note: Note) async throws {
        notes.removeAll(where: { $0.id ==  note.id })
    }
}
