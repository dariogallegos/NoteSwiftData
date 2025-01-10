//
//  TagListViewModel.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 20/9/24.
//

import Foundation

@Observable
final class TagListViewModel {
    var allTags: [Tag] = []
    
    private let handler: DataTagHandler
    
    init(handler: DataTagHandler) {
        self.handler = handler
        Task {
            await loadTags()
        }
    }
    
    func loadTags() async {
        do {
            let tags = try await handler.getAllTags()
            DispatchQueue.main.async {
                self.allTags = tags
            }
        } catch {
            print("Error loading tags: \(error.localizedDescription)")
        }
    }
    
    func createTag(name: String) async {
        let tag = Tag(id: UUID().uuidString, name: name)
        do {
            try await handler.newTag(tag)
            await loadTags()
        } catch {
            print("Error creating tag: \(error.localizedDescription)")
        }
    }

    func deleteTag(tag: Tag) async {
        do {
            try await handler.delete(tag: tag)
            await loadTags()
        } catch {
            print("Error deleting tag: \(error.localizedDescription)")
        }
    }
    
    func checkedTag(tag: Tag) async {
        let updatedTag = Tag(id: tag.id, name: tag.name, isChecked: !tag.isChecked, notes: tag.notes)
        do {
            try await handler.newTag(updatedTag)
            await loadTags()
        } catch {
            print("Error checking tag: \(error.localizedDescription)")
        }
    }
}
