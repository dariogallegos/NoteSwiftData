//
//  DataProvider.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 1/10/24.
//

import Foundation
import SwiftData

final class DataProvider: Sendable {
    public static let shared = DataProvider()
    
    public let sharedModelContainer: ModelContainer = {
       let schema = Schema(CurrentScheme.models)
       let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

       do {
         return try ModelContainer(for: schema, configurations: [modelConfiguration])
       } catch {
         fatalError("Could not create ModelContainer: \(error)")
       }
     }()
    
    
    public func dataHandlerCreator() -> @Sendable () async -> DataHandler {
        let container = sharedModelContainer
        return { DataHandler(modelContainer: container) }
    }
}
