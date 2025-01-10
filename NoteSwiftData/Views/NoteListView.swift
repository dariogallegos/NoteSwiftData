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
    @State var selectedTags: [Tag] = []
    
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
                                
                                if selectedTags.contains(where: { $0.id == tag.id }) {
                                    Spacer()
                                    
                                    Image(systemName: "checkmark.circle")
                                        .symbolRenderingMode(.multicolor)
                                }
                                
                                /*if tag.isChecked {
                                    Spacer()
                                    
                                    Image(systemName: "checkmark.circle")
                                        .symbolRenderingMode(.multicolor)
                                }*/
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                /*Task {
                                    // TODO: vamos a evitar guardar el estado en la base de datos, ya que es algo temporal por lo que el control lo vamos a hacer en las notas, para cada nota, y no a nivel de tag.
                                    //await tagViewModel.checkedTag(tag: tag)
                                }*/
                                
                                if selectedTags.contains(where: { $0.id == tag.id }) {
                                    // si el tag esta dentro de la lista
                                    selectedTags.removeAll(where: { $0.id == tag.id })
                                } else {
                                    // el tag no esta dentro de la lista, se añade
                                    selectedTags.append(tag)
                                }
                            }
                        }
                    }
                    
                    Button("Save") {
                        // TODO: Aquí es donde tengo que relacionar las notas con las tags.
                        noteViewModel.createNote(text: noteText, tags: selectedTags)
                        selectedTags.removeAll()
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

#Preview {
    NoteListView(
        noteViewModel: NoteListViewModel(repository: NoteMockHandler()),
        tagViewModel: TagListViewModel(handler: TagMockHandler())
    )
}
