//
//  TagListViewModel.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 20/9/24.
//

import Foundation

@Observable
final class TagListViewModel {
    var allTags: [Tag]
    
    private let repository: DataTagRepository
    
    init(repository: DataTagRepository) {
        self.repository = repository
        do {
            allTags = try repository.getTags()
        } catch {
            /// Error handling. For default, we set tags list to empty
            allTags = []
            print("debug: error \(error.localizedDescription)")
        }
    }
    
    func createTag(name: String) {
        let tag = Tag(id: UUID().uuidString, name: name)
        do {
            try repository.setTag(tag: tag)
            allTags.append(tag)
        } catch {
            print("debug: error \(error.localizedDescription)")
        }
    }
    
    func deleteTag(tag: Tag) {
        do {
            try repository.deleteTag(tag: tag)
            allTags.removeAll { $0.id == tag.id }
        } catch {
            print("debug: error \(error.localizedDescription)")
        }
    }
    
    func deleteNote(_ note: Note, from tag: Tag) {
        do {
            try repository.deleteNoteFromTag(note: note, from: tag)
            /// Actualizar las listas de tags y notas
            allTags = try repository.getTags()
        } catch {
            print("debug: error \(error.localizedDescription)")
        }
    }
}
