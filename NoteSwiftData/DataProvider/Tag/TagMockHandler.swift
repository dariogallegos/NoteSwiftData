//
//  TagMockHandler.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 18/12/24.
//

import Foundation

final class TagMockHandler: DataTagHandler {
    var tags: [Tag] = [
        Tag(id: UUID().uuidString, name: "iOS", isChecked: false),
        Tag(id: UUID().uuidString, name: "Android", isChecked: false),
        Tag(id: UUID().uuidString, name: "Web", isChecked: false)
    ]
    
    func newTag(_ tag: Tag) async throws {
        if tags.contains(where: { $0.id == tag.id }) {
            tags.append(tag)
        }
    }
    
    func getAllTags() async throws -> [Tag] {
        tags
    }
    
    func delete(tag: Tag) async throws {
        tags.removeAll(where: { $0.id == tag.id })
    }
}
