//
//  Filters.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 19/9/24.
//

import Foundation

enum NoteSortBy: Identifiable, CaseIterable {
    var id: Self { self }
    
    case createdAt
    case content
    
    var text: String {
        switch self {
        case .createdAt: return "Create at"
        case .content: return "Content"
        }
    }
}

enum OrderBy: Identifiable, CaseIterable {
    var id: Self { self}
    
    case ascending
    case descending
    
    var text: String {
        switch self {
        case .ascending: return "Ascending"
        case .descending: return "Descending"
        }
    }
}
