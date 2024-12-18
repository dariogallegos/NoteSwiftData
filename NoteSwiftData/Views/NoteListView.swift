//
//  NoteListView.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 18/9/24.
//

import SwiftUI
import SwiftData

struct NoteListView: View {
    @State var noteViewModel: NoteListViewModel
    @State var tagViewModel: TagListViewModel
    @State var noteText = ""
    
    var body: some View {
        List {
            Section {
                DisclosureGroup("Create a note") {
                    TextField("Enter text", text: $noteText, axis: .vertical)
                        .lineLimit(2...4)
                        .autocorrectionDisabled()
                    
                    DisclosureGroup("Tag With") {
                        if tagViewModel.allTags.isEmpty {
                            Text("You don't have any tags yet. Please create one from Tags tab")
                                .foregroundStyle(.gray)
                        }
                        
                        ForEach (tagViewModel.allTags) { tag in
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
                                Task {
                                    await tagViewModel.checkedTag(tag: tag)
                                }
                            }
                        }
                    }
                    
                    Button("Save") {
                        noteViewModel.createNote(text: noteText, tags: [])
                        noteText = ""
                        UIApplication.shared.endEditing()
                    }
                }
            }
            
            Section {
                if noteViewModel.allNotes.isEmpty {
                    ContentUnavailableView("You don't have any notes yet", systemImage: "note")
                } else {
                    ForEach(noteViewModel.allNotes) {  note in
                        VStack(alignment: .leading) {
                            Text(note.content)
                            
                            if let tags = note.tags, tags.count > 0 {
                                Text("Tags:" + tags.map(\.name).joined(separator: ", "))
                                    .font(.caption)
                            }
                            
                            Text(note.createAt, style: .time)
                                .font(.caption)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            noteViewModel.deleteNote(note: noteViewModel.allNotes[index])
                        }
                    }
                }
            }
        }
        .onAppear {
            Task.detached(priority: .medium) {
                await noteViewModel.loadNotes()
            }
        }
    }
}

//#Preview {
//    NoteListView()
//}
