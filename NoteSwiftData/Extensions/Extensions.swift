//
//  Extensions.swift
//  NoteSwiftData
//
//  Created by Dario Gallegos on 3/11/24.
//

import Foundation
import SwiftUI

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
    
