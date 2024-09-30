//
//  TagRepository.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 20/9/24.
//

import Foundation
import SwiftData

protocol DataTagRepository {
    func getTags() throws -> [Tag]
    func setTag(tag: Tag) throws
    func deleteTag(tag: Tag) throws
    func deleteNoteFromTag(note: Note, from tag: Tag) throws
}

class TagRepository: DataTagRepository {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func getTags() throws -> [Tag] {
        let tagsModel = try context.fetch(FetchDescriptor<TagModel>())
        return tagsModel.map {
            Tag(
                id: $0.id,
                name: $0.name,
                notes: $0.notes?.compactMap(\.toNote)
            )
        }
    }
    
    func setTag(tag: Tag) throws {
        context.insert(TagModel(id: tag.id, name: tag.name))
        try context.save()
    }
    
    func deleteTag(tag: Tag) throws {
        /// TODO:  intentar cambiar esto para usar un predicate de filtrado por id. Ahora mismo sacamos todos los tagModel y comparamos
        /// let descriptor = FetchDescriptor<TagModel>(predicate: #Predicate { $0.id == tag.id })

        let tagToDelete = try context.fetch(FetchDescriptor<TagModel>()).first(where: { $0.id == tag.id })
        
        if let tagToDelete {
            context.delete(tagToDelete)
            try context.save()
        }
    }
    
    func deleteNoteFromTag(note: Note, from tag: Tag) throws {
        /// TODO:  intentar cambiar esto para usar un predicate de filtrado por id. Ahora mismo sacamos todos los tagModel y comparamos
        let tagModel = try context.fetch(FetchDescriptor<TagModel>()).first(where: { $0.id == tag.id })
        if let tagModel {
            if let noteModel = tagModel.notes?.first(where: { $0.id == note.id }) {
                context.delete(noteModel)
                try context.save()
            }
        }
    }
}

class TagRepositoryTest: DataTagRepository {
    private var mockTags: [Tag] = [
          Tag(id: UUID().uuidString, name: "Android_t"),
          Tag(id: UUID().uuidString, name: "iOS_t"),
          Tag(id: UUID().uuidString, name: "Dart_t"),
          Tag(id: UUID().uuidString, name: "Web_t")
      ]
    
    func getTags() throws -> [Tag] {
        mockTags
    }
    
    func setTag(tag: Tag) throws {
        mockTags.append(tag)
    }
    
    func deleteTag(tag: Tag) throws {
        mockTags.removeAll { $0.id == tag.id }
    }
    
    func deleteNoteFromTag(note: Note, from tag: Tag) throws {
    }
}
