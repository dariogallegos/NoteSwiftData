//
//  TagHandler.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 1/10/24.
//

import Foundation
import SwiftData

protocol DataTagHandler {
    func newTag(_ tag: Tag) async throws
    func getAllTags() async throws -> [Tag]
    func delete(tag: Tag) async throws
}

@ModelActor
actor TagHandler: DataTagHandler {
    @MainActor
    init(modelContainer: ModelContainer, mainActor _: Bool) {
       let modelContext = modelContainer.mainContext
       modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
       self.modelContainer = modelContainer
     }
    
    func newTag(_ tag: Tag) async throws {
        let tagModel = TagModel(id: tag.id, name: tag.name, isChecked: tag.isChecked)
        modelContext.insert(tagModel)
        try modelContext.save()
    }

    func getAllTags() async throws -> [Tag] {
        let tagsModel = try modelContext.fetch(FetchDescriptor<TagModel>())
        return tagsModel.map { Tag(id: $0.id, name: $0.name, isChecked: $0.isChecked) }
    }
    
    func delete(tag: Tag) async throws {
        let tagModel = try modelContext
            .fetch(FetchDescriptor<TagModel>())
            .first(where: { $0.id == tag.id })
        
        guard let tagModel else { return }
        
        modelContext.delete(tagModel)
        try modelContext.save()
    }
}
