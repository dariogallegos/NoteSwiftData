//
//  TagListView.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 18/9/24.
//

import SwiftUI
import SwiftData

struct TagListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Tags.name, order: .reverse) var allTags: [Tags]
    @State var tagText = ""

    var body: some View {
        List {
            Section {
                DisclosureGroup("Create a tag") {
                    TextField("Enter tag", text: $tagText, axis: .vertical)
                        .lineLimit(2...4)
                        .autocorrectionDisabled()
                    
                    Button("Save") {
                        createNote()
                    }
                }
            }
            
            Section {
                if allTags.isEmpty {
                    ContentUnavailableView("You don't have any tags yet", systemImage: "tag")
                } else {
                    ForEach(allTags) { tag in
                        if let notes = tag.notes, notes.count > 0 {
                            DisclosureGroup("\(tag.name) (\(notes.count))") {
                                ForEach(notes) { note in
                                    Text(note.content)
                                }
                                .onDelete { indexSet in
                                    indexSet.forEach { index in
                                        context.delete(notes[index])
                                    }
                                    try? context.save()
                                }
                            }
                        } else {
                            Text(tag.name)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            context.delete(allTags[index])
                        }
                        
                        try? context.save()
                    }
                }
            }
        }
    }
    
    private func createNote() {
        let tag = Tags(id: UUID().uuidString, name: tagText)
        context.insert(tag)
        try? context.save()
        tagText = ""
    }
}

#Preview {
    TagListView()
}
