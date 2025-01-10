//
//  NoteListViewModel.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 3/11/24.
//

import Foundation

@Observable
final class NoteListViewModel {
    var allNotes: [Note] = []
    private let repository: DataNoteHandler
    
    init(repository: DataNoteHandler) {
        self.repository = repository
        Task {
            await loadNotes()
        }
    }
    
    @MainActor
    func loadNotes() async {
        do {
            let notes = try await repository.getAllNotes()
            self.allNotes = notes
        } catch {
            print("Error loading tags: \(error.localizedDescription)")
        }
    }
    
    func createNote(text: String, tags: [Tag]) {
        Task {
            do {
                let note = Note(id: UUID().uuidString, content: text, createAt: .now, tags: tags)
                try await repository.newNote(note)
                await loadNotes()
            } catch {
                print("Error deleting tag: \(error.localizedDescription)")
            }
        }
    }

    func deleteNote(note: Note) {
        Task {
            do {
                try await repository.delete(note: note)
                await loadNotes()
            } catch {
                print("Error deleting tag: \(error.localizedDescription)")
            }
        }
    }
}
