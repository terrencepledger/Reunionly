//
//  Event.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//


import Foundation
import FirebaseFirestore

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var eventDate: Date
    var location: String
}
