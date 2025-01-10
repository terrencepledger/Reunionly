//
//  StorageItem.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/9/25.
//

import Foundation

struct StorageItem: Identifiable, Codable {
    var id: String { title }
    var title: String
    var filename: String
    var isPublic: Bool
}
