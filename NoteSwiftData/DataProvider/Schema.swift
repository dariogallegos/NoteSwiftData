//
//  Schema.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 1/10/24.
//

import Foundation
import SwiftData


public enum CurrentScheme: VersionedSchema {
    public static var versionIdentifier: Schema.Version {
        .init(1, 0, 0)
    }
    
    public static var models: [any PersistentModel.Type] {
        [
            TagModel.self,
            NoteModel.self
        ]
    }
}
