//
//  NoteListView.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 18/9/24.
//

import SwiftUI
import SwiftData

struct NoteListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \NoteModel.createdAt, order: .reverse) var allNotes: [NoteModel]
    @Query(sort: \TagModel.name, order: .forward) var allTags: [TagModel]
    @State var noteText = ""
    
    var body: some View {
        List {
            Section {
                DisclosureGroup("Create a note") {
                    TextField("Enter text", text: $noteText, axis: .vertical)
                        .lineLimit(2...4)
                        .autocorrectionDisabled()
                    
                    DisclosureGroup("Tag With") {
                        if allTags.isEmpty {
                            Text("You don't have any tags yet. Please create one from Tags tab")
                                .foregroundStyle(.gray)
                        }
                        
                        ForEach (allTags) { tag in
                            HStack {
                                Text(tag.name)
                                
                                if tag.isChecked {
                                    Spacer()
                                    
                                    Image(systemName: "checkmark.circle")
                                        .symbolRenderingMode(.multicolor)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                tag.isChecked.toggle()
                            }
                        }
                    }
                    
                    Button("Save") {
                        createNote()
                    }
                }
            }
            
            Section {
                if allNotes.isEmpty {
                    ContentUnavailableView("You don't have any notes yet", systemImage: "note")
                } else {
                    ForEach(allNotes) { note in
                        VStack(alignment: .leading) {
                            Text(note.content)
                            
                            if let tags = note.tags, tags.count > 0 {
                                Text("Tags:" + tags.map(\.name).joined(separator: ", "))
                                    .font(.caption)
                            }
                            
                            Text(note.createdAt, style: .time)
                                .font(.caption)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            context.delete(allNotes[index])
                        }
                        
                        try? context.save()
                    }
                }
            }
        }
    }
    
    private func createNote() {
        var tags: [TagModel] = []
        allTags.forEach { tag in
            if tag.isChecked {
                tags.append(tag)
                tag.isChecked = false
            }
        }
        
        let note = NoteModel(id: UUID().uuidString, content: noteText, createdAt: .now, tags: tags)
        context.insert(note)
        try? context.save()
        noteText = ""
    }
}

#Preview {
    NoteListView()
}
