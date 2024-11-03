//
//  TagHandler.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 1/10/24.
//

import Foundation
import SwiftData

@ModelActor
actor TagHandler {
    @MainActor
    init(modelContainer: ModelContainer, mainActor _: Bool) {
       let modelContext = modelContainer.mainContext
       modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
       self.modelContainer = modelContainer
     }
    
    @discardableResult
    func newTag(_ tag: Tag) throws -> PersistentIdentifier {
        let tagModel = TagModel(id: tag.id, name: tag.name)
        modelContext.insert(tagModel)
        try modelContext.save()
        return tagModel.persistentModelID
    }

    func getAllTags() throws -> [Tag] {
        let tagsModel = try modelContext.fetch(FetchDescriptor<TagModel>())
        return tagsModel.map { Tag(id: $0.id, name: $0.name) }
    }
    
    func delete(tag: Tag) throws {
        let tagModel = try modelContext
            .fetch(FetchDescriptor<TagModel>())
            .first(where: { $0.id == tag.id })
        
        guard let tagModel else { return }
        
        modelContext.delete(tagModel)
        try modelContext.save()
    }
}
