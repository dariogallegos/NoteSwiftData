//
//  TagListView.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 18/9/24.
//

import SwiftUI
import SwiftData

struct TagListView: View {
    @State var viewModel: TagListViewModel
    //@Environment(\.modelContext) private var context
    //@Query(sort: \TagModel.name, order: .reverse) var allTags: [TagModel]
    @State private var tagText = ""
    
    init(viewModel: TagListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            Section {
                DisclosureGroup("Create a tag") {
                    TextField("Enter tag", text: $tagText, axis: .vertical)
                        .lineLimit(2...4)
                        .autocorrectionDisabled()
                    
                    Button("Save") {
                        viewModel.createTag(name: tagText)
                        tagText = ""
                    }
                }
            }
            
            Section {
                if viewModel.allTags.isEmpty {
                    ContentUnavailableView("You don't have any tags yet", systemImage: "tag")
                } else {
                    ForEach(viewModel.allTags) { tag in
                        DisclosureGroup("\(tag.name)") {
                            if let notes = tag.notes, notes.count > 0 {
                                ForEach(notes) { note in
                                    Text(note.content)
                                }
                                .onDelete { indexSet in
                                    indexSet.forEach { index in
                                        viewModel.deleteNote(notes[index], from: tag)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            viewModel.deleteTag(tag: viewModel.allTags[index])
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TagListView(
        viewModel: TagListViewModel(repository: TagRepositoryTest())
    )
}
