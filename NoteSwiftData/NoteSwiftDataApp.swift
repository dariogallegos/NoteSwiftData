//
//  NoteSwiftDataApp.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 18/9/24.
//

import SwiftUI
import SwiftData

@main
struct NoteSwiftDataApp: App {
    
    @State var noteSearchText = ""
    @State var noteSortBy = NoteSortBy.createdAt
    @State var noteOrderBy = OrderBy.descending
    
    @State var tagSearchText = ""
    @State var tarOrderBy = OrderBy.descending

    
    
    var body: some Scene {
        WindowGroup {
            TabView {
                noteList
                
                tagList
            }
        }
        .modelContainer(for: [
            Note.self,
            Tags.self
        ])
    }
    
    private var noteList: some View {
        NavigationStack {
            NoteListView()
                .searchable(text: $noteSearchText, prompt: "Search")
                .textInputAutocapitalization(.never)
                .navigationTitle("Notes")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Picker("Sort by", selection: $noteSortBy){
                                ForEach(NoteSortBy.allCases) {
                                    Text($0.text).id($0)
                                }
                            }
                            
                        } label: {
                            Label(noteSortBy.text, image: "line.horizontal.3.decrease.circle")
                        }
                    }
                }
        }
        .tabItem {
            Image(systemName: "note")
            Text("Notes")
        }
    }
    
    private var tagList: some View {
        NavigationStack {
            TagListView()
                .navigationTitle("Tags")
        }
        .tabItem {
            Image(systemName: "tag")
            Text("Tags")
        }
    }
}
