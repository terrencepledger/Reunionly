//
//  InfoPage.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/9/25.
//


import Foundation

struct InfoPage: Identifiable, Codable {
    var id: String { title }
    let title: String
    let filename: String
    let isPublic: Bool
}
