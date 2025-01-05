//
//  Item.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
