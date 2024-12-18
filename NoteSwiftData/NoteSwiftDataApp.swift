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
    let dataProvider = DataProvider.shared
    
    @State var noteSearchText = ""
    @State var noteSortBy = NoteSortBy.createdAt
    @State var noteOrderBy = OrderBy.descending
    
    @State var tagSearchText = ""
    @State var tarOrderBy = OrderBy.descending
    @State var tagViewModel = TagListViewModel(handler: TagHandler(modelContainer:DataProvider.shared.sharedModelContainer))
    
    var body: some Scene {
        WindowGroup {
            TabView {
                noteList
                
                tagList
            }
        }
        .modelContainer(dataProvider.sharedModelContainer)
    }
    
    private var noteList: some View {
        NavigationStack {
            NoteListView(
                noteViewModel: NoteListViewModel(repository: NoteHandler(modelContainer: dataProvider.sharedModelContainer)),
                tagViewModel: tagViewModel
            )
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
                            Label(noteSortBy.text, systemImage: "line.3.horizontal.decrease.circle")
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
            TagListView(viewModel: tagViewModel)
                .navigationTitle("Tags")
        }
        .tabItem {
            Image(systemName: "tag")
            Text("Tags")
        }
    }
}
